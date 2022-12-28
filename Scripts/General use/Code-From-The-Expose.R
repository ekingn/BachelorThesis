
{
#```{r fig.align='right', out.height="100%",out.width="100%", fig.width = 15, fig.height = 18}

# Load the Gadm Map of germany with lines highlighting the administrative boundaries between the German federal states.
# Every Gadm Map is a polygon that contains geographical information in the form of angular coordinates
Germany = gadm_sf.loadCountries(fileNames = "DEU",level = 1)

# Plot the weather stations on the Gadm Map of Germany according to their respective unique pair of coordinates
dots(x = Germany, size = 1, color = "black", points = ListOfAllUniqueCoordinates, value = NULL, breaks = NULL, steps = 4, palette = NULL, labels = NULL, strate = NULL, title="", subtitle = "", legend = NULL, note=NULL)
#```
}


# Wrap a text around a figure (plot or picture), that is aligned to the right side
{
\begin{wrapfigure}[12]{r}{0.4\textwidth}
  \centering
  \vspace{-2cm}
```{r fig.align='right', out.height="100%",out.width="100%", fig.width = 15, fig.height = 18}

plot(x=c(1,2,3), y=c(2,4,6))

```
  \caption{A non-informative plot}
\end{wrapfigure}
}

# An visual overview of the format of the data (first five rows)
{
  WeatherGermany[c(1:5),-c(14,15)] %>%
    kbl(caption  =  "Rows 1-5 of the data. Own representation") %>%  
    kable_classic() %>% 
    kable_styling(font_size  =  12, latex_options  =  c("HOLD_position","scale_down"),full_width  =  FALSE) %>% 
    footnote(number  =  c("'index' indentifies the station, to which an observation belongs", 
                          "'T' describes the mean temperature, 'TMin' describes the minimum temperature, 'TMax' describes the maximum temperature",
                          "'rain' describes precipiation height (mm)",
                          "'sun' describes the total hours of sunlight",
                          "'year','month' and 'day' identify the year, month and day of a year of an observation",
                          "'alt' describes the level of altitude of the station",
                          "'lon' describes longitude, 'lat' describes latitude",
                          "'name' describes the city where the station is",
                          "'ExtremePrecipitationEvent' indicates the occurence of an EPE: 1=EPE, 0=NO-EPE"), threeparttable  =  TRUE)
}

# A visualization of the variation of the number of observations (irregularity of data layout)
{
  VisualizationOfIrregularity = qplot(NumberOfObservationsPerWeatherStation$index,
                                      NumberOfObservationsPerWeatherStation$n, 
                                      color = I("black"), 
                                      shape = I(1), 
                                      size = I(5), 
                                      alpha = I(1),
                                      xlab = "Index-number of the weather station",
                                      ylab = "Number of observations") + 
    theme(plot.title = element_text(hjust = 0.5,vjust = 1)) + theme(axis.text=element_text(size = 50, face = "bold"),
                                                                    axis.title=element_text(size=50,face="bold"))
  VisualizationOfIrregularity
}

# LaTeX Code for two equation: The left equation defines EPE as dichotomous variable and 
# as a function of the precipitation height. The right defines rain as a linear combination of k parameters. 
\begin{align}
EPE &= f(rain) =
  \left\{\begin{array}{rcl}
    1 & \mbox{for}
    & rain\ge\:arbitrary\:value \\ 
    0 & \mbox{for} 
    & rain\:<\:arbitrary\:value
    \end{array}\right. &
      \wedge
    \hspace{+1cm}
    rain &= g(x_{1},\dots,x_{k}) = x\beta 
\end{align}
    
