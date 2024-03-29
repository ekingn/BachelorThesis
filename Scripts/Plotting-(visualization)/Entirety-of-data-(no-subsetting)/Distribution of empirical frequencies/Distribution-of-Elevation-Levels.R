# The purpose of this script is to investigate the distribution of Altitude levels of the weather stations. 

# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
# {
  library(here)
  source(here("Scripts","Session-Related","Packages.R"))
  source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
  source(here("Scripts","Functions","Individualizing-Boxplots.R"))
# }

# Compute specific quantile values for the distribution of Altitude levels 
Quantile_Values_of_Altitude <-
  
  data.frame("quantile_values" = round(x = quantile(Weather_Data_Daily_Resolution$alt,
                                                    c(0,0.05,0.25,0.5,0.75,0.95,1)),
                                       2))

# Compute the frequency of each level of Altitude within the data
Number_of_Observations_per_Altitude_Level <-
  
  data.frame(count(Weather_Data_Daily_Resolution,
                   Weather_Data_Daily_Resolution$alt)) %>% 
  
  rename(altitude = Weather_Data_Daily_Resolution.alt) %>% 
  
  round(.,
        2)

###

Histogram_of_Altitude_Levels <-
  
  Weather_Data_Daily_Resolution %>% 
  
  ggplot() +
  
  geom_histogram(aes(x = alt),
           fill = "white", 
           color = "black",
           binwidth = 50) +
  
  labs(x = "Altitude Level",
       y = "Absolute \nFrequency of\n Observations") +
  
  theme(axis.text.x = element_text(angle = 90, 
                                   vjust = 0.5, 
                                   hjust = 1,
                                   size = 18),
        axis.text.y = element_text(size = 18),
        axis.title.x = element_text(size = 20),
        axis.title.y = element_text(lineheight = 0.4,
                                    size = 20)) +
  
  scale_x_continuous(breaks = seq(from = -100,
                                  to = 3000,
                                  by = 50)) +

  scale_y_continuous(labels = function(x) format(x, 
                                                 big.mark = ",", 
                                                 scientific = FALSE))

save_plot(plot = Histogram_of_Altitude_Levels,
          path = here("Output",
                      "JPGs",
                      "Altitude"),
          filename = "Distribution-of-Altitude-Levels.JPG")

# Compute the distribution of the Altitude levels as a boxplot 
Boxplot_of_Altitude_Levels <- 
  
  Weather_Data_Daily_Resolution %>% 
  
  ggplot() + 
  
  aes(x="", 
      y=alt) + 
  
  stat_summary(fun.data = Boxplot_Quantiles, 
               geom="boxplot",
               lwd = 0.1) +
  
  stat_summary(fun.y = Determining_Outliers, 
               geom="point",
               size = 0.1) + 
  
  theme(axis.ticks.x = element_blank(),
        axis.text.y = element_text(size = 12,
                                   face = "bold"),
        axis.title.y = element_text(size = 16,
                                    face = "bold")) + 
   
  scale_y_continuous(breaks = c(seq(from=0, 
                                    to=3100, 
                                    by=100)),
                     labels=function(x) format(x, 
                                               big.mark = ",", 
                                               scientific = FALSE)) + 
  
  xlab("") + 
  
  ylab("Altitude levels") +
  
  coord_cartesian(ylim = c(0,
                           3100)) 

save_plot(plot = Boxplot_of_Altitude_Levels,
          filename = "Boxplot_of_Altitude_Levels.JPG",
          path = here("Output","JPGs","Altitude"))
