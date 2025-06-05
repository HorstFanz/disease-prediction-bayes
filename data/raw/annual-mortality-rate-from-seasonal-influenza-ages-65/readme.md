# Respiratory death rate from seasonal influenza, age 65+ - Data package

This data package contains the data that powers the chart ["Respiratory death rate from seasonal influenza, age 65+"](https://ourworldindata.org/grapher/annual-mortality-rate-from-seasonal-influenza-ages-65?v=1&csvType=full&useColumnShortNames=false) on the Our World in Data website. It was downloaded on June 04, 2025.

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


## Annual mortality rate (ages 65+)


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
GLaMOR (2019) – processed by Our World in Data

#### Full citation
GLaMOR (2019) – processed by Our World in Data. “Annual mortality rate (ages 65+)” [dataset]. GLaMOR (2019) [original data].
Source: GLaMOR (2019) – processed by Our World In Data

### Additional information about this data
This study was part of the Global Pandemic Mortality Project II (GLaMOR) and was conducted by the Netherlands Institute for Health Service Research, in collaboration with the US National Institutes of Health and Centers for Disease Control, funded by the World Health Organization.

The authors used a two stage approach to estimate annual mortality from seasonal influenza between 2002 and 2011 (excluding the Swine flu pandemic season). In the first step, the authors used weekly or monthly mortality records and influenza surveillance data to estimate age-specific excess respiratory mortality caused by seasonal influenza for 31 countries. In the second step, they used country-specific indicators to extrapolate these estimates to remaining countries. They applied sensitivity analyses and estimated reliability coefficients to understand how sensitive these estimates were to different methodological decisions. 

These estimates focus on respiratory-associated influenza mortality. This means they aim to include respiratory deaths where other complications may have been listed as the primary cause of death, but those deaths were actually caused by influenza. However, it would exclude deaths where patients did not have respiratory disease, even if their deaths were caused by influenza (such as through only cardiovascular complications).

The global number of people who die from other complications of the flu is unclear. Paget et al. (the authors of the GLaMOR project) state in their paper that their estimate “does not cover cardiovascular deaths, something that could at least double the estimate of influenza-associated deaths.” In recent meta-analyses, Behrouzi et al. found that influenza vaccination reduces the chances of major cardiovascular events (such as heart attacks and strokes) by around 34%, in clinical trials of the elderly. This suggests the death toll from other complications could be large. However, global estimates have not been made of these types of deaths from flu.

See: Paget, J., Danielle Iuliano, A., Taylor, R. J., Simonsen, L., Viboud, C., & Spreeuwenberg, P. (2022). Estimates of mortality associated with seasonal influenza for the European Union from the GLaMOR project. Vaccine, 40(9), 1361–1369. https://doi.org/10.1016/j.vaccine.2021.11.080
Behrouzi, B., Bhatt, D. L., Cannon, C. P., Vardeny, O., Lee, D. S., Solomon, S. D., & Udell, J. A. (2022). Association of Influenza Vaccination With Cardiovascular Risk: A Meta-analysis. JAMA Network Open, 5(4), e228873. https://doi.org/10.1001/jamanetworkopen.2022.8873


    