## WGU Performance Assessment - Population Prediction for Home State ##
## R script - wgu_population_predictions_ri.R ##
## Author - Abhishek Khatti ##

## Import required Libraries
library(dplyr)  # To work with Data Frame type structures

## Set Current Working directory

setwd("C:/Personal/C997 - Data Analysis with R/population/src/r_code")

## Check data for Year 2010 for Rhode Island
ri_2010 <- c(1052567, 1052940, 1053337)  # Data from Census, Estimates Base and 2010 Column
ri_density <- density(ri_2010)
plot(ri_density)  # Displays normal distribution

posstdint <- mean(ri_2010) + sd(ri_2010)
negstdint <- mean(ri_2010) - sd(ri_2010)
  
print("1 Std. Dev Interval: ")
posstdint
negstdint

ri_2010[3] - posstdint 

## Conclusion: The 2010 column entry is approx. 1 std dev away from mean. 
## Thus we can drop April Census and Baseline Estimate features in favor of 2010 July Estimates 

## Create Linear Regression Models
trainingdata <-
  read.csv("../../data/processed/population_ri_train.csv")  # Data saved in another subfolder

## Split Training Data set into respective Predictor and Response Vectors
year <-
  trainingdata[, 1] # First feature is the predictor variable Year
population <-
  trainingdata[, 2] # Second feature is the response variable Population

## Create Scatterplot Matrix to find if Realtionship between two variables
pairs(cbind(population, year))

## Conclusion: Some form of Linear regression exists

## Perform Train-Test Split of the training data set
set.seed(100)
trainingsize <-
  nrow(trainingdata)  # Total # of rows in training data set
trainRowIndex <- sample(trainingsize, 0.8 * trainingsize)

split_train <- trainingdata[trainRowIndex, ]
split_test <- trainingdata[-trainRowIndex, ]

split_train <- split_train[order(split_train$Year),]  ## Sort in Ascending format

split_train
split_test

## Create Linear Regression Model
lr_model <- lm(Population ~ Year, data = split_train)
summary(lr_model)

## Check Linear Regression Model Assumptions

# Independence Test
plot(split_train$Year,
     residuals(lr_model),
     xlab = "Year",
     ylab = "Residuals for Year Feature")
qqline(0)
# Mean of 0 AND Constant Variance - Fitted vs Residuals
plot(fitted(lr_model),
     residuals(lr_model),
     xlab = "Fitted Values",
     ylab = "Residuals")
qqline(0)

# Check for normal distribution of training data subset
qqnorm(residuals(lr_model))
qqline(residuals(lr_model))

## Generate test results
predict_test <- predict(lr_model, newdata = split_test)
predict_test

## Calculate the performance of the model
ActvsPred <-
  data.frame(cbind(Actuals = split_test$Population, Predictions = predict_test))  # Create data frame for comparison
ActvsPred

# Calculate Error Rates
DMwR::regr.eval(ActvsPred$Actuals, ActvsPred$Predictions)
# Min-Max Accuracy
min_max_accuracy <-
  mean(apply(ActvsPred, 1, min) / apply(ActvsPred, 1, max))
min_max_accuracy

## Generate Final predictions for next 5 years
testfeatures <- read.csv("../../data/processed/population_test.csv")
testfeatures

fiveyearpredictions <- predict(lr_model, newdata = testfeatures)
fiveyearpredictions

finalpredictions <-
  data.frame(Year = testfeatures, Population = fiveyearpredictions)
finalpredictions  

## Write the output to the file
setwd("../../data/external")  # set the directory where you want to save final output file
write.csv(finalpredictions, "population_predictions.csv", row.names = FALSE)
setwd("../../src/r_code")  # Set the PWD back to original

