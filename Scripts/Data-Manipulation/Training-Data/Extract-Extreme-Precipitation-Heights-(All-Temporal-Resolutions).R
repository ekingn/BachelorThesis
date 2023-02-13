# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
# {
#   library(here)
#   source(here("Scripts","Session-Related","Packages.R"))
#   source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
# }

# The purpose of this script is to filter only extreme precipitation heights of the daily precipitation data.  
# Daily Precipitation data is being subsetted to rows with none-NA values for precipitation. 
# NA values for precipitation have already been filtered in monthly and annual precipitation data.

# Create a dataframe of EPE only
{
  Extreme_Precipitation_Heights_Daily_Resolution <- 
    
    Weather_Data_Daily_Resolution %>% 
    
    filter(!is.na(rain)) %>% 
    
    filter(EPE == 1) %>% 
    
    select(index,
           year,
           month,
           rain)
                                                                                            
}
