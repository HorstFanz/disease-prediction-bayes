# Disease Frequency and Mortality Prediction

## Project Overview

This project aims to model the frequency or mortality rate of diseases such as malaria or tuberculosis among countries with low GDP per capita. Using a Bayesian linear regression framework, we seek to understand and predict disease outcomes based on socio-economic and demographic factors.

## Model

We use a Bayesian linear regression model of the form:

\[
Y = \beta_0 + \beta_1 X_1 + \dots + \beta_k X_k
\]

- **Y**: Vector of disease frequency or mortality rates (averaged over a specific year)
- **X**: Matrix of predictors, including GDP per capita, health expenditure per capita, population density, influenza incidence, and population share over 65 years

The analysis is cross-sectional, comparing different countries rather than analyzing time series data.

## Research Question

Can we build a predictive model that estimates disease frequency or mortality for a given country based on data from other countries in the dataset?

## Validation

If time allows, we will conduct leave-one-out tests by excluding individual countries to assess the model’s predictive validity.

## Bayesian Modeling Approach

- Employ a Spike-and-Slab Variable Selection (SSVS) prior
- Use Gibbs sampling if necessary, depending on model complexity
- Aim to include as many countries as possible
- Approach inspired by econometric growth prediction models

## Data Sources

Data will be sourced primarily from Our World in Data, Human Development Index (HDI), and World Bank datasets.

