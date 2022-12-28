# Read a GADM map in R Studio
Germany = readRDS(file = "C:/Users/User/Desktop/Bachelor Thesis/Space-Time Modeling of EPE/BachelorThesis/Working Directory/DEU_adm1.sf.rds")
str(Germany)

# Plot a GADM map of Germany with ggplot
ggplot(Germany) + geom_sf(fill = "white")