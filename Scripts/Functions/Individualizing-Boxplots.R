# Function that enables individualizing boxplots
{
  Boxplot_Quantiles <- function(x){
    d <- data.frame(ymin = stats::quantile(x,0.01),
                    lower = stats::quantile(x,0.25),
                    middle = stats::quantile(x,0.5),
                    upper = stats::quantile(x,0.75),
                    ymax = stats::quantile(x,0.99),
                    row.names = NULL)
    d[1, ]
  }
  
  Determining_Outliers = function(x) 
  {
    subset(x, 
           stats::quantile(x,0.99) < x | stats::quantile(x,0.01) > x)
  }
}



