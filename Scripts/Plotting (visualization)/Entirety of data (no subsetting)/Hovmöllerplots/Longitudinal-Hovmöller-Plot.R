# Creating a longitudinal Hovmoellerplot (Values are averaged along latitudinal degrees)

## First step: Create a regular grid of 50 spatial points and 100 temporal points 

### Compute the range of Longitude and time in the data
RangeLongitudeDegrees = range(WeatherDataDailyResolution$lon)
RangeTime = range(WeatherDataDailyResolution$year)

### Create two axis: One spatial axis and one temporal axis 
SpatialAxis = seq(
  RangeLongitudeDegrees[1],
  RangeLongitudeDegrees[2],
  length.out = 100
)

TemporalAxis = seq(
  RangeTime[1],
  RangeTime[2],
  length.out = 100
)

SpaceTimeGrid = expand.grid(Longitude = SpatialAxis,
                            Time = TemporalAxis)

### Associate each station's longitudinal coordinate with the closest gridpoint

#### Compute the distance of each longitudinal coordinate to every gridpoint, determine which gridpoint is closest and allocate the longitudinal coordinate to that gridpoint

WeatherDataDailyResolutionGrid = WeatherDataDailyResolution 

distances = abs(outer(WeatherDataDailyResolutionGrid$lon, SpatialAxis, "-"))

### Create a gridded version of the spatio-temporal data

WeatherDataDailyResolutionGrid$lon = SpatialAxis[apply(distances, 1, which.min)]

### Group the weather stations by unique combinations of Longitude degree and calendar date. 
### Then, average all the observations of precipitation height that have the same unique combination of longitudinal degree and calendar date. 
### This results in the data frame required for the Hovmoellerplot. 
DataframeHovmoellerPlot = group_by(.data = WeatherDataDailyResolutionGrid, 
                                   lon, 
                                   year) %>%
  summarise(rain = mean(rain))

### Create the longitudinal Hovmöllerplot
LongitudinalHovmoellerPlot = ggplot(DataframeHovmoellerPlot) +
  geom_tile(aes(x = lon, y = year, fill = rain)) +
  fill_scale(name = paste0("Average precipitation height in millimetre (mm)","\nacross all latitudinal degrees")) + 
  scale_y_reverse() + 
  xlab("Longitude (degrees)") +
  ylab("Year") +
  ggtitle("Longitudinal Hovmöllerplot") + 
  theme_bw()

## Final step: Print the Hovmöllerplot
LongitudinalHovmoellerPlot
ggsave("LongitudinalHovmoellerPlot.jpg", width = 20, height = 10)
rm(LongitudinalHovmoellerPlot)




