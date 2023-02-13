# The purpose of this script is to visualize the variation of the monthly share of extreme precipitation events among all precipitation events 
# as a result of the variation of angular coordinates (spatial location at full resolution), the variation of months of the same year and the variation of years.


# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
# {
#   library(here)
#   source(here("Scripts","Session-Related","Packages.R"))
#   source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
#   source(here("Scripts","Data-Manipulation","Share-of-EPE.R"))
# }

# Map of Monthly Average Precipitation Values
Average_Monthly_Precipitation_Map = ggplot(Average_Monthly_Extreme_Precipitation) + 
  
  geom_path(data = map_data("world","Germany"),
            aes(x = long, 
                y = lat, 
                group = group)) +
  
  coord_fixed(xlim = c(6,
                       15),
              ylim = c(47,
                       55)) + 
  
  geom_point(aes(x=lon, 
                y=lat, 
                group = month_of_year), 
            colour = ifelse(test = Average_Monthly_Extreme_Precipitation$share_of_EPE > 0.3,
                           I("Red"),
                           I("Blue")),
            size = ifelse(test = Average_Monthly_Extreme_Precipitation$share_of_EPE > 0.3,
                          8,
                          3)) + 

  xlab("Longitude (degree)") +
  
  ylab("Latitude (degree)") + 
  
  theme_bw() +
  
  theme(legend.position = "bottom", 
        legend.title = element_text(size=12, face="bold"),
        panel.background = element_blank(),
        legend.background = element_blank(),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0))) +
  
  transition_manual(frames = month_of_year) + 
  
  labs(title = '{unique(Average_Monthly_Extreme_Precipitation$month_of_year)[as.integer(frame)]}', 
       colour = paste0("Share of Extreme Precipitation Events \namong all Precipitation Events"))

anim_save(filename = "Share-of-Extreme-Precipitation-Events.mp4",
          path = here("Output","Animations","EPE"),
          animate(
            Average_Monthly_Precipitation_Map,
            nframes = 1000,
            renderer = ffmpeg_renderer()
          ))

