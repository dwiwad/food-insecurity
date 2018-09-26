# Multilevel model of food insecurity and economic inequality by county and year

setwd("/users/dylanwiwad/dropbox/work/spyderprojects/food-insecurity/")
data = read.csv('merged_long.csv')
library(nlme)

data$gini <- scale(data$gini, center=TRUE, scale=TRUE)
data$FI_rate <- scale(data$FI_rate, center=TRUE, scale=TRUE)

# Null model for fips
null.model.fips <- lme(gini ~ 1, data=data, random = ~ 1|fips, method = 'ML', na.action = 'na.omit')
summary(null.model.fips)

# Null model for year
null.model.year <- lme(gini ~ 1, data=data, random = ~ 1|year, method = 'ML', na.action = 'na.omit')
summary(null.model.year)

# Full null model
null.model <- lme(gini ~ 1, data=data, random = ~ 1|year/fips, method = 'ML', na.action = 'na.omit')
summary(null.model)

# time series model
fi.only.model <- lme(gini~FI_rate, data=data, random= ~ 1|year/fips, method='ML', na.action='na.omit')
summary(fi.only.model)

data$year[data$year == 2010] <- 1
data$year[data$year == 2011] <- 2
data$year[data$year == 2012] <- 3
data$year[data$year == 2013] <- 4
data$year[data$year == 2014] <- 5
data$year[data$year == 2015] <- 6
data$year[data$year == 2016] <- 7
