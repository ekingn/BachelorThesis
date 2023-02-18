# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it
# Do not forget to re-comment it again afterwards:
{
  library(here)
  source(here("Scripts","Session-Related","Packages.R"))
  source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
}

# Sample a random subset of the weatherstations based on their unique ID
set.seed(1)

Random_Sample_Weather_Stations <-
  
  sample(Index_Lat_Lon$index, 
         10)

# Subset the Daily Precipitation Weather Data towards the random sample of weather stations
Weather_Data_Daily_Resolution_1996 <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(index %in% Random_Sample_Weather_Stations,
         year == 1996)

Weather_Data_Daily_Resolution_2006 <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(index %in% Random_Sample_Weather_Stations,
         year == 2006)


Weather_Data_Daily_Resolution_2016 <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(index %in% Random_Sample_Weather_Stations,
         year == 2012)

# Create plots for each spatial and temporal subsets
Temporal_Plots_Rain_Daily_Resolution_1996 <-
  
  Weather_Data_Daily_Resolution_1996 %>%
  
  ggplot() +
  
  geom_point(aes(x = calendar_date, 
                 y = rain, 
                 colour = season, 
                 alpha = 0.00005,
                 shape = season)) + 
  
  facet_wrap(~index, 
             ncol = 5) + 
  
  xlab("Day") + 
  
  ylab("Precipitation Height in millimetre (mm)") + 
  
  theme_bw() + 
  
  theme(panel.spacing = unit(1, 
                             "lines"))

Temporal_Plots_Rain_Daily_Resolution_2006 <- 
  
  Weather_Data_Daily_Resolution_2006 %>% 
  
  ggplot() +
  
  geom_point(aes(x = calendar_date, y = rain, 
                 colour = season, alpha = 0.00005,
                 shape = season)) + 
  
  facet_wrap(~index, ncol = 5) +
  
  xlab("Day") + 
  
  ylab("Precipitation Height in millimetre (mm)") +
  
  theme_bw() + 
  
  theme(panel.spacing = unit(1, "lines"))

Temporal_Plots_Rain_Daily_Resolution_2016 <- 
  
  Weather_Data_Daily_Resolution_2016 %>% 
  
  ggplot() +
  
  geom_point(aes(x = calendar_date, 
                 y = rain, 
                 colour = season, 
                 alpha = 0.00005,
                 shape = season)) +
  
  facet_wrap(~index, 
             ncol = 5) +
  
  xlab("Day") + 
  
  ylab("Precipitation Height in millimetre (mm)") +
  
  theme_bw() + 
  
  theme(panel.spacing = unit(1,
                             "lines"))

# Print the plots as a grid
Plotgrid_Spatial_Snapshots <-
  
  plot_grid(Temporal_Plots_Rain_Daily_Resolution_1996,
            Temporal_Plots_Rain_Daily_Resolution_2006,
            Temporal_Plots_Rain_Daily_Resolution_2016, 
            nrow = 3)

ggsave(plot = Plotgrid_Spatial_Snapshots,
       filename = "Spatial-Precipitation-Facetted-by-Season.JPG",
       path = here("Output","JPGs","Snapshots-Precipitation"),
       width = 10,
       height = 5)

