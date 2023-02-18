# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
# {
# library(here)
# source(here("Scripts","Session-Related","Packages.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
# }


# The purpose of this script is the creation of a latitudinal Hovmoellerplot 
# (Values are averaged along longitudinal degrees)

## First step: Create a regular grid of 50 spatial points and 100 temporal points 

### Compute the range of latitude and time in the data
Range_Latitude_Degrees <-
  
  range(Weather_Data_Daily_Resolution$lat)

Range_Time <-
  
  range(Weather_Data_Daily_Resolution$year)

### Create two axis: One spatial axis and one temporal axis 
Spatial_Axis <-
  
  seq(
    Range_Latitude_Degrees[1],
    Range_Latitude_Degrees[2],
    length.out = 125)

Temporal_Axis <-
  
  seq(
    Range_Time[1],
    Range_Time[2],
    length.out = 125 
)

Space_Time_Grid <-
  
  expand.grid(Latitude = Spatial_Axis,
              Time = Temporal_Axis)

### Associate each station's latitudinal coordinate with the closest gridpoint

#### Compute the distance of each latitudinal coordinate to every gridpoint, determine which gridpoint is closest and allocate the latitudinal coordinate to that gridpoint

Weather_Data_Daily_Resolution_Grid <- 
  
  Weather_Data_Daily_Resolution 

distances <-
  
  abs(outer(Weather_Data_Daily_Resolution_Grid$lat,
            Spatial_Axis,
            "-"))

### Create a gridded version of the spatio-temporal data

Weather_Data_Daily_Resolution_Grid$lat <-
  
  Spatial_Axis[apply(distances,
                     1,
                     which.min)
               ]

### Group the weather stations by unique combinations of latitude degree and calendar date. 
### Then, average all the observations of precipitation height that have the same unique combination of latitudinal degree and calendar date. 
### This results in the data frame required for the Hovmoellerplot. 
Dataframe_Hovmoellerplot <- 
  
  Weather_Data_Daily_Resolution_Grid %>% 
  
  group_by(lat,
           year) %>% 
  
  summarise(rain = mean(rain))

### Create the latidunal Hovmoellerplot
Latitudinal_Hovmoellerplot <- 
  
  Dataframe_Hovmoellerplot %>% 
  
  filter(!is.na(rain)) %>% 
  
  ggplot() +
  
  geom_tile(aes(x = lat, 
                y = year, 
                fill = rain),
            na.rm = TRUE) +
  
  scale_y_reverse() + 
  
  scale_fill_viridis_c() + 
  
  xlab("Latitude (degrees)") +
  
  ylab("Year") +
  
  ggtitle("Latitudinal Hovmöllerplot") + 
  
  labs(fill = paste0("Average precipitation height in millimetre (mm)","\nacross all longitudinal degrees")) + 
  
  theme_bw() + 
  
  scale_x_continuous(breaks = c(seq(from = 47.4, 
                                    to = 54.8, 
                                    by=0.2))) 

ggsave(plot = Latitudinal_Hovmoellerplot,
       filename = "Latitudinal-Hovmoellerplot-High-Res.jpg",
       path = here("Output","JPGs","Hovmoellerplots"))



