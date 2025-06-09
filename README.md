# disease-prediction-bayes

This Document is a summary of the project and can be used for the final presentation. 

## What we wanted to do (Project Overview)

- Model the frequency or mortality rate of diseases such as malaria or tuberculosis  
- Use cross sectional analysis for comparing countries with comparable disease (Malaria) incidence
- Use a Bayesian linear regression framework 
- Understand and predict disease (Malaira) outcomes based on socio-economic, demographic and medical factors

## Research Question(s)

- Can we build a predictive model that estimates disease frequency or mortality rate for a given country?
- How good is our model?
- How well can we predict the response variable for the countries in our data set?

## Data Sources

- Data was used from Our World in Data, Human Development Index (HDI), and World Bank datasets (unitl now HDI data wasn't used)
- For detailed information on the used data, see the [`README.md file`](/data/README.md) in the Data directory.

## Remarks on data

- Variable Population share over 65, the estimate is no mean but rather the exact estimation for 2011
- No time series for this predictor available
- Malaria total cases, there was only an estimate provided (from years 2015-2019 rest was NAs) 
- No lower or higher bound. Hence, we also droped these variables 
- Only used Estimate for Malaria variables, not lower and upper bounds
- Some of the variables contained missing data for several years
- Handled this by setting time period of interest very recent
- Only one NA remained and was resolved by interpolating the mean of 2009-2019 

## Data manipulation

- We read in over 10 different time series tables
- We cleaned the data and took the mean of each variable across the time period 2009-2019
- Selection to avoid COVID distortion effeckts and better data quality
- Assumption: More recent data is more reliable

## Bayesian Modeling Approach

- Employed a Spike-and-Slab Variable Selection (SSVS) prior
- Used Gibbs sampling to find relevant predictors
- Aimed to include as many countries as possible (we ended up with 40)
- Approach inspired by econometric growth prediction models

## Our Model

- We use a Bayesian linear regression model of the form:

\[
Y = \beta_0 + \beta_1 X_1 + \dots + \beta_k X_k
\]

- **Y**: Vector of disease frequency or mortality rates (averaged over a specific year). Ended up using Malaria mortality per 100 000 population  
- **X**: Matrix of predictors, including GDP per capita, health expenditure per capita, population density, influenza incidence, population share over 65 years

- The analysis is cross-sectional, comparing different countries rather than analyzing time series data
- Checked for multicoliniarity when [`implementing the model`](/scripts/03_model_SSVS.R)

## Validation

- We did leave-one-out analysis by excluding individual countries to assess the model’s predictive validity
- The results can be seen in [`this script`](/scripts/05_loo_SSVS.R)

## Results

- Model does good job at predicting the response variable
- Some variables more relevant than others (insert examples)
- Room for improvement

## To Do

- Check the script for errors (especially the later ones further info can be found at [`README.md file in /scripts`](/scripts))
- Chose country of interest for prediction
- Predict the response variable for country of interest. This can be done using the model scrpits in [`/scrpits`](/scripts)
- Elaborate on visualization and summary of the results 
- Store results in [`output folder`](/output/)
- Create presentation for June 24th

### Optional

- Comparison to COVID year (maybe 2021)
- Check if the prediction was close to the actual data
- Experiment with inclusion and exclusion of predictors to optimize model