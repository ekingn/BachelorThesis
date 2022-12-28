# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
#{
# library(here)
# source(here("Scripts","Session-Related","Packages.R"))
# source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
#}

# Creating a latitudinal Hovmoellerplot (Values are averaged along longitudinal degrees)

## First step: Create a regular grid of 50 spatial points and 100 temporal points 

### Compute the range of latitude and time in the data
RangeLatitudeDegrees = range(WeatherDataDailyResolution$lat)
RangeTime = range(WeatherDataDailyResolution$year)

### Create two axis: One spatial axis and one temporal axis 
SpatialAxis = seq(
  RangeLatitudeDegrees[1],
  RangeLatitudeDegrees[2],
  length.out = 125)

TemporalAxis = seq(
  RangeTime[1],
  RangeTime[2],
  length.out = 125 
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
  summarise(EPE = mean(ExtremePrecipitationEvent))

### Create the latidunal Hovmoellerplot
LatitudinalHovmoellerPlot = ggplot(subset(DataframeHovmoellerPlot,!is.na(EPE))) +
  geom_tile(aes(x = lat, y = year, fill = EPE),
            na.rm = TRUE) +
  scale_y_reverse() + 
  scale_fill_viridis_c() + 
  xlab("Latitude (degrees)") +
  ylab("Year") +
  ggtitle("Latitudinal Hovmöllerplot") + 
  labs(fill = paste0("Average precipitation height in millimetre (mm)","\nacross all longitudinal degrees")) + 
  theme_bw() + 
  scale_x_continuous(breaks = c(seq(from = 47.4, to = 54.8, by=0.2))) 

## Final step: Print the Hovmöllerplot
LatitudinalHovmoellerPlot

ggsave("LatitudinalHovmoellerPlotEPE.jpg", width = 20, height = 10)



