#' DevelopmentModelCreator
#' 
#' Creates model coefficients from development data, and saves in corresponding
#' list entry.
#' @param development.data A dataframe. The development data. No default.
#' @param outcome.name A character vector. The name of the outcome variable. No
#'     default.
#' @param level.1 A character vector. The level corresponding to outcome = 1. No
#'     default.
#' @param predictor.names A character vector. The names of the predictor
#'     variables. No default.
#' @param test Logical. If TRUE only 5 bootstrap samples are used to estimate
#'     the linear shrinkage factor. Defaults to FALSE.
DevelopmentModelCreator <- function(development.data, outcome.name, level.1,
                                    predictor.names, test = FALSE) {

    ## Create model function
    log.reg.model <- function(model.data) {
        ## Run model
        model <- glm(Y ~ .,
                     data = model.data,
                     family = "binomial")
        ## Return model
        return(model)
    }
    ## Create development model in development sample
    Y <- as.numeric(development.data[, outcome.name] == level.1)
    X <- development.data[, predictor.names]
    model.data <- boot.data <- cbind(Y, X)
    development.model <- log.reg.model(model.data)
    ## Estimate linear shrinkage factor
    get.prediction.slope <- function(boot.data, indices) {  
        model.data <- boot.data[indices,]
        model.fit <- log.reg.model(model.data)
        prediction <- predict(model.fit, newdata = boot.data)
        calibration.model <- glm(boot.data$Y ~ prediction, family = "binomial")
        slope <- coef(calibration.model)["prediction"]
        return(slope)  
    }
    R <- 1000
    if (test)
        R <- 5
    linear.shrinkage.factor <- mean(boot(  
        data = boot.data, 
        statistic = get.prediction.slope, 
        R = R
    )$t)
    ## Apply bootstrap results to shrink model coefficients
    development.model$coefficients <- development.model$coef <- development.model$coefficients * linear.shrinkage.factor
    ## Identify cutoff
    prediction <- predict(development.model)
    cutoff <- IdentifyCutoff(prediction, development.data)
    ## Return model
    model <- list(model = development.model,
                  cutoff = cutoff)
    return(model)
}
