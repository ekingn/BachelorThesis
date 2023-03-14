{
  library(here)
  source(here("Scripts","Session-Related","Packages.R"))
}

# Load the data
load(here("Input","Data","WeatherGermany.rda"))

# Rename data 
Weather_Data_Daily_Resolution <- 
  
  WeatherGermany %>% 
  
  rename("mean_temperature" = "T",
         "minimum_temperature" = "Tmin", 
         "maximum_temperature" = "Tmax")

rm(WeatherGermany)

# Perform several steps of data manipulation:
# - filter the data temporally to observations made between 1976 and 2016 
# - create a new "index" column and use it to substitute the existing "id" column
# - order the data increasingly 
Weather_Data_Daily_Resolution <- 
  
  filter(Weather_Data_Daily_Resolution, 
         year %in% 1996:2012) %>% 
  
  mutate(index = as.numeric(as.factor(name)),
         .before = id) %>% 
  
  select(-id,
         -quality) %>% 
  
  arrange(name,
          year,
          month,
          day) %>% 
  
  select(index,
         name,
         year,
         month,
         day,
         everything())

# Create an overview of unique tupels of "index", "name", "lat" and "lon" as dataframe for later use.
Index_Lat_Lon <- 
  
  Weather_Data_Daily_Resolution %>%
  
  select(c(index,
           name,
           lat, 
           lon)) %>% 
  
  unique() %>% 
  
  `rownames<-`(NULL)


# Substitute all values "-999" as NAs, since this number is indeed code for not available
Weather_Data_Daily_Resolution <- Weather_Data_Daily_Resolution %>%
  
  mutate(across(where(is.numeric), 
                ~na_if(., -999)))

# For each weather station, count how many rows in the data are  no value for precipitation height 
{
  Count_of_NA_Precipitation <- Weather_Data_Daily_Resolution %>%
    
    group_by(name) %>%
    
    dplyr::summarize(frequency_of_na = sum(is.na(rain)),
                     total_number_observations = n()) %>%
    
    mutate(no_values = ifelse(frequency_of_na == total_number_observations,
                              "Yes",
                              "No"))
  }

# For each weather station, count how many rows in the data have no value for mean temperature 
{
  Count_of_NA_Mean_Temperature <- 
    
    Weather_Data_Daily_Resolution %>%     
    
    group_by(name) %>%
    
    dplyr::summarize(frequency_of_na = sum(is.na(mean_temperature)),
                     total_number_observations = n()) %>% 
    
    mutate(no_values = ifelse(frequency_of_na == total_number_observations,
                              "Yes",
                              "No"))
}

# Drop all weather stations from the data, for which no observations of precipitation height are available 
Weather_Data_Daily_Resolution <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(!(name %in% c(filter(Count_of_NA_Precipitation,
                              no_values == "Yes")$name)))

# Count the number of observations of daily resolution each weather station made
Number_of_Observations_per_Weather_Station <- 
  
  data.frame(dplyr::count(Weather_Data_Daily_Resolution,
                          index))

# Compute the temporal coverage of the pooled data
Range_of_Temporal_Coverage <- 
  
  max(Weather_Data_Daily_Resolution$year,na.rm = TRUE) - min(Weather_Data_Daily_Resolution$year,na.rm = TRUE)

# Compute the empirical distribution of the number of observations
{
  Distribution_Number_of_Observations <- 
    
    Number_of_Observations_per_Weather_Station %>% 
    
    summary()
  }                                 

# Prepare the threshold values, based on whom observed precipitation events will be classified as either extreme or none-extreme precipitation events.
# For this analysis, a precipitation event is classified as extreme, if it exceed the typical total precipitation of the calendar month it belongs to.
{
  # Group the daily precipitation data by weather station, year and month and then 
  # sum the daily precipitation totals within each group. 
  
  Weather_Data_Monthly_Resolution <- 
    
    Weather_Data_Daily_Resolution %>% filter(!is.na(rain)) %>% 
    
    group_by(index,
             year,
             month) %>% 
    
    summarise(monthly_total_precipitation = sum(rain),
              n = n()) %>% 
    
    ungroup()
}  

# Compute the thresholds for the classification of an PE as an EPE based on the concept mentioned above
{
  # Group the daily precipitation totals by weather station (indexnumber) and month. 
  # Then Compute the average monthly precipitation total within each group.
  # This average monthly precipitation of a specific weatherstation 
  # in a specific month across all years shall serve as classification threshold.
  Monthly_Mean_Precipitation_Across_All_Years <- Weather_Data_Monthly_Resolution %>%
    group_by(index,
             month) %>% 
    
    dplyr::summarize(monthly_mean_precipitation = mean(monthly_total_precipitation),
                     days = n()) %>% 
    
    ungroup()
}

# Create a new variable that indicates the true classification decisions
{
  # Create a column whose values indicate, whether an observed precipitation event is extreme or not 
  Weather_Data_Daily_Resolution <- Weather_Data_Daily_Resolution %>% 
    
    left_join(select(Monthly_Mean_Precipitation_Across_All_Years,
                     -days), by = c("index", "month")) %>% 
    
    mutate(EPE = if_else(rain > monthly_mean_precipitation, 
                         1,
                         0))
}

# Create a table that recounts that contrasts the number of observations of a weather stations with its' index number
Number_of_Observations_per_Weather_Station <- dplyr::count(Weather_Data_Daily_Resolution, 
                                                           index) %>% data.frame()

# Create an ordered list of unique altitude levels 
List_of_Unique_Elevation_Levels <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  select(alt) %>% 
  
  unique() %>% 
  
  as.data.frame() %>% 
  
  rename(unique_altitude_levels = 1) %>% 
  
  `rownames<-`(NULL) %>% 
  
  arrange(unique_altitude_levels)


# Construct a calendardate column, a julian-date column and a column that shows the number of continuous days that 
# have elapsed since the earliest observation, which is the 1st of January 1996
Weather_Data_Daily_Resolution <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  mutate(calendar_date = paste0(year,"-",month,"-",day)) %>% 
  
  mutate_at(vars(calendar_date),
            as.Date) %>% 
  
  mutate(julian_date = insol::JD(as.POSIXlt(calendar_date))) %>% 
  
  mutate(days_since_earliest_observation = round(julian_date - insol::JDymd(1996,1,1,0,0),0))


# Create a column that indicates the metereological season an observation belongs to 
Weather_Data_Daily_Resolution <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  mutate("season" = case_when(
    Weather_Data_Daily_Resolution$month <=  2 | Weather_Data_Daily_Resolution$month ==  12 ~ "Winter",
    Weather_Data_Daily_Resolution$month <=  11 & Weather_Data_Daily_Resolution$month >=  9 ~ "Autumn",
    Weather_Data_Daily_Resolution$month <=  8 & Weather_Data_Daily_Resolution$month >=  6 ~ "Summer",
    Weather_Data_Daily_Resolution$month <=  5 & Weather_Data_Daily_Resolution$month >=  3 ~ "Spring"))

# Change column positions
Weather_Data_Daily_Resolution <-
  
  Weather_Data_Daily_Resolution %>% 
  
  ungroup() %>% 
  
  select(index,
         name,
         lon,
         lat,
         alt,
         year,
         month,
         day,
         calendar_date,
         julian_date,
         days_since_earliest_observation,
         yday,
         season,
         rain,
         monthly_mean_precipitation,
         EPE,
         everything()) %>% 
  
  arrange(index,
          year,
          month,
          day)


