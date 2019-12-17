#' CalculateMedians
#'
#' Calculates medians.
#' @param data A data.frame or matrix. The data for which to calculate
#'     medians. No default.
#' @param format A character vector of length 1. The format to use when
#'     formatting the output. Defaults to "%.3f".
#' @export
CalculateMedians <- function(data, format = "%.3f") {
    median.data <- lapply(data, function(column) {
        new.column <- unique(column)
        if (class(column) == "numeric")
            new.column <- sprintf(format, median(column))
        return(new.column)
    })
    median.data <- as.data.frame(median.data, stringsAsFactors = FALSE)
    rownames(median.data) <- NULL
    return(median.data)
}
