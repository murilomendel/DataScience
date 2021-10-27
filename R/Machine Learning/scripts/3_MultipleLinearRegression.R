# Multiple Linear Regression

library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(caTools)

# Reading data
dataset <- read.csv('input/50_Startups.csv')

# Encoding categorical data
dataset$State <- base::factor(dataset$State,
                               levels = base::unique(dataset$State),
                               labels = c(1:base::length(base::unique(dataset$State))))

# Train / Test Split
base::set.seed(123)
split <- sample.split(dataset$Profit, SplitRatio = 2/3)

training_set <- base::subset(dataset, split == TRUE)
test_set <- base::subset(dataset, split == FALSE)

# Fitting Multiple Linear Regression
regressor = lm(Profit ~ .,
               data = training_set)

summary(regressor)

y_pred <- predict(regressor, newdata = test_set)
y_pred


# Backward Elimination

backwardElimination <- function(x, sl) {
  numVars = length(x)
  for (i in c(1:numVars)){
    regressor = lm(formula = Profit ~ ., data = x)
    maxVar = max(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"])
    if (maxVar > sl){
      j = which(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"] == maxVar)
      x = x[, -j]
    }
    numVars = numVars - 1
  }
  return(summary(regressor))
}

SL = 0.05
dataset = dataset[, c(1,2,3,4,5)]
backwardElimination(training_set, SL)