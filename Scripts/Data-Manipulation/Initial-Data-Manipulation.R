# Load the data
load(here("Input","Data","WeatherGermany.rda"))

# Rename data 
WeatherDataDailyResolution = WeatherGermany 
rm(WeatherGermany)

# Filter the data temporally to observations made between 1976 and 2016
WeatherDataDailyResolution = filter(WeatherDataDailyResolution, year %in% 1996:(max(WeatherDataDailyResolution$year)))

# Change format of the index column to factor/categorical
WeatherDataDailyResolution$index = as.numeric(factor(WeatherDataDailyResolution$name))

# Relocate the index column before the id column 
WeatherDataDailyResolution = WeatherDataDailyResolution %>% relocate(index,.before = id)

# Order the Data based the values of the name column in an increasing way
WeatherDataDailyResolution = WeatherDataDailyResolution[order(WeatherDataDailyResolution$name),]

# Delete the id column, as the index column is a better substitute for it 
WeatherDataDailyResolution = subset(WeatherDataDailyResolution, select = -c(id) )

# Select the columns for index number, latitudinal degree and longitudinal degree 
IndexLatLon = select(WeatherDataDailyResolution, c(index, lat, lon, name)) %>% unique()
rownames(IndexLatLon) = NULL

# reformat the id column as numeric values
# WeatherDataDailyResolution$id = as.numeric(WeatherDataDailyResolution$id)
# reformat the id column as numeric values
# WeatherDataDailyResolution$id = as.numeric(WeatherDataDailyResolution$id)
# Create a list of all unique ids of the german weather stations
# ListOfAllUniqueIDs = data.frame(unique(data.frame(WeatherDataDailyResolution$id)))

# Substitute all values "-999" as NAs, since this number is indeed code for not available
WeatherDataDailyResolution = WeatherDataDailyResolution %>%
  mutate(across(where(is.numeric), ~na_if(., -999)))

# Count the number of observations of daily resolution each weather station made
NumberOfObservationsPerWeatherStation = data.frame(dplyr::count(WeatherDataDailyResolution,
                                                                index))

# Compute the latest year of observation among all the weather stations
MaximumYear = max(WeatherDataDailyResolution$year, na.rm = TRUE)

# Compute the earliest year of observation among all the weather stations
MinimumYear = min(WeatherDataDailyResolution$year, na.rm = TRUE)

# Compute the spatial coverage among all the weather stations
RangeOfTemporalCoverage = MaximumYear - MinimumYear

# Compute the empirical distribution of the number of observations, meaning the 4 quartiles 
{
  DistributionNumberOfObservations = summary(NumberOfObservationsPerWeatherStation$n)
}

# Compute the boundaries for the classification of an PE as an EPE in terms of the 5th and 95th percentile of precipitation height
{
  ExtremePrecipitationClassificationBoundariesDailyResolution = data.frame("ClassificationBoundaries"= quantile(WeatherDataDailyResolution$rain,probs = c(0.05,0.95),na.rm = TRUE))
}

# Create a new variable that indicates the occurence of an EPE based on the arbitrary boundaries from above and the data on precipitation heigt
{
  WeatherDataDailyResolution = 
    WeatherDataDailyResolution %>% mutate(ExtremePrecipitationEvent = 
                                            case_when(WeatherDataDailyResolution$rain >= ExtremePrecipitationClassificationBoundariesDailyResolution[2,1]  ~ 1,
                                                      WeatherDataDailyResolution$rain >= ExtremePrecipitationClassificationBoundariesDailyResolution[1,1] & WeatherDataDailyResolution$rain < ExtremePrecipitationClassificationBoundariesDailyResolution[2,1] ~ 0))
}

# Create a table that recounts that contrasts the number of observations of a weather stations with its' index number
NumberOfObservationsPerWeatherStation = data.frame(dplyr::count(WeatherDataDailyResolution, index))

# Create an ordered list of unique altitude levels 
ListOfUniqueElevationLevels = data.frame("UniqueAltitudeLevels" = unique(WeatherDataDailyResolution$alt))
ListOfUniqueElevationLevels = data.frame("UniqueAltitudeLevels" = ListOfUniqueElevationLevels[order(ListOfUniqueElevationLevels$UniqueAltitudeLevels),])

# Construct a calendardate column
WeatherDataDailyResolution$CalendarDate = paste0(WeatherDataDailyResolution$year,
                                                 "-",
                                                 WeatherDataDailyResolution$month,
                                                 "-",
                                                 WeatherDataDailyResolution$day) 

# Change type of calendardate column from character to date format
WeatherDataDailyResolution$CalendarDate = as.Date(WeatherDataDailyResolution$CalendarDate)

# Create a column whose values depict the number of continuous days elapsed since 1st of January 4713 BC (Begin of Julian Periode)
WeatherDataDailyResolution$JulianDate = insol::JD(as.POSIXlt(WeatherDataDailyResolution$CalendarDate))

# Create a column whose values depict the number of continuous days elapsed since the 1st of January 1936 (earliest time of observation in the present metereological data)
WeatherDataDailyResolution$ContinuousDaysElapsedSinceEarliestObservation = 
  round(insol::JD(as.POSIXlt(WeatherDataDailyResolution$CalendarDate))-insol::JDymd(1996,1,1,0,0),0)

# Create a column that indicates the metereological season an observation belongs to 
WeatherDataDailyResolution = WeatherDataDailyResolution %>% 
  mutate("Season" = case_when(
    WeatherDataDailyResolution$month <=  2 | WeatherDataDailyResolution$month ==  12 ~ "Winter",
    WeatherDataDailyResolution$month <=  11 & WeatherDataDailyResolution$month >=  9 ~ "Autumn",
    WeatherDataDailyResolution$month <=  8 & WeatherDataDailyResolution$month >=  6 ~ "Summer",
    WeatherDataDailyResolution$month <=  5 & WeatherDataDailyResolution$month >=  3 ~ "Spring"))


# Create a data frame of class "spacetime: STIDF (Space Time Irregular Data Frame)"
WeatherDataDailyResolutionSpaceTime = stConstruct(x = WeatherDataDailyResolution,
                                                  space = c("lon","lat"),
                                                  time = "CalendarDate")

save.image(here("Output","RData","InitialData.RData"))