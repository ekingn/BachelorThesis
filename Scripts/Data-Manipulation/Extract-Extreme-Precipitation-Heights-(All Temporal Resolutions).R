# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
  # library(here)
  # source(here("Scripts","Session-Related","Packages.R"))
  # source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
}

# Daily Temporal Resolution
{
# Compute the 95th percentile of the daily resolution weather data
ExtremePrecipitationClassificationBoundariesDailyResolution = data.frame("ClassificationBoundaries"= quantile(WeatherDataDailyResolution$rain,probs = c(0.05,0.95),na.rm = TRUE))

# Extract the extreme precipitation events / extreme precipitation heights based on the 95th percentile as threshold
ExtremePrecipitationHeightsDailyResolution = data.frame("ExtremePrecipitationHeights" = 
                                                          filter(.data = WeatherDataDailyResolution,
                                                                 rain >= ExtremePrecipitationClassificationBoundariesDailyResolution[2,1])) # Only Extreme Precipitation Heights
}

# Monthly Temporal Resolution
{
# Compute the 95th percentile of the monthly resolution weather data
ExtremePrecipitationClassificationBoundariesMonthlyResolution = data.frame("ClassificationBoundaries"= quantile(WeatherDataMonthlyResolution$`PrecipitationHeightInMillimetre`,
                                                                                                                probs = c(0.05,0.95),na.rm = TRUE))

# Extract the extreme precipitation events / extreme precipitation heights based on the 95th percentile as threshold
ExtremePrecipitationHeightsMonthlyResolution = data.frame("ExtremePrecipitationHeights" = 
                                           filter(.data = WeatherDataMonthlyResolution,
                                                  PrecipitationHeightInMillimetre >= ExtremePrecipitationClassificationBoundariesMonthlyResolution[2,1])) # Only Extreme Precipitation Heights
}

# Annual Temporal Resolution
{
# Compute the 95th percentile of the annual resolution weather data 
ExtremePrecipitationClassificationBoundariesAnnualResolution = data.frame("ClassificationBoundaries"= quantile(WeatherDataAnnualResolution$AnnualPrecipitationHeightInMillimetre,
                                                                                                               probs = c(0.05,0.95),na.rm = TRUE))

# Extract the extreme precipitation events / extreme precipitation heights based on the 95th percentile as threshold
ExtremePrecipitationHeightsAnnualResolution = data.frame("ExtremePrecipitationHeights" = 
                                                            filter(.data = WeatherDataAnnualResolution,
                                                                   AnnualPrecipitationHeightInMillimetre >= ExtremePrecipitationClassificationBoundariesAnnualResolution[2,1])) # Only Extreme Precipitation Heights
}