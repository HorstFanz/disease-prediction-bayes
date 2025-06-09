# Documentation of all scripts 

## 01_process_raw_data

A script that 

- takes the raw data and does some first wrangling
- stores the cleaned tables into processed tables in [`/data/processed`](/data/processed)

### Additional information

This script was reviewed twice and tested. Data was available for relevant countries and time period.

## 02_build_model_table

A script that

- takes the cleaned data and does further wrangling
- selects the countries and time period of interest
- joins all tables into single table in [`/data/processed`](/data/processed)

### Additional information

This script was reviewed several times. The country selection was done based on a search of the main countries with malaria cases (all of them in Africa). This includes about 40 countries. The selection may be changed according to better prior information on the spread of Malaria across the region. 

The time period 2009-2019 was used to calculate a mean of the predictor variables. Changes may be applied with caution. 2020 was excluded bacuase of potential COVID effeckts. 

## 03_model_SSVS

A script that

- takes the model table
- uses the code.SSVS file from the course
- models the malaria mortality rate as a linear regression of the predictors
- uses cross sectional approach ans SSVS prior for modelling 
- includes a section for visualization and summaries 

### Additional information

The model was scaled to make the regression easier to calculate. If not applied, comparison of predictors might not be possible (idea of chat gpt needs validation). Interpretation of the final results might need some rescaling to be able to talk about respective predictor units. 

## 04_function_SSVS

A script that 

- uses the SSVS.function from the course
- creates a similar function for our model

### Additional information

This script relied heavily on the use of generative AI. The results need to be revisited carefully. 

## 05_loo_SSVS

A script that

- impliments a leave one (country) out analysis
- compares the predicted Malaria mortality rate with the actual rate seen in the data
- istores ncludes summary and visualization of the results in [`/output`](/output)

### Additional information

This script relied heavily on the use of generative AI. The results need to be revisited carefully. 