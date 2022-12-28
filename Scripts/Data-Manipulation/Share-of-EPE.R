# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
library(here)
source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
}

# Transformation of the WeatherData from daily to monthly resolution (summing up daily total precipitation)
MonthlyAverageExtremePrecipitation = data.frame(
  aggregate( #Compute some sort of aggregate values
    WeatherDataDailyResolution[,c("ExtremePrecipitationEvent")], #data, that is to be aggregate
    by = list #list of columns, on whose values the aggregation shall be based
    (
      WeatherDataDailyResolution$index, #First criterion of aggregation
      WeatherDataDailyResolution$year, #Second criterion of aggregation
      WeatherDataDailyResolution$month #Third criterion of aggregation
      #All the observations within the same month within the same year characterizing the same weather station are aggregated  
    ), 
    FUN = mean,
    na.action = na.omit) #aggregation is defined as computing the sum of daily values
)


# Rename the columns of the dataframe of monthly resolution data
colnames(MonthlyAverageExtremePrecipitation) = c("index","year","month","Share_of_EPE")


# Create a season variable 
MonthlyAverageExtremePrecipitation = mutate(.data = MonthlyAverageExtremePrecipitation, Season = 
                                                     case_when(
  MonthlyAverageExtremePrecipitation$month <=  2 | MonthlyAverageExtremePrecipitation$month ==  12 ~ "Winter",
  MonthlyAverageExtremePrecipitation$month <=  11 & MonthlyAverageExtremePrecipitation$month >=  9 ~ "Autumn",
  MonthlyAverageExtremePrecipitation$month <=  8 & MonthlyAverageExtremePrecipitation$month >=  6 ~ "Summer",
  MonthlyAverageExtremePrecipitation$month <=  5 & MonthlyAverageExtremePrecipitation$month >=  3 ~ "Spring"))


# Order the columns first by indexnumber, then by year and finally based on the month
MonthlyAverageExtremePrecipitation = MonthlyAverageExtremePrecipitation[order(MonthlyAverageExtremePrecipitation$`index`, 
                                                                              MonthlyAverageExtremePrecipitation$year,
                                                                              MonthlyAverageExtremePrecipitation$month),] %>% 
  mutate_if(is.numeric, ~round(., 2))

# Delete rownames
rownames(MonthlyAverageExtremePrecipitation) = NULL

MonthlyAverageExtremePrecipitation = inner_join(x = MonthlyAverageExtremePrecipitation, 
                                                y = IndexLatLon, 
                                                by = "index")
