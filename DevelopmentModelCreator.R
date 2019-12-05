#' DevelopmentModelCreator
#' 
#' Creates model coefficients from development data, and saves in corresponding
#' list entry.
#' @param df A dataframe.
#' @param test Logical. If TRUE only 5 bootstrap samples are used to estimate
#'     the linear shrinkage factor. Defaults to FALSE.
DevelopmentModelCreator <- function(df, test = FALSE) {

    ## Create model function
    log.reg.model <- function(model.data) {
        ## Run model
        model <- glm(m30d ~ trts_gcs + trts_sbp + trts_rr,
                     data = model.data,
                     family = "binomial")
        ## Return model
        return(model)
    }
    ## Create development model in development sample
    development.model <- log.reg.model(development.data)
    ## Estimate linear shrinkage factor
    get.prediction.slope <- function(original.data, indices) {  
        model.data <- original.data[indices,]  
        model.fit <- log.reg.model(model.data)
        prediction <- predict(model.fit, newdata = original.data)
        calibration.model <- glm(original.data$res_survival ~ prediction, family = "binomial")
        slope <- coef(calibration.model)["prediction"]
        return(slope)  
    }
    R <- 1000
    if (test)
        R <- 5
    linear.shrinkage.factor <- mean(boot(  
        data = development.data, 
        statistic = get.prediction.slope, 
        R = R
    )$t)
    ## Apply bootstrap results to shrink model coefficients
    development.model$coef <- development.model$coef * linear.shrinkage.factor
    ## Return output
    return(development.model)
}
