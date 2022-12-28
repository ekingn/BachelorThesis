# Function that enables individualizing boxplots
{
  IndividualizedBoxplotQuantiles <- function(x) {
    r <- quantile(x, probs = c(0.05, 0.25, 0.5, 0.75, 0.95))
    names(r) <- c("ymin", "lower", "middle", "upper", "ymax")
    r
  }
  
  DefinitionOfOutliers = function(x) 
  {
    subset(x, quantile(x,0.95) < x)
  }
}


