setwd("~/dropbox/work/SpyderProjects/food-insecurity/")

data <- read.csv("merged_long.csv")

# Run the Growth Curve Model, no time lag
data$gini <- scale(data$gini, center=TRUE, scale=TRUE)
data$FI_rate <- scale(data$FI_rate, center=TRUE, scale=TRUE)
data$med_house_inc <- scale(data$med_house_inc, center = TRUE, scale = TRUE)
data$perc_below_pov <- scale(data$perc_below_pov, center = TRUE, scale = TRUE)
data <- data[!is.na(data$med_house_inc), ]

library(nlme)
model1 <- lme(gini ~ FI_rate + med_house_inc + perc_below_pov, random = ~ 1|year/fips, data = data)
summary(model1)

model2 <- lme(perc_below_pov ~ FI_rate, random = ~ 1|year/fips, data = data)
summary(model2)

library(ggplot2)
data$year <- as.factor(data$year)

ggplot(data, aes(x=FI_rate, y=gini, color=year)) + geom_point() +
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  scale_color_brewer(palette = 'Set1', direction = -1) + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

ggplot(data, aes(x=FI_rate, y=perc_below_pov, color=year)) + geom_point() +
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  scale_color_brewer(palette = 'Set1', direction = -1) + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

ggplot(data, aes(x=FI_rate, y=gini, color=year)) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  scale_color_brewer(palette = 'Set1') + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))


# Trying to build a growth curve model
library(lavaan)
# Gotta use the wide data for this
data_wide <- read.csv("merged_wide.csv")

library(semPlot)

# Food insecurity predicting poverty
model3 <- '
# Key Paths
perc_below_pov_2016 ~ FI_rate_2015
perc_below_pov_2015 ~ FI_rate_2014
perc_below_pov_2014 ~ FI_rate_2013
perc_below_pov_2013 ~ FI_rate_2012
perc_below_pov_2012 ~ FI_rate_2011
perc_below_pov_2011 ~ FI_rate_2010
# Autoregressions gini
perc_below_pov_2016 ~ perc_below_pov_2015
perc_below_pov_2015 ~ perc_below_pov_2014
perc_below_pov_2014 ~ perc_below_pov_2013
perc_below_pov_2013 ~ perc_below_pov_2012
perc_below_pov_2012 ~ perc_below_pov_2011
perc_below_pov_2011 ~ perc_below_pov_2010
# Autoregressions FI
FI_rate_2016 ~ FI_rate_2015
FI_rate_2015 ~ FI_rate_2014
FI_rate_2014 ~ FI_rate_2013
FI_rate_2013 ~ FI_rate_2012
FI_rate_2012 ~ FI_rate_2011
FI_rate_2011 ~ FI_rate_2010
# Cross correlations
FI_rate_2010 ~~ perc_below_pov_2010
'

fit3 <- sem(model3, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
            auto.var=FALSE)
summary(fit3, fit.measures = TRUE, standardized=TRUE)

semPaths(fit4)


# Food insecurity predicting Gini
model4 <- '
# Key Paths
gini_2016 ~ FI_rate_2015
gini_2015 ~ FI_rate_2014
gini_2014 ~ FI_rate_2013
gini_2013 ~ FI_rate_2012
gini_2012 ~ FI_rate_2011
gini_2011 ~ FI_rate_2010
# Autoregressions gini
gini_2016 ~ gini_2015
gini_2015 ~ gini_2014
gini_2014 ~ gini_2013
gini_2013 ~ gini_2012
gini_2012 ~ gini_2011
gini_2011 ~ gini_2010
# Autoregressions FI
FI_rate_2016 ~ FI_rate_2015
FI_rate_2015 ~ FI_rate_2014
FI_rate_2014 ~ FI_rate_2013
FI_rate_2013 ~ FI_rate_2012
FI_rate_2012 ~ FI_rate_2011
FI_rate_2011 ~ FI_rate_2010
# Cross correlations
FI_rate_2010 ~~ gini_2010
'

