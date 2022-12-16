pacman::p_load(pacman, tidyverse, spacetime)
WeatherDataDailySPACETIME = stConstruct(x = WeatherDataDailyResolution,
                                        space = c("lon","lat"),
                                        time = "CalendarDate")

