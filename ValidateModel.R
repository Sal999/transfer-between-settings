#' ValidateModel
#'
#' Validates a model on a specific sample.
#' @param names A character vector. The first item is the model name and the
#'     second item is the sample name. No default.
#' @param prediction.models A list. The prediction models. No default.
#' @param validation.samples A list. The validation samples. No default.
#' @export
ValidateModel <- function(names, prediction.models, validation.samples) {
    ## Get model and sample
    model.name <- names[1]
    sample.name <- names[2]
    model <- prediction.models[[model.name]]$model
    cutoff <- prediction.models[[model.name]]$cutoff
    validation.sample <- validation.samples[[sample.name]]
    ## Apply model and calculate mistriage 
    prediction <- predict(model, newdata = validation.sample, type = "response")
    major <- validation.sample$major
    undertriage <- CalculateUndertriage(cutoff, prediction, major)
    overtriage <- CalculateOvertriage(cutoff, prediction, major)
    mistriage <- undertriage + overtriage
    ## Return results
    results <- data.frame(Model = model.name, Sample = sample.name, Undertriage = undertriage, Overtriage = overtriage, Mistriage = mistriage, stringsAsFactors = FALSE)
    return(results)
}
