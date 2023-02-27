# Define a function, that applies the Haversine Function for two spatial locations to calculate the distance in kilometer between them
haversine <- function(lat1, lon1, lat2, lon2) {

  # convert the latitudinal and longitudinal degrees to radians
  lat1 <- lat1 * pi / 180
  lon1 <- lon1 * pi / 180
  lat2 <- lat2 * pi / 180
  lon2 <- lon2 * pi / 180
  
  # calculate the difference between latitudes and longitudes of the two spatial locations
  dLat <- lat2 - lat1
  dLon <- lon2 - lon1
  
  # intermediary values
  a <- sin(dLat / 2) ^ 2 + cos(lat1) * cos(lat2) * sin(dLon / 2) ^ 2
  c <- 2 * asin(sqrt(a))
  
  # radius of earth in kilometers
  r <- 6371
  
  # calculate distance in kilometer
  d <- r * c
   
  # Return the calculated distance as the output of the function
  return(d)

}