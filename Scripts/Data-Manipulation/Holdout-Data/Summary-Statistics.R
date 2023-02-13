((Weather_Data_Daily_Resolution %>% filter(!is.na(rain)) %>% select(EPE) %>% sum()) /
  
  Weather_Data_Daily_Resolution %>% filter(!is.na(rain)) %>% nrow()) %>% scales::percent(.,accuracy = 0.00001)

Weather_Data_Daily_Resolution %>% filter(!is.na(rain)) %>% pull(monthly_mean_precipitation) %>% quantile(.,
                                                                                                         probs =
                                                                                                           c(seq(from = 0,
                                                                                                                 to = 1,
                                                                                                                 by = 0.01)))