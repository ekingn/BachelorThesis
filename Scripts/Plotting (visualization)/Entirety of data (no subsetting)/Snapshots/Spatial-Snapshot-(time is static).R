# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
# {
#   library(here)
#   source(here("Scripts","Session-Related","Packages.R"))
#   source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
# }

# Sample a random subset of the weatherstations based on their unique ID
set.seed(1)

RandomSampleWeatherStations <-
  
  sample(Index_Lat_Lon$index, 
         10)

# Subset the Daily Precipitation Weather Data towards the random sample of weather stations
Weather_Data_Daily_ResolutionSubset1996 <- filter(Weather_Data_Daily_Resolution, 
                                          index %in% RandomSampleWeatherStations,
                                          year == 1996)
Weather_Data_Daily_ResolutionSubset2006 <- filter(Weather_Data_Daily_Resolution, 
                                              index %in% RandomSampleWeatherStations,
                                              year == 2006)
Weather_Data_Daily_ResolutionSubset2016 <- filter(Weather_Data_Daily_Resolution, 
                                              index %in% RandomSampleWeatherStations,
                                              year == 2016)

# Create plots for each spatial and temporal subsets
TemporalPlotsRainDailyResol1996 <-
  
  ggplot(Weather_Data_Daily_ResolutionSubset1996) +
  
  geom_point(aes(x = calendar_date, y = rain, 
                 colour = season, alpha = 0.00005,
                 shape = season)) + 
  
  facet_wrap(~index, ncol = 5) + 
  
  xlab("Day") + 
  
  ylab("Precipitation Height in millimetre (mm)") + 
  
  theme_bw() + 
  
  theme(panel.spacing = unit(1, "lines"))

TemporalPlotsRainDailyResol2006 <- 
  
  ggplot(Weather_Data_Daily_ResolutionSubset2006) +
  
  geom_point(aes(x = calendar_date, y = rain, 
                 colour = season, alpha = 0.00005,
                 shape = season)) + 
  
  facet_wrap(~index, ncol = 5) +
  
  xlab("Day") + 
  
  ylab("Precipitation Height in millimetre (mm)") +
  
  theme_bw() + 
  
  theme(panel.spacing = unit(1, "lines"))

TemporalPlotsRainDailyResol2016 <- 
  
  ggplot(Weather_Data_Daily_ResolutionSubset2016) +
  
  geom_point(aes(x = calendar_date, y = rain, 
                 colour = season, alpha = 0.00005,
                 shape = season)) +
  
  facet_wrap(~index, ncol = 5) +
  
  xlab("Day") + 
  
  ylab("Precipitation Height in millimetre (mm)") +
  
  theme_bw() + 
  
  theme(panel.spacing = unit(1, "lines"))

# Print the plots as a grid
plot_grid(TemporalPlotsRainDailyResol1996, TemporalPlotsRainDailyResol2006, TemporalPlotsRainDailyResol2016, 
          align = "v", nrow = 3)

ggsave("PrecpitationFacetted.jpg", width = 20, height = 10)