fit4 <- sem(model4, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
               auto.var=FALSE)
summary(fit4, fit.measures = TRUE, standardized=TRUE)

semPaths(fit4)

# Food insecurity predicting Gini, controlling for poverty
model4b <- '
# Key Paths
gini_2016 ~ FI_rate_2015
gini_2015 ~ FI_rate_2014
gini_2014 ~ FI_rate_2013
gini_2013 ~ FI_rate_2012
gini_2012 ~ FI_rate_2011
gini_2011 ~ FI_rate_2010
# Autoregressions gini
gini_2016 ~ gini_2015
gini_2015 ~ gini_2014
gini_2014 ~ gini_2013
gini_2013 ~ gini_2012
gini_2012 ~ gini_2011
gini_2011 ~ gini_2010
# Autoregressions FI
FI_rate_2016 ~ FI_rate_2015
FI_rate_2015 ~ FI_rate_2014
FI_rate_2014 ~ FI_rate_2013
FI_rate_2013 ~ FI_rate_2012
FI_rate_2012 ~ FI_rate_2011
FI_rate_2011 ~ FI_rate_2010
# Cross correlations
FI_rate_2010 ~~ gini_2010
# Poverty controls
FI_rate_2010 ~ perc_below_pov_2010
gini_2010 ~ perc_below_pov_2010
FI_rate_2011 ~ perc_below_pov_2011
gini_2011 ~ perc_below_pov_2011
FI_rate_2012 ~ perc_below_pov_2012
gini_2012 ~ perc_below_pov_2012
FI_rate_2013 ~ perc_below_pov_2013
gini_2013 ~ perc_below_pov_2013
FI_rate_2014 ~ perc_below_pov_2014
gini_2014 ~ perc_below_pov_2014
FI_rate_2015 ~ perc_below_pov_2015
gini_2015 ~ perc_below_pov_2015
FI_rate_2016 ~ perc_below_pov_2016
gini_2016 ~ perc_below_pov_2016
'

fit4b <- sem(model4b, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
            auto.var=FALSE)
summary(fit4b, fit.measures = TRUE, standardized=TRUE)

semPaths(fit4b)

# Everything goes away

# gini predicting food insecurity model
model5 <- '
# Key Paths
FI_rate_2016 ~ gini_2015
FI_rate_2015 ~ gini_2014
FI_rate_2014 ~ gini_2013
FI_rate_2013 ~ gini_2012
FI_rate_2012 ~ gini_2011
FI_rate_2011 ~ gini_2010
# Autoregressions gini
gini_2016 ~ gini_2015
gini_2015 ~ gini_2014
gini_2014 ~ gini_2013
gini_2013 ~ gini_2012
gini_2012 ~ gini_2011
gini_2011 ~ gini_2010
# Autoregressions FI
FI_rate_2016 ~ FI_rate_2015
FI_rate_2015 ~ FI_rate_2014
FI_rate_2014 ~ FI_rate_2013
FI_rate_2013 ~ FI_rate_2012
FI_rate_2012 ~ FI_rate_2011
FI_rate_2011 ~ FI_rate_2010
# Cross correlations
FI_rate_2010 ~~ gini_2010
'

fit5 <- sem(model5, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
            auto.var=FALSE)
summary(fit5, fit.measures = TRUE, standardized=TRUE)

