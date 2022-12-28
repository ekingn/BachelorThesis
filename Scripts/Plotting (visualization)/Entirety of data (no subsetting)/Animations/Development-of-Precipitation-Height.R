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
    FUN = mean,
    na.action = na.omit) #aggregation is defined as computing the sum of daily values
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

# Subset the Monthly Averages of the Daily Precipitation Data
# MonthlyAveragePrecipitationForMapping = filter(AverageMonthlyPrecipitation,
#                                          year %in% c(1996),
#                                          month %in% c(1,5,12))

AverageMonthlyPrecipitation$MonthOfYear = paste0(AverageMonthlyPrecipitation$year,
                                                 "-",
                                                 AverageMonthlyPrecipitation$month)

AverageMonthlyPrecipitation = AverageMonthlyPrecipitation[order(AverageMonthlyPrecipitation$year,
                                                                AverageMonthlyPrecipitation$month),]

rownames(AverageMonthlyPrecipitation) = NULL

# Number of NA values in the column of monthly mean precipitation
sum(is.na(AverageMonthlyPrecipitation$MonthlyAverageRain))


# Map of Monthly Average Precipitation Values
MonthlyAveragePrecipitationMap = ggplot(AverageMonthlyPrecipitation) + 
  geom_path(data = map_data("world","Germany"),
            aes(x = long, y = lat, group = group)) +
  coord_fixed(xlim = c(6,15),
              ylim = c(47,55)) + 
  geom_point(aes(x=lon, y=lat, 
                 colour = MonthlyAverageRain,
                 group = MonthOfYear,
                 alpha = ifelse(MonthlyAverageRain >= 5, 1, 0)),
             size = 3,
             ) + 
  xlab("Longitude (degree)") +
  ylab("Latitude (degree)") + 
  theme_bw() +
  scale_color_gradient(low="blue", high="red", limits = c(0,12)) +
  transition_manual(frames = MonthOfYear) + 
  labs(title = '{unique(AverageMonthlyPrecipitation$MonthOfYear)[as.integer(frame)]}', 
       color = paste0("Monthly Average of \nDaily Averages of Precipitation \nin millimetre (mm)")) 

animate(MonthlyAveragePrecipitationMap, 
        renderer = 
          ffmpeg_renderer(
            format = "auto",
            ffmpeg = NULL,
            options = list(pix_fmt = "yuv420p")
        ),
        nframes = 1500,
        width = 640,
        height = 480)

