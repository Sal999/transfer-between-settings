#' CreateResultTables
#'
#' Creates results tables.
#' @param performance.list A list. The performance data. No default.
#' @param save.to.disk A logical vector of length 1. If TRUE the tables are
#'     saved to disk as docx files. Defaults to FALSE.
#' @export
CreateResultTables <- function(performance.list, save.to.disk = FALSE) {
    ## Define format
    fmt <- "%.3f"
    ## Create performance data
    performance.data <- do.call(rbind, performance.list)
    performance.data$run.id <- NULL
    ## Define effect data list
    effect.data.list <- list(performance.data = performance.data)
    ## Compare models
    comparisons.list <- lapply(performance.list, CompareModels)
    ## Extract transfer effect component
    transfer.effect.lists <- lapply(comparisons.list, function(comparison.list) lapply(comparison.list, function(model.list) model.list$transfer.effect))
    effect.data.list$transfer.effect.data <- do.call(rbind, do.call(rbind, transfer.effect.lists))
    ## Extract updating effect component
    updating.effect.lists <- lapply(comparisons.list, function(comparison.list) lapply(comparison.list, function(model.list) model.list$updating.effect))
    effect.data.list$updating.effect.data <- do.call(rbind, do.call(rbind, updating.effect.lists))
    ## Create transfer effect table
    result.tables <- lapply(effect.data.list, CreateResultTable, format = fmt)
    ## Define captions
    captions <- list(performance.data = "Under-, over-, and mistriage of models.",
                     transfer.effect.data = "Effects of transferring models between samples.",
                     updating.effect.data = "Effects of updating models.")
    ## Format tables
    formatted.tables <- lapply(setNames(nm = names(result.tables)), function(name) {
        result.table <- result.tables[[name]]
        caption <- captions[[name]]
        formatted.table <- knitr::kable(result.table, caption = caption, format = "pandoc", row.names = FALSE)
        return(formatted.table)
    })
    ## Save tables to disk
    file.name <- "result-tables"
    full.file.name <- paste0(file.name, ".docx")
    if (save.to.disk) {
        if (file.exists(full.file.name))
            file.remove(full.file.name)
        for (formatted.table in formatted.tables) {
            write(formatted.table, paste0(file.name, ".md"), append = TRUE)
            write("\n &nbsp; \n", paste0(file.name, ".md"), append = TRUE)
            rmarkdown::render(paste0(file.name, ".md"), output_format = "word_document")
        }
        unlink(paste0(file.name, ".md"))
    }
    return(formatted.tables)
}
