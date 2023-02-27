#' Calculate the Haversine distance in kilometers between two points specified by latitude and longitude column names in a data frame.
#'
#' This function takes a data frame and four column names as input and returns a numeric vector containing the distance in kilometers between each pair of points specified by the input column names. 
#' The function uses the Haversine formula, which is an equation used to find the great-circle distance between two points on a sphere.
#'
#' @param df A data frame containing the input columns.
#' @param lat1_col A numeric vector specifying the column name containing the latitude of the first point.
#' @param lon1_col A numeric vector specifying the column name containing the longitude of the first point.
#' @param lat2_col A numeric vector specifying the column name containing the latitude of the second point.
#' @param lon2_col A numeric vector specifying the column name containing the longitude of the second point.
#' @return A numeric vector containing the distance in kilometers between each pair of points.
#' @examples
#' # Create a data frame with two points
#' df <- data.frame(lat1 = c(51.5072, 40.7128), lon1 = c(-0.1276, -74.0060), lat2 = c(48.8566, 37.7749), lon2 = c(2.3522, -122.4194))
#' # Calculate the distances between the two points
#' haversine_distance_two_points_column_arguments(df, "lat1", "lon1", "lat2", "lon2")
#' # Returns a numeric vector containing the distances (in kilometers) between the two points: 341.8887 3932.2598
#' @export
# Define a function that takes a data frame and four column names as input
haversine_distance_two_points_column_arguments <- function(df, 
                                                           lat1_col, 
                                                           lon1_col, 
                                                           lat2_col, 
                                                           lon2_col) {
  # Define the function, that returns the distance in kilometer between a pair of spatial locations defined
  # per angular coordinates
  
  haversine_distance_two_points <- function(lat1, long1, lat2, long2) {
    
    # Convert latitudes and longitudes to radians
    lat1_rad <- deg2rad(lat1)
    long1_rad <- deg2rad(long1)
    lat2_rad <- deg2rad(lat2)
    long2_rad <- deg2rad(long2)
    
    # Calculate differences in latitudinal degree and longitudinal degree
    delta_lat <- lat2_rad - lat1_rad
    delta_long <- long2_rad - long1_rad
    
    # Mean Radius of the Earth in kilometers
    earth_radius_km <- 6371
    
    # Haversine formula for calculating distance the distance in kilometer
    a <- sin(delta_lat/2)^2 + cos(lat1_rad) * cos(lat2_rad) * sin(delta_long/2)^2
    c <- 2 * asin(min(1, sqrt(a)))
    distance_km <- earth_radius_km * c
    
    # Return the distance in kilometers
    return(distance_km)
  }
  
  # Helper function to convert degrees to radians
  deg2rad <- function(deg) {
    return(deg * pi / 180)
  }
  
  # Apply the haversine_distance_two_points function to each row of the data frame
  distances <- 
    
    apply(df[, c(lat1_col, lon1_col, lat2_col, lon2_col)], 
          1, 
          function(row) {
            
            haversine_distance_two_points(row[1], 
                                          row[2], 
                                          row[3], 
                                          row[4])
            })
  
  # Return the distances
  return(distances)
}