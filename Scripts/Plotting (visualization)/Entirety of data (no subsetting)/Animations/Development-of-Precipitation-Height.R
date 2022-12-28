# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
# {
  # library(here)
  # source(here("Scripts","Session-Related","Packages.R"))
  # source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
  # source(here("Scripts","Data-Manipulation","Average-Monthly-Precipitation-Heights.R"))
# }

AverageMonthlyPrecipitation$MonthOfYear = paste0(AverageMonthlyPrecipitation$year,
                                                 "-",
                                                 AverageMonthlyPrecipitation$month)

AverageMonthlyPrecipitation = AverageMonthlyPrecipitation[order(AverageMonthlyPrecipitation$year,
                                                                AverageMonthlyPrecipitation$month),]

rownames(AverageMonthlyPrecipitation) = NULL

# Number of NA values in the column of monthly mean precipitation
sum(is.na(AverageMonthlyPrecipitation$MonthlyAverageRain))


# Map of Monthly Average Precipitation Values
MonthlyAveragePrecipitationMap = ggplot(AverageMonthlyPrecipitation) + 
  geom_path(data = map_data("world","Germany"),
            aes(x = long, y = lat, group = group)) +
  coord_fixed(xlim = c(6,15),
              ylim = c(47,55)) + 
  geom_point(aes(x=lon, y=lat, 
                 colour = MonthlyAverageRain,
                 group = MonthOfYear,
                 alpha = ifelse(MonthlyAverageRain >= 5, 1, 0)),
             size = 3,
             ) + 
  xlab("Longitude (degree)") +
  ylab("Latitude (degree)") + 
  theme_bw() +
  scale_color_gradient(low="blue", high="red", limits = c(0,12)) +
  transition_manual(frames = MonthOfYear) + 
  labs(title = '{unique(AverageMonthlyPrecipitation$MonthOfYear)[as.integer(frame)]}', 
       color = paste0("Monthly Average of \nDaily Averages of Precipitation \nin millimetre (mm)")) 

animate(MonthlyAveragePrecipitationMap, 
        renderer = 
          ffmpeg_renderer(
            format = "auto",
            ffmpeg = NULL,
            options = list(pix_fmt = "yuv420p")
        ),
        nframes = 1500,
        width = 640,
        height = 480)

