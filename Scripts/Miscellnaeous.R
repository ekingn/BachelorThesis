#Lists all unique entities as a data frane
ListOfEntities = data.frame("Entity names" = unique(data$Entities))  

# Omit the rows, that contain NAs
DataWithoutNA = na.omit(Data)

# Exempt specific columns
Data = Data[,-c(5:24)] 

# Relocate a dataframe column
Data = Data %>% 
  relocate(
    ColumnToBeRelocated,
    .before = ColumnThatItShouldComeBefore
          )

# Compute specific percentile-values for an empirical distribution 
quantile(Data, probs = c(0.05,0.95))

# Delete the rownames of a data.frame
rownames(Data) = NULL

# Combine the two dataframes "DataA" and "DataB" into a new data.frame
Data = cbind(DataA,DataB) 

# Set "," as the decimal seperator instead of "." (Germany instead of England)
options(scipen = 999, OutDec  =  ",") 

# Read a .dta file 
daten =  read_dta("blabla.dta") 

# Read a .csv file 
data = read.csv("data.csv") 

# Create an index column based on a categorical column
data$index  =  as.numeric(as.factor(data$names)) #create an index column based on a categorical column

# Count the number of entities as the number of dinstict index numbers across all rows
number_entities = n_distinct(data$Index) 

# Create a custom Kable table from dataframe data
{
  # Take specific rows and columns from the dataframe "Data"
  Data[c(1:6),c(1,4,8)] %>%
  # Round the values of all numeric columns to the second digit
  mutate_if(is.numeric, ~round(., 2)) %>% 
  # Create a kable table with "A","B" and "C" as column headers and give the table a custom caption
  kbl(col.names  =  c("A","B","C"), 
      caption  =  "Rows 1-6 of the data. Own representation") %>%  
  #Use the classic design for the table
  kable_classic() %>% 
  kable_styling(font_size  =  12, latex_options  =  "HOLD_position",full_width  =  FALSE) %>% #Use fontsize 12 and put the table exactly where the code is. Make it non-full-width
  column_spec(column  = c(1:3)) %>% #Here I could add arguments to change the columns
  footnote(number  =  c("A describes Bla", "B describes Blabla"), #Add a footnote and use numerical bullet points
           alphabet  =  c("NA stands for NotAvailable"), #Add alphabetical bulletpoints
           threeparttable  =  TRUE) %>% #Divide the table into three parts
  row_spec(0,bold = TRUE) #print the rownames in fat symbols
}

NumberRowsNegativeValues = n_distinct(data$SomeColumn[data$SomeColumn <= 0]) # Compute the number of negative rows

data = data %>% 
  mutate(SomethingImportant = #Create a new variable called "SomethingImportant"
           case_when(
             data$A <=  5 & data$A >=  1 ~ "1-5",
             data$A >=  6 & data$A <=  10 ~ "6-10",
             data$A >=  11 & data$A <=  15 ~ "11-15")
         #The values of the new variable "SomethingImportant" are based on the column A of the data.
         #The "~" symbol says "then create..."
  )

MeanValues = data.frame(
  aggregate( #Compute some sort of aggregate values
    data$InputValues, #data, that is to be aggregate
    by = list #list of columns, on whose values the aggregation shall be based
    (
    data$A, #First criterion of aggregation
    data$B #Second criterion of aggregation
    #All the values of a specific pair of A-value und B-values get aggregated
    ), 
    FUN = mean) #aggregation is defined as computing mean values
  )

Data = arrange( #Sort a dataframe based on a column
  Data, #Dataframe to be sorted
  Data$A, #Column, on which the ascending sorting shall occur
  )

Data = rename( #rename some specificed columns
  Data, #data with columns
  "A" = "bla", #"A" substitutes "bla"
  "B" = "blabla", 
  "C" = "blubli"
  )

Numbers = data.frame(rep(1:10, each = 3)) #repeat the numbers 1 to 10, each 3 times

CorrelationMatrix = as.data.frame( #Create a correlationmatrix as data.frame
  round( #Round the results
    cor( #Compute the correlationcoefficients
      Data[,c(5:7)], #Use columns 5 to 7 from data 
      use  =  "pairwise.complete.obs"), #Use only pairwise complete observations
    2)
  )

row.names(data) = c("A","B","C") #Change the rownames of data into "A","B","C"

colnames(data) = c("D","E","F") #Change the columnnames of data into "D","E","F"

