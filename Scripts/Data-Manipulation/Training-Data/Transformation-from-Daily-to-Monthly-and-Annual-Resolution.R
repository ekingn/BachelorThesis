# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
# {
#   library(here)
#   source(here("Scripts","Session-Related","Packages.R"))
#   source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
# }

# The purpose of this script is to translate the weather data from its initial daily resolution to monthly and annual resolution.
# Since precipitation height and hours of sunlight are the only variables of interest, before being worked upon, the daily resolution precipitation data
# is subsetted to all rows that have none-NA values for precipitation height 

# Transformation of the WeatherData from daily to monthly resolution (summing up daily total precipitation)
Weather_Data_Monthly_Resolution <-
  
  Weather_Data_Daily_Resolution %>% 
  
  ungroup() %>% 
  
  filter(!is.na(rain)) %>% 
  
  group_by(index,
           year,
           month) %>% 
  
  summarise(monthly_total_rain = sum(rain)) %>% 
  
  arrange(index, 
          year,
          month) %>% 
  
  `rownames<-`(NULL) %>% 
  
  ungroup()

# Transformation of the WeatherData from daily to annual resolution (summing up total precipitation)
Weather_Data_Annual_Resolution <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  ungroup() %>% 
  
  filter(!is.na(rain)) %>% 
  
  group_by(index,
           year) %>% 
  
  summarise(annual_total_rain = sum(rain)) %>% 
  
  arrange(index,
          year) %>% 
  
  `rownames<-`(NULL) %>% 
  
  ungroup()

