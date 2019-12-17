#' RunAnalyses
#'
#' Run all analyses and returns results
#' @param combineddatasets A data.frame. The combined datasets. No default.
#' @export
RunAnalyses <- function(combineddatasets, run.id) {
    ## Split dataset into three categories Training (Development), Validation, Test (Updating) and add them as a new column
    cohorts <- split(combineddatasets, combineddatasets$dataset)
    split.cohorts <- lapply(cohorts, bengaltiger::SplitDataset, events = c(300,100,100), event.variable.name = "m30d", event.level = "Yes", sample.names = c("Development", "Updating", "Validation"))

    ## Extract development samples
    development.samples <- lapply(split.cohorts, function(cohort) cohort$Development)

    ## Develop clinical prediction models
    outcome.name <- "m30d"
    level.1 <- "Yes"
    predictor.names <- c("trts_gcs4.5", "trts_gcs6.8", "trts_gcs9.12",
                         "trts_gcs13.15", "trts_sbp1.49", "trts_sbp50.75",
                         "trts_sbp76.89", "trts_sbp.89", "trts_rr1.5", "trts_rr6.9",
                         "trts_rr.29", "trts_rr10.29")
    test <- FALSE
    R <- 0
    prediction.models <- lapply(development.samples, DevelopmentModelCreator, outcome.name = outcome.name, level.1 = level.1, predictor.names = predictor.names, test = test, R = R)

    ## Update models
    updating.samples <- lapply(split.cohorts, function(cohort) cohort$Updating)
    updating.combinations <- strsplit(names(unlist(lapply(dataNames(), function(name) dataNames()[name != dataNames()]))), ".", fixed = TRUE)
    updated.models <- lapply(updating.combinations, UpdateModel, prediction.models = prediction.models, updating.samples = updating.samples)
    names(updated.models) <- sapply(updating.combinations, paste0, collapse = ".updated.in.")

    ## Validate models
    all.models <- c(prediction.models, updated.models)
    original.matrix <- unique(t(combn(rep(dataNames(), 2), 2)))
    original.list <- split(original.matrix, f = 1:nrow(original.matrix))
    validation.combinations <- c(original.list, lapply(names(updated.models), function(model.name) {
        sample.name <- unlist(strsplit(model.name, ".in.", fixed = TRUE))[2]
        validation.list <- c(model.name, sample.name)
        return(validation.list)
    }))
    validation.samples <- lapply(split.cohorts, function(cohort) cohort$Validation)
    validation.list <- lapply(validation.combinations, ValidateModel, prediction.models = all.models, validation.samples = validation.samples)
    validation.data <- do.call(rbind, validation.list)
    validation.data$run.id <- run.id

    ## Save to disk
    dir.create("out")
    saveRDS(validation.data, paste0("out/run-", run.id, ".Rds"))

    ## Return validation data
    return(validation.data)
}
