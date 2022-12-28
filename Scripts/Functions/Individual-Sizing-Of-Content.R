# Function that enables individual sizing of content 
{
  def.chunk.hook  <- knitr::knit_hooks$get("chunk")
  knitr::knit_hooks$set(chunk  =  function(x, options) {
    x <- def.chunk.hook(x, options)
    ifelse(options$size  !=   "normalsize", paste0("\n \\", options$size,"\n\n", x, "\n\n \\normalsize"), x)
  })
}