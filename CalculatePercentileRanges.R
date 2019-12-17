#' CalculatePercentileRanges
#'
#' Calculates percentile ranges.
#' @param data A data.frame or matrix. The data for which to calculate
#'     percentile ranges. No default.
#' @param percentiles A numeric vector of length two. The two percentiles to
#'     calculate. Defaults to c(0.025, 0.975).
#' @param format A character vector of length 1. The format to use when
#'     formatting the output. Defaults to "%.3f". 
#' @export
CalculatePercentileRanges <- function(data, percentiles = c(0.025, 0.975),
                                      format = "%.3f") {
    percentile.data <- lapply(data, function(column) {
        new.column <- unique(column)
        if (class(column) == "numeric") {
            quantiles <- quantile(column, probs = percentiles)
            quantiles.fmt <- sprintf(format, quantiles)
            new.column <- paste0("(", paste0(quantiles.fmt, collapse = ", "), ")")
        }
        return(new.column)
    })
    percentile.data <- as.data.frame(percentile.data, stringsAsFactors = FALSE)
    return(percentile.data)
}
