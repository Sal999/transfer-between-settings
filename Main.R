## Import data from a file called "data" which contains the swedish and indian register
library(devtools)
library(bengaltiger)
## If bengaltiger is not installed do:
## install_github("martingerdin/bengaltiger@develop")
data.names <- list(swetrau = "simulated-swetrau-data.csv",
                   titco = "titco-I-limited-dataset-v1.csv")
data.list <- lapply(data.names, bengaltiger::ImportStudyData, data.path = "../data/")
## Add 30-day mortality to titco data
data.list$titco <- bengaltiger::Add30DayInHospitalMortality(data.list$titco)
## Create study sample from selected variables from either sweden or india.
variable.names.list <- list(swetrau = c("pt_age_yrs", "pt_Gender", "ed_gcs_sum",
                                        "ed_sbp_value", "ed_rr_value",
                                        "res_survival", "ISS", 
                                        "DateTime_Of_Trauma"),
                            titco = c("age", "sex", "gcs_t_1", "sbp_1", "rr_1",
                                      "m30d", "iss", "doi", "toi"))
selected.data.list <- lapply(names(variable.names.list), VariableSelection,
                             data = data.list,
                             variable.names.list = variable.names.list)
