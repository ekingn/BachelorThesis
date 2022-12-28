# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
#{
# library(here)
# source(here("Scripts","Session-Related","Packages.R"))
# source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
#}

# Estimate a linear regression model 
ResultsLinearRegression = lm(rain~T+sun+year+month+day+alt+lon+lat, data = WeatherDataDailyResolution)
summary(ResultsLinearRegression$residuals)

# Compute the standardized residuals
StandardizedResidualsLinearRegression = rstandard(ResultsLinearRegression)

# Get an overview of the distribution of the standardized residuals 
# summary(StandardizedResidualsLinearRegression)

# Determine the 5th and 95th percentile of the distribution of standardized residuals 
quantile(StandardizedResidualsLinearRegression,0.05)
quantile(StandardizedResidualsLinearRegression,0.95)

PlotAsBarsFrequencyOfStandardizedResidualsLinearRegression = qplot(x = StandardizedResidualsLinearRegression, 
                                                                   fill = I("white"), color = I("black"), 
                                                                   xlab = "Residuals",
                                                                   ylab = paste0("Absolute\nFrequency"),
                                                                   breaks = c(seq(from=-2, to=5, by = 0.1 )),
                                                                   main = "Distribution of residuals") + expand_limits(x=0, y=0) + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  scale_x_continuous(breaks = c(seq(from=-2, to=5, by=0.1))) + 
  scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))


PlotAsBarsFrequencyOfStandardizedResidualsLinearRegression = qplot(x = StandardizedResidualsLinearRegression, 
                                                                   fill = I("white"), color = I("black"), 
                                                                   xlab = "Residuals",
                                                                   ylab = paste0("Absolute\nFrequency"),
                                                                   breaks = c(seq(from=-2, to=5, by = 0.1 )),
                                                                   main = "Distribution of residuals") + expand_limits(x=0, y=0) + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  scale_x_continuous(breaks = c(seq(from=-2, to=5, by=0.1))) + 
  scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))

plot(ResultsLinearRegression)

# Unable to conduct the Durbin-Watson-Test due to vast requirement of working memory 
# durbinWatsonTest(ResultsLinearRegression)