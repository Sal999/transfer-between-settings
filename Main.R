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

## Doi and toi in the same variable
as.POSIXct(paste(variable.names.list$doi, variable.names.list$toi), format="%Y-%m-%d %H:%M:%S")

## Titco and swetrau in a variable
combineddatasets <- rbind("simulated-swetrau-data.csv" , "titco-I-limited-dataset-v1.csv")

selected.data.list <- lapply(names(variable.names.list), VariableSelection,
                             data = data.list,
                             variable.names.list = variable.names.list)

selected.data.list <- lapply(names(variable.names.list), NACounterVariable,
                             data = data.list,
                             variable.names.list = variable.names.list)

selected.data.list <- lapply(names(variable.names.list), NACounterDataSet,
                             data = data.list,
                             variable.names.list = variable.names.list)

## Codebook  
codebook <- list(pt_age_yrs = list(full.label = "Patient age, years",
                                   abbreviated.label = "Age, years"),
                 pt_Gender = list(full.label = "Patient sex",
                                  abbreviated.label = "Sex"),
                 ed_gcs_sum = list(full.label = "Glasgow coma scale",
                                   abbreviated.label = "GCS"),
                 ed_sbp_value = list(full.label = "Systolic blood pressure",
                                     abbreviated.label = "SBP"),
                 ed_rr_value = list(full.label = "Respiratory rate",
                                    abbreviated.label = "RR"),
                 res_survival = list(full.label = "30-day survival",
                                     abbreviated.label = "30-day survival"),
                 ISS = list(full.label = "Injury severity score",
                            abbreviated.label = "ISS"),
                 NISS = list(full.label = "New injury severity score",
                             abbreviated.label = "NISS"),
                 Datetime_of_trauma = list(full.label = "Datetime of trauma",
                                    abbreviated.label = "Dateoftrauma"),
                 group = list(full.label = "Group",
                              abbreviated.label = ""),
                 age = list(full.label = "Patient age, years",
                            abbreviated.label = "Age, years"),
                 sex = list(full.label = "Patient sex",
                            abbreviated.label = "Sex"),
                 gcs_t_1 = list(full.label = "Glasgow coma scale",
                                abbreviated.label = "GCS"),
                 sbp_1 = list(full.label = "Systolic blood pressure",
                              abbreviated.label = "SBP"),
                 rr_1 = list(full.label = "Respiratory rate",
                             abbreviated.label = "RR"),
                 m30d = list(full.label = "30-day survival",
                          abbreviated.label = "30-day survival"),
                 iss = list(full.label = "Injury severity score",
                          abbreviated.label = "ISS"),
                 xxx = list(full.label = "New injury severity score",
                               abbreviated.label = "NISS"),
                 datetimeindia = list(full.label = "Date of injury and time of injury",
                             abbreviated.label = "DatetimeIndia"), 
                 Group = list(full.label = "Group",
                             abbreviated.label = "mm"))
