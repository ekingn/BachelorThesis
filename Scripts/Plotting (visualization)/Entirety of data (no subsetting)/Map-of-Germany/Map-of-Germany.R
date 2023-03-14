library(here)
source(here("Scripts","Data-Manipulation","Training-Data","Training-Data.R"))
source(here("Scripts","Session-Related","Packages.R"))

Germany <- 
  
  ne_states(country = "Germany", returnclass = "sf")

Germany <- 
  
  ggplot() + 
  
  geom_sf(data = NULL, inherit.aes = FALSE) +
  
  geom_sf(data = Germany) + 
  
  geom_point(data = Index_Lat_Lon,
             aes(x = lon,
                 y = lat),
             size = 0.1) +
  
  theme(plot.background = element_blank(),
        panel.background = element_blank(),
        axis.title.x = element_text(size = 26,
                                    face = "bold"),
        axis.title.y = element_text(size = 26,
                                    face = "bold"),
        axis.text.x = element_text(size = 20,
                                   face = "bold"),
        axis.text.y = element_text(size = 20,
                                   face = "bold"),
        plot.margin = unit(c(0,0,0,0), "cm"))
        

ggsave(plot = Germany,
       filename = "Germany.jpg",
       path = here("Output","JPGs","Maps"),
       width = 7,
       height = 9,
       units = "cm",
       dpi = 300)
