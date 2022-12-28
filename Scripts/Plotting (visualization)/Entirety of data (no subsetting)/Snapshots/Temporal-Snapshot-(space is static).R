# Subset the Daily Precipitation data by filtering the observations on the first, fifteenth and thirtieth day of the month
SubsetDailyPrecipitationDec1996 = filter(WeatherDataDailyResolution, 
                                  year %in% c(1996),
                                  day %in% c(1,15,30), 
                                  month %in% c(12)) 

SubsetDailyPrecipitationSept1996 = filter(WeatherDataDailyResolution,
                                         year %in% c(1996),
                                         day %in% c(1,15,30),
                                         month %in% c(9))

SubsetDailyPrecipitationJune1996 = filter(WeatherDataDailyResolution,
                                          year %in% c(1996),
                                          day %in% c(1,15,30),
                                          month %in% c(6))

# Create the first plot
SpatialPlotsRainDailyResol1 = ggplot(SubsetDailyPrecipitationDec1996) + 
  geom_point(aes(x=lon, y=lat, colour = rain), size = 2) + 
  xlab("Longitude (degree)") +
  ylab("Latitude (degree)") + 
  labs(color = paste0("Precipitation Height \nin millimetre (mm)")) + 
  scale_color_gradient(low="blue", high="red") +
  geom_path(data = map_data("world","Germany"),
            aes(x = long, y = lat, group = group)) +
  facet_grid(~CalendarDate) + 
  coord_fixed(xlim = c(6,15),
              ylim = c(47,55)) + 
  theme_bw()

# Create the second plot 
SpatialPlotsRainDailyResol2 = ggplot(SubsetDailyPrecipitationSept1996) + 
  geom_point(aes(x=lon, y=lat, colour = rain), size = 2) + 
  xlab("Longitude (degree)") +
  ylab("Latitude (degree)") + 
  labs(color = paste0("Precipitation Height \nin millimetre (mm)")) +
  scale_color_gradient(low="blue", high="red") + 
  geom_path(data = map_data("world","Germany"),
            aes(x = long, y = lat, group = group)) +
  facet_grid(~CalendarDate) + 
  coord_fixed(xlim = c(6,15),
              ylim = c(47,55)) + 
  theme_bw()

# Create the third plot 
SpatialPlotsRainDailyResol3 = ggplot(SubsetDailyPrecipitationJune1996) + 
  geom_point(aes(x=lon, y=lat, colour = rain), size = 2) + 
  xlab("Longitude (degree)") +
  ylab("Latitude (degree)") + 
  labs(color = paste0("Precipitation Height \nin millimetre (mm)")) +
  scale_color_gradient(low="blue", high="red") + 
  geom_path(data = map_data("world","Germany"),
            aes(x = long, y = lat, group = group)) +
  facet_grid(~CalendarDate) + 
  coord_fixed(xlim = c(6,15),
              ylim = c(47,55)) + 
  theme_bw()

# Print both plots on a grid 
plot_grid(SpatialPlotsRainDailyResol1,
          SpatialPlotsRainDailyResol2,
          SpatialPlotsRainDailyResol3,
          align = "v",nrow = 3)
  
ggsave("PrecipitationMap.jpg", width = 20, height = 10)





