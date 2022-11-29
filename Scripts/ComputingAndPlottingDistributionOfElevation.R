summary(WeatherDataDailyResolution$alt)

NumberOfObservationsPerElevationLevel = data.frame(count(WeatherDataDailyResolution,WeatherDataDailyResolution$alt))

PlotAsBarsFrequencyOfElevationLevels = qplot(x = WeatherDataDailyResolution$alt, 
                                                 fill = I("white"), color = I("black"), 
                                                 xlab = "Elevation Level",
                                                 ylab = paste0("Absolute\nFrequency"),
                                                 breaks = seq(from=0, to=3000, by = 50 ),
                                                 main = "Frequency of Elevation Levels") + expand_limits(x=0, y=0) + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  scale_x_continuous(breaks = c(seq(from=-10, to=3000, by=50)))

PlotAsBarsFrequencyOfElevationLevels + scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))
