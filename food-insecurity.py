import matplotlib.pyplot as plt
#plt.style.use('fivethirtyeight') # Makes the plots look like fivethirtyeight
import pandas as pd
from scipy.stats.stats import pearsonr

# Uncomment and use to restore plt settings to default from fivethirtyeight
# plt.rcParams.update(plt.rcParamsDefault)

cty_data = pd.read_csv("county_overall_FI.csv")
gini_data = pd.read_csv("gini_2016.csv")
pov_data = pd.read_csv("county_poverty_trimmed.csv")

# Make the county/state columns in each file lowercase
cty_data['county'] = cty_data['county'].str.lower()
cty_data['state'] = cty_data['state'].str.lower()
gini_data['county'] = gini_data['county'].str.lower()

# Need to combine the state and county columns, with a comma, in cty_data
cty_data['county'] = cty_data['county'] + ", " + cty_data['state']

# Given in the county data set there is no use of the word 'county,' this 
# next line goes through the gini data county column and removes every 'county'
gini_data['county'] = gini_data['county'].str.replace(' county', '')

# Merge the data on county
# We end up with 2,964 counties - so we lose 176 counties.
merged = pd.merge(cty_data, gini_data, on='county')
merged = pd.merge(merged, pov_data, on = "fips")

# Uncomment and runthis next line to save the new file
# merged.to_csv('merged_data.csv')


# Quick check on the correlation between ineq and food insecurity
print(pearsonr(merged['gini'], merged['FI_perc']))

# Regression model
# Module for modeling
import statsmodels.api as sm

# basic OLS regression model. gini predicting FI_perc. Adding the constant
# adds in a column of 1s so we can get an intercept

# Run and print the model
cols = ['gini', 'All Ages in Poverty Percent', 'Median Household Income in Dollars']
basic_model = sm.OLS(merged['FI_perc'], sm.add_constant(merged[cols])).fit() 
print(basic_model.summary())

# Just as a learning experience, here's what happens when you don't add the 
# sm.add_constant - we get a weird model without an intercept.
test_model = sm.OLS(merged['FI_perc'], merged['gini']).fit()
print(test_model.summary())

# From the basic model output, the slope and intercept are .5683 and -0.1004
# So lets make a regression line
slope = .5180
intercept = -.0944
# This is the regression equation for the above model
line = slope*merged['gini'] + intercept

# Plot out the relationship in a quick scatter
plt.scatter(merged['gini'], merged['FI_perc'], s=2)
plt.title("Food Insecurity by Income Inequality")
plt.xlabel("2016 Gini Coefficient")
plt.ylabel("2016 Food Insecurity rate (%)")
plt.plot(merged['gini'], line, color='red', lw=2)
plt.xlim(.3,.7)
plt.ylim(0,.4)
plt.show()