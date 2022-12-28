# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
{
library(here)
source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
source(here("Scripts","Data-Manipulation","Share-of-EPE.R"))
}

MonthlyAverageExtremePrecipitation$MonthOfYear = paste0(MonthlyAverageExtremePrecipitation$year,
                                                        "-",
                                                        MonthlyAverageExtremePrecipitation$month)

MonthlyAverageExtremePrecipitation = MonthlyAverageExtremePrecipitation[order(MonthlyAverageExtremePrecipitation$year,
                                                                              MonthlyAverageExtremePrecipitation$month),]

rownames(MonthlyAverageExtremePrecipitation) = NULL

# Number of NA values in the column of monthly mean precipitation
sum(is.na(MonthlyAverageExtremePrecipitation$ShareOfExtremePrecipitationEvents))

str(MonthlyAverageExtremePrecipitation)

# Preperation for the animation
season_symbols = c("Spring" = "\u1F95A",
                    "Summer" =  "\u1F31E", 
                    "Autmn" = "\u1F342",
                    "Winter" = "\u2744")

# Map of Monthly Average Precipitation Values
MonthlyAveragePrecipitationMap = ggplot(MonthlyAverageExtremePrecipitation) + 
  geom_path(data = map_data("world","Germany"),
            aes(x = long, 
                y = lat, 
                group = group)) +
  coord_fixed(xlim = c(6,15),
              ylim = c(47,55)) + 
  geom_point(aes(x=lon, 
                 y=lat, 
                 group = MonthOfYear,
                 shape = Season), 
             size = 10) + 
  scale_shape_manual(values = season_symbols, breaks = c("Spring", "Summer", "Autmn", "Winter"),
                     guide = guide_legend(override.aes = list(color = c("black", "black", "black","black")))) +
  geom_point(aes(x=lon, 
                 y=lat, 
                 group = MonthOfYear),
             colour = ifelse(test = MonthlyAverageExtremePrecipitation$Share_of_EPE > 0.3, 
                             I("red"),
                             I("blue"))) + 
  # scale_color_gradient(low="blue", high="yellow") + 
  xlab("Longitude (degree)") +
  ylab("Latitude (degree)") + 
  theme_bw() +
  transition_manual(frames = MonthOfYear) + 
  theme(legend.position = "bottom", 
        legend.title = element_text(size=12, face="bold"),
        panel.background = element_blank(),
        legend.background = element_blank()) +
  labs(title = '{unique(MonthlyAverageExtremePrecipitation$MonthOfYear)[as.integer(frame)]}', 
       color = paste0("Share of Extreme Precipitation Events \namong all Precipitation Events"),
       shape = "Season")

anim_save("Share-of-Extreme-Precipitation-Events.mp4",
          animate(
            MonthlyAveragePrecipitationMap,
            nframes = 1000,
            renderer = ffmpeg_renderer()
          ))
