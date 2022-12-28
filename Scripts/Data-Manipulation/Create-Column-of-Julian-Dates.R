
WeatherDataDailyResolution$CalendarDate = paste0(WeatherDataDailyResolution$year,
                                                 "-",
                                                 WeatherDataDailyResolution$month,
                                                 "-",
                                                 WeatherDataDailyResolution$day) 

WeatherDataDailyResolution$JulianDate = insol::JD(as.POSIXlt(WeatherDataDailyResolution$CalendarDate))

WeatherDataDailyResolution$ContinuousDaysElapsedSinceEarliestObservation = 
  insol::JD(as.POSIXlt(WeatherDataDailyResolution$CalendarDate))-insol::JDymd(1936,1,1,0,0)


