# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
#{
  # library(here)
  # source(here("Scripts","Session-Related","Packages.R"))
  # source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
#}

# Exploring the data per empirical spatial and temporal means as well as covariances 

## Compute and plot the empirical spatial means: The average precipiation height at each spatial location.
## A spatial location is determined as a unique combination of angular coordinates, longitudinal and latitudinal degrees.

SpatialMeans = 
  group_by(WeatherDataDailyResolution,
                        lat,
                        lon) %>% 
  summarise(MeanPrecipitationHeight = mean(rain))

SpatialMeansPerLatitudinalDegree = ggplot(SpatialMeans) + 
  geom_point(aes(x = lat,
                 y = MeanPrecipitationHeight)) +
  xlab("Latitude (degree)") + 
  ylab(paste0("Mean Precipitation Height\n(per Longitudinal degree)")) + 
  theme_bw()

SpatialMeansPerLatitudinalDegree

ggsave("SpatialMeansPerLatitudinalDegree.jpg", width = 20, height = 10)

SpatialMeansPerLongitudinalDegree = ggplot(SpatialMeans) +
  geom_point(aes(x = lon,
                 y = MeanPrecipitationHeight)) + 
  xlab("Longitude (degree)") +
  ylab(paste0("Mean Precipitation Height\n(per Latitudinal degree)")) + 
  theme_bw()

SpatialMeansPerLongitudinalDegree

ggsave("SpatialMeansPerLongitudinalDegree.jpg", width = 20, height = 10)

## Compute and plot the empirical temporal means: The average precipitation height at each calendar date (unique day).
## Every calendar day constitutes a temporal location similar to how a spatial location is determined by a unique pair of angular coordinates. 

TemporalMeans = 
  group_by(WeatherDataDailyResolution,
           CalendarDate) %>% 
  summarise(MeanPrecipitationHeight = mean(rain))

TemporalMeansPlot = ggplot() + 
  geom_point(data = TemporalMeans,
            aes(x = CalendarDate, 
                y = MeanPrecipitationHeight),
            alpha = 0.5) +
  xlab("Years") + 
  ylab(paste0("Mean Precipitation Height \nacross all weather stations")) + 
  theme_bw()

TemporalMeansPlot

ggsave("TemporalMeansPlot.jpg", width = 20, height = 10)

