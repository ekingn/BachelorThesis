# Compute specific quantile values for the distribution of elevation levels 
QuantileValuesOfElevation = data.frame("QuantileValues" = round(x= quantile(WeatherDataDailyResolution$alt, c(0,0.05,0.25,0.5,0.75,0.95,1)), 2))

# Compute the frequency of each level of elevation within the data
NumberOfObservationsPerElevationLevel = 
  data.frame(count(WeatherDataDailyResolution,WeatherDataDailyResolution$alt))
colnames(NumberOfObservationsPerElevationLevel) = c("LevelOfElevation(alt)","Frequency")

# Visualize the distribution of the elevation levels as a barplot
PlotAsBarsFrequencyOfElevationLevels = qplot(x = WeatherDataDailyResolution$alt, 
                                             fill = I("white"), color = I("black"), 
                                             xlab = "Elevation Level",
                                             ylab = paste0("Absolute\nFrequency"),
                                             breaks = c(seq(from=0, to=3000, by = 50 )),
                                             main = "Frequency of Elevation Levels") + expand_limits(x=0, y=0) + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  scale_x_continuous(breaks = c(seq(from=-10, to=3000, by=50))) + 
  scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))

# Compute the distribution of the elevation levels as a boxplot 
BoxplotOfElevationLevels = ggplot(data = WeatherDataDailyResolution) + aes(x="", y=alt) + stat_summary(fun.data = IndividualizedBoxplotQuantiles, geom="boxplot") +
  stat_summary(fun.y = DefinitionOfOutliers, geom="point") + 
  ggtitle("A boxplot of the elevation levels") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_y_continuous(breaks = c(seq(from=0, to=3100, by=100)) ,labels=function(x) format(x, big.mark = ".", scientific = FALSE)) + 
  xlab("") + 
  ylab("Elevation levels") +
  coord_cartesian(ylim = c(0,3100)) 

# Print the boxplot of the elevation levels
BoxplotOfElevationLevels

# Give a summary of the elevation levels 
summary(WeatherDataDailyResolution$alt