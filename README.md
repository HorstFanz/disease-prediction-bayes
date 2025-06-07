# disease-prediction-bayes

This Document is a nice documentation for the project and can be used for the final presentation. 

---

## 01 What we wanted to do (Project Overview)

This project aims to model the frequency or mortality rate of diseases such as malaria or tuberculosis among countries with low GDP per capita. Using a Bayesian linear regression framework, we seek to understand and predict disease outcomes based on socio-economic and demographic factors.

### Research Question

Can we build a predictive model that estimates disease frequency or mortality for a given country based on data from other countries in the dataset?

### Model

We use a Bayesian linear regression model of the form:

\[
Y = \beta_0 + \beta_1 X_1 + \dots + \beta_k X_k
\]

- **Y**: Vector of disease frequency or mortality rates (averaged over a specific year)
- **X**: Matrix of predictors, including GDP per capita, health expenditure per capita, population density, influenza incidence, and population share over 65 years

The analysis is cross-sectional, comparing different countries rather than analyzing time series data.

### Validation

If time allows, we will conduct leave-one-out tests by excluding individual countries to assess the model’s predictive validity.

### Bayesian Modeling Approach

- Employ a Spike-and-Slab Variable Selection (SSVS) prior
- Use Gibbs sampling if necessary, depending on model complexity
- Aim to include as many countries as possible
- Approach inspired by econometric growth prediction models

### Data Sources

Data will be sourced primarily from Our World in Data, Human Development Index (HDI), and World Bank datasets.
For detailed information on the used data, see the README.md file in the Data directory.

---

## 02 What we actually did

### Data manipulation

First, we read in over 10 different time series tables. Then we cleaned the data and took the mean of each variable across the time period 2009-2019.
This period was chosen to avoid any distortion by effeckts caused by COVID. We want to compare the model later to a COVID year (maybe 2021) to better 
understand the difference the COVID has cuased.

We only included countries with significant Malaria burdon in the analysis. All of them are African countries. Additionally, we tried to keep thing comparable by
including only countries with similar economic parameters.

Important: for variable Population share over 65, the estimate is no mean but rather the exact estimation for 2011, as we couldn't find any time series data on this. Similarly, for Malaria total cases, there was only an estimate provided (from years 2015-2019 rest was NAs). No lower or higher bound. Hence, we also droped these variables like with the other Malaria Variables. Some of the other variables contained missing data for several years in our time period or for the countries we chose. When calculating the averages for analysis, we took care of NA handling by setting NA = F in R. 
