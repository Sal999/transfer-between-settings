---
title: How do transfers and updating of clinical prediction models for trauma triage affect mistriage rates?
subtitle: Study plan
author: Salar Mohammed
date: 2019-09-16
---

# Introduction
Trauma accounts for 10% of global mortality (1). More than 4.8 million people die anually due to trauma and it is one of the leading causes of mortality in individuals under 44 years old (1,2). Prediction models used in trauma care seek to facilitate when prioritizing patients but also to guide treatment decisions, for example massive transfusion. Models have and are still being developed to predict death or survival rates in patients. The clinical prediction models have shown to be useful but may decrease in performance when transformed to other settings than the one they were originally developed in. Many models are built on vital-parameters such as systolic blood pressure (SBP) and respiratory rate (RR) and other variables such as Glascow Coma Scale (GCS) . The variables are later put in a system to determine the level of trauma. One model that is being used as a triage tool is the Revised Trauma Score(RTS) which uses GCS, RR and SBP, often the initial parameters obtained from the patient before they arrive at the emergency care (3). Development of these models are in many cases being made limited to a specified location or setting and are later being used in other circumstances. Also, they are developed on a national level using databases for that specific country and is being used in other parts of the world. It has in previous studies been shown that Norwegian clinical prediction models are good at predicting survival even in other countries from which the models were not created from (4). What has not been heavily studied is the grade of mistriage when using prediction models developed in one country, and applying in another. This study will hopefully cover the knowledge gap and answer if transferring prediction models from a country and applying it in another country affects mistriage rates. Mistriage rates is measured as either over- or undertriage. When a patient is overtriaged a trauma protocol is being activated in a faulty way which result in the waste of hospital resources. When undertriaged however, a trauma protocol is being activated in a way resulting in an inadequate healthcare-service.

Updating the prediction models may have an impact on mistriage rates also. As mentioned before, the models are being developed in one country and used in another. Mistriage rates may improve if the models go through update with data from the same country. 

# Aim
To asses how transfers of prediction models for trauma triage between different settings affect mistriage rates and to assess how model updating affect these rates compared with no updating.

# Material and methods
## Study design
This is a registry-based cohort study with data from the Swedish trauma registry (SweTrau), the US national trauma data bank (NTDB) and the Towards Improved Trauma Care Outcomes in India cohort (TITCO). 

Each dataset will be divided into samples of three; development, updating and validation samples. Logistic regression will be used to develop the models in the development samples. An estimation will be made of the mistriage rates in the validation samples models and will be compared to it self and to the other validation sample from the other databases. The updating samples will be tested in different settings and compared to see how model updating affect the mistriage rates.

## Setting
95.5% of all Swedish hospitals are connected to SweTrau, making it 52 out of 55 hospitals. It holds approximately 55 000 cases. The NTDB holds data from pediatric and adult patients from different levels of trauma centers, including undesignated trauma centers from 2007 to 2017. TITCO collects information from designated trauma centres in India from four centres. These centres are based in large cities in urban India. Kolkata, Mumbai (2-centres) and Delhi (5-7)

## Participants
The inclusion criteria in patients registered in SweTrau are:

- All patient that have experienced a traumatic event in which a trauma protocol has been activated in a hospital
- Admitted patients with or without trauma protocol activation
- Patients transferred to the hospital <7 days after the traumatic event and with a NISS score of >15. 

Exclusion criteria for SweTrau:

- Patients whose only traumatic injury is chronic subdural hematoma
- Trauma protocol activation without an underlying traumatic event(5)

Exclusion- and inclusioncriterias for NTDB(8):  

Inclusion criteria for TITCO: 

- Patients presenting to the casualty department with injury sustained from road traffic, railway, assault or burns admitted to hospital for treatment
- Patients who died after arrival but before admission

Exclusion criteria for TITCO: 

- Patients who were dead on arrival (6)

The Convention on the rights of the Child defines a child as a human being below the age of eighteen(9). Individuals 15 years or older registered in all three registers, SweTrau, NTDB and TITCO cohort will be included. We will use >15 years as the cut off because everything below that activates trauma team for pediatrics in many cases but mainly it is because of the physiology difference between children and adults. (10). 

## Data sources/measurement
Every parameter will be obtained from NTDB, SweTrau and TITCO. SBP, RR, GCS, ASA, NISS and ISS sex and age have been registered or calculated by workers in hospitals (physicians, nurses, assistant nurse). 

## Bias
Possible when coding. The programming will be double checked by an experienced colleague. Confirmation bias is also a risk when conducting data to the analysis program.

## Study size
All patients in SweTrau, NTDB and TITCO over 15 years of age and that fits the inclusion criteria to be in the register.

