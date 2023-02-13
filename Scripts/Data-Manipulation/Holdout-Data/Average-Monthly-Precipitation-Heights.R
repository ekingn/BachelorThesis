# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
# {
# library(here)
# source(here("Scripts","Session-Related","Packages.R"))
# source(here("Scripts","Data-Manipulation","Holdout-Data","Holdout-Data.R"))
# }

# Transformation of the WeatherData from daily to monthly resolution (summing up daily total precipitation)
Average_Monthly_Precipitation <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(!is.na(rain)) %>% 
  
  group_by(index, 
           year, 
           month) %>% 
  
  summarise(
    monthly_average_rain = mean(rain),
    monthly_average_sunlight = mean(sun)) %>% 
  
  ungroup()


# Order the columns, first by indexnumber, then by year and finally based on the month and 
# round the numeric value
Average_Monthly_Precipitation <- 
  
  Average_Monthly_Precipitation %>% 
  
  arrange(index, 
          year, 
          month) %>% 
  
  mutate_if(is.numeric, 
            round, 
            2)  %>%
  
  `rownames<-`(NULL) %>% 
  
  inner_join(Index_Lat_Lon,
             by = "index")
