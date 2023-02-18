# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
# {
  library(here)
  source(here("Scripts","Session-Related","Packages.R"))
  source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
# }

# Subset the Daily Precipitation data by filtering the observations on the first, fifteenth and thirtieth day of the month
Daily_Precipitation_Dec_1996 <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(!is.na(rain),
         year %in% c(1996),
         day %in% c(1,15,30),
         month %in% c(12)) 

Daily_Precipitation_Sept_1996 <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(!is.na(rain),
         year %in% c(1996),
         day %in% c(1,15,30),
         month %in% c(9))

Daily_Precipitation_June_1996 <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(!is.na(rain),
         year %in% c(1996),
         day %in% c(1,15,30),
         month %in% c(6))


# Create the first plot
Spatial_Plot_Dec <-
  
  Daily_Precipitation_Dec_1996 %>% 
  
  ggplot() + 
  
  geom_point(aes(x=lon, 
                 y=lat, 
                 colour = rain), 
             size = 0.1) + 
  
  xlab("Longitude (degree)") +
  
  ylab("Latitude (degree)") + 
  
  labs(color = paste0("Precipitation Height \nin millimetre (mm)")) + 
  
  scale_colour_gradientn(colours = viridis::viridis(10)) + 
  
  geom_path(data = map_data("world","Germany"),
            aes(x = long, 
                y = lat, 
                group = group)) +
  
  facet_grid(~calendar_date) + 
  
  coord_fixed(xlim = c(6,
                       15),
              ylim = c(47,
                       55)) + 
  
  theme_bw()

# Create the second plot 
Spatial_Plot_Sep <-
  
  Daily_Precipitation_Sept_1996 %>% 
  
  ggplot() +
  
  geom_point(aes(x=lon, 
                 y=lat, 
                 colour = rain), 
             size = 0.1) + 
  
  xlab("Longitude (degree)") +
  
  ylab("Latitude (degree)") + 
  
  labs(color = paste0("Precipitation Height \nin millimetre (mm)")) +
  
  scale_colour_gradientn(colours = viridis::viridis(10)) + 
  
  geom_path(data = map_data("world","Germany"),
            aes(x = long, 
                y = lat, 
                group = group)) +
  
  facet_grid(~calendar_date) + 
  
  coord_fixed(xlim = c(6,15),
              ylim = c(47,55)) + 
  
  theme_bw()

# Create the third plot 
Spatial_Plot_June <-
  
  Daily_Precipitation_June_1996 %>% 
  
  ggplot() + 
  
  geom_point(aes(x=lon, 
                 y=lat, 
                 colour = rain), 
             size = 0.1) + 
  
  xlab("Longitude (degree)") +
  
  ylab("Latitude (degree)") + 
  
  labs(color = paste0("Precipitation Height \nin millimetre (mm)")) +
  
  scale_colour_gradientn(colours = viridis::viridis(10)) + 
  
  geom_path(data = map_data("world","Germany"),
            aes(x = long, 
                y = lat, 
                group = group)) +
  
  facet_grid(~calendar_date) + 
  
  coord_fixed(xlim = c(6,
                       15),
              ylim = c(47,
                       55)) + 
  
  theme_bw()

# Print both plots on a grid 
Plotgrid_Temporal_Snapshot <- plot_grid(Spatial_Plot_June,
                                        Spatial_Plot_Sep,
                                        Spatial_Plot_Dec,
                                        nrow = 3)
  
save_plot(plot = Plotgrid_Temporal_Snapshot ,
          filename = "Precipitation_Map.JPG",
          path = here("Output","JPGs","Snapshots-Precipitation"))





