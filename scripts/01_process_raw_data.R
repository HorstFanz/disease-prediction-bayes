# import data sets from folder into R----

# malaria cases deaths 

library(readr)

malaria_total_cases <- read.csv("data/raw/malaria-cases-deaths/data/MALARIA_TOTAL_CASES.csv")
malaria_est_incidence <- read.csv("data/raw/malaria-cases-deaths/data/MALARIA_EST_INCIDENCE.csv")
malaria_est_mortality <- read.csv("data/raw/malaria-cases-deaths/data/MALARIA_EST_MORTALITY.csv")

# number of deaths from malaria

number_deaths_malaria <- read.csv2("data/raw/number-of-deaths-from-malaria-who/number-of-deaths-from-malaria-who.csv")

# gdp per capita

gdp_per_capita <- read_csv("data/raw/gdp-per-capita-worldbank/gdp-per-capita-worldbank.csv")

# health care expenditure

health_care_expenditure <- read.csv("data/raw/annual-healthcare-expenditure-per-capita/annual-healthcare-expenditure-per-capita.csv")

# pop density 

pop_density <- read.csv("data/raw/population-density/population-density.csv")

# death rate influenza

influenza_death_rate <- read.csv("data/raw/annual-mortality-rate-from-seasonal-influenza-ages-65/annual-mortality-rate-from-seasonal-influenza-ages-65.csv")

# tuberculosis_deaths

tuberculosis_deaths <- read.csv("data/raw/tuberculosis-deaths-who/tuberculosis-deaths-who.csv")

# tuberculosis death rate

tuberculosis_death_rate <- read.csv("data/raw/tuberculosis-death-rate/tuberculosis-death-rate.csv")

# urbanization

ubran_pop_share <- read.csv("data/raw/urban-population-share-2050/urban-population-share-2050.csv")



# look at data----

head(gdp_per_capita) # looks nice and understandable ready to clean
str(gdp_per_capita)
head(health_care_expenditure) # looks good year 
str(health_care_expenditure) # two years included maybe need more COVID period

head(malaria_est_incidence) # weird table structure
head(malaria_est_mortality) # where is the the actual number looks like confidence interval
head(malaria_est_incidence) # country names not included only three letter abbreviations

head(pop_density)
length(unique(pop_density$time))

# delete unnecessary rows and columns----

# handle missing values----
