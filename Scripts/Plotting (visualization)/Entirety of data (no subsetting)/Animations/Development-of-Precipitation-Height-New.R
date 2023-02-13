# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
{
  library(here)
  source(here("Scripts","Session-Related","Packages.R"))
  source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
  source(here("Scripts","Data-Manipulation","Average-Monthly-Precipitation-Heights.R"))
}

Average_Monthly_Precipitation <-   
  
  Average_Monthly_Precipitation %>%
  
  ungroup() %>% 
  
  filter(!is.na(monthly_average_rain)) %>%
  
  mutate(month_of_year = paste0(year, "-", month)) %>%
  
  arrange(year, month)

  
Average_Monthly_Precipitation_Plot <-

ggplot(Average_Monthly_Precipitation) +  
  
  geom_path(data = map_data("world","Germany"),
            aes(x = long,
                y = lat,
                group = group)) +
  
  geom_point(aes(x=lon, y=lat, 
                 group = month_of_year,
                 size = monthly_average_rain)) + 
  
  coord_fixed(clip = "on",
              ratio = 20/15) +
  
  labs(title = '{unique(Average_Monthly_Precipitation$month_of_year)[as.integer(frame)]}',
       x = "Longitude (degree)",
       y = "Latitude (degree)",
       color = paste0("Monthly Mean \nPrecipitation")) + 
 
  theme_bw() + 
  
  scale_size_continuous(limits = c(1, NA),
                        guide = guide_legend(title = "Monthly Mean\n Precipitation"), 
                        range = c(0,
                                  10)) +
  
  transition_manual(frames = month_of_year) + 
  
  theme(plot.margin = margin(t=75,
                             r=75,
                             b=75,
                             l=75),
        axis.title.x = element_text(vjust = - 10),
        axis.title.y = element_text(vjust = 10))

anim_save(filename = "Development-of-Precipitation.mp4",
          path = here("Output",
                      "Animations",
                      "All-Precipitation"),
          animate(
            Average_Monthly_Precipitation_Plot,
            nframes = 1000,
            renderer = ffmpeg_renderer(),
            height = 720,
            width = 680)
            )


