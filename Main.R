## Import data from a file called "data" which contains the swedish and indian register
library(devtools)
library(bengaltiger)
source("VariableSelection.R")
source("NACounterDataSet.R")
source("NACounterVariable.R")
source("DataCleaning.R")
source("MyReplace.R")

## If bengaltiger is not installed do:
##install_github("martingerdin/bengaltiger@develop")
data.names <- list(swetrau = "simulated-swetrau-data.csv",
                   titco = "titco-I-limited-dataset-v1.csv")
data.list <- lapply(data.names, bengaltiger::ImportStudyData, data.path = "../data/")

## Add 30-day mortality to titco data
data.list$titco <- bengaltiger::Add30DayInHospitalMortality(data.list$titco)

## Create column called doi_toi inside titco data.frame and merge doi + toi columns to it
data.list$titco$doi_toi <- paste(data.list$titco$doi, data.list$titco$toi)

## Create study sample from selected variables from either sweden or india.
variable.names.list <- list(swetrau = c("pt_age_yrs", "pt_Gender", "ed_gcs_sum",
                                        "ed_sbp_value", "ed_rr_value",
                                        "res_survival", "ISS", 
                                        "DateTime_Of_Trauma"),
                            titco = c("age", "sex", "gcs_t_1", "sbp_1", "rr_1",
                                      "m30d", "iss", "doi_toi"))

##Calling Variableselection function to select 8 columns from variable name list
dataNames <- function() setNames(nm = names(data.names))
selected.data.list <- lapply(dataNames(), VariableSelection,
                             data = data.list,
                             variable.names.list = variable.names.list)

## Rename Swedish column names with india column names
names(selected.data.list[[1]]) <- names(selected.data.list[[2]])

## Add cohort name to dataset
selected.data.list <- lapply(dataNames(), function(name) {
    dataset <- selected.data.list[[name]]
    dataset$dataset <- name
    return(dataset)
})

## Clean data list of inconsistent values, e.g 1 to Male, 2 to Female etc.
selected.data.list$swetrau <- DataCleaning(selected.data.list$swetrau)

## Merge Swedish and India Selected data list
combineddatasets <- do.call(rbind, selected.data.list)

## Add combineddatasets to list
all.data.list <- c(selected.data.list, list(combined.datasets = combineddatasets))

## Calling NACounterVariable function and saving to new variable
numberOfNAVariable <- lapply(all.data.list, NACounterVariable)

## Calling NACounterDataSet function and saving to new variable
numberOfNADataSet <- lapply(all.data.list, NACounterDataSet)

## Codebook  
codebook <- list(age = list(full.label = "Patient age, years",
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
                 doi_toi = list(full.label = "Date of injury and time of injury",
                                abbreviated.label = ""), 
                 dataset = list(full.label = "Dataset",
                                abbreviated.label = ""))

## Create Sample Characteristics table of the data sets
table1 <- bengaltiger::CreateSampleCharacteristicsTable(study.sample = combineddatasets,
                                                        codebook = codebook,
                                                        save.to.disk = FALSE,
                                                        save.to.results = FALSE,
                                                        table.name = "SwetrauVstitco",
                                                        include.overall = FALSE,
                                                        ##return.pretty = TRUE,
                                                        group = "dataset") 
