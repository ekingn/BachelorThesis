# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
  # library(here)
  # source(here("Scripts","Session-Related","Packages.R"))
  # source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
}

# Transformation of the WeatherData from daily to monthly resolution (summing up daily total precipitation)
WeatherDataMonthlyResolution = data.frame(
  aggregate( #Compute some sort of aggregate values
    WeatherDataDailyResolution[,c("rain","sun")], #data, that is to be aggregate
    by = list #list of columns, on whose values the aggregation shall be based
    (
      WeatherDataDailyResolution$index, #First criterion of aggregation
      WeatherDataDailyResolution$year, #Second criterion of aggregation
      WeatherDataDailyResolution$month #Third criterion of aggregation
      #All the observations within the same month within the same year characterizing the same weather station are aggregated  
    ), 
    FUN = sum) #aggregation is defined as computing the sum of daily values
)

# Rename the columns of the dataframe of monthly resolution data
colnames(WeatherDataMonthlyResolution) = c("IndexnumberOfWeatherStation","Year","Month","PrecipitationHeightInMillimetre","TotalHoursOfSunlight")

# Order the columns first by indexnumber, then by year and finally based on the month
WeatherDataMonthlyResolution = WeatherDataMonthlyResolution[order(WeatherDataMonthlyResolution$`IndexnumberOfWeatherStation`, 
                                                                  WeatherDataMonthlyResolution$Year,
                                                                  WeatherDataMonthlyResolution$Month),]

# Transformation of the WeatherData from daily to annual resolution (summing up total precipitation)
WeatherDataAnnualResolution = data.frame(
  aggregate( #Compute some sort of aggregate values
    WeatherDataDailyResolution[,c("rain","sun")], #data, that is to be aggregate
    by = list #list of columns, on whose values the aggregation shall be based
    (
      WeatherDataDailyResolution$index, #First criterion of aggregation
      WeatherDataDailyResolution$year #Second criterion of aggregation
      #All the values of a specific pair of A-value und B-values get aggregated
    ), 
    FUN = sum) #aggregation is defined as computing the sum of monthly values
)

# Rename the columns of the dataframe of annual resolution data
colnames(WeatherDataAnnualResolution) = c("IndexnumberOfWeatherStation","Year",
                                          "AnnualPrecipitationHeightInMillimetre", 
                                          "AnnualTotalHoursOfSunlight")

# Order the columns first by indexnumber, then by year
WeatherDataAnnualResolution = WeatherDataAnnualResolution[order(WeatherDataAnnualResolution$`IndexnumberOfWeatherStation`, 
                                                                  WeatherDataAnnualResolution$Year),]
# Delete rownames
rownames(WeatherDataMonthlyResolution) = NULL
rownames(WeatherDataAnnualResolution) = NULL
