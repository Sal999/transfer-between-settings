## Import data from a file called "data" which contains the swedish and indian register
library(doMPI)
library(devtools)
library(bengaltiger)
library(boot)
library(dummies)
library(foreach)
source("VariableSelection.R")
source("NACounterDataSet.R")
source("NACounterVariable.R")
source("DataCleaning.R")
source("MyReplace.R")
source("DevelopmentModelCreator.R")
source("UpdateModel.R")
source("IdentifyCutoff.R")
source("CalculateUndertriage.R")
source("CalculateOvertriage.R")
source("ValidateModel.R")
source("RunAnalyses.R")
source("CompareModels.R")
source("CreateResultTable.R")
source("CreateResultTables.R")
source("CalculateMedians.R")
source("CalculatePercentileRanges.R")

## Set seed
set.seed(2489)

## Start the MPI cluster to prevent slaves to execute master code
dir.create("log")
study.cluster <- doMPI::startMPIcluster(count = 4, verbose = TRUE, logdir = "log")
registerDoMPI(study.cluster)

## If bengaltiger is not installed do:
##install_github("martingerdin/bengaltiger@v1.1.4")
data.names <- list(SweTrau = "swetrau-20110101-20160425.csv",
                   TITCO = "titco-I-full-dataset-v1.csv",
                   NTDB = "ntdb-2014-age-gender-issloc-sbp-gcstot-rr-m30d.csv")
data.list <- lapply(data.names, bengaltiger::ImportStudyData, data.path = "../data/")

## Add 30-day mortality to titco data
data.list$TITCO <- bengaltiger::Add30DayInHospitalMortality(data.list$TITCO)

## Make titco age numeric
data.list$TITCO$age <- as.numeric(data.list$TITCO$age)

## Create study sample from selected variables from either sweden or india.
variable.names.list <- list(SweTrau = c("pt_age_yrs", "pt_Gender", "ed_gcs_sum",
                                        "ed_sbp_value", "ed_rr_value",
                                        "res_survival", "ISS"),
                            TITCO = c("age", "sex", "gcs_t_1", "sbp_1", "rr_1",
                                      "m30d", "iss"),
                            NTDB = c("age", "gender", "gcstot", "sbp", "rr",
                                     "m30d", "issloc"))

##Calling Variableselection function to select 8 columns from variable name list
dataNames <- function() setNames(nm = names(data.names))
selected.data.list <- lapply(dataNames(), VariableSelection,
                             data = data.list,
                             variable.names.list = variable.names.list)

## Rename column names in other datasets with india column names
not.titco <- names(selected.data.list) != "TITCO"
selected.data.list[not.titco] <- lapply(selected.data.list[not.titco], function(selected.data) {
  names(selected.data) <- names(selected.data.list$TITCO)
  return(selected.data)
})

## Add cohort name to dataset
selected.data.list <- lapply(dataNames(), function(name) {
  dataset <- selected.data.list[[name]]
  dataset$dataset <- name
  return(dataset)
})

## Clean data list of inconsistent values, e.g 1 to Male, 2 to Female etc.
selected.data.list$SweTrau <- DataCleaning(selected.data.list$SweTrau)

## Merge Swedish and India Selected data list
combineddatasets <- do.call(rbind, selected.data.list)

## Remove children
combineddatasets <- combineddatasets[combineddatasets$age >= 15, ]

## Add combineddatasets to list
all.data.list <- c(selected.data.list, list(combined.datasets = combineddatasets))

## Calling NACounterVariable function and saving to new variable
numberOfNAVariable <- lapply(all.data.list, NACounterVariable)

## Calling NACounterDataSet function and saving to new variable
numberOfNADataSet <- lapply(all.data.list, NACounterDataSet)

## Gets the revised trauma score components from the data set and adds them to the dataset
trts.names <- c("trts_gcs", "trts_sbp", "trts_rr")
combineddatasets[, trts.names] <- bengaltiger::GetRevisedTraumaScoreComponents(combineddatasets, return.labels = TRUE)

## Add new variable "major" in the dataset. If ISS is greater than 15, consider it a Major Trauma
combineddatasets$major <- ifelse(combineddatasets$iss > 15, "Yes", "No")

## Keep only complete cases
combineddatasets <- combineddatasets[complete.cases(combineddatasets), ]

## Codebook  
codebook <- list(age = list(full.label = "Patient age, years",
                            abbreviated.label = "Age, years"),
                 sex = list(full.label = "Patient sex",
                            abbreviated.label = "Sex"),
                 gcs_t_1 = list(full.label = "Glasgow coma scale",
                                abbreviated.label = "GCS"),
                 trts_gcs = list(full.label = "Triage Revised Trauma Score - Glasgow coma scale",
                                 abbreviated.label = "TRTS-GCS"),
                 sbp_1 = list(full.label = "Systolic blood pressure",
                              abbreviated.label = "SBP"),
                 trts_sbp = list(full.label = "Triage Revised Trauma Score - Systolic blood pressure",
                                 abbreviated.label = "TRTS-SBP"),                 
                 rr_1 = list(full.label = "Respiratory rate",
                             abbreviated.label = "RR"),
                 trts_rr = list(full.label = "Triage Revised Trauma Score - Respiratory rate",
                                abbreviated.label = "TRTS-RR"),                                  
                 iss = list(full.label = "Injury severity score",
                            abbreviated.label = "ISS"),
                 major = list(full.label = "Major trauma",
                              abbreviated.label = ""),
                 m30d = list(full.label = "30-day survival",
                             abbreviated.label = ""),                 
                 dataset = list(full.label = "Dataset",
                                abbreviated.label = ""))

## Create Sample Characteristics table of the data sets
table1 <- bengaltiger::CreateSampleCharacteristicsTable(study.sample = combineddatasets,
                                                        codebook = codebook,
                                                        exclude.variables = "doi_toi",
                                                        save.to.disk = TRUE,
                                                        save.to.results = FALSE,
                                                        table.name = "sample-characteristics-table",
                                                        include.overall = FALSE,
                                                        return.pretty = TRUE,
                                                        group = "dataset")

## Create T-RTS indicator variables
trts.dummy.data <- dummy.data.frame(combineddatasets[, trts.names])
names(trts.dummy.data) <- gsub("-|>|<", ".", names(trts.dummy.data))
combineddatasets <- cbind(combineddatasets, trts.dummy.data)

## Run analyses
unlink("out")
n.runs <- 4
performance.list <- foreach(run.id = 1:n.runs) %dopar% RunAnalyses(combineddatasets, run.id)
closeCluster(study.cluster)

## Calculate median and percentile range
result.tables <- CreateResultTables(performance.list)

## Quit MPI
mpi.quit()
