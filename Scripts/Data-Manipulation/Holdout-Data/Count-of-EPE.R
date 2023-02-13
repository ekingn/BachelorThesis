# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
# {
#   library(here)
#   source(here("Scripts","Data-Manipulation","Holdout-Data","Holdout-Data.R"))
# }

Monthly_Count_of_EPE <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(EPE == 1) %>% 
  
  group_by(month) %>% 
  
  count(EPE)

Annual_Count_of_EPE <-
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(EPE == 1) %>% 
  
  group_by(year) %>% 
  
  count(EPE)

Annual_Monthly_Count_of_EPE <-
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(EPE == 1) %>% 
  
  group_by(year,
           month) %>% 
  
  count(EPE)
