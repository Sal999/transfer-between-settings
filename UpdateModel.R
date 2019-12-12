#' UpdateModel
#'
#' Updates a model given the names of the model to be updated and the updating
#' sample to be used.
#' @param names A character vector of length 2. The first entry should be the
#'     name of the model and the second the name of the updating sample. No
#'     default.
#' @param prediction.models A list. The prediction models. No default.
#' @param updating.samples A list. The updating samples. No default.
#' @export
UpdateModel <- function(names, prediction.models, updating.samples) {
    ## Arrange names
    model.name <- names[1]
    sample.name <- names[2]
    ## Get model
    model <- prediction.models[[model.name]]$model
    ## Get updating sample
    updating.sample <- updating.samples[[sample.name]]
    ## Update model
    prediction <- predict(model, newdata = updating.sample)
    Y <- as.numeric(updating.sample$m30d == "Yes")
    updating.model <- glm(Y ~ prediction, family = "binomial")
    calibration.intercept <- coef(updating.model)["(Intercept)"]
    calibration.slope <- coef(updating.model)["prediction"]
    updated.model <- model
    intercept.i <- grep("(Intercept)", names(updated.model$coefficients), fixed = TRUE)
    ## Update coefficients
    updated.model$coefficients <- updated.model$coef <- updated.model$coefficients * calibration.slope
    ## Update intercept
    updated.model$coefficients[intercept.i] <- updated.model$coef[intercept.i] <- updated.model$coefficients[intercept.i] + calibration.intercept
    ## Identify cutoff
    updated.prediction <- predict(updated.model, newdata = updating.sample, type = "response")
    cutoff <- IdentifyCutoff(prediction = updated.prediction, data = updating.sample)
    ## Return updated model
    return.object <- list(model = updated.model,
                          cutoff = cutoff)
    return(return.object)
}
