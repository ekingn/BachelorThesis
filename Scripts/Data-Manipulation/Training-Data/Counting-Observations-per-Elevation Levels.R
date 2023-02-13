#If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
# library(here)
# source(here("Scripts","Session-Related","Packages.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
}

Quantiles_of_Observed_Elevation_Levels <- 
  
  data.frame(n_total = 
               
               Weather_Data_Daily_Resolution %>% 
               
               pull(alt) %>% 
               
               length(),
             
             n_below_equal_75th_percentile = 
               
               Weather_Data_Daily_Resolution %>% 
               
               filter(alt <= quantile(alt, 
                                      0.75)) %>% 
               
               nrow(),
             
             n_above_75th_below_95th_percentile = 
               
               Weather_Data_Daily_Resolution %>% 
               
               filter(alt > quantile(alt,
                                     0.75) & 
                                alt <= quantile(alt,
                                                0.95)) %>% 
               
               nrow(),
             
             n_above_95th_below_99th_percentile = 
               
               Weather_Data_Daily_Resolution %>% 
               
               filter(alt > quantile(alt,
                                     0.95) & alt <= quantile(alt,
                                                             0.99)) %>% 
               
               nrow())

