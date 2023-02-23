haversine_distance_two_points <- function(lat1, long1, lat2, long2) {
  # Convert latitudes and longitudes to radians
  lat1_rad <- 
    
    deg2rad(lat1)
  
  long1_rad <- 
    
    deg2rad(long1)
  
  lat2_rad <- 
    
    deg2rad(lat2)
  
  long2_rad <- 
    
    deg2rad(long2)
  
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
    
    2 * asin(min(1, sqrt(a)))
  
  distance_km <- earth_radius_km * c
  
  # Return the distance in kilometers
  return(distance_km)
}

# Helper function to convert degrees to radians
deg2rad <- function(deg) {
  return(deg * pi / 180)
}
