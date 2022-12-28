# Function that changes decimal seperator from "." to "," (German convention)
{
  comma_decimal <- function(x) {
    gsub(".", ",", x, fixed = TRUE)
  }
}