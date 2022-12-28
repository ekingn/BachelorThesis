WeatherDataDailyResolution1996 = filter(WeatherDataDailyResolution,
                                        year == 1996,
                                        Season == "Winter",
                                        month == 12)

SpatialMapOfPrecipitationAlongTime = function(ribbit) {
  WeatherDataDailyResolutionSub = filter(WeatherDataDailyResolution1996,
                                         ContinuousDaysElapsedSinceEarliestObservation == ribbit)
  ggplot(WeatherDataDailyResolutionSub) + 
    geom_point(aes(x = lon, y = lat, colour = rain), size = 4) + 
    labs(colour = "Precipitation Height in millimetre (mm)") + 
    theme_bw()
}

RangeOfTemporalCoverageInDays = range(WeatherDataDailyResolution1996$ContinuousDaysElapsedSinceEarliestObservation)

gen_anim = function() {
  for(ContinuousDaysElapsedSinceEarliestObservation in RangeOfTemporalCoverageInDays[1]:RangeOfTemporalCoverageInDays[2]) {
    plot(SpatialMapOfPrecipitationAlongTime(ContinuousDaysElapsedSinceEarliestObservation))
  }
}

ani.options(interval = 0.01)

saveHTML(gen_anim(),
         autoplay = TRUE,
         loop = FALSE,
         verbose = FALSE,
         outdir = ".",
         single.opts = "'controls': ['first','previous','play','next',
         'last', 'loop', 'speed']
         , 'delayMin': 0]",
         htmlfile = "PrecipitationHeight_Animation.html")

