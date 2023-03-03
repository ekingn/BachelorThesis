## The purpose of this script is the calculation of the spatio-temporal covariancefunction
## for various combinations of intervals of spatial distances and intervals of temporal distances. 
## The spatio-temporal covariance function returns the covariability of pairs of precipitations events, 
## for whom the spatial and temporal distances between the respective spatio-temporal locations
## of the observations lie within a specific interval of spatial distance and 
## a specific interval of temporal distances. 
## Once these spatio-temporal covariability values are calculated, they will be visualized, 
## more precisely, their variation as a consequence of variation of spatial and temporal intervals 
## will be visualized. 
## The analysis of this variation is meant to provide evidence to the existence of spatio-temporal dependencies. 
## Spatial, temporal and spatio-temporal dependencies describe each the similarity of precipitation height values 
## observed at relatively close locations, be it spatial, temporal or spatio-temporal respectively. 
## If the visualization of the calculated covariability values therefore reveals, 
## that the covariability within a spatio-temporal interval decreases,
## as either the interval of spatial or temporal distances encapsulates greater distances, 
## this hence proves aforementioned dependencies. 


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
}

{
  objects_to_keep <-
    
    c("Weather_Data_Daily_Resolution",
      "Index_Lat_Lon",
      "Intervals_of_Spatial_Distance",
      "Intervals_of_Temporal_Distance",
      "haversine_distance_two_points_column_arguments",
      "haversine_distance_two_points",
      "Spatial_Means_Julian_Dates")
  
  # Create a list of all objects in the environment
  all_objects <-
    
    ls()
  
  # Determine the objects to be deleted
  objects_to_be_deleted <-
    
    setdiff(all_objects, objects_to_keep)
  
  # Delete the unwanted objects
  rm(list = objects_to_be_deleted)
}

# Prepare the data. Since the calculation of the spatio-temporal covariancefunction, as implemented here,
# is demanding with regard to working memory, only observations from the January 2012, the first 10 days
# are used. 
{
Paired_Precipitation_Heights <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(year %in% 2012, 
         month %in% 1,
         day %in% 1:10) %>% 
  
  select(index, 
         days_since_earliest_observation, 
         rain) 

rm(Weather_Data_Daily_Resolution)
}

{
spatial_indices <- 
  
  unique(Paired_Precipitation_Heights$index)

temporal_indices <- 
  
  unique(Paired_Precipitation_Heights$days_since_earliest_observation)

# The expand.grid() function creates a dataframe from all possible combinations
# of the supplied vectors/columns. 
grid <- 
  
  expand.grid(location1 = spatial_indices, 
              location2 = spatial_indices, 
              julian_date1 = temporal_indices, 
              julian_date2 = temporal_indices)
}


# After all possible pairs of spatio-temporal locations, for whom the day of 
# observations lies within the first 10 days of january 2012, have been determined
# within a dataframe called grid, every row in that dataframe represents the 
# a pair of indices of weatherstations and a pair of julian dates. Now, the 
# precipitation height observed at the respective locations are added.
# Various other variables are either added or calculated also.
{merged_df <- 
  
  grid %>% 
  
  left_join(Paired_Precipitation_Heights, 
            by = c("location1" = "index", 
                   "julian_date1" = "days_since_earliest_observation"))

rm(grid)
}

{
merged_df <-
  
  merged_df %>%

  rename(rainfall1 = rain) %>% 
  
  left_join(Paired_Precipitation_Heights, 
            by = c("location2" = "index", 
                   "julian_date2" = "days_since_earliest_observation")) %>% 
  
  rename(rainfall2 = rain) %>% 
  
  select(location1, 
         location2, 
         julian_date1, 
         julian_date2, 
         rainfall1, 
         rainfall2) %>% 
  
  left_join(Index_Lat_Lon %>% 
              
              select(index, lat), 
            by = c("location1" = "index")) %>% 
  
  rename(lat1 = lat) %>% 
  
  left_join(Index_Lat_Lon %>% 
              
              select(index, lat), 
            by = c("location2" = "index")) %>% 
  
  rename(lat2 = lat) %>% 
  
  left_join(Index_Lat_Lon %>% 
              
              select(index, lon), 
            by = c("location1" = "index")) %>% 
  
  rename(lon1 = lon) %>% 
  
  left_join(Index_Lat_Lon %>% 
              
              select(index, lon), 
            by = c("location2" = "index")) %>% 
  
  rename(lon2 = lon) %>% 
  
  mutate(temporal_distance = abs(julian_date1 - julian_date2)) %>% 
  
  select(location1, location2, 
         julian_date1, julian_date2, 
         rainfall1, rainfall2, everything()) %>% 
  
  arrange(location1, location2, 
          julian_date1, julian_date2)
}

{
# In the previous step, the longitudinal and latitudinal coordinates
# of both paired weather stations had been added. Now,
# taking these angular coordinates as input, the spatial distances
# between the two weatherstations is calculated in kilometer using 
# applying a previously defined function, which implements the 
# haversine formula for calculating the great circle distance in kilometer.
merged_df$spatial_distance <- 
  haversine_distance_two_points_column_arguments(df = merged_df, 
                                                 lat1_col = "lat1", 
                                                 lat2_col = "lat2", 
                                                 lon1_col = "lon1", 
                                                 lon2_col = "lon2")
}

{  
Paired_Precipitation_Heights <-

  merged_df

rm(merged_df)
}

