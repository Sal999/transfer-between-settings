#' Compare models
#'
#' Compares model using a performance data object.
#' @param performance.data A data frame. The performance data. No default.
#' @export
CompareModels <- function(performance.data) {
    f <- sapply(performance.data$Model, function(model.name) unlist(strsplit(model.name, ".", fixed = TRUE))[1])
    model.list <- split(performance.data, f)
    result.list <- lapply(model.list, function(model.data) {
        triage.columns <- c("Undertriage", "Overtriage", "Mistriage")
        ## Get performance in own validation sample
        origin.name <- model.data[model.data$Model == model.data$Sample, "Model"]
        origin.data <- model.data[model.data$Sample == origin.name, triage.columns]
        ## Get performance after transfer
        transfer.names <- unique(model.data$Sample[model.data$Sample != origin.name])
        transfer.data <- model.data[model.data$Model == origin.name & model.data$Sample != origin.name, triage.columns]
        ## Make origin data and transfer data matrixes for easy comparison
        origin.matrix <- matrix(rep(as.numeric(origin.data), each = nrow(transfer.data)), ncol = ncol(transfer.data))
        transfer.matrix <- as.matrix(transfer.data)
        ## Calculate the effect of transfer
        transfer.effect <- as.data.frame(origin.matrix - transfer.matrix)
        Model <- data.frame(Model = rep(origin.name, nrow(transfer.effect)), stringsAsFactors = FALSE)
        Sample <- data.frame(Sample = transfer.names, stringsAsFactors = FALSE)
        transfer.effect <- cbind(Model, Sample, transfer.effect)
        ## Get performance after updating
        updating.matrix <- as.matrix(model.data[grep("updated.in", model.data$Model), triage.columns])
        updating.effect <- as.data.frame(updating.matrix - transfer.matrix)
        updating.effect <- cbind(Model, Sample, updating.effect)
        ## Create return list
        return.list <- list(transfer.effect = transfer.effect,
                            updating.effect = updating.effect)
        return(return.list)
    })
    return(result.list)
}
