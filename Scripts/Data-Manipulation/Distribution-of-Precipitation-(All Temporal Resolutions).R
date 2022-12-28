# Daily Temporal Resolution
{
  # Create a list of all unique precipitation heights for daily temporal resolution 
  ListOfAllPrecipitationHeightsDailyResolution = data.frame("PrecipitationHeights" = unique(WeatherDataDailyResolution$rain))
  
  # Count the frequencies of all the unique precipitation heights in the data for daily temporal resolution
  NumberOfObservationsPerPrecipitationHeightDailyResolution = data.frame(count(WeatherDataDailyResolution,WeatherDataDailyResolution$rain))
  
  # Create a list of all the unique extreme precipitation heights in the data for daily temporal resolution
  ListOfExtremePrecipitationHeightsDailyResolution = data.frame("ExtremePrecipitationHeights" = 
                                                                  unique(ExtremePrecipitationHeightsDailyResolution$ExtremePrecipitationHeightsDailyResolution.rain)) 
  
  # Count the frequencies of all the unique extreme precipitation heights in the data for daily temporal resolution
  NumberOfObservationsPerExtremePrecipitationHeightDailyResolution = data.frame(count(ExtremePrecipitationHeightsDailyResolution,ExtremePrecipitationHeights.rain))
  
  # Change the column names of the lists with frequencies of precipitation
  colnames(NumberOfObservationsPerPrecipitationHeightDailyResolution) = c("PrecipitationHeight","Frequency")
  colnames(NumberOfObservationsPerExtremePrecipitationHeightDailyResolution) = c("PrecipitationHeight","Frequency")
}

# Monthly Temporal Resolution
{
# Create a list of all unique precipitation heights for monthly temporal resolution 
ListOfAllPrecipitationHeightsMonthlyResolution = data.frame("AllPrecipitationHeights" = unique(WeatherDataMonthlyResolution$PrecipitationHeightInMillimetre))

# Count the frequencies of all the unique precipitation heights in the data for monthly temporal resolution
NumberOfObservationsPerPrecipitationHeightMonthlyResolution = data.frame(count(WeatherDataMonthlyResolution, WeatherDataMonthlyResolution$PrecipitationHeightInMillimetre))

# Create a list of all the unique extreme precipitation heights in the data for monthly temporal resolution
ListOfExtremePrecipitationHeightsMonthlyResolution = data.frame("ExtremePrecipitationHeights" = unique(ExtremePrecipitationHeightsMonthlyResolution$ExtremePrecipitationHeights.PrecipitationHeightInMillimetre))

# Count the frequencies of all the unique extreme precipitation heights in the data for monthly temporal resolution
NumberOfObersvationsPerExtremePrecipitationHeightMonthlyResolution = data.frame(count(ExtremePrecipitationHeightsMonthlyResolution,ExtremePrecipitationHeightsMonthlyResolution$ExtremePrecipitationHeights.PrecipitationHeightInMillimetre))

# Change the column names of the lists with frequencies of precipitation
colnames(NumberOfObservationsPerPrecipitationHeightMonthlyResolution) = c("PrecipitationHeight","Frequency")
colnames(NumberOfObersvationsPerExtremePrecipitationHeightMonthlyResolution) = c("ExtremePrecipitationHeight","Frequency")
}

# Annual Temporal Resolution
{
# Create a list of all unique precipitation heights for monthly temporal resolution 
ListOfAllPrecipitationHeightsAnnualResolution = data.frame("AllPrecipitationHeights" = unique(WeatherDataAnnualResolution$AnnualPrecipitationHeightInMillimetre))
  
# Count the frequencies of all the unique precipitation heights in the data for monthly temporal resolution
NumberOfObservationsPerPrecipitationHeightAnnualResolution = data.frame(count(WeatherDataAnnualResolution, WeatherDataAnnualResolution$AnnualPrecipitationHeightInMillimetre))

# Create a list of all the unique extreme precipitation heights in the data for annual temporal resolution 
ListOfExtremePrecipitationHeightsAnnualResolution = data.frame("ExtremePrecipitationHeights" = unique(ExtremePrecipitationHeightsAnnualResolution))

# Count the frequencies of all the unique precipitation heights in the data for annual temporal resolution 
NumberOfObservationsPerExtremePrecipitationHeightAnnualResolution = data.frame(count(WeatherDataAnnualResolution, WeatherDataAnnualResolution$AnnualPrecipitationHeightInMillimetre))

# Change the column names of the created data frames 
colnames(NumberOfObservationsPerPrecipitationHeightAnnualResolution) = c("PrecipitationHeight","Frequency")
colnames(NumberOfObservationsPerExtremePrecipitationHeightAnnualResolution) = c("ExtremePrecipitationHeight","Frequency")
}

# Distribution of precipitation heights: daily, monthly and annual resolution
DistributionRainDifferentTemporalResolutions = data.frame("QuantileValueDailyResolution" = quantile(WeatherDataDailyResolution$rain, probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1), na.rm = TRUE), "QuantileValueMonthlyResolution" = quantile(WeatherDataMonthlyResolution$PrecipitationHeightInMillimetre, probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1), na.rm = TRUE), "QuantileValueAnnualResolution" = quantile(WeatherDataAnnualResolution, probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1), na.rm = TRUE))

# Distribution of extreme precipitation heights: daily, monthly and annual resolution
DistributionExtremeRainDifferentTemporalResolutions = data.frame("QuantileValueDailyResolution" = quantile(ExtremePrecipitationHeightsDailyResolution$ExtremePrecipitationHeights.rain, probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1), na.rm = TRUE), "QuantileValueMonthlyResolution" = quantile(ExtremePrecipitationHeightsMonthlyResolution$ExtremePrecipitationHeights.PrecipitationHeightInMillimetre, probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1), na.rm = TRUE), "QuantileValueAnnualResolution" = quantile(ExtremePrecipitationHeightsAnnualResolution$ExtremePrecipitationHeights.AnnualPrecipitationHeightInMillimetre, probs = c(0,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1), na.rm = TRUE))

