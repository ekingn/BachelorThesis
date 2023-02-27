# This is inefficient, because it performs a cross join and then subsets the data afterwords, which results in a 
# large intermediate demand on the working memory intermediate

Paired_Precipitation_Heights <-

  # Initial Dataframe to be changed
  Paired_Precipitation_Heights %>%

  # Create a cross join between A and B to include all the rows in both columns in the dataframe A
  left_join(Intervals_of_Spatial_Distance,
            by = character()) %>%

  # filter the rows, where a lies between x and y
  filter(spatial_distance >= lower  & spatial_distance < upper)
