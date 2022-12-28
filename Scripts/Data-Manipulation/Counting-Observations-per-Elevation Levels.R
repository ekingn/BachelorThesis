TotalNumberOfObservations = length(WeatherDataDailyResolution$alt)

ObservationsBetween0thAnd75thPercentile = length(which(WeatherDataDailyResolution$alt <= quantile(WeatherDataDailyResolution$alt, 0.75)))

ObservationsGreaterThan75thSmallerEqualThan95thPercentile = length(which(
  WeatherDataDailyResolution$alt > quantile(WeatherDataDailyResolution$alt, 0.75) &  
  WeatherDataDailyResolution$alt <= quantile(WeatherDataDailyResolution$alt,0.95)))

ObservationsGreaterThan95thSmallerEqualThan99thPercentile = ObservationsGreaterThan75thSmallerThan95thPercentile = length(which(
  WeatherDataDailyResolution$alt > quantile(WeatherDataDailyResolution$alt, 0.95) &  
    WeatherDataDailyResolution$alt <= quantile(WeatherDataDailyResolution$alt,0.99)))

ObservationsGreaterThan99thPercentile = length(which(
  WeatherDataDailyResolution$alt > quantile(WeatherDataDailyResolution$alt, 0.99)))

ObservationsGreaterThan99thPercentile