# Feedback loop model
model6 <- '
# Key Paths
FI_rate_2016 ~ gini_2015
FI_rate_2015 ~ gini_2014
FI_rate_2014 ~ gini_2013
FI_rate_2013 ~ gini_2012
FI_rate_2012 ~ gini_2011
FI_rate_2011 ~ gini_2010
gini_2016 ~ FI_rate_2015
gini_2015 ~ FI_rate_2014
gini_2014 ~ FI_rate_2013
gini_2013 ~ FI_rate_2012
gini_2012 ~ FI_rate_2011
gini_2011 ~ FI_rate_2010
# Autoregressions gini
gini_2016 ~ gini_2015
gini_2015 ~ gini_2014
gini_2014 ~ gini_2013
gini_2013 ~ gini_2012
gini_2012 ~ gini_2011
gini_2011 ~ gini_2010
# Autoregressions FI
FI_rate_2016 ~ FI_rate_2015
FI_rate_2015 ~ FI_rate_2014
FI_rate_2014 ~ FI_rate_2013
FI_rate_2013 ~ FI_rate_2012
FI_rate_2012 ~ FI_rate_2011
FI_rate_2011 ~ FI_rate_2010
# Cross correlations
FI_rate_2010 ~~ gini_2010
'

fit6 <- sem(model6, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
            auto.var=FALSE)
summary(fit6, fit.measures = TRUE)

# Feedback loop model, poverty
model6b <- '
# Key Paths
FI_rate_2016 ~ perc_below_pov_2015
FI_rate_2015 ~ perc_below_pov_2014
FI_rate_2014 ~ perc_below_pov_2013
FI_rate_2013 ~ perc_below_pov_2012
FI_rate_2012 ~ perc_below_pov_2011
FI_rate_2011 ~ perc_below_pov_2010
perc_below_pov_2016 ~ FI_rate_2015
perc_below_pov_2015 ~ FI_rate_2014
perc_below_pov_2014 ~ FI_rate_2013
perc_below_pov_2013 ~ FI_rate_2012
perc_below_pov_2012 ~ FI_rate_2011
perc_below_pov_2011 ~ FI_rate_2010
# Autoregressions gini
perc_below_pov_2016 ~ perc_below_pov_2015
perc_below_pov_2015 ~ perc_below_pov_2014
perc_below_pov_2014 ~ perc_below_pov_2013
perc_below_pov_2013 ~ perc_below_pov_2012
perc_below_pov_2012 ~ perc_below_pov_2011
perc_below_pov_2011 ~ perc_below_pov_2010
# Autoregressions FI
FI_rate_2016 ~ FI_rate_2015
FI_rate_2015 ~ FI_rate_2014
FI_rate_2014 ~ FI_rate_2013
FI_rate_2013 ~ FI_rate_2012
FI_rate_2012 ~ FI_rate_2011
FI_rate_2011 ~ FI_rate_2010
# Cross correlations
FI_rate_2010 ~~ perc_below_pov_2010
'

fit6b <- sem(model6b, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
            auto.var=FALSE)
summary(fit6b, fit.measures = TRUE)


semPaths(fit4)
semPaths(fit5)
semPaths(fit6)

# The fit is still not amazing but it clearly fits MUCH better this other direction.
# Inequality appears to be a cause of food insecurity

# Rebuild the bi-directional model, controlling for poverty rates
model6b <- '
# Key Paths
FI_rate_2016 ~ gini_2015
FI_rate_2015 ~ gini_2014
FI_rate_2014 ~ gini_2013
FI_rate_2013 ~ gini_2012
FI_rate_2012 ~ gini_2011
FI_rate_2011 ~ gini_2010
gini_2016 ~ FI_rate_2015
gini_2015 ~ FI_rate_2014
gini_2014 ~ FI_rate_2013
gini_2013 ~ FI_rate_2012
gini_2012 ~ FI_rate_2011
gini_2011 ~ FI_rate_2010
# Autoregressions gini
gini_2016 ~ gini_2015
gini_2015 ~ gini_2014
gini_2014 ~ gini_2013
gini_2013 ~ gini_2012
gini_2012 ~ gini_2011
gini_2011 ~ gini_2010
# Autoregressions FI
FI_rate_2016 ~ FI_rate_2015
FI_rate_2015 ~ FI_rate_2014
FI_rate_2014 ~ FI_rate_2013
FI_rate_2013 ~ FI_rate_2012
FI_rate_2012 ~ FI_rate_2011
FI_rate_2011 ~ FI_rate_2010
# Cross correlations
FI_rate_2010 ~~ gini_2010
# Poverty controls
FI_rate_2010 ~ perc_below_pov_2010
gini_2010 ~ perc_below_pov_2010
FI_rate_2011 ~ perc_below_pov_2011
gini_2011 ~ perc_below_pov_2011
FI_rate_2012 ~ perc_below_pov_2012
gini_2012 ~ perc_below_pov_2012
FI_rate_2013 ~ perc_below_pov_2013
gini_2013 ~ perc_below_pov_2013
FI_rate_2014 ~ perc_below_pov_2014
gini_2014 ~ perc_below_pov_2014
FI_rate_2015 ~ perc_below_pov_2015
gini_2015 ~ perc_below_pov_2015
FI_rate_2016 ~ perc_below_pov_2016
gini_2016 ~ perc_below_pov_2016
'

