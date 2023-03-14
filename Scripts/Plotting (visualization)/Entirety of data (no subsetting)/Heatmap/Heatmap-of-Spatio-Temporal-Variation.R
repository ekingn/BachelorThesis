# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:

{
library(here)
# source(here("Scripts","Session-Related","Packages.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
# source(here("Scripts","Functions","Haversine-Function-Arguments-are-Columns.R"))
# source(here("Scripts","Functions","Haversine-Function.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Spatial-Means-Each-Julian-Date.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Spatial-Distances.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Intervals-of-Spatial-Distances.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Temporal-Distances.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Intervals-of-Temporal-Distances.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Calculating-Spatiotemporal-Covariances.R"))
}

# Create a heatmap, that visualizes,
# how the covariability pf precipitation observed at a pair of weather stations 
# varies as a consequence of increasing spatial and temporal distances between the
# paired observations

Spatial_Intervals_Factors <-
  
  Intervals_of_Spatial_Distance %>% 
  
  select(spatial_interval) %>% 
  
  as_factor()

Heatmap_Spatio_Temporal_Covariance <- 
  
  Paired_Precipitation_Heights %>%
  
  filter(index_dspatial %in% 1:10,
         index_dtemporal %in% 1:10) %>% 
  
  ggplot(aes(x = factor(spatial_interval), 
             y = factor(temporal_interval))) +
  
  geom_tile(aes(fill = abs(averaged_sumof_crossproducts))) +
  
  scale_x_discrete(limits = Spatial_Intervals_Factors$spatial_interval[1:10]) +

  scale_fill_viridis_c() +  
  
  labs(x = "Interval of Distances in Kilometer", 
       y = "Interval of Distances in Julian Dates", 
       fill = paste("Spatio-Temporal\n","Covariability")) +
  
  theme(plot.title = element_text(size = 14,
                                  hjust = 0.5,
                                  face = "bold",
                                  margin = margin(b = 15)),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x = element_text(size = 12,
                                   face = "bold",
                                   angle = 60,
                                   margin = margin(t = 5)),
        axis.text.y = element_text(size = 12,
                                   face = "bold"),
        axis.title.x = element_text(size = 14,
                                    face = "bold",
                                    vjust = -3,
                                    margin = margin(t = -2)),
        axis.title.y = element_text(size = 14,
                                    face = "bold",
                                    vjust = 3,
                                    margin = margin(r = 5)),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = "bold",
                                    hjust = 0),
        legend.text = element_text(face = "bold"))

Heatmap_Spatio_Temporal_Covariance 

ggsave(plot = Heatmap_Spatio_Temporal_Covariance,
       filename = "Heatmap-Spatio-Temporal-Covariance.jpg",
       path = here("Output","JPGs","Heatmaps"),
       width = 4,
       height = 2)


