# Haversine formula for calculating distance between two points specified by latitude and longitude
haversine <- function(lat1, 
                      long1, 
                      lat2, 
                      long2) {
  
  # Convert latitudes and longitudes to radians
  lat1_rad <- 
    
    lat1 * pi / 180
  
  long1_rad <- 
    
    long1 * pi / 180
  
  lat2_rad <- 
    
    lat2 * pi / 180
  
  long2_rad <- 
    
    long2 * pi / 180
  
  # Calculate differences in latitude and longitude
  delta_lat <- 
    
    lat2_rad - lat1_rad
  
  delta_long <- 
    
    long2_rad - long1_rad
  
  # Radius of the Earth in kilometers
  earth_radius_km <- 6371
  
  # Haversine formula for calculating distance
  a <- 
    
    sin(delta_lat/2)^2 + cos(lat1_rad) * cos(lat2_rad) * sin(delta_long/2)^2
  
  c <- 
    
    2 * asin(pmin(1, sqrt(a)))
  
  distance_km <- 
    
    earth_radius_km * c
  
  # Return the distance in kilometers
  return(distance_km)
}

# Create a dataframe called Lon_Lat, whose first column consists of longitudinal degrees
# and whose second column consists of latitudinal degrees
Lon_Lat <- 
  
  Index_Lat_Lon %>% 
  
  select(lon,
         lat) %>% 
  
  rename("longitude" = lon,
         "latitude" = lat)

# Calculate distance between all pairs of points
distance_matrix <- 
  
  data.frame(apply(Lon_Lat,
                   1,
                   function(row) {
                     haversine(row[2],
                               row[1],
                               Lon_Lat$latitude,
                               Lon_Lat$longitude)}
                   ))

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


Intervals_of_Distance <- 
  
  Stacked_Distance_Matrix %>% 
  
  mutate(interval = cut(distance_km, 
                        breaks = seq(0, 
                                     max(distance_km), 
                                     length.out = 26),
                        include.lowest = TRUE, 
                        right = FALSE)) %>% 
  
  group_by(interval) %>% 
  
  summarise(count = n()/2) %>% 
  
  ungroup()





