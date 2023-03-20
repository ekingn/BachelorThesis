library(here)
source(here("Scripts","Session-Related","Packages.R"))
load(file = here("Output","RData","Trained-GAMM.RData"))

## Plot the smooth terms 

### Create a grid (layout) out of these plots     
# plot_grid_smooth_terms <-

### Create
jpeg(filename = here("Output","JPGs","Smooth-Terms","Smooth-Term-Effects.jpg"),
     width = 720 * 2, # Increase the width
     height = 480 * 2, # Increase the height
     quality = 100,
     res = 150)

layout_matrix <-
  
  matrix(c(1, 2, 3, 4, 5, 0), nrow = 2, ncol = 3, byrow = TRUE)

layout(layout_matrix)

{
  plot(gamm_model,
       select = 1,
       main = "Smooth Term:\nAltitude",
       xlab = "Altitude",
       ylab = "Smooth Term Effect",
       cex.axis = 1.5, cex.lab = 1.5, cex.main = 1.5, lwd = 1.25)
  plot(gamm_model, 
       select = 2, 
       main = "Smooth term:\nMean Temperature", 
       xlab = "Mean Temperature",
       ylab = "Smooth Term Effect",
       cex.axis = 1.5, cex.lab = 1.5, cex.main = 1.5, lwd = 1.25)
  plot(gamm_model, 
       select = 3, 
       main = "Smooth term:\nLongitudinal Degree", 
       xlab = "Longitudinal Degree",
       ylab = "Smooth Term Effect",
       cex.axis = 1.5, cex.lab = 1.5, cex.main = 1.5, lwd = 1.25)
  plot(gamm_model,
       select = 4,
       main = "Smooth Term:\nLatitudinal Degree",
       xlab = "Latitudinal Degree",
       ylab = "Smooth Term Effect",
       cex.axis = 1.5, cex.lab = 1.5, cex.main = 1.5, lwd = 1.25)
  plot(gamm_model, 
       select = 5, 
       main = "Smooth term:\nJulian Date", 
       xlab = "Julian Date",
       ylab = "Smooth Term Effect",
       cex.axis = 1.5, cex.lab = 1.5, cex.main = 1.5, lwd = 1.25) 
}

dev.off()

