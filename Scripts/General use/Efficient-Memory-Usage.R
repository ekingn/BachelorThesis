# Print the working memory currently in use through R Studio
mem_used()

# Print a decreasing list of memory usages of the individual objects in the R Studio environment
sort(decreasing = TRUE,sapply(ls(),function(x){object.size(get(x))}))


 