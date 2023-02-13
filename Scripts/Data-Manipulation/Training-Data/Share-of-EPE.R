# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
# {
# library(here)
# source(here("Scripts","Session-Related","Packages.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
# }

# Transformation of the WeatherData from daily to monthly resolution (summing up daily total precipitation)

Average_Monthly_Extreme_Precipitation <- 
  
  Weather_Data_Daily_Resolution %>%
  
  filter(!is.na(rain)) %>%
  
  group_by(index, year, month) %>%
  
  summarize(mean(EPE)) %>% 
  
  mutate("mean(EPE)" = round(!!sym(names(.)[4]),
                             2)) %>% 
  
  as.data.frame() %>%
  
  ungroup()

# Create a season variable 
Average_Monthly_Extreme_Precipitation <- 

  Average_Monthly_Precipitation %>% 
  
  mutate(season = case_when(
    month <=  2 | month ==  12 ~ "Winter",
    month <=  11 & month >=  9 ~ "Autumn",
    month <=  8 & month >=  6 ~ "Summer",
    month <=  5 & month >=  3 ~ "Spring"))


# Several acts of data-manipulation:
# - Order data 
# - add index, lat, lon and name columnn
# - add column that indicates year and month simultaneously
Average_Monthly_Extreme_Precipitation <-
  
  Average_Monthly_Extreme_Precipitation %>% 
  
  arrange(index,
          year,
          month) %>% 
  
  mutate_if(is.numeric, ~round(., 2)) %>%
  
  `row.names<-`(NULL) %>% 
  
  inner_join(x = .,
             y = IndexLatLon, 
             by = "index") %>% 
  
  mutate(month_of_year = paste0(Average_Monthly_Extreme_Precipitation$year,
                                "-",
                                Average_Monthly_Extreme_Precipitation$month)) %>% 
  
  arrange(index,
          year,
          month) %>%
  
  `row.names<-`(NULL) %>% 
  
  mutate(Average_Monthly_Extreme_Precipitation,
         season_symbols = case_when(
           season == "Spring" ~ emoji("cherry_blossom"),
           season == "Summer" ~ emoji("tropical_drink"),
           season == "Autumn" ~ emoji("fallen_leaf"),
           season == "Winter" ~ emoji("snowflake")
                                               ))