## Patient cohort
Age, sex, ASA(American Society of Anaesthesiologist physical status classification system), ISS(Injury Severity Score) and NISS(New ISS).

## Variables
### Study outcome
ISS >15 major trauma. ISS ≤15 minor trauma. Overtriage will be defined as the event when major trauma is ISS ≤15 calculated by the prediction model. Undertriage will be when ISS > 15 is considered minor trauma by the prediction model. The overtriage rate will be calculated by dividing the amount of overtriaged patients with all patients. The undertriage rate will be the number of undertriaged patients divided by all patients. The mistriage rate will be the sum of the overtriage and undertriage rate.

### Model outcome
Mortality within 30 days of the traumatic event. For NTDB and TITCO mortality will be in-hospital mortality. For SweTrau mortality includes out of hospital mortality too. 

### Model predictors
SBP, RR and GCS will be used as quantitive variables to develop the models. These are the same parameters used in the Revised Trauma Score(RTS). The sum of each variable multiplied by a weighted coefficient.

RTS = 0.9368(GCSvalue) + 0.7326(SBPvalue) + 0.22908(RRvalue)

**Respiratory** **rate**

Parameter     |   Score
------------- | -------------
10-29         | 4
<29           | 3
6-9           | 2
1-5           | 1
0             | 0

**Systolic** **Blood** **Pressure**

Parameter     |   Score
------------- | -------------
>89           | 4
76-89         | 3
50-75         | 2
1-49          | 1
0             | 0

**Glasgow** **Coma** **Scale**

Parameter     |   Score
------------- | -------------
13-15         | 4
9-12          | 3
6-8           | 2
4-5           | 1
3             | 0

The higher the RTS value, the higher the chance for survival. A lower value is associated with death (11). 


## Statistical methods
We will use data from three sources: SweTrau, NTDB and TITCO. Each dataset will be split temporally into three samples: one development, one updating, and one validation sample. We will develop one model per development sample, resulting in three models. The performance of each model will be evaluated by testing the model in all three validation samples. Local performance will be defined as a model’s performance in the validation sample from the same dataset as the development sample, for example the SweTrau model’s performance in the SweTrau validation sample. Transferred performance will be defined as a model’s performance in a validation sample from a different dataset compared to the sample in which the model was developed, for example the SweTrau model’s performance in the NTDB and TITCO validation samples. To assess how model transfer affect mistriage rates the local and transferred performances will be compared by subtracting the transferred performance from the local performance in a pair-wise manner. For example, the SweTrau model’s performance in the NTDB validation sample will be subtracted from the SweTrau model’s performance in the SweTrau validation sample. A negative difference then means that the performance declined when the model was transferred. Then, each model will be updated in updating samples from datasets in which the model was not developed, the SweTrau model will for example be updated in the NTDB and TITCO updating samples. Updated performance will then be defined as an updated model’s performance in the validation sample from the same dataset as the updating sample, for example the SweTrau model’s performance in the NTDB validation sample after having been updated in the NTDB updating sample. To assess how model updating affect mistriage rates compared to no updating the updated performance will be compared with the transferred performance by subtracting the transferred performance from the updated performance. A positive difference means that the updating improved performance compared to no updating. Models will be developed using logistic regression. Predictors will be treated as continuous variables with linear associations with mortality. The entire process will be repeated 1000 times and results presented as medians and values at the 2.5th and 97.5th percentiles. Observations with missing data will be excluded.

### Model development
Model development will be made through logistic regression using GCS, RR, SBP as independent variables and 30 days all cause mortality as the dependent  variable. This process will be as described in the statistical methods with the model development taking place in the development sample in each dataset. It will be developed in a way that keeps over- and undertriage under a certain value and will give us a cut-off which will be a marker for major and minor traumas. 

A bootstrap procedure will be used so the model wont be overfitted. It is going to give us a linear shrinkage factor which will be applied to the coefficents used in the model which is after going to be used to estimate probability of all cause 30 day mortality. Then, a grid search is going to try the highest possible combination for the parameters which will give us the optimal cut-off value. 


### Model validation
In this step, the model performance will be evaluated. The probability of all cause 30 day mortality will be estimated first. Then, The model will be assessed in the validation sample with the cut-off value obtained from the development samples giving us either major or minor trauma. 

### Model comparison
The models (the difference in model performance) will be compared in pairs evaluating how they performed in the validation sample from the same dataset versus a validation sample from a different dataset. The samples will be resampled 1000 times with bootstrap procedure and estimated with confidence intervals for the model performances. The models will be the same size as the original sample. Model development, validation and comparison will be repeated until all countries has been compared with eachother.

