#' CreateResultTable
#'
#' Creates results table.
#' @param effect.data A data.frame. The effect data. No default.
#' @param format A character vector of length 1. The format to use when
#'     formatting the output. Defaults to "%.3f".  
#' @export
CreateResultTable <- function(effect.data, format = "%.3f") {
    ## Define triage columns
    triage.columns <- c("Undertriage", "Overtriage", "Mistriage")
    ## Split effect data
    effect.split <- split(effect.data, do.call(paste0, effect.data[, c("Model", "Sample")]))
    ## Get table of medians
    medians <- as.matrix(do.call(rbind, lapply(effect.split, CalculateMedians, format = format)))
    ## Get table of percentile ranges
    percentile.ranges <- as.matrix(do.call(rbind, lapply(effect.split, CalculatePercentileRanges, format = format)))
    ## Combine tables
    pasted.data <- cbind(medians[, c("Model", "Sample")], matrix(paste0(medians[, triage.columns], " ", percentile.ranges[, triage.columns]), nrow = nrow(medians)))
    colnames(pasted.data)[3:5] <- paste0(triage.columns, " (95% UI)")
    ## Return table
    pasted.data <- as.data.frame(pasted.data)
    rownames(pasted.data) <- NULL
    pasted.data <- pasted.data[order(pasted.data$Model), ]
    pasted.data$Model <- gsub(".", " ", pasted.data$Model, fixed = TRUE)
    return(pasted.data)
}
