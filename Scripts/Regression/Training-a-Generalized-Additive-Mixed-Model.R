# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
  library(here)
  source(here("Scripts","Session-Related","Packages.R"))
  source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
}

# Removing the rows with NAs for precipitation
{
  Weather_NoNA <-
    
    Weather_Data_Daily_Resolution %>% 
    
    rename(Julian = days_since_earliest_observation) %>% 
    
    filter(!is.na(rain))
  
  Weather_NoNA$season <-
    
    as.factor(Weather_NoNA$season)

}

{  
  Weather_NoNA_1996_2000 <-
    
    Weather_NoNA %>% 
    
    filter(year %in% 1996:2000) %>% 
    
    select(EPE,
           alt,
           mean_temperature,
           lon,
           lat,
           Julian,
           season)
}

# Remove unnesseccary objects from the environment
{
  objects_to_keep <-
    
    c("Weather_NoNA_1996_2000")
  
  # Create a list of all objects in the environment
  all_objects <-
    
    ls()
  
  # Determine the objects to be deleted
  objects_to_be_deleted <-
    
    setdiff(all_objects, objects_to_keep)
  
  # Delete the unwanted objects
  rm(list = objects_to_be_deleted)
}

# Estimation of the GAMM 
{
  gamm_model <- gam(EPE ~ s(alt) + 
                      s(mean_temperature) + 
                      s(lon) + 
                      s(lat) + 
                      s(Julian)  + 
                      s(season, bs = "re") +
                      s(alt, by = season, bs = "fs", m = 1) + 
                      s(Julian, by = season, bs = "fs", m = 1),
                    data = Weather_NoNA_1996_2000,
                    family = binomial(link = "logit"))
}

# Extracting information from the fitted GAMM

## Summary of the trained GAMM
summary <- 
  
  summary(gamm_model)

## Returns the predicted values of the response for given predictor variables 
##(altitude, mean_temperature, longitude, latitude, Julian Date). These predictions
## are on the scale of the linear predictor, or the log-odds in other words. 

predictions <-
  
  predict(gamm_model)

## Returns the coefficients of the smooth terms. 
## The coefficients of smooth terms correspond to weights applied
## to the respective basis functions, that are utilized for constructing the
## individual smooth terms for the distinct predictors. 
## These coefficients are not directly interpretable. 
## It is better instead to plot the individual smoothterms,
## if the objective is an examination of the trained dependency
## of the log-odds on the respective predictors. 

coefs <-
  
  data.frame(coef(gamm_model))

## Returns the response of type probabilities or the output of the sigmoid-function
## applied to the log-odds.
  
predicted_probabilities <- 
  
  predict(gamm_model,
          type = "response") %>% 
  
  as.data.frame()


### Save the environment data 
save.image(here("Output","RData","Trained-GAMM.RData"))

