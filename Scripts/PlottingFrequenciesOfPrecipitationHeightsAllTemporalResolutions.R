# Create scatter-plots for Daily Temporal Resolution
{
PlotAsPointsFrequencyOfExtremeRainDailyResolution = qplot(x = NumberOfObservationsPerExtremePrecipitationHeightDailyResolution$`PrecipitationHeight`, 
                                   y = NumberOfObservationsPerExtremePrecipitationHeightDailyResolution$Frequency,
                                   xlab = "Extreme Precipitation Height",
                                   ylab = "Frequency",
                                   main = "Frequencies of Extreme Precipitation (daily)")

PlotAsPointsFrequencyOfRainDailyResolution = qplot(x = NumberOfObservationsPerPrecipitationHeightDailyResolution$'PrecipitationHeight',
                            y = NumberOfObservationsPerPrecipitationHeightDailyResolution$Frequency,
                            xlab = "Precipitation Height",
                            ylab = "Frequency",
                            main = "Frequencies of Precipitation (daily)") 
}

# Create scatter-plots for Monthly Temporal Resolution 
{
PlotAsPointsFrequencyOfExtremeRainMonthlyResolution = qplot(x = NumberOfObersvationsPerExtremePrecipitationHeightMonthlyResolution$ExtremePrecipitationHeight, 
                                   y = NumberOfObersvationsPerExtremePrecipitationHeightMonthlyResolution$Frequency,
                                   xlab = "Extreme Precipitation Height",
                                   ylab = "Frequency",
                                   main = "Frequencies of Extreme Precipitation (monthly)")

PlotAsPointsFrequencyOfRainMonthlyResolution = qplot(x = NumberOfObservationsPerPrecipitationHeightMonthlyResolution$PrecipitationHeight,
                                             y = NumberOfObservationsPerPrecipitationHeightMonthlyResolution$Frequency,
                                             xlab = "Precipitation Height",
                                             ylab = "Frequency",
                                             main = "Frequencies of Precipitation (monthly)")
}

# Create scatter-plots for Annual Temporal Resolution
{
PlotAsPointsFrequencyOfExtremeRainAnnualResolution = qplot(x = NumberOfObservationsPerExtremePrecipitationHeightAnnualResolution$ExtremePrecipitationHeight, 
                                                   y = NumberOfObservationsPerExtremePrecipitationHeightAnnualResolution$Frequency,
                                                   xlab = "Extreme Precipitation Height",
                                                   ylab = "Frequency",
                                                   main = "Frequencies of Extreme Precipitation (annual)")
PlotAsPointsFrequencyOfRainAnnualResolution = qplot(x = NumberOfObservationsPerPrecipitationHeightAnnualResolution$PrecipitationHeight,
                                            y = NumberOfObservationsPerPrecipitationHeightAnnualResolution$Frequency,
                                            xlab = "Precipitation Height",
                                            ylab = "Frequency",
                                            main = "Frequencies of Precipitation (annual)")
}

# Show all the scatter-plots simultaneously 
plot_grid(PlotAsPointsFrequencyOfRainDailyResolution,
          PlotAsPointsFrequencyOfExtremeRainDailyResolution,
          PlotAsPointsFrequencyOfRainMonthlyResolution,
          PlotAsPointsFrequencyOfExtremeRainMonthlyResolution,
          PlotAsPointsFrequencyOfRainAnnualResolution,
          PlotAsPointsFrequencyOfExtremeRainAnnualResolution,
          align  =  "h",
          nrow = 3,
          ncol = 2,
          rel_widths  =  2,
          rel_heights  =  2)
