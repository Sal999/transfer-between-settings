#' CalculateUndertriage
#'
#' Calculates the undertriage associated with a specific level.
#' @param level A numeric vector of length 1. The level to be evaluated. No default.
#' @param prediction A numeric vector. The predictions. No default.
#' @param major A vector. Indicates if a trauma was major or not. No default.
#' @export
CalculateUndertriage <- function(level, prediction, major) {
    undertriage <- mean(major == "Yes" & prediction < level)
    return(undertriage)
}
