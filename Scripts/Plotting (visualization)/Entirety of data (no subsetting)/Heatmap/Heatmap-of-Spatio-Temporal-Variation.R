# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:

{
library(here)
source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
source(here("Scripts","Functions","Haversine-Function-Arguments-are-Columns.R"))
source(here("Scripts","Functions","Haversine-Function.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Spatial-Means-Each-Julian-Date.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Spatial-Distances.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Intervals-of-Spatial-Distances.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Temporal-Distances.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Intervals-of-Temporal-Distances.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Calculating-Spatiotemporal-Covariances.R"))
}

# Create a heatmap, that visualizes,
# how the covariability pf precipitation observed at a pair of weather stations 
# varies as a consequence of increasing spatial and temporal distances between the
# paired observations

Heatmap_Spatio_Temporal_Covariance <- 
  
  Paired_Precipitation_Heights %>%
  
  filter(index_dspatial %in% 1:10,
         index_dtemporal %in% 1:6) %>% 
  
  ggplot(aes(x = factor(spatial_interval), 
             y = factor(temporal_interval))) +
  
  geom_tile(aes(fill = abs(averaged_sumof_crossproducts))) +
  
  # scale_x_discrete(name = ,
  #                  limits = c("")) +
  # 
  # scale_y_discrete(name = , 
  #                  limits = c("")) +
  
  scale_fill_viridis_c() + 
  
  labs(x = "Interval of Distances in Kilometer", 
       y = "Interval of Distances in Julian Dates", 
       fill = "Spatio-Temporal Covariability") +
  
  ggtitle("Variation in the Spatio-Temporal Covariability") + 
  
  theme_bw()

Heatmap_Spatio_Temporal_Covariance 

ggsave(plot = Heatmap_Spatio_Temporal_Covariance,
       filename = "Heatmap-Spatio-Temporal-Covariance.jpg",
       path = here("Output","JPGs","Heatmaps"),
       width = 5,
       height = 2)
