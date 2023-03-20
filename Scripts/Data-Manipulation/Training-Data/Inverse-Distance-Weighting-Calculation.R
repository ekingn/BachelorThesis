# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
library(here)
source(here("Scripts","Session-Related","Packages.R"))
source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
}

  
  
{
Weather_NoNA <-
  
  Weather_Data_Daily_Resolution %>% 

  rename(Julian = days_since_earliest_observation) %>% 
  
  filter(!is.na(rain)) 
}

  
  
{
  spatial_indices <- 
    
    unique(Weather_NoNA$index)
  
  temporal_indices <- 
    
    unique(Weather_NoNA$Julian)
  
  # The expand.grid() function creates a dataframe from all possible combinations
  # of the supplied vectors/columns. 
  grid <- 
    
    expand.grid(index = spatial_indices,
                Julian = temporal_indices) %>% 
    
    left_join(Index_Lat_Lon %>%
                select(index, lon),
              by = c("index" = "index")) %>% 
    
    left_join(Index_Lat_Lon %>% select(index, lat),
              by = c("index" = "index")) 
}
grid <- 
    
    grid %>% 
    
    left_join(Weather_NoNA %>% select(index, 
                                    Julian,
                                    season),
              by = c("index" = "index",
                     "Julian" = "Julian")) 
    

Weather_NoNA_IDW_Interpolated <-
  
  idw(formula = rain ~ 1,
      locations = ~ lon + lat + Julian,
      data = Weather_NoNA,
      newdata = grid,
      idp = 2)

save.image(file = here("Output","RData","IDW-Without-Confusion-Matrix.RData"))

Weather_NoNA_IDW_Interpolated <-

  Weather_NoNA_IDW_Interpolated %>%

  left_join(Weather_NoNA %>% select(lat,
                                    lon,
                                    Julian,
                                    monthly_mean_precipitation),
            by = c("lat" = "lat",
                   "lon" = "lon",
                   "Julian" = "Julian"))

Weather_NoNA_IDW_Interpolated <-
  
  Weather_NoNA_IDW_Interpolated %>% 
  
  filter(!is.na(monthly_mean_precipitation)) %>% 
  
  rename(predicted_rain = var1.pred) %>% 
  
  mutate(generated_classification = ifelse(predicted_rain > monthly_mean_precipitation,
                                           1,
                                           0))
Confusion_Matrix <-
  
  Weather_NoNA %>% 
  
  select(lon,
         lat,
         Julian,
         EPE) %>% 
  
  left_join(Weather_NoNA_IDW_Interpolated %>% select(lon, 
                                                     lat, 
                                                     Julian,
                                                     generated_classification),
            by = c("lon" = "lon",
                   "lat" = "lat",
                   "Julian" = "Julian")) %>% 
  
  select(EPE,
         generated_classification) %>% 
  
  count(EPE,
        generated_classification) %>% 
  
  pivot_wider(names_from = generated_classification, 
              values_from = n, 
              values_fill = 0) %>%
  
  rename("True Class" = EPE, 
         "Predicted Negative" = `0`, 
         "Predicted Positive" = `1`) %>%
  
  column_to_rownames(var = "True Class") %>%
  
  `rownames<-`(c("Negative by S.o.T.",
                 "Positive by S.o.T."))

Confusion_Matrix_Formatted <- 
  
  Confusion_Matrix %>% 
  
  mutate(`Predicted Negative` = format(`Predicted Negative`, big.mark = ","),
         `Predicted Positive` = format(`Predicted Positive`, big.mark = ",")) %>% 
  
  as.data.frame()

# Calculation of the performance indicators

{
  # Measuring the Precision of the classifier model
  Precision <-
    
    (as.numeric(Confusion_Matrix[2,2]))/(as.numeric((Confusion_Matrix[2,2])) + as.numeric((Confusion_Matrix[1,2])))
  
  # Measuring the Sensitivity of the classifier model 
  Sensitivity <- 
    
    (as.numeric((Confusion_Matrix[2,2])))/(as.numeric((Confusion_Matrix[2,2])) + as.numeric((Confusion_Matrix[2,1])))
  
  # Measuring the Specificity of the classifier model
  Specificity <- 
    
    (as.numeric(Confusion_Matrix[1,1]))/(as.numeric(Confusion_Matrix[1,1]) + as.numeric(Confusion_Matrix[1,2]))
  
  # Measuring the False Negative Rate of the classifier model 
  False_Positive_Rate <-
    
    1 - Specificity
  
  # Measuring the False Positive Rate of the classifier model
  False_Negative_Rate <- 
    
    1 - Sensitivity

}

save.image(file = here("Output","RData","IDW-With-Confusion-Matrix.RData"))
  