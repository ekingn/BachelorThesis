# The purpose of this script is to investigate the empirical distributions of the classification boundaries, based
# on the definition of extreme precipitation events, whereafter a daily precipitation event is extreme, if 
# the precipitation height exceed the monthly precipitation total of the corresponding month, 
# that is typical for the respective spatial location / weather station. Visualizing 
# the empirical distributions shall aid in assessing, whether this concept of defining extreme events 
# is useful.

# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
{
library(here)
source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
source(here("Scripts","Functions","Individualizing-Boxplots.R"))
}

Monthly_Mean_Precipitation_Across_All_Years <-
  
  Monthly_Mean_Precipitation_Across_All_Years %>% 
  
  group_by(month)

Monthly_Means_Above_99th_Percentile <- 
  
  Monthly_Mean_Precipitation_Across_All_Years %>% 
  
  filter(monthly_mean_precipitation > quantile(monthly_mean_precipitation,
                                               0.99)) 

Monthly_Means_Below_1st_Percentile <- 
  
  Monthly_Mean_Precipitation_Across_All_Years %>% 
  
  filter(monthly_mean_precipitation < quantile(monthly_mean_precipitation,
                                               0.01))

Max_Mean_Precipitation <- 
  
  Monthly_Mean_Precipitation_Across_All_Years %>% 
  
  filter(monthly_mean_precipitation == max(monthly_mean_precipitation))

Min_Mean_Precipitation <- 
  
  Monthly_Mean_Precipitation_Across_All_Years %>% 
  
  filter(monthly_mean_precipitation == min(monthly_mean_precipitation))

Distribution_of_Classification_Boundaries <- 
  
  Monthly_Mean_Precipitation_Across_All_Years %>% 
  
  ungroup() %>% 
  
  mutate(month = as.factor(month)) %>% 
  
  group_by(month) %>% 
  
  ggplot() + 
  
  aes(x = month, 
      y = monthly_mean_precipitation,
      group = month) + 
  
  stat_summary(fun.data = Boxplot_Quantiles, 
               geom="boxplot",
               lwd = 0.1) +
  
  stat_summary(fun = Determining_Outliers, 
               geom="point",
               size = 0.3) + 
  
  labs(title = "Distribution of Classification Boundaries Based On Months",
       x = "Month",
       y = "Mean Precipitation") + 
  
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
  geom_point(data = Monthly_Means_Above_99th_Percentile,
             colour = "blue",
             size = 0.3) + 
  
  geom_point(data = Monthly_Means_Below_1st_Percentile,
             colour = "red",
             size = 0.3) + 
  
  geom_text(data = Max_Mean_Precipitation,
            aes(x = month,
                y = monthly_mean_precipitation,
                group = month,
                label = round(monthly_mean_precipitation,
                              2)),
            position = position_nudge(x = 0.15,
                                      y = 5),
            size = 4,
            colour = "blue"
            ) + 
  
  geom_text(data = Min_Mean_Precipitation,
            aes(x = month,
                y = monthly_mean_precipitation,
                group = month,
                label = round(monthly_mean_precipitation,
                              2)),
            position = position_nudge(x = 0.15,
                                      y = -5),
            size = 4,
            colour = "red") 

save_plot(plot = Distribution_of_Classification_Boundaries,
          filename = "Distribution_of_Classification_Boundaries.JPG",
          path = here("Output","JPG's","Classification-Related"))