fit6b <- sem(model6b, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
            auto.var=FALSE)
summary(fit6b, fit.measures = TRUE)
semPaths(fit6b)

# As one might expect, most of the pathways get demolished when we control for poverty. Poverty
# is doing most of the lifting here "causing" both inequality 

# Paul's suggestions
model7 <- '
# Key Paths
gini_2016 ~ FI_rate_2015
gini_2015 ~ FI_rate_2014
gini_2014 ~ FI_rate_2013
gini_2013 ~ FI_rate_2012
gini_2012 ~ FI_rate_2011
gini_2011 ~ FI_rate_2010
FI_rate_2010 ~ gini_2010
FI_rate_2011 ~ gini_2011
FI_rate_2012 ~ gini_2012
FI_rate_2013 ~ gini_2013
FI_rate_2014 ~ gini_2014
FI_rate_2015 ~ gini_2015
FI_rate_2016 ~ gini_2016
# Autoregressions gini
gini_2016 ~ gini_2015
gini_2015 ~ gini_2014
gini_2014 ~ gini_2013
gini_2013 ~ gini_2012
gini_2012 ~ gini_2011
gini_2011 ~ gini_2010
# Autoregressions FI
FI_rate_2016 ~ FI_rate_2015
FI_rate_2015 ~ FI_rate_2014
FI_rate_2014 ~ FI_rate_2013
FI_rate_2013 ~ FI_rate_2012
FI_rate_2012 ~ FI_rate_2011
FI_rate_2011 ~ FI_rate_2010
'

fit7 <- sem(model7, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
            auto.var=FALSE)
summary(fit7, fit.measures = TRUE, standardized=TRUE)

semPaths(fit7)

# Food insecurity predicting poverty the next year, controlling for same year poverty predicting
# same year FI
model8 <- '
# Key Paths
perc_below_pov_2016 ~ FI_rate_2015
perc_below_pov_2015 ~ FI_rate_2014
perc_below_pov_2014 ~ FI_rate_2013
perc_below_pov_2013 ~ FI_rate_2012
perc_below_pov_2012 ~ FI_rate_2011
perc_below_pov_2011 ~ FI_rate_2010
FI_rate_2011 ~ perc_below_pov_2011
FI_rate_2012 ~ perc_below_pov_2012
FI_rate_2013 ~ perc_below_pov_2013
FI_rate_2014 ~ perc_below_pov_2014
FI_rate_2015 ~ perc_below_pov_2015
FI_rate_2016 ~ perc_below_pov_2016
# Autoregressions gini
perc_below_pov_2016 ~ perc_below_pov_2015
perc_below_pov_2015 ~ perc_below_pov_2014
perc_below_pov_2014 ~ perc_below_pov_2013
perc_below_pov_2013 ~ perc_below_pov_2012
perc_below_pov_2012 ~ perc_below_pov_2011
perc_below_pov_2011 ~ perc_below_pov_2010
# Autoregressions FI
FI_rate_2016 ~ FI_rate_2015
FI_rate_2015 ~ FI_rate_2014
FI_rate_2014 ~ FI_rate_2013
FI_rate_2013 ~ FI_rate_2012
FI_rate_2012 ~ FI_rate_2011
FI_rate_2011 ~ FI_rate_2010
# Cross correlations
FI_rate_2010 ~~ perc_below_pov_2010
# Fix the var of pov 2010
perc_below_pov_2010~1*perc_below_pov_2010
'