{
# Here, two data frames, one of which defined in another sourced script,
# are set to be data tables instead of data frames. The underlying reason
# is that data tables are more memory efficient regarding acts of data manipulation,
# if the data is big (which is the case here).
setDT(Paired_Precipitation_Heights)
setDT(Intervals_of_Spatial_Distance)
}

{
# Add indices of the interval of spatial distances, which a pair of weather
# stations belong to, based on the spatial distances and the lower and upper boundaries
# of the intervals. 
Paired_Precipitation_Heights <- 
  
  Intervals_of_Spatial_Distance[Paired_Precipitation_Heights, 
                                          on = .(lower <= spatial_distance, 
                                                 upper >= spatial_distance), 
                                          nomatch = 0L] %>% 
  
  data.frame()

Paired_Precipitation_Heights <-
  
  Paired_Precipitation_Heights %>% select(location1, location2, 
                                          lat1, lat2, 
                                          lon1, lon2, 
                                          spatial_interval, index_dspatial, 
                                          julian_date1, julian_date2, temporal_distance, 
                                          rainfall1, rainfall2)
}

# Reduce the demand on the working memory
{
  objects_to_keep <-

    c("Paired_Precipitation_Heights",
      "Intervals_of_Spatial_Distance",
      "Intervals_of_Temporal_Distance",
      "Index_Lat_Lon",
      "haversine",
      "haversine_distance_two_points_column_arguments",
      "haversine_distance_two_points",
      "Spatial_Means_Julian_Dates")

  # Create a list of all objects in the environment
  all_objects <-

    ls()

  # Determine the objects to be deleted
  objects_to_be_deleted <-

    setdiff(all_objects, objects_to_keep)

  # Delete the unwanted objects
  rm(list = objects_to_be_deleted)
}


{
# Similar to the definition of indices of intervals of spatial distances above,
# indices of intervals of temporal distances are added here.
setDT(Paired_Precipitation_Heights)
setDT(Intervals_of_Temporal_Distance)

Paired_Precipitation_Heights <- 
  
  Intervals_of_Temporal_Distance[Paired_Precipitation_Heights, 
                                on = .(lower <= temporal_distance, 
                                       upper >= temporal_distance), 
                                nomatch = 0L] %>% 
  
  data.frame() %>% 
  
  select(location1, location2,
         lat1, lat2,
         lon1, lon2,
         spatial_interval, index_dspatial,
         julian_date1, julian_date2, temporal_interval, index_dtemporal,
         rainfall1, rainfall2)
} 

{
setDT(Paired_Precipitation_Heights)
setDT(Spatial_Means_Julian_Dates)

# Here, the spatial means of precipitation height at a specific julian date, defined and 
# calculated in an external sourced script, are inserted into the dataframe Paired_Precipitation_Heights,
# which is the center for the calculation of the spatio-temporal covariances.  
Paired_Precipitation_Heights <- 
  
  Spatial_Means_Julian_Dates[Paired_Precipitation_Heights, 
                                 on = .(days_since_earliest_observation == julian_date1), 
                                 nomatch = 0L] %>% 
  
  data.frame() %>% 
  
  select(location1, location2,
         lat1, lat2,
         lon1, lon2,
         spatial_interval, index_dspatial,
         julian_date2, temporal_interval, index_dtemporal,
         rainfall1, rainfall2, spatial_means) %>% 
  
  rename(spatial_means_jul_1 = spatial_means)
}

{
  # Same as above, for the second weather station.
  setDT(Paired_Precipitation_Heights)
  setDT(Spatial_Means_Julian_Dates)
  Paired_Precipitation_Heights <- 
    
    Spatial_Means_Julian_Dates[Paired_Precipitation_Heights, 
                               on = .(days_since_earliest_observation == julian_date2), 
                               nomatch = 0L] %>% 
    
    data.frame() %>% 
    
    select(location1, location2,
           lat1, lat2,
           lon1, lon2,
           spatial_interval, index_dspatial,
           temporal_interval, index_dtemporal,
           rainfall1, rainfall2, spatial_means_jul_1, spatial_means) %>% 
    
    rename(spatial_means_jul_2 = spatial_means)
}

{
# Here, in a final step,
# - the precipitation observations are centered
# - cross-products of the centered precipitation values are calculated
# - the cross-products are summed up
# - the average of all cross-products within the interval of spatial and 
# temporal distances is taken
# and finally, the intervals are inserted into the resulting dataframe. 
Paired_Precipitation_Heights <- 
  
  Paired_Precipitation_Heights %>%
  
  mutate(centered_rainfall1 = rainfall1 - spatial_means_jul_1,
         centered_rainfall2 = rainfall2 - spatial_means_jul_2) %>% 
  
  mutate(cross_product_centered_rainfall = centered_rainfall1 * centered_rainfall2) %>% 
  
  filter(!is.na(cross_product_centered_rainfall)) %>% 
  
  group_by(index_dspatial,
           index_dtemporal) %>% 
  
  summarise(sum_cross_products = sum(cross_product_centered_rainfall),
            n = n()) %>%
  
  mutate(averaged_sumof_crossproducts = sum_cross_products / (n)) %>% 
  
  ungroup() %>% 
  
  left_join(Intervals_of_Spatial_Distance %>% select(index_dspatial, 
                                                      spatial_interval),
            by = "index_dspatial") %>% 
  
  left_join(Intervals_of_Temporal_Distance %>% select(index_dtemporal,
                                                      temporal_interval),
            by = "index_dtemporal")
}
