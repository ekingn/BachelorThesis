# Transformation of the WeatherData from daily to monthly resolution (summing up daily total precipitation)
AverageMonthlyPrecipitation = data.frame(
  aggregate( #Compute some sort of aggregate values
    WeatherDataDailyResolution[,c("rain","sun")], #data, that is to be aggregate
    by = list #list of columns, on whose values the aggregation shall be based
    (
      WeatherDataDailyResolution$index, #First criterion of aggregation
      WeatherDataDailyResolution$year, #Second criterion of aggregation
      WeatherDataDailyResolution$month #Third criterion of aggregation
      #All the observations within the same month within the same year characterizing the same weather station are aggregated  
    ), 
    FUN = mean) #aggregation is defined as computing the sum of daily values
)

# Rename the columns of the dataframe of monthly resolution data
colnames(AverageMonthlyPrecipitation) = c("index","year","month","MonthlyAverageRain","MonthlyAverageSunlight")

# Order the columns first by indexnumber, then by year and finally based on the month
AverageMonthlyPrecipitation = AverageMonthlyPrecipitation[order(AverageMonthlyPrecipitation$`index`, 
                                                                  AverageMonthlyPrecipitation$year,
                                                                  AverageMonthlyPrecipitation$month),] %>% 
  mutate_if(is.numeric, ~round(., 2))
rownames(AverageMonthlyPrecipitation) = NULL

AverageMonthlyPrecipitation = inner_join(x = AverageMonthlyPrecipitation, y = IndexLatLon, by = "index")

