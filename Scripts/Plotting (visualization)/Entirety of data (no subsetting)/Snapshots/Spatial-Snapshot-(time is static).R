# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
# {
#   library(here)
#   source(here("Scripts","Session-Related","Packages.R"))
#   source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
# }

# Sample a random subset of the weatherstations based on their unique ID
set.seed(1)
RandomSampleWeatherStations = sample(ListOfAllUniqueIndexnumbers$IndexNumbers, 10)

# Subset the Daily Precipitation Weather Data towards the random sample of weather stations
WeatherDataDailyResolutionSubset1996 = filter(WeatherDataDailyResolution, 
                                          index %in% RandomSampleWeatherStations,
                                          year == 1996)
WeatherDataDailyResolutionSubset2006 = filter(WeatherDataDailyResolution, 
                                              index %in% RandomSampleWeatherStations,
                                              year == 2006)
WeatherDataDailyResolutionSubset2016 = filter(WeatherDataDailyResolution, 
                                              index %in% RandomSampleWeatherStations,
                                              year == 2016)

# Create plots for each spatial and temporal subsets
TemporalPlotsRainDailyResol1996 = ggplot(WeatherDataDailyResolutionSubset1996) +
  geom_point(aes(x = CalendarDate, y = rain, 
                 colour = Season, alpha = 0.00005,
                 shape = Season)) + 
  facet_wrap(~index, ncol = 5) +
  xlab("Day") + 
  ylab("Precipitation Height in millimetre (mm)") +
  theme_bw() + 
  theme(panel.spacing = unit(1, "lines"))

TemporalPlotsRainDailyResol2006 = ggplot(WeatherDataDailyResolutionSubset2006) +
  geom_point(aes(x = CalendarDate, y = rain, 
                 colour = Season, alpha = 0.00005,
                 shape = Season)) + 
  facet_wrap(~index, ncol = 5) +
  xlab("Day") + 
  ylab("Precipitation Height in millimetre (mm)") +
  theme_bw() + 
  theme(panel.spacing = unit(1, "lines"))

TemporalPlotsRainDailyResol2016 = ggplot(WeatherDataDailyResolutionSubset2016) +
  geom_point(aes(x = CalendarDate, y = rain, 
                 colour = Season, alpha = 0.00005,
                 shape = Season)) + 
  facet_wrap(~index, ncol = 5) +
  xlab("Day") + 
  ylab("Precipitation Height in millimetre (mm)") +
  theme_bw() + 
  theme(panel.spacing = unit(1, "lines"))

# Print the plots as a grid
plot_grid(TemporalPlotsRainDailyResol1996, TemporalPlotsRainDailyResol2006, TemporalPlotsRainDailyResol2016, 
          align = "v", nrow = 3)

ggsave("PrecpitationFacetted.jpg", width = 20, height = 10)

