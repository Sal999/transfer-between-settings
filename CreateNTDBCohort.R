#' CreateNTDBCohort
#'
#' Creates the NTDB cohort from the raw data.
#' @param data.dir.path A character vector of length 1. The path to the
#'     directory with the raw data. Defaults to unlist(options("data.dir.path")).
#' @export
CreateNTDBCohort <- function(data.dir.path = unlist(options("data.dir.path"))) {
    ## Check parameters
    if (!is.character(data.dir.path) | length(data.dir.path) > 1)
        stop ("data.dir.path has to be a character vector of length 1")
    ## Import data
    file.names <- paste0(c("RDS_DEMO", "RDS_ED", "RDS_VITALS", "RDS_DISCHARGE"), ".csv")
    file.paths <- paste0(data.dir.path, file.names)
    if (!any(sapply(file.paths, file.exists)))
        stop (paste0("At least one of ", paste0(file.paths, collapse = ", "), " does not exist"))
    data.list <- lapply(file.paths, data.table::fread, data.table = FALSE)
    ## Keep only relevant variables
    relevant.variables <- list(demo = c("AGE", "AGEU", "GENDER"),
                               ed = c("ISSLOC", "EDDISP"),
                               vitals = c("SBP", "GCSTOT", "RR", "VSTYPE"),
                               discharge = c("HOSPDISP", "LOSDAYS"))
    data.list <- lapply(seq_along(data.list), function(i) data.list[[i]][c("INC_KEY", relevant.variables[[i]])])
    ## Merge datasets
    merged.data <- Reduce(function(x, y) merge(x, y, by = "INC_KEY", all = TRUE), data.list)
    ## Set error to missing
    num.errors <- c(-1, -2)
    char.errors <- c("Not Applicable BIU 1", "Not Known/Not Recorded BIU 2")
    error.codes <- list(AGE = c(-99, -2),
                        AGEU = char.errors,
                        GENDER = char.errors,
                        ISSLOC = num.errors,
                        EDDISP = char.errors,
                        SBP = num.errors,
                        RR = num.errors,
                        GCSTOT = num.errors,
                        HOSPDISP = char.errors,
                        LOSDAYS = num.errors)
    merged.data[names(error.codes)] <- lapply(names(error.codes), function(name) {
        column <- merged.data[, name]
        codes <- error.codes[[name]]
        for (code in codes) column[column == code] <- NA
        return(column)
    })
    ## Keep only observations from the emergency department
    merged.data <- merged.data[merged.data$VSTYPE == "ED", ]
    ## Keep only adults
    merged.data <- merged.data[merged.data$AGE >= 15 & merged.data$AGEU == "Years", ]
    ## Add 30 days hospital mortality
    merged.data$m30d <- factor(as.numeric(with(merged.data, (EDDISP == "Died/Expired" | HOSPDISP == "Deceased/Expired") & LOSDAYS <= 30)), levels = c(0, 1), labels = c("No", "Yes"))
    ## Rename variables
    names(merged.data) <- tolower(names(merged.data))
    ## Drop variables
    to.drop <- c("inc_key", "ageu", "eddisp", "vstype", "hospdisp", "losdays")
    merged.data <- merged.data[, -grep(paste0(to.drop, collapse = "|"), names(merged.data))]
    ## Save data to disk
    file.name <- paste0("ntdb-2014-", paste0(names(merged.data), collapse = "-"), ".csv")
    data.table::fwrite(merged.data, file.name)
}
