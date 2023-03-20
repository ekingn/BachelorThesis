# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
library(here)
source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
}

# Creating a longitudinal Hovmoellerplot (Values are averaged along latitudinal degrees)

## First step: Create a regular grid of 50 spatial points and 100 temporal points 

### Compute the range of Longitude and time in the data
Range_Longitude_Degrees <-
  
  Weather_Data_Daily_Resolution %>% 
  
  select(lon) %>% 
  
  range()

Range_Time <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  select(year) %>% 
  
  range()

### Create two axis: One spatial axis and one temporal axis 
Spatial_Axis <-
  
  seq(
    Range_Longitude_Degrees[1],
    Range_Longitude_Degrees[2],
    length.out = 100)

Temporal_Axis <- 
  
  seq(
    Range_Time[1],
    Range_Time[2],
    length.out = 100)

Space_Time_Grid <-
  
  expand.grid(Longitude = Spatial_Axis,
              Time = Temporal_Axis)

### Associate each station's longitudinal coordinate with the closest gridpoint

#### Compute the distance of each longitudinal coordinate to every gridpoint, determine which gridpoint is closest and allocate the longitudinal coordinate to that gridpoint

Weather_Data_Daily_Resolution_Grid <-
  
  Weather_Data_Daily_Resolution 

distances <- 
  
  abs(outer(
  Weather_Data_Daily_Resolution_Grid$lon,
  Spatial_Axis, 
  "-"))

### Create a gridded version of the spatio-temporal data

Weather_Data_Daily_Resolution_Grid$lon <- 
  
  Spatial_Axis[apply(distances,
                     1,
                     which.min)]

### Group the weather stations by unique combinations of Longitude degree and calendar date. 
### Then, average all the observations of precipitation height that have the same unique combination of longitudinal degree and calendar date. 
### This results in the data frame required for the Hovmoellerplot. 
Dataframe_Hovmoellerplot <- 
  
  Weather_Data_Daily_Resolution_Grid %>% 
  
  group_by(lon,
           year) %>%
  
  summarise(rain = mean(rain))

### Create the longitudinal Hovmöllerplot
Longitudinal_Hovmoellerplot <- 
  
  Dataframe_Hovmoellerplot %>% 
  
  ggplot() +
  
  geom_tile(aes(x = lon, y = year, fill = rain)) +
  
  scale_y_reverse() + 
  
  xlab("Longitude (degrees)") +
  
  ylab("Year") +
  
  ggtitle("Longitudinal Hovmöllerplot") + 
  
  theme_bw()


ggsave(plot = Longitudinal_Hovmoellerplot,
       filename = "Longitudinal-Hovmoellerplot-High-Res.jpg",
       path = here("Output","JPGs","Hovmoellerplots"),
       width = 5,
       height = 2)
