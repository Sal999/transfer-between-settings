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
#' @param R A numeric vector of length 1. The number of bootstrap samples. If
#'     NULL 1000 bootstrap samples are used to estimate the linear shrinkage
#'     factor. Defaults to NULL.
DevelopmentModelCreator <- function(development.data, outcome.name, level.1,
                                    predictor.names, test = FALSE, R = NULL) {

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
    linear.shrinkage.factor <- 1
    if (is.null(R))
        R <- 1000
    if (test)
        R <- 5
    if (R > 0) 
        linear.shrinkage.factor <- mean(boot(  
            data = boot.data, 
            statistic = get.prediction.slope, 
            R = R
        )$t)
    ## Apply bootstrap results to shrink model coefficients
    development.model$coefficients <- development.model$coef <- development.model$coefficients * linear.shrinkage.factor
    ## Identify cutoff
    prediction <- predict(development.model, type = "response")
    cutoff <- IdentifyCutoff(prediction, development.data)
    ## Return model
    return.object <- list(model = development.model,
                          cutoff = cutoff)
    return(return.object)
}
