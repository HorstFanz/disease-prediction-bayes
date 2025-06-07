# Number of deaths from malaria - Data package

This data package contains the data that powers the chart ["Number of deaths from malaria"](https://ourworldindata.org/grapher/number-of-deaths-from-malaria-who?v=1&csvType=full&useColumnShortNames=false) on the Our World in Data website. It was downloaded on June 04, 2025.

### Active Filters

A filtered subset of the full data was downloaded. The following filters were applied:

## CSV Structure

The high level structure of the CSV file is that each row is an observation for an entity (usually a country or region) and a timepoint (usually a year).

The first two columns in the CSV file are "Entity" and "Code". "Entity" is the name of the entity (e.g. "United States"). "Code" is the OWID internal entity code that we use if the entity is a country or region. For normal countries, this is the same as the [iso alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code of the entity (e.g. "USA") - for non-standard countries like historical countries these are custom codes.

The third column is either "Year" or "Day". If the data is annual, this is "Year" and contains only the year as an integer. If the column is "Day", the column contains a date string in the form "YYYY-MM-DD".

The final column is the data column, which is the time series that powers the chart. If the CSV data is downloaded using the "full data" option, then the column corresponds to the time series below. If the CSV data is downloaded using the "only selected data visible in the chart" option then the data column is transformed depending on the chart type and thus the association with the time series might not be as straightforward.

## Metadata.json structure

The .metadata.json file contains metadata about the data package. The "charts" key contains information to recreate the chart, like the title, subtitle etc.. The "columns" key contains information about each of the columns in the csv, like the unit, timespan covered, citation for the data etc..

## About the data

Our World in Data is almost never the original producer of the data - almost all of the data we use has been compiled by others. If you want to re-use data, it is your responsibility to ensure that you adhere to the sources' license and to credit them correctly. Please note that a single time series may have more than one source - e.g. when we stich together data from different time periods by different producers or when we calculate per capita metrics using population data from a second source.

## Detailed information about the data


## Estimated number of malaria deaths
Estimated number of deaths due to malaria
Last updated: January 3, 2024  
Next update: July 2025  
Date range: 2000–2021  
Unit: Deaths  


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
World Health Organization - Global Health Observatory (2024) – processed by Our World in Data

#### Full citation
World Health Organization - Global Health Observatory (2024) – processed by Our World in Data. “Estimated number of malaria deaths” [dataset]. World Health Organization, “Global Health Observatory” [original data].
Source: World Health Organization - Global Health Observatory (2024) – processed by Our World In Data

### How is this data described by its producer - World Health Organization - Global Health Observatory (2024)?
#### Definition
Estimated number of deaths due to malaria

#### Method of measurement
The number of deaths due to indigenously acquired malaria was reported by national malaria control programs to WHO. The number of malaria estimated cases per Plasmodium species was used to estimate deaths after applying a species-specific case fatality rates.

#### Method of estimation
The number of malaria deaths was estimated by one of two methods: i) For countries outside Africa and for low-transmission countries in Africa: the number of deaths was estimated by multiplying the estimated number of P. falciparum malaria cases by a fixed case fatality rate for each country, as described in the World malaria report 2008. This method was used for all countries outside Africa and for low-transmission countries in Africa, where estimates of case incidence were derived from routine reporting systems. A case fatality rate of between 0.01% and 0.40% was applied to the estimated number of P. falciparum cases, and a case fatality rate of between 0.01% and 0.06% was applied to the estimated number of P. vivax cases. For countries in the pre-elimination and elimination phases, and those with vital registration systems that reported more than 50% of all deaths (determined by comparing the number of reported deaths with those expected given a country’s population size and crude deaths rate), the number of malaria deaths was derived from the number of reported deaths, adjusting for completeness of reporting. ii) For countries in Africa with a high proportion of deaths due to malaria: child malaria deaths were estimated using a verbal autopsy multicause model developed by the Maternal and Child Health Epidemiology Estimation Group which estimates causes of death for children aged 1–59 months. Mortality estimates were derived for eight causes of post-neonatal death (pneumonia, diarrhoea, malaria, meningitis, injuries, pertussis, tuberculosis and other disorders), causes arising in the neonatal period (prematurity, birth asphyxia and trauma, sepsis, and other conditions of the neonate) and other causes (e.g. malnutrition). Deaths due to measles, unknown causes and HIV/AIDS were estimated separately. The resulting cause-specific estimates were adjusted, country by country, to fit the estimated 1–59 month mortality envelopes (excluding HIV and measles deaths) for corresponding years. Estimated malaria parasite prevalence, was used as a covariate within the model. Deaths in those aged over 5 years were inferred from a relationship between levels of malaria mortality in different age groups and the intensity of malaria transmission; thus, the estimated malaria mortality rate in children aged under 5 years was used to infer malaria-specific mortality in older age groups.

### Source

#### World Health Organization – Global Health Observatory
Retrieved on: 2024-01-03  
Retrieved from: https://www.who.int/data/gho  


    