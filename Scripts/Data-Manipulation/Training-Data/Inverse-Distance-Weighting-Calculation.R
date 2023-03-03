# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
library(here)
source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
}

  
  
{
Weather_NoNA <-
  
  Weather_Data_Daily_Resolution %>% 

  rename(Julian = days_since_earliest_observation) %>% 
  
  filter(!is.na(rain)) 
}

  
  
{
  spatial_indices <- 
    
    unique(Weather_NoNA$index)
  
  temporal_indices <- 
    
    unique(Weather_NoNA$Julian)
  
  # The expand.grid() function creates a dataframe from all possible combinations
  # of the supplied vectors/columns. 
  grid <- 
    
    expand.grid(index = spatial_indices,
                Julian = temporal_indices) %>% 
    
    left_join(Index_Lat_Lon %>%
                select(index, lon),
              by = c("index" = "index")) %>% 
    
    left_join(Index_Lat_Lon %>% select(index, lat),
              by = c("index" = "index")) 
}
grid <- 
    
    grid %>% 
    
    left_join(Weather_NoNA %>% select(index, 
                                    Julian,
                                    season),
              by = c("index" = "index",
                     "Julian" = "Julian")) 
    

Weather_NoNA_IDW_Interpolated <-
  
  idw(formula = rain ~ 1,
      locations = ~ lon + lat + Julian,
      data = Weather_NoNA,
      newdata = grid,
      idp = 2)

save.image(file = "IDW.RData")
  