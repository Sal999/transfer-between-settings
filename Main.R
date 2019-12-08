## Import data from a file called "data" which contains the swedish and indian register
library(devtools)
library(bengaltiger)
library(boot)
library(dummies)
source("VariableSelection.R")
source("NACounterDataSet.R")
source("NACounterVariable.R")
source("DataCleaning.R")
source("MyReplace.R")
source("DevelopmentModelCreator.R")

## If bengaltiger is not installed do:
##install_github("martingerdin/bengaltiger@v1.1.3")
data.names <- list(swetrau = "swetrau-20110101-20160425.csv",
                   titco = "titco-I-full-dataset-v1.csv")
                   ## ntdb = "2014_iss.csv")
data.list <- lapply(data.names, bengaltiger::ImportStudyData, data.path = "../data/")

## Add 30-day mortality to titco data
data.list$titco <- bengaltiger::Add30DayInHospitalMortality(data.list$titco)

## Make titco age numeric
data.list$titco$age <- as.numeric(data.list$titco$age)

## Create study sample from selected variables from either sweden or india.
variable.names.list <- list(swetrau = c("pt_age_yrs", "pt_Gender", "ed_gcs_sum",
                                        "ed_sbp_value", "ed_rr_value",
                                        "res_survival", "ISS"),
                            titco = c("age", "sex", "gcs_t_1", "sbp_1", "rr_1",
                                      "m30d", "iss"))

##Calling Variableselection function to select 8 columns from variable name list
dataNames <- function() setNames(nm = names(data.names))
selected.data.list <- lapply(dataNames(), VariableSelection,
                             data = data.list,
                             variable.names.list = variable.names.list)

## Rename column names in other datasets with india column names
not.titco <- names(selected.data.list) != "titco"
selected.data.list[not.titco] <- lapply(selected.data.list[not.titco], function(selected.data) {
  names(selected.data) <- names(selected.data.list$titco)
  return(selected.data)
})

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
                                                        save.to.disk = FALSE,
                                                        save.to.results = FALSE,
                                                        table.name = "sample-characteristics-table",
                                                        include.overall = FALSE,
                                                        return.pretty = TRUE,
                                                        group = "dataset")

## Create T-RTS indicator variables
trts.dummy.data <- dummy.data.frame(combineddatasets[, trts.names])
names(trts.dummy.data) <- gsub("-|>|<", ".", names(trts.dummy.data))
combineddatasets <- cbind(combineddatasets, trts.dummy.data)

## Split dataset into three categories Training (Development), Validation, Test (Updating) and add them as a new column
cohorts <- split(combineddatasets, combineddatasets$dataset)
split.cohorts <- lapply(cohorts, bengaltiger::SplitDataset, events = c(300,100,100), event.variable.name = "m30d", event.level = "Yes", sample.names = c("Development", "Updating", "Validation"))

## Extract development samples
development.samples <- lapply(split.cohorts, function(cohort) cohort$Development)

## Develop clinical prediction models
outcome.name <- "m30d"
level.1 <- "Yes"
predictor.names <- c("trts_gcs4.5", "trts_gcs6.8", "trts_gcs9.12",
                     "trts_gcs13.15", "trts_sbp1.49", "trts_sbp50.75",
                     "trts_sbp76.89", "trts_sbp.89", "trts_rr1.5", "trts_rr6.9",
                     "trts_rr.29", "trts_rr10.29")
test <- TRUE
prediction.models <- lapply(development.samples, DevelopmentModelCreator, outcome.name = outcome.name, level.1 = level.1, predictor.names = predictor.names, test = test)

## Update models
updating.samples <- lapply(split.cohorts, function(cohort) cohort$Updating)
updating.combinations <- strsplit(names(unlist(lapply(dataNames(), function(name) dataNames()[name != dataNames()]))), ".", fixed = TRUE)
updated.models <- lapply(updating.combinations, UpdateModel, prediction.models = prediction.models, updating.samples = updating.samples)
names(updated.models) <- sapply(updating.combinations, paste0, collapse = ".updated.in.")
## Validate models
all.models <- c(prediction.models, updated.models)
original.matrix <- unique(t(combn(rep(dataNames(), 2), 2)))
original.list <- split(original.matrix, f = 1:nrow(original.matrix))
validation.combinations <- c(original.list, lapply(names(updated.models), function(model.name) {
    sample.name <- unlist(strsplit(model.name, ".in.", fixed = TRUE))[2]
    validation.list <- c(model.name, sample.name)
    return(validation.list)
}))
validation.samples <- lapply(split.cohorts, function(cohort) cohort$Validation)
validation.list <- lapply(validation.combinations, ValidateModel, prediction.models = all.models, validation.samples = validation.samples)
validation.data <- do.call(rbind, validation.list)
