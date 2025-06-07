# import data sets from folder into R----

# malaria cases deaths 

library(readr)

r_malaria_total_cases <- read.csv("data/raw/malaria-cases-deaths/data/MALARIA_TOTAL_CASES.csv")
r_malaria_est_incidence <- read.csv("data/raw/malaria-cases-deaths/data/MALARIA_EST_INCIDENCE.csv")
r_malaria_est_mortality <- read.csv("data/raw/malaria-cases-deaths/data/MALARIA_EST_MORTALITY.csv")

# number of deaths from malaria

r_number_deaths_malaria <- read.csv("data/raw/number-of-deaths-from-malaria-who/number-of-deaths-from-malaria-who.csv")

# gdp per capita

r_gdp_per_capita <- read_csv("data/raw/gdp-per-capita-worldbank/gdp-per-capita-worldbank.csv")

# health care expenditure

r_health_care_expenditure <- read.csv("data/raw/annual-healthcare-expenditure-per-capita/annual-healthcare-expenditure-per-capita.csv")

# pop density 

r_pop_density <- read.csv("data/raw/population-density/population-density.csv")

# death rate influenza

r_influenza_death_rate <- read.csv("data/raw/annual-mortality-rate-from-seasonal-influenza-ages-65/annual-mortality-rate-from-seasonal-influenza-ages-65.csv")

# tuberculosis_deaths

r_tuberculosis_deaths <- read.csv("data/raw/tuberculosis-deaths-who/tuberculosis-deaths-who.csv")

# tuberculosis death rate

r_tuberculosis_death_rate <- read.csv("data/raw/tuberculosis-death-rate/tuberculosis-death-rate.csv")

# urbanization

r_urban_pop_share <- read.csv("data/raw/urban-population-share-2050/urban-population-share-2050.csv")

# delete unnecessary rows and columns----

# different table structures -> clean every table individually
# directive: keep only relevant countries (maybe 30), only relevant years (from 1990)

length(r_gdp_per_capita$Entity) # large table but format is acceptable. we don't know what we need exactly just yet. 

str(r_health_care_expenditure) # format acceptable

str(r_influenza_death_rate) # format acceptable

str(r_malaria_est_incidence) # weird format need cleening. since all successive tables come from our world in data -> write function

# create function for speed

clean_table <- function (df){
  df <- df %>% 
    select(Code = SpatialDimensionValueCode, # rename for better joining
           Year = TimeDim, 
           Estimate = NumericValue,
           Low,
           High)
  return(df)
}

r_malaria_est_incidence <- clean_table(r_malaria_est_incidence) # looks good

# write for loop to not have to retype the last line

ourwid_table_names <- c("r_malaria_est_mortality", "r_malaria_total_cases")

for (name in ourwid_table_names){
  df <- get(name)
  cleaned <- clean_table(df)
  assign(name, cleaned)
} 

remove(df, cleaned) # remove unnecessary tables

head(r_malaria_est_mortality, 1) # looks solid

# clean rest of tables to similar format

str(r_number_deaths_malaria,1) # format acceptable

r_pop_density <- r_pop_density %>% 
  filter(between(Year, 1950, 2025)) # we dont need ancient past or future values

str(r_tuberculosis_death_rate) # format acceptable

str(r_tuberculosis_deaths) # format acceptable

r_urban_pop_share <- r_urban_pop_share %>% 
  filter(between(Year, 1950, 2025)) # same as pop_density

# check missing values----

r_tables <- list(r_gdp_per_capita, r_health_care_expenditure,
                 r_influenza_death_rate, r_malaria_est_incidence, 
                 r_malaria_est_mortality, r_malaria_total_cases, 
                 r_number_deaths_malaria, r_pop_density, 
                 r_tuberculosis_death_rate, r_tuberculosis_deaths, 
                 r_urban_pop_share)

for (table in r_tables){ 
  if (any(is.na(table))){
    print("has Na")
    } else {
      print("no NA")
    }
} # there are some NAs -> Keep NAs in individual tables for now to not lose data early.
  # After joining, filter out or impute NAs in the final combined table before modeling.

# save processed tables----

names(r_tables) <- c("gdp_per_capita", "health_care_expenditure", 
                   "influenza_death_rate", "malaria_est_incidence", 
                   "malaria_est_mortality", "malaria_total_cases", 
                   "number_deaths_malaria", "pop_density", 
                   "tuberculosis_death_rate", "tuberculosis_deaths", 

                                      "urban_pop_share") # assign names to tables
# write function

save_table <- function (df, name){
  write.csv(df, paste0("data/processed/", name, ".csv"), row.names = FALSE)
}

# loop into desired directory

for (name in names(r_tables)){
  save_table(r_tables[[name]], name)
}

