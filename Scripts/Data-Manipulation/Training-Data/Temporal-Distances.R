{
 #library(here)
 #source(here("Scripts","Session-Related","Packages.R"))
 #source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
}

Distinct_Julian_Dates <-

  Weather_Data_Daily_Resolution %>%
  
  filter(year %in% 2012,
         month %in% 1,
         day %in% 1:7) %>% 

  distinct(days_since_earliest_observation) %>%

  arrange(days_since_earliest_observation) %>%

  rename("julian_date" = days_since_earliest_observation)




Temporal_Distances <-

  data.frame(julian_date_1 = rep(Distinct_Julian_Dates$julian_date,
                                 each = nrow(Distinct_Julian_Dates)))


Temporal_Distances <-

  Temporal_Distances %>%

  mutate(julian_date_2 = rep(Distinct_Julian_Dates$julian_date,
                             times = length(Distinct_Julian_Dates$julian_date))) %>%

  mutate(temporal_difference = abs(julian_date_1 - julian_date_2))




Intervals_of_Temporal_Distance <-

  Temporal_Distances %>%

  mutate(interval = cut(temporal_difference,
                        breaks = seq(min(temporal_difference),
                                     max(temporal_difference),
                                     length.out = 7),
                        include.lowest = TRUE,
                        right = FALSE,
                        left = TRUE,
                        dig.lab = 5)) %>%

  group_by(interval) %>%

  summarise(count = n()) %>%

  ungroup() %>% 
  
  rename(temporal_interval = interval) %>% 
           
  mutate(temporal_interval = as.character(temporal_interval))

