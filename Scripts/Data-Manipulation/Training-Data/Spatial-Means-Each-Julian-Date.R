Spatial_Means_Julian_Dates <-
  
  Weather_Data_Daily_Resolution %>%
  
  filter(year %in% 2012,
         month %in% 1,
         day %in% 1:10,
         !is.na(rain)) %>% 
  
  select(days_since_earliest_observation,
         rain) %>% 
  
  group_by(days_since_earliest_observation) %>% 
  
  summarise(spatial_means = mean(rain))
  
  