Top10 = data.frame( #Get the top10 values of some data
  head( #Get the head of (the first somewhat rows)
    unique(
      (
        data[
          order(
            data$SomeRealVariable,
            decreasing = TRUE)
          ] #data is being ordered ascendingly based on "SomeRealVariable"
      )$SomeIndexVariable #The column, where the 10 rows shall come from
      ), 
    n = 10) #Determines to get first 10 rows
  )

Bottom10 = data.frame(head(unique((data[order(data$SomeRealVariable,decreasing = TRUE)])$SomeIndexVariable),n = 10))
{
# Create a vector, that indicates all rows, where all numerical columns consist of "NA" values
ind = apply(
  data[,c(6:10)], 
  1, 
  function(data) all(is.na(data))
  )

# Delete all rows, where all numerical columns completetely consist of "NA" values
data = data[ !ind, ]
}
# Add a column with the maximum values each row
data$MaximumOfEachRow = apply(
  (mutate_all(
    data,
    ~replace(.,is.na(.),0)))[,c(5:37)], #the data is a transformation, where all "NA" values are substituted by 1
  1, #Setting, so that function is applied row-wise
  max) #sets "find the maximum value" as the function to be applied

# Add a column with the minimum values of each row
data$MinimumOfEachRow = apply(
  (mutate_all(
    data,
    ~replace(.,is.na(.),9999999999999999999)))[,c(5:37)],
  1, #Setting, so that function is applied row-wise
  min) #sets "find the minimum value" as the function to be applied

# Find the values, that are realized both in the columns X and Y in the same row 
Intersect_X_Y = intersect(Data$X,Data$Y)

# Compute the variance inflation values for a given regression object
VIFs = lm(A~B+C+D, data = Data) %>% vif() %>% as.data.frame()


# Create a table with very custom column names and first column values, that is to be printed as a kable table
{
  # Create a table from a custom first column and a second column with values from arbitrary dataframes
  CustomTable = data.frame(
    FirstColumn = c("$\\beta_{pquer}$",
          "$\\beta_{squer}$",
          "$\\beta_{tquer}$"),
    SecondColumn = round( # round the values before putting them into the second column
      c(A[1,1],
        B[1,1],
        C[1,1]),
      2))
  # 
  kable(CustomTable, 
        col.names = c("$\\beta_{k}$","VIF"), 
        escape = FALSE, 
        caption = "A custom kable table. Own representation.") %>% 
    kable_classic() %>% 
    kable_styling(font_size  =  12, 
                  latex_options  =  c("HOLD_position"),
                  full_width  =  FALSE) %>% 
    row_spec(0,bold = TRUE) %>% 
    footnote(general_title  =  "",
             general  =  "",
             threeparttable  =  TRUE)
}

# Get a summary of the distribution of dataframe-column A rounded to the second digit
SummaryOfColumnA = round(summary(Data$A),2)

# Make a custom table with the summaries of the distributions of specific dataframe-columns rounded to the second digit
{
  # Create a custom row with the Interquantilranges of the specified columns
  IQR = c("IQR",
        round(IQR(Data$A,na.rm = TRUE),2),
        round(IQR(Data$B,na.rm  = TRUE),2))
  # Create a dataframe of distributional characteristics other than the IQR
  CharacteristicsExemptIQR = data.frame(
    "Type of Characteristic" = c("Minimum",
                 "Erstes Quartil",
                 "Median",
                 "Mittelwert",
                 "Drittes Quartil",
                 "Maximum",
                 "Anzahl NA's"),
   A = as.vector(unname(summary(Data$A))),
   B = as.vector(unname(summary(Data$B)))
   )
  # Row-bind the IQR-row and the rows for the other distributional characteristics 
  DistributionalCharacteristics = rbind(CharacteristicsExemptIQR,IQR)
}

# Create a sequence of numbers that ups by a specified value
sequence = c(seq(from = -5,to = 5,by = 0.5)) #Ergibt 21 Werte, weil -5 zur Sequenz gehört

# Create a custom string that keeps blank spaces 
paste("Statistik est fortuna")

# Create a histogram through qplot
SomeHistogram = qplot(x = A,
                      data = Data, 
                      fill = I("white"), 
                      color = I("black"), 
                      xlab = "A",
                      ylab = paste0("Absolute\nFrequency"),
                      breaks = c(seq(from = -3,to = 3,by = 0.5)))

# Create a plotgrid of histograms, that were constructed previously
Plotgrid = plot_grid(histogram_object_A,
                     histogram_object_B,
                     histogram_object_C,
                     align  =  "H", 
                     scale = 1)