### Model updating
The same procedure as in the model development step will be repeated but this time the models will be developed from the updated samples from a different country instead of the development samples. It will then be validated and compared in the same way as described in the previous step.

Numerous methods can be used when updating a prediction model. Recalibration methods can be used and also revision methods. A third alternative is no adjustment to the model (12). This is the method that is going to be used. We are going to use the original prediction rule which was used in the development sample and apply it to the updated sample. In reality it is the same as updating the model with different or new sets of data. 

### Missing data
Observations with missing data will be excluded from this study. 

## Ethical considerations 

### Autonomy-respect
The patients can withdraw from the register if they choose to do so. They are not in all cases informed that the information can be used in a study. In that case, we have a responsibility to treat the data with respect like we will do with all data used in this study. 

### The principle of beneficence
The study will hopefully improve the management of trauma care and contribute to better healthcare for patients.

### The principle of nonmaleficence
No intervention is being made so there is no risk for physical harm. Data leakage will be the biggest risk for harm and integrity.

### The principle of justice 
All patients are depersonalized and anonymous when the data is being obtained. The information gained from the registry will either way be treated equal. 

## Ethical Permit
2015/426-31 and 2016/461-32

### Time plan
3-15 September: Write study plan. 16-28 September: Write analysis plan. 29 September - 28 October: Initial analysis and prepare half time report. 29 October - 30 November: Complete analysis and write results. 1 December - 2 January: Write discussion and finalise thesis.

### Backup plan
All the data exist and there is minimal risk that the data can not be used. One potential problem is that the programming takes longer than usual. In this case there will be experienced (supervisor or other) people that will guide me along the way.

# References
1.	World Health Organization. Injuries and violence: The facts. Geneva: World Health Organization; 2014
2.	Haagsma J. The global burden of injury: incidence, mortality, disability-adjusted life years and time trends from the Global Burden of Disease study 2013 [Internet]. Institute for Health Metrics and Evaluation. 2019 [cited 15 September 2019]. Available from: http://www.healthdata.org/research-article/global-burden-injury-incidence-mortality-disability-adjusted-life-years-and-time
3.	J.M.JONES. (2019). Norwegian survival prediction model in trauma: modelling effects of anatomic injury, acute physiology, age, and co-morbidity. Wiley Online Library [online] available at: https://onlinelibrary.wiley.com/doi/full/10.1111/aas.12256
4.	 Ghorbani P e. Validation of the Norwegian survival prediction model in trauma (NORMIT) in Swedish trauma populations. - PubMed - NCBI [Internet]. Ncbi.nlm.nih.gov. 2019 [cited 25 September 2019]. Available from: https://www.ncbi.nlm.nih.gov/pubmed/?term=Validation+of+the+Norwegian+survival+prediction+model+in+trauma+(NORMIT)+in+Swedish+trauma+populations
5.	.Rcsyd.se. (2019). Om SweTrau | SweTrau. [online] Available at: http://rcsyd.se/swetrau/om-rc-syd [Accessed 13 Sep. 2019]
6.	Sites.google.com. (2019). About TITCO - India - TITCO-India. [online] Available at: https://www.sites.google.com/site/titcoindia/about-titco [Accessed 13 Sep. 2019]
7.	Trauma Quality Programs Participant Use File [Internet]. American College of Surgeons. 2019 [cited 16 September 2019]. Available from: https://www.facs.org/quality-programs/trauma/tqp/center-programs/ntdb/datasets
8.	[Internet]. Facs.org. 2019 page 5 [cited 16 September 2019]. Available from: https://www.facs.org/-/media/files/quality-programs/trauma/ntdb/ntds/data-dictionaries/ntds_data_dictionary_2020.ashx?la=en
9.	 OHCHR | Convention on the Rights of the Child [Internet]. Ohchr.org. 2019 [cited 1 October 2019]. Available from: https://www.ohchr.org/en/professionalinterest/pages/crc.aspx
10.	School, M. (2019). Trauma Team Activation for Pediatrics (age 15 years and below) | Department of Surgery | McGovern Medical School. [online] Med.uth.edu. Available at: https://med.uth.edu/surgery/trauma-team-activation-for-pediatrics-age-15-years-and-below/ [Accessed 13 Sep. 2019].
11.	 TRAUMA.ORG: Trauma Scoring: Revised Trauma Score [Internet]. Trauma.org. 2019 [cited 1 October 2019]. Available from: http://www.trauma.org/archive/scores/rts.html
12.	Janssen KJ e. Updating methods improved the performance of a clinical prediction model in new patients. - PubMed - NCBI [Internet]. Ncbi.nlm.nih.gov. 2019 [cited 1 October 2019]. Available from: https://www.ncbi.nlm.nih.gov/pubmed/18083464
