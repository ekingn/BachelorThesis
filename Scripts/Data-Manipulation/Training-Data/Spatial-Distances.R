# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:

{
#library(here)
#source(here("Scripts","Session-Related","Packages.R"))
#source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
#source(here("Scripts","Functions","Haversine-Function.R"))
}

# The purpose of this script is twofold:
# - Compute the spatial distances in kilometre between all spatial combinations weather stations 
# - Provide the spatial intervals for the computation of the spatio-temporal covariance function

# Create a dataframe called Lon_Lat, whose first column consists of longitudinal degrees
# and whose second column consists of latitudinal degrees
Lon_Lat <- 
  
  Index_Lat_Lon %>% 
  
  select(lon,
         lat) %>% 
  
  rename("longitude" = lon,
         "latitude" = lat)



{
  # initialize an empty matrix to hold distances
  n <- nrow(Lon_Lat)
  distance_matrix <- matrix(0, nrow=n, ncol=n)
  
  # loop over all pairs of points and calculate distances
  for (i in 1:n) {
    for (j in 1:n) {
      distance_matrix[i, j] <- haversine(lat1 = Lon_Lat$latitude[i],
                                         lon1 = Lon_Lat$longitude[i],
                                         lat2 = Lon_Lat$latitude[j],
                                         lon2 = Lon_Lat$longitude[j])
    }
  }

  # convert the matrix to a data frame with appropriate row and column names
  distance_matrix <- as.data.frame(distance_matrix)
  rownames(distance_matrix) <- 1:nrow(Lon_Lat)
  colnames(distance_matrix) <- 1:nrow(Lon_Lat)
}


colnames(distance_matrix) <- 
  
  paste0("index_",
         seq_along(distance_matrix))

rownames(distance_matrix) <- 
  
  paste0("index_",
         seq_len(nrow(distance_matrix)))

Stacked_Distance_Matrix <-
  
  distance_matrix %>% 
  
  stack() %>% 
  
  mutate(pair_of_indices = paste(rep(x = seq(from = 1,
                                             to = nrow(Lon_Lat),
                                             by = 1),
                                     each = nrow(Lon_Lat)),
                                 rep(x = seq(from = 1,
                                             to = nrow(Lon_Lat),
                                             by = 1),
                                     times = nrow(Lon_Lat)),
                                 sep = "-"),
         distance_km = values) %>% 
  
  select(pair_of_indices, distance_km) %>% 
  
  mutate(index_1 = rep(seq(from = 1,
                           to = nrow(Lon_Lat),
                           by = 1),
                       each = nrow(Lon_Lat)),
         index_2 = rep(seq(from = 1,
                           to = nrow(Lon_Lat),
                           by = 1),
                       times = nrow(Lon_Lat))
  ) %>% 
  
  select(index_1,
         index_2,
         pair_of_indices,
         distance_km)


Intervals_of_Spatial_Distance <- 
  
  Stacked_Distance_Matrix %>% 
  
  mutate(spatial_interval = cut(distance_km, 
                        breaks = seq(0, 
                                     max(distance_km), 
                                     length.out = 51),
                        include.lowest = TRUE, 
                        right = FALSE)) %>% 
  
  group_by(spatial_interval) %>% 
  
  summarise(count = n()) %>% 
  
  ungroup() %>% 
  
  mutate(spatial_interval = as.character(spatial_interval))

