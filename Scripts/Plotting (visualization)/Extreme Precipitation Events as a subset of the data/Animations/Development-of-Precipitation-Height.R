# Transformation of the WeatherData from daily to monthly resolution (summing up daily total precipitation)
MonthlyAverageExtremePrecipitation = data.frame(
  aggregate( #Compute some sort of aggregate values
    WeatherDataDailyResolution[,c("ExtremePrecipitationEvent")], #data, that is to be aggregate
    by = list #list of columns, on whose values the aggregation shall be based
    (
      WeatherDataDailyResolution$index, #First criterion of aggregation
      WeatherDataDailyResolution$year, #Second criterion of aggregation
      WeatherDataDailyResolution$month #Third criterion of aggregation
      #All the observations within the same month within the same year characterizing the same weather station are aggregated  
    ), 
    FUN = mean,
    na.action = na.omit) #aggregation is defined as computing the sum of daily values
)

# Rename the columns of the dataframe of monthly resolution data
colnames(MonthlyAverageExtremePrecipitation) = c("index","year","month","ShareOfExtremePrecipitationEvents")

# Order the columns first by indexnumber, then by year and finally based on the month
MonthlyAverageExtremePrecipitation = MonthlyAverageExtremePrecipitation[order(MonthlyAverageExtremePrecipitation$`index`, 
                                                                MonthlyAverageExtremePrecipitation$year,
                                                                MonthlyAverageExtremePrecipitation$month),] %>% 
  mutate_if(is.numeric, ~round(., 2))

rownames(MonthlyAverageExtremePrecipitation) = NULL

MonthlyAverageExtremePrecipitation = inner_join(x = MonthlyAverageExtremePrecipitation, 
                                                y = IndexLatLon, 
                                                by = "index")

# Subset the Monthly Averages of the Daily Precipitation Data
# MonthlyAveragePrecipitationForMapping = filter(MonthlyAverageExtremePrecipitation,
#                                          year %in% c(1996),
#                                          month %in% c(1,5,12))

MonthlyAverageExtremePrecipitation$MonthOfYear = paste0(MonthlyAverageExtremePrecipitation$year,
                                                 "-",
                                                 MonthlyAverageExtremePrecipitation$month)

MonthlyAverageExtremePrecipitation = MonthlyAverageExtremePrecipitation[order(MonthlyAverageExtremePrecipitation$year,
                                                                MonthlyAverageExtremePrecipitation$month),]

rownames(MonthlyAverageExtremePrecipitation) = NULL

# Number of NA values in the column of monthly mean precipitation
sum(is.na(MonthlyAverageExtremePrecipitation$ShareOfExtremePrecipitationEvents))

str(MonthlyAverageExtremePrecipitation)

# Map of Monthly Average Precipitation Values
MonthlyAveragePrecipitationMap = ggplot(MonthlyAverageExtremePrecipitation) + 
  geom_path(data = map_data("world","Germany"),
            aes(x = long, y = lat, group = group)) +
  coord_fixed(xlim = c(6,15),
              ylim = c(47,55)) + 
  geom_point(aes(x=lon, y=lat, 
                 group = MonthOfYear),
             size = ifelse(test = MonthlyAverageExtremePrecipitation$ShareOfExtremePrecipitationEvents > 0.3,
                           5,
                           2),
             colour = ifelse(test = MonthlyAverageExtremePrecipitation$ShareOfExtremePrecipitationEvents > 0.3, 
                             I("red"),
                             I("blue"))) + 
  # scale_color_gradient(low="blue", high="yellow") + 
  xlab("Longitude (degree)") +
  ylab("Latitude (degree)") + 
  theme_bw() +
  transition_manual(frames = MonthOfYear) + 
  labs(title = '{unique(MonthlyAverageExtremePrecipitation$MonthOfYear)[as.integer(frame)]}', 
       color = paste0("Share of Extreme Precipitation Events \namong all Precipitation Events")) 


anim_save("Share-of-Extreme-Precipitation-Events.mp4",
  animate(
  MonthlyAveragePrecipitationMap,
  nframes = 1000,
  renderer = ffmpeg_renderer()
))