# Estimate a fixed effects model
FixedEffecsModel = plm(D~A+B+C,
                       data = Data,
                       model = "within")

# Construct a table of regression estimates, their p-values and estimated standard errors
# Example: Fixed-Effects-Model
{
  # Extract the required values and put them into a dataframe
  SummaryFixedEffectsModel = data.frame(
  A = unname((summary(SomeFixedEffectsModel))$coefficients[,1]), #the coefficient-estimates
  B = unname((summary(SomeFixedEffectsModel))$coefficients[,4]), #the p-values
  C = unname((summary(SomeFixedEffectsModel))$coefficients[,2])) #the standarderrors of the estimates
  # Round the values to the second digit
  SummaryFixedEffectsModel = SummaryFixedEffectsModel %>% 
  mutate_if(is.numeric, ~round(., 2))
  # Make a kable table from the summary above
  kable1 = cbind(c("$x_1-\\overline{x_1}$",
                   "$x_2-\\overline{x_2}$",
                   "$x_3-\\overline{x_3}$"),
                 SummaryFixedEffectsModel) %>% 
    kable(caption = "Regressionsoutput (1)",
          col.names = c("$x_{k}$",
                        "$\\hat{\\beta}_{k}$",
                        "$Pr(>|t|)$",
                        "$\\hat{\\sigma}_{\\hat{\\beta_k}}$"),
          escape = FALSE) %>% 
    kable_classic() %>%
    kable_styling(latex_options = c("HOLD_position"), full_width = FALSE) 
  # Create dataframes with rsquared and the fstatistic
  rsquared_FixedEffectsModel = unname(summary(FixedEffectsModel)$r.squared)
  rsquared_FixedEffectsModel = rsquared_FixedEffectsModel2[1]
  PValueOfFTest_FixedEffectsModel = unname(((summary(FixedEffectsModel)$fstatistic))$p.value)
  # Put the rsquared and the p value of the f test into on dataframe and then 
  SummaryFixedEffectsModel2 = data.frame(A = rsquared_FixedEffectsModel,
                                         B = PValueOfFTest_FixedEffectsModel) %>% 
    mutate_if(is.numeric, ~round(., 3))
  # Make a second kable table from the dataframe with rsquared and the p value of the f test
  kable2 = kable(caption="Regressionsoutput (2)",
               SummaryFixedEffectsModel2,
               escape = FALSE, 
               col.names = c("P(>|F|)","$R^2$")) %>% 
  kable_classic() %>% 
  kable_styling(latex_options = c("HOLD_position"), 
                full_width = FALSE)
}

# Estimate a random effects model
RandomEffectsModel = plm(D~A+B+C,
                         data = Data, 
                         model = "random")

# Create a table of regression estimates, p-values and estimated standard errors
# Example: Random Effects Model
{
  # Extract the required values and put them into a dataframe
  SummaryRandomEffectsModel = data.frame(
    xk = c("$x_1-\\theta\\left(\\overline{x_1)}\\right)$",
         "$x_2-\\theta\\left(\\overline{x_2}\\right)$",
         "$x_3-\\theta\\left(\\overline{x_3}\\right)$"),
    EstimatedCoefficients = unname(SummaryRandomEffectsModel$coefficients[2:4,1]),
    PValueChiSquare = unname(SummaryRandomEffectsModel$coefficients[2:4,4]),
    Standarderror = unname(SummaryRandomEffectsModel$coefficients[2:4,2]))
 # Round the required values to the second digit and then create a Kable table
  SummaryRandomEffectsModel = SummaryRandomEffectsModel %>% 
    mutate_if(is.numeric, ~round(., 2))
  kable(SummaryRandomEffectsModel, 
        caption = "Regressionsoutput (1)", 
        col.names = c("$x_{k}$",
                      "$\\hat{\\beta}_{k}$",
                      "$Pr(>|\\chi^2|)$",
                      "$\\hat{\\sigma}_{\\hat{\\beta_k}}$"),
        escape = FALSE) %>% kable_classic() %>% 
    kable_styling(latex_options = c("HOLD_position"),
                  full_width = FALSE)
}  

# Compute the thetas of the random effects model a posteriori
Theta = (summary(RandomEffectsModel))$ercomp$theta
# Compute rsquared of a Random Effects Model
RSquared = (summary(RandomEffectsModel))$r.squared[1]
# Compute the F statistic of a Random Effects Model
FStatistic = unname((summary(RandomEffectsModel))$fstatistic[4])

