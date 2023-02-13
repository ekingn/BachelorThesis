# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
# {
  library(here)
  source(here("Scripts","Session-Related","Packages.R"))
  source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
# }

# Subset the Daily Precipitation data by filtering the observations on the first, fifteenth and thirtieth day of the month
Subset_Daily_Precipitation_Dec_1996 = filter(Weather_Data_Daily_Resolution, 
                                         !is.na(rain),
                                         year %in% c(1996),
                                         day %in% c(1,15,30), 
                                         month %in% c(12)) 

Subset_Daily_Precipitation_Sept_1996 = filter(Weather_Data_Daily_Resolution,
                                          !is.na(rain),
                                          year %in% c(1996),
                                          day %in% c(1,15,30),
                                          month %in% c(9))

Subset_Daily_Precipitation_June_1996 = filter(Weather_Data_Daily_Resolution,
                                          !is.na(rain),
                                          year %in% c(1996),
                                          day %in% c(1,15,30),
                                          month %in% c(6))


viridis::viridis(10)
# Create the first plot
Spatial_Plot_Dec = ggplot(Subset_Daily_Precipitation_Dec_1996) + 
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

# Create the second plot 
Spatial_Plot_Sep = ggplot(Subset_Daily_Precipitation_Sept_1996) + 
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
Spatial_Plot_June = ggplot(Subset_Daily_Precipitation_June_1996) + 
  geom_point(aes(x=lon, 
                 y=lat, 
                 colour = rain), 
             size = 0.1) + 
  xlab("Longitude (degree)") +
  ylab("Latitude (degree)") + 
  labs(color = paste0("Precipitation Height \nin millimetre (mm)")) +
  scale_colour_gradientn(colours = viridis::viridis(10)) + 
  geom_path(data = map_data("world","Germany"),
            aes(x = long, y = lat, group = group)) +
  facet_grid(~calendar_date) + 
  coord_fixed(xlim = c(6,15),
              ylim = c(47,55)) + 
  theme_bw()

# Print both plots on a grid 
Plot_Grid = plot_grid(Spatial_Plot_June,
          Spatial_Plot_Sep,
          Spatial_Plot_Dec,
          align = "v",nrow = 3)
  
save_plot(plot = Plot_Grid ,
          filename = "Precipitation_Map.JPG",
          path = here("Output","JPG's","Snapshots"))





