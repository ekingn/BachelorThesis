WeatherDataDailyResolution$Seasons = WeatherDataDailyResolution %>% 
  mutate(Season = #Create a variable indicating the current season  
           case_when(
             WeatherDataDailyResolution$month <=  2 & WeatherDataDailyResolution$month >=  12 ~ "Winter",
             WeatherDataDailyResolution$month <=  11 & WeatherDataDailyResolution$month >=  9 ~ "Autmn",
             WeatherDataDailyResolution$month <=  8 & WeatherDataDailyResolution$month >=  6 ~ "Summer",
             WeatherDataDailyResolution$month <=  5 & WeatherDataDailyResolution$month >=  3 ~ "Spring"))
