```{r fig.cap = "\\label{fig:fig2}Histograms of the Frequencies of Precipitation for different temporal resolutions. Own representation.", include = TRUE}
PlotAsBarsFrequencyOfRainDailyResolution = qplot(x = WeatherDataDailyResolution$rain, 
                                                 fill = I("white"), color = I("black"), 
                                                 xlab = "Precipitation Height",
                                                 ylab = paste0("Absolute\nFrequency"),
                                                 breaks = seq(from=0, to=60, by = 0.5 ),
                                                 main = "Daily Resolution") + expand_limits(x=0, y=0) + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  scale_x_continuous(breaks = c(seq(from=0, to=60, by=5))) + scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))
PlotAsBarsFrequencyOfExtremeRainDailyResolution = qplot(x = ExtremePrecipitationHeightsDailyResolution$ExtremePrecipitationHeights.rain,
                                                        fill = I("white"), color = I("black"),
                                                        xlab = "Extreme Precipitation Height",
                                                        ylab = paste0("Absolute\nFrequency"),
                                                        breaks = c(seq(from = 0,to = 60,by = 0.5)),
                                                        main = "Daily Resolution") + expand_limits(x=0, y=0) + theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + scale_x_continuous(breaks = c(seq(from=0, to=60, by=5))) + scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))

PlotAsBarsFrequencyOfRainMonthlyResolution = qplot(x = WeatherDataMonthlyResolution$PrecipitationHeightInMillimetre,
                                                   fill = I("white"), color = I("black"),
                                                   xlab = "Precipitation Height",
                                                   ylab = paste0("Absolute\nFrequency"),
                                                   breaks = c(seq(from = 0,to = 300,by = 2)),
                                                   main = "Monthly Resolution") + expand_limits(x=0, y=0) + theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + scale_x_continuous(breaks = c(seq(from=0, to=300, by=30))) + scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))

PlotAsBarsFrequencyOfExtremeRainMonthlyResolution = qplot(x = ExtremePrecipitationHeightsMonthlyResolution$ExtremePrecipitationHeights.PrecipitationHeightInMillimetre,
                                                          fill = I("white"), color = I("black"),
                                                          xlab = "Extreme Precipitation Height",
                                                          ylab = paste0("Absolute\nFrequency"),
                                                          breaks = c(seq(from = 0,to = 300,by = 2)),
                                                          main = "Monthly Resolution") + expand_limits(x=0, y=0) + theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + scale_x_continuous(breaks = c(seq(from=0, to=300, by=30))) + scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))

PlotAsBarsFrequencyOfRainAnnualResolution = qplot(x = WeatherDataAnnualResolution$AnnualPrecipitationHeightInMillimetre,
                                                  fill = I("white"), color = I("black"),
                                                  xlab = "Precipitation Height",
                                                  ylab = paste0("Absolute\nFrequency"),
                                                  breaks = c(seq(from=0, to=2200, by=10)),
                                                  main = "Annual Resolution") + expand_limits(x=0, y=0) + theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + scale_x_continuous(breaks = c(seq(from=0, to=2200, by=200))) + scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))

PlotAsBarsFrequencyOfExtremeRainAnnualResolution = qplot(x = ExtremePrecipitationHeightsAnnualResolution$ExtremePrecipitationHeights.AnnualPrecipitationHeightInMillimetre,
                                                         fill = I("white"), color = I("black"),
                                                         xlab = "Extreme Precipitation Height",
                                                         ylab = paste0("Absolute\nFrequency"),
                                                         breaks = c(seq(from=0, to=2200, by=20)),
                                                         main = "Annual Resolution") + expand_limits(x=0, y=0) + theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + scale_x_continuous(breaks = c(seq(from=0, to=2200, by=200))) + scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))

BarplotsOfFrequenciesOfPrecipitationHeight = plot_grid(PlotAsBarsFrequencyOfRainDailyResolution,
                                                       PlotAsBarsFrequencyOfExtremeRainDailyResolution,
                                                       PlotAsBarsFrequencyOfRainMonthlyResolution,
                                                       PlotAsBarsFrequencyOfExtremeRainMonthlyResolution,
                                                       PlotAsBarsFrequencyOfRainAnnualResolution,
                                                       PlotAsBarsFrequencyOfExtremeRainAnnualResolution,
                                                       nrow = 3,
                                                       ncol = 2,
                                                       align  =  "H", scale=1)

# Print the barplots of the frequencies of the different precipitation heights
BarplotsOfFrequenciesOfPrecipitationHeight 

# Superficially assessing possibility of poisson distribution:
# Right-steep distribution with a long upper tail
# Small median (between 0 and zero). Also small mean, that is likely influenced by a high-value outlier
summary(WeatherDataDailyResolution$rain)
```