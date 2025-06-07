# read in processed data----

rm(list = ls()) # remove old data, files and functions in environment to avoid dependencies (optional)

# List all CSV files in a folder
files <- list.files("data/processed", pattern = "\\.csv$", full.names = TRUE)

# Read all into a named list
tables <- lapply(files, read.csv)
names(tables) <- basename(files) |> tools::file_path_sans_ext()

# seperate tables for wrangling
gdp_per_capita <- tables[["gdp_per_capita"]]
health_care_expenditure <- tables[["health_care_expenditure"]]
influenza_death_rate <- tables[["influenza_death_rate"]]
malaria_est_incidence <- tables[["malaria_est_incidence"]]
malaria_est_mortality <- tables[["malaria_est_mortality"]]
malaria_total_cases <- tables[["malaria_total_cases"]]
number_deaths_malaria <- tables[["number_deaths_malaria"]]
pop_density <- tables[["pop_density"]]
tuberculosis_death_rate <- tables[["tuberculosis_death_rate"]]
tuberculosis_deaths <- tables[["tuberculosis_deaths"]]
urban_pop_share <- tables[["urban_pop_share"]]

# wrangle to joinable tables----

# note: every tables should have only time period from 2009-2019 in it. also, 
# we make sure that we only have relevant countries in our tables.

# next we calculate the mean values of the time period because we want only one
# observation per table for the corss-sectional model.

# later we can slcie the year 2021 to compare our averaged data to the COVID period

# gdp_per_capita


# define countries for analysis by code variable
countries <- c("NGA", "COD", "UGA", "MOZ", "BFA", "GHA", "NER", "TZA", "MLI", "CMR",
               "AGO", "BEN", "BDI", "CAF", "TCD", "CIV", "GNQ", "ERI", "ETH", "GAB",
               "GMB", "GIN", "GNB", "KEN", "LBR", "MDG", "MWI", "MRT", "NAM", "COG",
               "RWA", "SEN", "SLE", "SOM", "SSD", "SDN", "TGO", "ZMB", "ZWE", "COM")


# wirte function for tidying data
tidy_table <- function (df){
  df %>% 
    filter(between(Year, 2009, 2019),
           Code %in% countries)
}

# store tidied data
tidy_tables <- lapply(tables, tidy_table)

# join tables----

final_table <- reduce(tidy_tables, left_join, by = c("Code", "Year"))

# save jioned table----