# Create a second table with distributional properties of theta, the probability of the FStatistic and rsquared
{
  # Test, if you can access the distributional propoerties of theta the following way 
  RandomModelThetas = summary(((summary(RandomEffectsModel))$ercomp)$theta)
  # Test, if you can access the fstatistic the following way
  RandomModelFStatistic = unname((summary(RandomEffectsModel))$fstatistic[4])
  # Test, if you can access the rsquared value the following way 
  RandomModelRsquared = (summary((RandomEffectsModel)))$r.squared[1]
  # Create a dataframe with the distributional properties of the thetas 
  RandomModelThetas = data.frame("Distributional Characteristic" = c("Minimum",
                                                   "First Quartile",
                                                   "Median",
                                                   "Third Quartile",
                                                   "Maximum"),
                               "Value" = c(unname(summary((summary(RandomEffectsModel))$ercomp$theta)[1]),
                                          unname(summary((summary(RandomEffectsModel))$ercomp$theta)[2]),
                                          unname(summary((summary(RandomEffectsModel))$ercomp$theta)[3]),
                                          unname(summary((summary(RandomEffectsModel))$ercomp$theta)[4]),
                                          unname(summary((summary(RandomEffectsModel))$ercomp$theta)[5]))) %>% 
  
    mutate_if(is.numeric, ~round(., 2))
colnames(RandomModelThetas) = c(paste("Distribution\nproperty\n$\\theta$"),"Value")
}

# Create a second table with RSquared and the FStatistic of the Random Effects Model 
{
  # Create the second table
  RandomModelFStatisticAndRSquared = data.frame(unname((summary(RandomEffectsModel))$fstatistic[4]),
                                              unname((summary(RandomEffectsModel))$r.squared[1])) %>% 
    mutate_if(is.numeric, ~round(., 3))
  # Change the column names
  colnames(RandomModelFStatisticAndRSquared) = c("Pr(>|F|)","$R^2$")
}

# Create a Kable table from two data.frames at once (Thetas and other statistics) 
kable(list(RandomModelThetas,
           RandomModelFStatisticAndRSquared), 
      caption = "Regressionsoutput (2)", 
      escape = FALSE, 
      row.names = FALSE) %>% 
  kable_classic() %>% 
  kable_styling(latex_options = c("HOLD_position"), 
                full_width = FALSE)

# Compute a Hausman-Test and put the Teststatistic and it's PValue into a Kable table 
{
  # Compute the Hausman-Test as a Test
  HausmanTest = phtest(FixedEffectsModel,RandomEffectsModel)
  # Access the Teststatistic of the Hausman-Test as a Test
  HausmanTeststatistic = unname(HausmanTest$statistic)
  # Access the PValue of the Teststatistic
  HausmanPValue = unname(HausmanTest$p.value)
  # Create a table 
  HausmanTest = data.frame("$\\chi^2$" = unname(phtest(FixedEffectsModel,RandomEffectsModel)$statistic),
                           "$Pr(>|\\chi^2|)$" = unname(phtest(FixedEffectsModel,RandomEffectsModel)$p.value))
  }

# Create a plotgrid of multiple custom scatterplots
{
  # First plot
  plot1 = qplot(Data$XVariableOne,
                Data$YVariableOne, 
                color = I("black"), 
                shape = I(1), 
                size = I(1), 
                alpha = I(1),
                main = "Variable YOne against Variable XOne", 
                xlab = "Variable XOne",
                ylab = "Variable YOne") + 
    theme(plot.title = element_text(hjust = 0.5))
  # Second plot
  plot2 = qplot(XVariableTwo,
                YVariableOne, 
                data = Data
                shape = I(1),
                size = I(1),
                alpha = I(1),
                color = I("black"), 
                xlab = "Variable XTwo",
                ylab = "Variable Yone",
                main = "Variable Yone against Variable XTwo") + 
    theme(plot.title = element_text(hjust = 0.5))
  # Create a plotgrid 
  plot_grid(plot1,
            plot2,
            align  =  "h",
            rel_widths  =  2,
            rel_heights  =  2)
}

# Conduct matrix multiplication
{
A = matrix(data =
    c(1,2,3,
      3,4,5,
      5,6,7),
    ncol=3,
    nrow=3)
B = matrix(data=c(1,
                  2,
                  3),
            ncol=1,
            nrow=3)
Matrixmultiplication = A%*%B
}

# Create SessionInfo
sessionInfo()

# Align the caption of a figure/plot in the center
qplot() + theme(plot.title = element_text(hjust = 0.5))

# Change the left, right, top and bottom margin of a figure/plot
qplot() + theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
