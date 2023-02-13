# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
# {
#   library(here)
#   source(here("Scripts","Session-Related","Packages.R"))
#   source(here("Scripts","Data-Manipulation","Holdout-Data","Holdout-Data.R"))
#   source(here("Scripts","Data-Manipulation","Holdout-Data","Transformation-from-Daily-to-Monthly-and-Annual-Resolution.R"))
#   source(here("Scripts","Data-Manipulation","Holdout-Data","Extract-Extreme-Precipitation-Heights-(All-Temporal-Resolutions).R"))
# }

# The purpose of this script is to describe the empirical distributions of precipitation at daily, monthly and annual resolution.
# Since precipitation is the only variable of interest in this script, it will use a subset of the initial data, where all rows
# that contain NA values for precipitation are removed. 

Weather_Data_Daily_Resolution_Without_NA_Precipitation <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  ungroup() %>% 
  
  filter(!is.na(rain))

Weather_Data_Monthly_Resolution_Without_NA_Precipitation <- 
  
  Weather_Data_Monthly_Resolution %>% 
  
  ungroup() %>% 
  
  filter(!is.na(monthly_total_rain))

Weather_Data_Annual_Resolution_Without_NA_Precipitation <- 
  
  Weather_Data_Annual_Resolution %>% 
  
  ungroup() %>% 
  
  filter(!is.na(annual_total_rain))

rm(Weather_Data_Daily_Resolution, 
   Weather_Data_Monthly_Resolution,
   Weather_Data_Annual_Resolution)

# Daily Resolution
{
  # Create a list of all unique daily precipitation heights 
  List_of_All_Precipitation_Heights_Daily_Resolution <- 
    
    Weather_Data_Daily_Resolution_Without_NA_Precipitation %>% 
    
    ungroup() %>% 
    
    distinct(rain) %>% 
    
    arrange(rain) %>%
    
    data.frame(unique_precipitation_heights = .)
  
  # Count the frequencies of all the unique precipitation heights in the data for daily temporal resolution
  Number_of_Observations_per_Precipitation_Height_Daily_Resolution <- Weather_Data_Daily_Resolution_Without_NA_Precipitation %>%
    
    ungroup() %>% 
    
    count(rain) %>% transmute(precipitation_height = rain,
                              count = n)
  
  # Create a list of all the unique extreme precipitation heights in the data for daily temporal resolution
  List_of_Extreme_Precipitation_Heights_Daily_Resolution <- 
    
    Extreme_Precipitation_Heights_Daily_Resolution %>%
    
    distinct(rain) %>%
    
    data.frame(extreme_precipitation_heights = .)
  
  # Count the frequencies of all the unique extreme precipitation heights in the data for daily temporal resolution
  Number_of_Observations_per_Extreme_Precipitation_Height_Daily_Resolution <- 
    
    Extreme_Precipitation_Heights_Daily_Resolution %>%
    
    count(rain) %>%
    
    transmute(precipitation_height = .$rain, frequency = .$n)
}

# Monthly Resolution 
{
  List_of_All_Precipitation_Heights_Monthly_Resolution <- 
    
    Weather_Data_Monthly_Resolution_Without_NA_Precipitation %>%
    
    select(monthly_total_rain) %>%
    
    distinct() %>%
    
    arrange(monthly_total_rain)
  
  Number_of_Observations_per_Precipitation_Height_Monthly_Resolution <- 
    
    Weather_Data_Monthly_Resolution_Without_NA_Precipitation %>%
    
    count(monthly_total_rain)
}

# Annual Precipitation
{
  List_of_All_Precipitation_Heights_Annual_Resolution <- 
    
    Weather_Data_Annual_Resolution_Without_NA_Precipitation %>%
    
    select(annual_total_rain) %>%
    
    distinct() %>%
    
    arrange(annual_total_rain)
  
  Number_of_Observations_per_Precipitation_Height_Annual_Resolution <- 
    
    Weather_Data_Annual_Resolution_Without_NA_Precipitation %>%
    
    count(annual_total_rain)
  
}
# Distribution of precipitation heights
{
  Distribution_Rain_Different_Temporal_Resolutions <- data.frame(
    
    quantile_value_daily_resolution = 
      
      Weather_Data_Daily_Resolution_Without_NA_Precipitation %>%
      
      pull(rain) %>%
      
      quantile(probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1), 
               na.rm = TRUE),
    
    quantile_value_monthly_resolution = 
      
      Weather_Data_Monthly_Resolution_Without_NA_Precipitation %>%
      
      pull(monthly_total_rain) %>%
      
      quantile(probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1), 
               na.rm = TRUE),
    
    quantile_value_annual_resolution = 
      
      Weather_Data_Annual_Resolution_Without_NA_Precipitation %>%
      
      pull(annual_total_rain) %>%
      
      quantile(probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1),
               na.rm = TRUE))
}

# Distribution of daily precpitation height
Distribution_Extreme_Precipitation_Heights = 
  
  Extreme_Precipitation_Heights_Daily_Resolution %>% 
  
  pull(rain) %>%
  
  quantile(probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1),
           na.rm = TRUE) %>%
  
  data.frame(quantile_values = .) %>%
  
  mutate(quantiles = rownames(.),
         .before = quantile_values) %>%
  
  `row.names<-`(NULL)





