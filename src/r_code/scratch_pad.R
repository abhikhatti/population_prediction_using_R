df <- data.frame(
        Name = c("Cat", "Dog", "Cow", "Pig"),
        HowMany = c(5, 10, 15, 20),
        IsPet = c(TRUE, TRUE, FALSE, FALSE)
      )

df

df[2,]

c(1,2,3) + c(4,5,6)

#install.packages("dplyr")

library(dplyr)
?data.frame

# Read csv file from different directories, compared to PWD
setwd("C:/Personal/C997 - Data Analysis with R/population/src/r_code")
data <- read.csv("../../data/interim/population_ri_train.csv")
data

# Write Sample Response & Predictors to their resp. variables

year <- data[,1]
population <- data[,2]

year
population

#Check Scatterplot
pairs(cbind(population, year))

# Create linear regression model
lr_model <- lm(population ~ year)
summary(lr_model)

fitted(lr_model)
residuals(lr_model) 

anova(lr_model)

plot(year, residuals(lr_model), xlab = "Year", ylab = "Residuals for Year Feature")
plot(fitted(lr_model), residuals(lr_model), ylab = "Residuals", xlab = "Fitted Values")
qqnorm(residuals(lr_model))
#qqline(residuals(lr_model))
qqline(0)
# Check the Sqrt of Residual Mean Square Error MSE (RMSE - Standard Error)
sqrt(631624) #RMSE

?skew

plot(density(population), main="Density Plot: Population", ylab = "population", sub=paste("Skewness: ", e1071::skewness(population)))

# Create training model
set.seed(100)
trainingRowIndex <- sample(1:nrow(data), 0.8*nrow(data))

# Train-Test Split
trainingData <- data[trainingRowIndex,]
testData <- data[-trainingRowIndex,]
trainingData
testData
data
# Fit model
lrm1 <- lm(Population ~ Year, data = trainingData) #build model
poppredict <- predict(lrm1, testData)
summary(lrm1)


testfeatures <- read.csv("../../data/interim/population_test.csv")
testfeatures

testpred <- predict(lrm1, testData)
testpred

act <- data.frame(cbind(actuals=testData$Population, presidents=testpred))
act
corr <- cor(act)
cor(data.frame(cbind(actuals = testData$Population, predicted = testpred)))
head(act)
corr

R2_Score(testpred, testData$Population)

finalpredictions = predict(lrm1, testfeatures)

#install.packages("DAAG")
install.packages("DMwR")
library(DAAG)
library("MLmetrics")
cvResults <- suppressMessages(CVlm(data = data, form.lm=Population ~ Year, m=5, dots=FALSE, seed=29, legend.pos="topleft",  printit=FALSE, main="Small symbols are predicted values while bigger ones are actuals."));  # performs the CV
attr(cvResults, 'ms')

R2_Score(testpred,testData$Population)
DMwR::regr.eval(act$actuals, act$presidents)
min_max_accuracy <- mean(apply(act, 1, min) / apply(act, 1, max))  
min_max_accuracy

finaloutput = data.frame(Year = testfeatures, Population = finalpredictions, row.names = NULL)
finaloutput


?data.frame
write.csv(finaloutput, "population_ri_predictions.csv", row.names = FALSE)

read.csv("population_ri_predictions.csv")

ri_2010 <- c(1052567, 1052940, 1053337)
d <- density(ri_2010) # Census, Baseline and 2010 prediction
plot(d)

sd(ri_2010) + mean(ri_2010)

# R2 score
R2_Score(ActvsPred$Predictions, ActvsPred$Actuals)