fit8 <- sem(model8, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
               auto.var=FALSE)
summary(fit8, fit.measures = TRUE)

semPaths(fit4)

# ------------------------------------------------------------------------------------------------
# Child food insecurity models models
# ------------------------------------------------------------------------------------------------
data_wide$FI_child_2013 <- as.character(data_wide$FI_child_2013)
data_wide$FI_child_2013 <- as.numeric(data_wide$FI_child_2013)

model6 <- '
# Key Paths
FI_child_2016 ~ gini_2015
FI_child_2015 ~ gini_2014
FI_child_2014 ~ gini_2013
FI_child_2013 ~ gini_2012
FI_child_2012 ~ gini_2011
FI_child_2011 ~ gini_2010
# Autoregressions gini
gini_2016 ~ gini_2015
gini_2015 ~ gini_2014
gini_2014 ~ gini_2013
gini_2013 ~ gini_2012
gini_2012 ~ gini_2011
gini_2011 ~ 1*gini_2010
# Autoregressions FI
FI_child_2016 ~ FI_child_2015
FI_child_2015 ~ FI_child_2014
FI_child_2014 ~ FI_child_2013
FI_child_2013 ~ FI_child_2012
FI_child_2012 ~ FI_child_2011
FI_child_2011 ~ 1*FI_child_2010
# Cross correlations
FI_child_2016 ~~ gini_2016
FI_child_2015 ~~ gini_2015
FI_child_2014 ~~ gini_2014
FI_child_2013 ~~ gini_2013
FI_child_2012 ~~ gini_2012
FI_child_2011 ~~ gini_2011
FI_child_2010 ~~ gini_2010
'

fit6 <- sem(model6, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
            auto.var=FALSE)
summary(fit6, fit.measures = TRUE, standardized=TRUE)

semPaths(fit5)


# child FI -> inequality
model7 <- '
# Key Paths
gini_2016 ~ FI_child_2015
gini_2015 ~ FI_child_2014
gini_2014 ~ FI_child_2013
gini_2013 ~ FI_child_2012
gini_2012 ~ FI_child_2011
gini_2011 ~ FI_child_2010
# Autoregressions gini
gini_2016 ~ gini_2015
gini_2015 ~ gini_2014
gini_2014 ~ gini_2013
gini_2013 ~ gini_2012
gini_2012 ~ gini_2011
gini_2011 ~ 1*gini_2010
# Autoregressions FI
FI_child_2016 ~ FI_child_2015
FI_child_2015 ~ FI_child_2014
FI_child_2014 ~ FI_child_2013
FI_child_2013 ~ FI_child_2012
FI_child_2012 ~ FI_child_2011
FI_child_2011 ~ 1*FI_child_2010
# Cross correlations
FI_child_2016 ~~ gini_2016
FI_child_2015 ~~ gini_2015
FI_child_2014 ~~ gini_2014
FI_child_2013 ~~ gini_2013
FI_child_2012 ~~ gini_2012
FI_child_2011 ~~ gini_2011
FI_child_2010 ~~ gini_2010
'

fit7 <- sem(model7, data = data_wide, auto.cov.y = FALSE, std.ov=TRUE, estimator='ML',
            auto.var=FALSE)
summary(fit7, fit.measures = TRUE, standardized=TRUE)

semPaths(fit5)

library(lattice)
p1 <- xyplot(gini ~ year, groups = fips, data=data, type=c("a", "g"))
p2 <- xyplot(FI_rate ~ year, groups = fips, data=data, type=c("a","g"))
print(p2)




