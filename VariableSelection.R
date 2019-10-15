#' VariableSelection
#'
#' Outputs a dataframe with the preselected variables: Patient age, patient
#' gender, GCS on arrival to the ER, SBP on arrival to the ER, RR on arrival to
#' the ER, 30-day survival, ISS, NISS and the date of trauma.
#' @param data.name Character. The name of the data to be used. Defaults to
#'     NULL, in which case data is used, assuming data is a data.frame.
#' @param data Data.frame or list. If data.name is NULL then data has to be a
#'     data.frame. If data.name is not NULL then data has to be a list. No
#'     default.
#' @param variable.names Character. The names of variables to be included in the
#'     study sample. Ignored if variable.names.list is not NULL. Defaults to c(
#'     "pt_age_yrs", "pt_Gender", "ed_gcs_sum", "ed_sbp_value", "ed_rr_value",
#'     "res_survival", "ISS", "NISS", "DateTime_Of_Trauma").
#' @param variable.names.list List. A list of variable names. Defaults to NULL,
#'     in which case it is ignored.
VariableSelection <- function(data.name = NULL, data, variable.names = c( "pt_age_yrs", "pt_Gender", "ed_gcs_sum", "ed_sbp_value", "ed_rr_value", "res_survival", "ISS", "NISS", "DateTime_Of_Trauma"), variable.names.list = NULL) {
  
  ## Error handling
  if (!is.character(data.name) & !is.null(data.name))
    stop ("data.name has to be a character vector or NULL")
  if (is.null(data.name) & !is.data.frame(data))
    stop ("data has to be a data.frame if data.name is NULL")
  if (!is.null(data.name) & !is.list(data))
    stop ("data has to be a list of data.frames if data.name is not NULL")
  if (!is.null(data.name) & !all(sapply(data, is.data.frame)))
    stop ("data has to be a list of data.frames if data.name is not NULL")
  if (!is.character(variable.names))
    stop ("variable.names has to be a character vector")
  if (!is.list(variable.names.list) & !is.null(variable.names.list))
    stop ("variable.names.list has to be a list or NULL")
  ## Selects variables
  if (!is.null(data.name))
    data <- data[[data.name]]
  if (!is.null(variable.names.list))
    variable.names <- variable.names.list[[data.name]]
  df <- data[, variable.names]
  
  ## Return data.frame
  return(df)
}
