# Total health expenditure per person - Data package

This data package contains the data that powers the chart ["Total health expenditure per person"](https://ourworldindata.org/grapher/annual-healthcare-expenditure-per-capita?v=1&csvType=full&useColumnShortNames=false) on the Our World in Data website. It was downloaded on June 04, 2025.

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


## Current health expenditure per capita, PPP (current international $)
Last updated: January 24, 2025  
Next update: January 2026  
Date range: 2000–2022  
Unit: current international $  


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
World Health Organization (2025) – processed by Our World in Data

#### Full citation
World Health Organization (2025) – processed by Our World in Data. “Current health expenditure per capita, PPP (current international $)” [dataset]. World Health Organization, “World Development Indicators” [original data].
Source: World Health Organization (2025) – processed by Our World In Data

### How is this data described by its producer - World Health Organization (2025)?
Current expenditures on health per capita expressed in international dollars at purchasing power parity.

Statistical concept and methodology: The health expenditure estimates have been prepared by the World Health Organization (WHO) under the framework of the System of Health Accounts 2011 (SHA 2011). The Health SHA 2011 tracks all health spending in a given country over a defined period of time regardless of the entity or institution that financed and managed that spending. It generates consistent and comprehensive data on health spending in a country, which in turn can contribute to evidence-based policy-making. WHO converted the expenditure data using PPP time series extracted from WDI (based on ICP 2017) and OECD data. Where WDI/OECD data were not available, IMF or WHO estimates were utilized. Detailed metadata are available at <https://apps.who.int/nha/database/Select/Indicators/en>.

Notes from original source: The World Health Organization (WHO) has revised health expenditure data using the new international classification for health expenditures in the revised System of Health Accounts (SHA 2011). WHO’s Global Health Expenditure Database in this new version is the reference source for health expenditure for international comparison imbedded in a standardized framework. The SHA 2011 clarifies the financing mechanisms and introduces new dimensions which improve the comparability of health expenditures in the perspective of universal health coverage.

### Source

#### World Health Organization – World Development Indicators
Retrieved on: 2025-01-24  
Retrieved from: https://datacatalog.worldbank.org/search/dataset/0037712/World-Development-Indicators  


    