# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
{
# library(here)
# source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
}

Seasonal_Means <-
  
  Weather_Data_Daily_Resolution %>% 
  
  ungroup() %>% 
  
  filter(!is.na(rain)) %>% 
  
  group_by(season) %>% 
  
  summarise(seasonal_mean_rain = mean(rain)) %>% 
  
  ungroup() 

Seasonal_Means_Plot <-
  
  Seasonal_Means %>% 
  
  ggplot() + 
  
  geom_point(aes(x = season,
                 y = seasonal_mean_rain),
             size = 1) +
  
  labs(x = "Season",
       y = "Mean Precipitation Height \nAcross All Weather Stations",
       caption = "") + 
  
  theme_bw() + 
  
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 14,
                                  face = "bold"),
        axis.title.x = element_text(size = 14,
                                    face = "bold"),
        axis.title.y = element_text(size = 14,
                                    face = "bold",
                                    lineheight = 0.5),
        axis.text.x = element_text(size = 12,
                                   face = "bold"),
        axis.text.y = element_text(size = 12,
                                   face =  "bold",
                                   lineheight = 0.8),
        plot.margin = unit(c(0.25, 0.5, 0.25, 0.5), "cm")) +
   
  scale_x_discrete() + 
  
  scale_y_continuous(breaks = c(seq(from = 0,
                                    to = 3,
                                    by = 0.25))) + 
  
  geom_text(aes(x = season,
                y = seasonal_mean_rain),
            label = round(Seasonal_Means$seasonal_mean_rain, 
                          2),
            nudge_y = 0.03,
            size = 4)


ggsave(plot = Seasonal_Means_Plot,
       filename = "Seasonal-Mean-Precipitation.JPG",
       path = here("Output","JPGs","Precipitation-Means"),
       width = 4,
       height = 2)
