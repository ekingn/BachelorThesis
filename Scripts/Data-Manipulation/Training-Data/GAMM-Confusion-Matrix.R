# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it: 
{
  library(here)
  source(here("Scripts","Session-Related","Packages.R"))
  # source(here("Scripts","Regression",,"Training-a-Generalized-Additive-Mixed-Model.R"))
}

# Load the Result of the script at here("Scripts","Regression",,"Training-a-Generalized-Additive-Mixed-Model.R") 
# as a shortcut to this script. It takes several hours to execute 
# source(here("Scripts","Regression",,"Training-a-Generalized-Additive-Mixed-Model.R")).
load(here("Output","RData","Trained-GAMM.RData"))



# Add the estimated probabilities to the weather data dataframe
Weather_NoNA_1996_2000 <- 
  
  Weather_NoNA_1996_2000 %>% 
  
  mutate(predicted_probability = predicted_probabilities %>% pull(.))



# Derive the classification decision by superimposing a threshold layer as 
# described in the markdown file 
Weather_NoNA_1996_2000 <- 
  
  Weather_NoNA_1996_2000 %>% 
  
  mutate(generated_classification = as.numeric(ifelse(predicted_probabilities > 0.01,
                                            1,
                                            0)))


# Constructing the confusion matrix
Confusion_Matrix <-
  
  data.frame("Predicted_Negative" = c(sum(Weather_NoNA_1996_2000$generated_classification == 0 & Weather_NoNA_1996_2000$EPE == 0),
                                      sum(Weather_NoNA_1996_2000$generated_classification == 0 & Weather_NoNA_1996_2000$EPE == 1)),
             "Predicted_Positive" = c(sum(Weather_NoNA_1996_2000$generated_classification == 1 & Weather_NoNA_1996_2000$EPE == 0),
                                      sum(Weather_NoNA_1996_2000$generated_classification == 1 & Weather_NoNA_1996_2000$EPE == 1))) 

# Changing rownames 
rownames(Confusion_Matrix) <- 
  
  c("Negative by S.o.T.","Positive by S.o.T.")

# Creating a formatted duplicate of the confusion matrix
Confusion_Matrix_Formatted <- 
  
  Confusion_Matrix %>% 
  
  mutate(`Predicted_Negative` = format(`Predicted_Negative`, big.mark = ","),
         `Predicted_Positive` = format(`Predicted_Positive`, big.mark = ",")) %>% 
  
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

save.image(here("Output","RData","Trained-GAMM.RData"))
