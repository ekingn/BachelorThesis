# The purpose of this script is to investigate the empirical distributions of the daily precipitation heights,
# facetted on the calendar months. In combination with the script that investigates the classification boundaries,
# such a visualization shall aid in assessing, whether the underlying concept of defining extreme events 
# is useful.

# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
{
library(here)
source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Initial-Data-Manipulation.R"))
source(here("Scripts","Functions","Individualizing-Boxplots.R"))
source(here("Scripts","Data-Manipulation","Classification-As-EPE.R"))
}

Weather_Data_Above_99th_Percentile = Weather_Data_Daily_Resolution %>% filter(!is.na(rain)) %>% 
  group_by(month) %>% filter(rain > quantile(rain,
                                             0.99))

Weather_Data_Below_1st_Percentile = Weather_Data_Daily_Resolution %>% filter(!is.na(rain)) %>% 
  group_by(month) %>% filter(rain < quantile(rain,
                                             0.01))

Daily_Weather_Monthly_Max = Weather_Data_Daily_Resolution %>% ungroup() %>% filter(!is.na(rain)) %>% group_by(month) %>% summarise(across(.fns = max)) %>% select(month,
                                                                                                                                                                  rain)

Daily_Weather_Monthly_Min = Weather_Data_Daily_Resolution %>% ungroup() %>% filter(!is.na(rain)) %>% group_by(month) %>% summarise(across(.fns = min)) %>% select(month,
                                                                                                                                                                  rain)

Distribution_of_Precipitation_Facetted_On_Months = Weather_Data_Daily_Resolution %>% ungroup() %>% 
  
  filter(!is.na(rain)) %>% mutate(month = as.factor(month)) %>%  group_by(month) %>% 
  
  ggplot() +
  
  aes(x = month, 
      y = rain,
      group = month) + 
  
  stat_summary(fun.data = Boxplot_Quantiles, 
               geom="boxplot",
               lwd = 0.1) +
  
  stat_summary(fun = Determining_Outliers, 
               geom="point",
               size = 0.3) + 
  
  labs(title = "Distribution of Daily Precipitation Totals Based on Calendar Months",
       x = "Month",
       y = "Precipitation Height in millimetre") + 
  
  theme(plot.title = element_text(size = 20,
                                  hjust = 0.5, 
                                  face = "bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(size = 12,
                                   face = "bold"),
        axis.text.y = element_text(size = 12,
                                   face = "bold"),
        axis.title.x = element_text(size = 16,
                                    face = "bold",
                                    vjust = -3),
        axis.title.y = element_text(size = 16,
                                    face = "bold",
                                    vjust = 3)) + 
  
  scale_x_discrete(breaks = c(seq(from = 1,
                                  to = 12,
                                  by = 1))) +
  
  scale_y_continuous(breaks = c(seq(from = 0,
                                    to = 330,
                                    by = 30)),
                     labels = function(x) format(x, 
                                                 big.mark = ".",
                                                 scientific = FALSE)) + 
  geom_point(data = Weather_Data_Above_99th_Percentile,
             colour = "blue",
             size = 0.3) + 
  
  geom_text(data = Daily_Weather_Monthly_Max,
            aes(x = month,
                y = rain,
                group = month,
                label = round(rain,
                              2)),
            position = position_nudge(x = 0.15,
                                      y = 5),
            size = 3,
            colour = "blue"
  ) 

save_plot(plot = Distribution_of_Precipitation_Facetted_On_Months,
          filename = "Distribution-of-Precipitation-Facetted-On-Months.JPG",
          path = here("Output","JPG's","Classification-Related"))

