# If this code is to be executed isolatedly, as a prerequisite de-comment the following code and execute it:
# {
#   library(here)
#   source(here("Scripts","Session-Related","Packages.R"))
#   source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
#   source(here("Scripts","Data-Manipulation","Training-Data","Temporal-Distances.R"))
# }

# The purpose of this script is the creation of a dataframe, that contains
# the boundaries of the intervals of spatial distances. 
# This dataframe aids the computation of the spatio-temporal covariances

Intervals_of_Temporal_Distance <- 
  
  Intervals_of_Temporal_Distance %>%
  
  mutate(lower = str_extract(temporal_interval, "(?<=\\[|\\()[^,]+"),
         upper = str_extract(temporal_interval, "[^,]+(?=\\]|\\))")) %>%
  
  mutate(lower = as.numeric(lower),
         upper = as.numeric(upper)) %>% 
  
  mutate(index_dtemporal = seq(from = 1,
                              to = nrow(Intervals_of_Temporal_Distance),
                              by = 1))
