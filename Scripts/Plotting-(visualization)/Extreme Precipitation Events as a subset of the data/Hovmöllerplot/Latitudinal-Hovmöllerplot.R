# The purpose of this script is to create a latitudinal Hovmöllerplot, which is a special type of heatmap.
# A latitudinal Hovmöllerplot is a grid consisting of fields, where each field corresponds to a combination 
# of latitudinal degree and a variable of time, in this case year. Since the initial weather data is not grid, but point data, it had to be 
# translated to grid data first. To that end, first of all, the number of latitudinal grid points was set 
# to 125, that range between the minimum of latitudinal degree and the maximum of latitudinal degree in the data (in the case of latitude)
# and between the minimum year . 
# After determining 125 equally spaced grid-points that range within the interval mentioned above, each existing 
# point datum is allocated to the grid point, to whom the latitudinal degree of the point data has the closest distance. 
# The number of temporal (year) grid points was naturally set to 21, the number of years observed in the data. 
# From 125 latitudinal grid-points and 21 temporal grid-point follow 2625 groups of data or 2625 latitude-year grid-fields. 
# After having the weather data seperated into 2625 groups, the average share of EPE within this group is computed, #
# which is an average across all weather stations within that latitudinal group for a particular year. 

# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
#{
# library(here)
# source(here("Scripts","Session-Related","Packages.R"))
# source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
#}

Weather_Data_Daily_Resolution_Without_NA_Precipitation = filter(Weather_Data_Daily_Resolution,
                                                                !is.na(rain))

# Creating a latitudinal Hovmoellerplot (Values are averaged along longitudinal degrees)

## First step: Create a regular grid of 50 spatial points and 100 temporal points 

### Compute the range of latitude and time in the data
Range_Latitude_Degrees = range(Weather_Data_Daily_Resolution_Without_NA_Precipitation$lat)
Range_Time = range(Weather_Data_Daily_Resolution_Without_NA_Precipitation$year)

### Create two axis: One spatial axis and one temporal axis 
Spatial_Axis = seq(
  Range_Latitude_Degrees[1],
  Range_Latitude_Degrees[2],
  length.out = 125)

Temporal_Axis = seq(
  Range_Time[1],
  Range_Time[2],
  length.out = 21) 


Space_Time_Grid = expand.grid(latitude = Spatial_Axis,
                            time = Temporal_Axis)

### Associate each station's latitudinal coordinate with the closest gridpoint

#### Compute the distance of each latitudinal coordinate to every gridpoint, determine which gridpoint is closest and allocate the latitudinal coordinate to that gridpoint

Weather_Data_Daily_Resolution_Without_NA_Precipitation_Grid = Weather_Data_Daily_Resolution_Without_NA_Precipitation 

distances = abs(outer(Weather_Data_Daily_Resolution_Without_NA_Precipitation_Grid$lat, Spatial_Axis, "-"))

### Create a gridded version of the spatio-temporal data
Weather_Data_Daily_Resolution_Without_NA_Precipitation_Grid$lat = Spatial_Axis[apply(distances, 1, which.min)]

### Group the weather stations by unique combinations of latitude degree and calendar date. 
### Then, average all the observations of precipitation height that have the same unique combination of latitudinal degree and calendar date. 
### This results in the data frame required for the Hovmoellerplot. 
Dataframe_Hovmoellerplot = group_by(.data = Weather_Data_Daily_Resolution_Without_NA_Precipitation_Grid, 
                                   lat, 
                                   year) %>%
  summarise(share_of_EPE = mean(extreme_precipitation_event))

### Create the latidunal Hovmoellerplot
Latitudinal_Hovmoellerplot = ggplot(Dataframe_Hovmoellerplot) +
  
  geom_tile(aes(x = lat, 
                y = year, 
                fill = share_of_EPE)) +
  
  scale_y_reverse() + 
  
  scale_fill_viridis_c() + 
  
  xlab("Latitude (degrees)") +
  
  ylab("Year") +
  
  ggtitle("Latitudinal Hovmöllerplot") + 
  
  labs(fill = "Average Share of Extreme Precipitation Events \nAmong All Precipitation Events") + 
  
  theme_bw() + 
  
  scale_x_continuous(breaks = c(seq(from = 47.4, 
                                    to = 54.8, 
                                    by=0.1))) +
  
  scale_y_continuous(breaks = c(seq(from = 1996,
                                    to = 2016,
                                    by = 1)),
                     labels = c(2016:1996)) + 
  
  theme(legend.title = element_text(lineheight = 0.4,
                                    face = "bold"),
        legend.text = element_text(face = "bold"),
        plot.title = element_text(hjust = 0.5,
                                  face = "bold",
                                  size = 16),
        axis.title.x = element_text(size = 14,
                                    face = "bold"),
        axis.title.y = element_text(size = 14,
                                    face = "bold"),
        axis.text.x = element_text(face = "bold",
                                   size = 10,
                                   angle = 70,
                                   vjust = 0.75),
        axis.text.y = element_text(face = "bold"))

save_plot(plot =  Latitudinal_Hovmoellerplot,
          filename = "Latitudinal-Hovmoellerplot-share_of_EPE.JPG",
          path = here("Output","JPG's","Hovmöllerplots"))



