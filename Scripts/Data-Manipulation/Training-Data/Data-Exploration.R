# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
# {
# library(here)
# source(here("Scripts","Session-Related","Packages.R"))
# source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
# }

# Exploring the data per empirical spatial and temporal means as well as covariances 

## Compute and plot the empirical spatial means: The average precipiation height at each spatial location.
## A spatial location is determined as a unique combination of angular coordinates, longitudinal and latitudinal degrees.

Spatial_Means <-
  
  Weather_Data_Daily_Resolution %>% 
  
  filter(!is.na(rain)) %>%
  
  group_by(lat,
           lon) %>% 
  
  summarise("mean_rain" = mean(rain),
            n = n()) %>% 
  
  ungroup()


Latitudinal_Means_of_Precipitation <-
  
  Spatial_Means %>% 
  
  ggplot(data = .) + 
  
  geom_point(aes(x = lat,
                 y = mean_rain),
             size = 0.1) +
  
  labs(title = "Latitudinal Means of Precipitation Height Across Time", 
       x = "Latitude (degree)", 
       y = paste0("Mean Precipitation Height Across \nAll Years and Days")) + 
  
  theme_bw() + 
  
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 20),
        axis.title.x = element_text(size = 12,
                                    vjust = -3),
        axis.title.y = element_text(size = 12,
                                    lineheight = 0.4,
                                    vjust = 3),
        axis.text.x = element_text(size = 12,
                                   face = "bold"),
        axis.text.y = element_text(size = 12,
                                   face =  "bold"),
        plot.margin = unit(c(0.25, 0.5, 0.25, 0.5), "cm")) + 
  
  scale_x_continuous(breaks = c(seq(from = 47,
                                    to = 55, 
                                    by = 0.5))) +
  
  scale_y_continuous(breaks = c(seq(from = 0,
                                    to = 8,
                                    by = 0.5)))

save_plot(filename = here("Output","JPG's","Precipitation-Means","Latitudinal-Means-of-Precipitation.JPG"),
          plot = Latitudinal_Means_of_Precipitation)


Longitudinal_Means_of_Precipitation <-
  
  Spatial_Means %>% 
  
  ggplot(.) +
  
  geom_point(aes(x = lon,
                 y = mean_rain),
             size = 0.1) + 
  
  labs(title = "Distribution of Annual Averages of Precipitation",
       x = "Longitude (degree)",
       y = "Annual Mean Precipitation Height") + 
  
  theme_bw() +
  
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 20,
                                  face = "bold"),
        axis.title.x = element_text(size = 14,
                                    vjust = 3),
        axis.title.y = element_text(size = 14,
                                    lineheight = 0.4,
                                    vjust = 3),
        axis.text.x = element_text(size = 12,
                                   face = "bold"),
        axis.text.y = element_text(size = 12,
                                   face =  "bold"),
        plot.margin = unit(c(0.25, 0.5, 0.25, 0.5), "cm")) +
  
  scale_x_continuous(breaks = c(seq(from = 6,
                                    to = 15,
                                    by = 0.5))) + 
  
  scale_y_continuous(breaks = c(seq(from = 0,
                                    to = 8,
                                    by = 0.5)))
  
save_plot(filename = here("Output","JPG's","Precipitation-Means","Longitudinal-Means-of-Precipitation.JPG"),
          plot = Longitudinal_Means_of_Precipitation)

## Compute and plot the empirical temporal means: The average precipitation height at each calendar date (unique day).
## Every calendar day constitutes a temporal location similar to how a spatial location is determined by a unique pair of angular coordinates. 

Monthly_Means <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  ungroup() %>% 
  
  filter(!is.na(rain)) %>% 
  
  group_by(month) %>% 
  
  summarise(monthly_mean_rain = mean(rain)) %>% 
  
  ungroup()

Monthly_Means_Plot = ggplot(Monthly_Means) + 
  
  geom_point(data = Monthly_Means,
             aes(x = month, 
                 y = monthly_mean_rain),
             size = 0.5) +
  
  labs(title = "Monthly Mean Precipitation Height",
       x = "Month",
       y = "Mean Precipitation Height \nAcross All Weather Stations") + 
  
  theme_bw() + 
  
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 20),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12,
                                    lineheight = 0.4),
        axis.text.x = element_text(size = 12,
                                   face = "bold"),
        axis.text.y = element_text(size = 12,
                                   face =  "bold"),
        plot.margin = unit(c(0.25, 0.5, 0.25, 0.5), "cm")) +
  
  scale_x_continuous(breaks = c(seq(from = 1,
                                    to = 12,
                                    by = 1))) + 
  
  geom_text(data = Monthly_Means,
            aes(x = month,
                y = monthly_mean_rain),
            label = round(Monthly_Means$monthly_mean_rain, 
                          2),
            nudge_y = 0.03)


save_plot(file = here("Output","JPG's","Precipitation-Means","Monthly-Mean-Precipitation.JPG"),
          plot = Monthly_Means_Plot)


Annual_Means <-
  
  Weather_Data_Daily_Resolution %>% 
  
  ungroup() %>% 
  
  filter(!is.na(rain)) %>% 
  
  group_by(year) %>% 
  
  summarise(annual_mean_rain = mean(rain))


Annual_Means_Plot <-
  
  Annual_Means %>% 
  
  ggplot() + 
  
  geom_point(aes(x = year, 
                 y = annual_mean_rain),
             size = 0.5) +
  
  labs(title = "Annual Mean Precipitation Height",
       x = "Year",
       y = "Mean Precipitation Height \nAcross All Weather Stations") + 
  
  theme_bw() + 
  
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 20),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12,
                                    lineheight = 0.4),
        axis.text.x = element_text(size = 12,
                                   face = "bold"),
        axis.text.y = element_text(size = 12,
                                   face =  "bold"),
        plot.margin = unit(c(0.25, 0.5, 0.25, 0.5), "cm")) +
  
  scale_x_continuous(breaks = c(seq(from = 1996,
                                to = 2016,
                                by = 1))) + 
  
  geom_text(aes(x = year,
                y = annual_mean_rain),
            label = round(Annual_Means$annual_mean_rain, 
                          2),
            nudge_y = 0.03) 

  
save_plot(file = here("Output","JPG's","Precipitation-Means","Annual-Mean-Precipitation.JPG"),
          plot = Annual_Means_Plot)

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
             size = 0.5) +
  
  labs(title = "Seasonal Mean Precipitation Height",
       x = "Season",
       y = "Mean Precipitation Height \nAcross All Weather Stations") + 
  
  theme_bw() + 
  
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 20,
                                  face = "bold"),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14,
                                    lineheight = 0.4),
        axis.text.x = element_text(size = 12,
                                   face = "bold"),
        axis.text.y = element_text(size = 12,
                                   face =  "bold"),
        plot.margin = unit(c(0.25, 0.5, 0.25, 0.5), "cm")) +
  
  scale_x_discrete() + 
  
  scale_y_continuous(breaks = c(seq(from = 0,
                                    to = 3,
                                    by = 0.25))) + 
  
  geom_text(aes(x = season,
                y = seasonal_mean_rain),
            label = round(Seasonal_Means$seasonal_mean_rain, 
                          2),
            nudge_y = 0.03) 


save_plot(file = here("Output","JPG's","Precipitation-Means","Seasonal-Mean-Precipitation.JPG"),
          plot = Seasonal_Means_Plot)


