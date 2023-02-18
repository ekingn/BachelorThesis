# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
library(here)
source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Transformation-from-Daily-to-Monthly-and-Annual-Resolution.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Extract-Extreme-Precipitation-Heights-(All-Temporal-Resolutions).R"))
}

#```{r fig.cap = "\\label{fig:fig2}Histograms of the Frequencies of Precipitation for different temporal resolutions. Own representation.", include = TRUE}

# Create a histogram of the daily precipitation heights 
Histogram_of_Daily_Precipitation_Heights <-
  
  Weather_Data_Daily_Resolution %>%
  
  ggplot(aes(x = rain, 
             fill = I("white"), 
             color = I("black"))) +
  
  geom_histogram(breaks = seq(from = 0, 
                              to = 60, 
                              by = 0.5)) +
  
  labs(x = "Daily Total Precipitation Height (mm)",
       y = "Absolute\nFrequency",
       title = "Daily Resolution") +
  
  expand_limits(x = 0, 
                y = 0) +
  
  scale_x_continuous(breaks = seq(from = 0, 
                                  to = 60, 
                                  by = 5)) +
  
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", 
                                                 scientific = FALSE)) +
  
  theme(plot.title = element_text(hjust = 0.5, 
                                  face = "bold"),
        axis.text.x = element_text(angle = 90, vjust = 0.5, 
                                   hjust = 1))

# Create a histogram of the extreme daily precipitation heights 

Histogram_of_Extreme_Daily_Precipitation_Heights <- 
  
  Extreme_Precipitation_Heights_Daily_Resolution %>%
  
  ggplot(aes(x = ExtremePrecipitationHeights.rain, 
             fill = I("white"), 
             color = I("black"))) +
  
  geom_histogram(breaks = seq(from = 0, 
                              to = 60, 
                              by = 0.5)) +
  
  labs(x = "Extreme Daily Total Precipitation (mm)",
       y = "Absolute\nFrequency",
       title = "Daily Resolution") +
  
  expand_limits(x = 0, 
                y = 0) +
  
  scale_x_continuous(breaks = seq(from = 0, 
                                  to = 60, 
                                  by = 5)) +
  
  scale_y_continuous(labels = function(x) format(x, 
                                                 big.mark = ".", 
                                                 scientific = FALSE)) +
  
  theme(plot.title = element_text(hjust = 0.5, 
                                  face = "bold"),
        axis.text.x = element_text(angle = 90, 
                                   vjust = 0.5, 
                                   hjust = 1))

# Create a histogram of the monthly precipitation totals
Histogram_of_Monthly_Precipitation_Heights <-
  
  Weather_Data_Monthly_Resolution %>%
  
  ggplot(aes(x = monthly_total_rain, 
             fill = I("white"), 
             color = I("black"))) +
  
  geom_histogram(breaks = seq(from = 0, 
                              to = 300, 
                              by = 2)) +
  
  labs(x = "Monthly Total Precipitation (mm)", y = "Absolute\nFrequency",
       title = "Monthly Resolution") +
  
  expand_limits(x = 0, 
                y = 0) +
  
  scale_x_continuous(breaks = seq(from = 0, 
                                  to = 300, 
                                  by = 30)) +
  
  scale_y_continuous(labels = function(x) format(x, 
                                                 big.mark = ".", 
                                                 scientific = FALSE)) +
  
  theme(plot.title = element_text(hjust = 0.5, 
                                  face = "bold"),
        axis.text.x = element_text(angle = 90, 
                                   vjust = 0.5, 
                                   hjust = 1))

# Create a histogram of the extreme monthly precipitation totals

Histogram_of_Annual_Precipitation_Heights <- 
  
  Weather_Data_Annual_Resolution %>% 
  
  ggplot(aes(x = annual_total_rain)) +
  
  geom_histogram(fill = "white", 
                 color = "black", 
                 binwidth = 10) +
  
  xlab("Annual Total Precipitation (mm)") +
  
  ylab("Absolute\nFrequency") +
  
  scale_x_continuous(breaks = seq(0, 
                                  2200, 
                                  200)) +
  
  scale_y_continuous(labels = function(x) format(x, 
                                                 big.mark = ".", 
                                                 scientific = FALSE)) +
  
  ggtitle("Annual Resolution") +
  
  theme(plot.title = element_text(hjust = 0.5, 
                                  face = "bold"),
        axis.text.x = element_text(angle = 90, 
                                   vjust = 0.5, 
                                   hjust = 1),
        plot.margin = unit(c(1,1,1,1), 
                           "cm")) +
  
  expand_limits(x = 0, y = 0)

Plotgrid_Distribution_Precipitation = plot_grid(Histogram_of_Daily_Precipitation_Heights,
                                                Histogram_of_Monthly_Precipitation_Heights,
                                                Histogram_of_Annual_Precipitation_Heights,
                                                nrow = 1,
                                                ncol = 3,
                                                align  =  "H", 
                                                scale=1)

ggsave(plot = Plotgrid_Distribution_Precipitation,
       filename = "Precipitation-Totals-Distribution-All-Resolution.JPG",
       path = here("Output","JPGs","Distribution-Precipitation"),
       scale = 1,
       dpi = "retina")
