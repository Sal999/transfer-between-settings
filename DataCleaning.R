#' DataCleaning
#'
#' Replaces certiain entries, using the function MyReplace.
#' @param df Dataframe. The study sample. No default.
DataCleaning <- function(df) {
  
    ## Error handling
    if (!is.data.frame(df))
        stop ("Input has to be a data.frame")
    ## Entry replacements
    df$sex <- MyReplace(df$sex, 1, "Male")
    df$sex <- MyReplace(df$sex, 2, "Female")
    df$sex <- MyReplace(df$sex, 999, NA)
    df$m30d <- MyReplace(df$m30d, 1, "Yes")
    df$m30d <- MyReplace(df$m30d, 2, "No")
    df$m30d <- MyReplace(df$m30d, 999, NA)    
    return(df)
}
