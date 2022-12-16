# Creating a latitudinal Hovmoellerplot (Values are averaged along longitudinal degrees)

## First step: Create a regular grid of 50 spatial points and 100 temporal points 

### Compute the range of latitude and time in the data
RangeLatitudeDegrees = range(WeatherDataDailyResolution$lat)
RangeTime = range(WeatherDataDailyResolution$year)

### Create two axis: One spatial axis and one temporal axis 
SpatialAxis = seq(
  RangeLatitudeDegrees[1],
  RangeLatitudeDegrees[2],
  length.out = 100
)

TemporalAxis = seq(
  RangeTime[1],
  RangeTime[2],
  length.out = 100
)

SpaceTimeGrid = expand.grid(Latitude = SpatialAxis,
                            Time = TemporalAxis)

### Associate each station's latitudinal coordinate with the closest gridpoint

#### Compute the distance of each latitudinal coordinate to every gridpoint, determine which gridpoint is closest and allocate the latitudinal coordinate to that gridpoint

WeatherDataDailyResolutionGrid = WeatherDataDailyResolution 

distances = abs(outer(WeatherDataDailyResolutionGrid$lat, SpatialAxis, "-"))

### Create a gridded version of the spatio-temporal data

WeatherDataDailyResolutionGrid$lat = SpatialAxis[apply(distances, 1, which.min)]

### Group the weather stations by unique combinations of latitude degree and calendar date. 
### Then, average all the observations of precipitation height that have the same unique combination of latitudinal degree and calendar date. 
### This results in the data frame required for the Hovmoellerplot. 
DataframeHovmoellerPlot = group_by(.data = WeatherDataDailyResolutionGrid, 
                                   lat, 
                                   year) %>%
  summarise(rain = mean(rain))

### Create the latidunial Hovmoellerplot
LatitudinalHovmoellerPlot = ggplot(DataframeHovmoellerPlot) +
  geom_tile(aes(x = lat, y = year, fill = rain)) +
  fill_scale(name = paste0("Average precipitation height in millimetre (mm)","\nacross all longitudinal degrees")) + 
  scale_y_reverse() + 
  xlab("Latitude (degrees)") +
  ylab("Year") +
  theme_bw()


## Final step: Print the Hovmöllerplot
LatitudinalHovmoellerPlot

ggsave("LatitudinalHovmoellerPlot.jpg", width = 20, height = 10)





