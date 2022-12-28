#If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
#{
  # library(here)
  # source(here("Scripts","Session-Related","Packages.R"))
  # source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
#}

TotalNumberOfObservations = length(WeatherDataDailyResolution$alt)

Observations_Between_0th_And_75thPercentile = length(which(WeatherDataDailyResolution$alt <= quantile(WeatherDataDailyResolution$alt, 0.75)))

Observations_Greater_Than_75th_SmallerEqual_95thPercentile = length(which(
  WeatherDataDailyResolution$alt > quantile(WeatherDataDailyResolution$alt, 0.75) &  
  WeatherDataDailyResolution$alt <= quantile(WeatherDataDailyResolution$alt,0.95)))

Observations_Greater_Than_95thSmallerEqual_99thPercentile = length(which(
  WeatherDataDailyResolution$alt > quantile(WeatherDataDailyResolution$alt, 0.95) &  
    WeatherDataDailyResolution$alt <= quantile(WeatherDataDailyResolution$alt,0.99)))

Observations_Greater_Than_99thPercentile = length(which(
  WeatherDataDailyResolution$alt > quantile(WeatherDataDailyResolution$alt, 0.99)))

Observations_Greater_Than_99thPercentile
