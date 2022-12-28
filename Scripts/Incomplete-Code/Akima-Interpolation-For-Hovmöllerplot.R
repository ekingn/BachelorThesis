# This script tells the story of the generation of a latiduinal Hovmöllerplot. 
# Since the underlying data is irregular point data and as grid points without values (NAs) are
# therefore to be expected, Akima interpolation (bivariate linear interpolation) is applied beforehand to interpolate missing values.

## First Step: Transform the point data into gridded data

### Subset the data to filter out NAs in the point data
NoNAWeatherDataDailyResolution = subset(WeatherDataDailyResolution,!is.na(rain))
rm(WeatherDataDailyResolution)

### Create a regular grid of 125 spatial points and 125 temporal points
### (125 space-time grid points)

#### Compute the range of latitude and time in the data
RangeLatitudeDegrees = range(NoNAWeatherDataDailyResolution$lat)
RangeTime = range(NoNAWeatherDataDailyResolution$year)

#### Create two axis: One spatial axis and one temporal axis 
SpatialAxis = seq(
  RangeLatitudeDegrees[1],
  RangeLatitudeDegrees[2],
  length.out = 125)

TemporalAxis = seq(
  RangeTime[1],
  RangeTime[2],
  length.out = 125 
)

### Associate each station's latitudinal coordinate with the closest gridpoint

#### Compute the distance of each latitudinal coordinate to every gridpoint, 
#### determine which gridpoint is closest and allocate every latitudinal coordinate to that gridpoint

NoNAWeatherDataDailyResolutionGrid = NoNAWeatherDataDailyResolution 

distances = abs(outer(NoNAWeatherDataDailyResolution$lat, SpatialAxis, "-"))

### Create a gridded version of the spatio-temporal data

NoNAWeatherDataDailyResolutionGrid$lat = SpatialAxis[apply(distances, 1, which.min)]

### Group the weather stations by unique combinations of latitude degree and calendar date. 
### Then, average all the observations of precipitation height that have the same unique combination of latitudinal degree and calendar date. 
### This results in the data frame required for the Hovmoellerplot. 
DataframeHovmoellerPlot = group_by(.data = NoNAWeatherDataDailyResolutionGrid, 
                                   lat, 
                                   year) %>%
  summarise(rain = mean(rain))

## Second step: Perform the Akima interpolation
AkimaInterpolatedHovmoellerData = akima::interp(x = DataframeHovmoellerPlot$lat, 
                                               y = DataframeHovmoellerPlot$year,
                                               z = DataframeHovmoellerPlot$rain,
                                               xo = SpatialAxis,
                                               yo = TemporalAxis,
                                                n)

AkimaInterpolatedHovmoellerData = data.frame(lat = DataframeHovmoellerPlot$lat,
                                            year = DataframeHovmoellerPlot$year,
                                            rain = DataframeHovmoellerPlot$rain)

# Hovmöllerplot on Akima interpolated data 
LatitudinalHovmoellerPlot = ggplot(AkimaInterpolatedHovmoellerData) +
  geom_tile(aes(x = lat  , 
                y = year, 
                fill = rain)) +
  scale_y_reverse() + 
  scale_fill_viridis_c() + 
  xlab("Latitude (degrees)") +
  ylab("Year") +
  ggtitle("Latitudinal Hovmöllerplot") + 
  labs(fill = paste0("Average precipitation height in millimetre (mm)","\nacross all longitudinal degrees")) + 
  theme_bw() +
  scale_x_continuous(breaks = c(seq(from = 47.4, to = 54.8, by=0.4)))

LatitudinalHovmoellerPlot
