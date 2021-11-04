# Decision Tree Regression
library(dplyr)
library(ggplot2)
library(rpart) # Recursive partitioning an Regression Trees


# 1.0 - Reading Dataset
dataset <- read.csv('./input/Position_Salaries.csv')
dataset <- dataset[2:3]


# 2.0 - Fitting Decision Tree
regressor = rpart::rpart(formula = Salary ~ .,
                         data = dataset,
                         control = rpart.control(minsplit = 1))


# 3.0 - Predicting
y_pred = predict(regressor, data.frame(Level = 6.5))


# 4.0 - Plotting Decision Tree Regression
ggplot() +
  geom_point(data = dataset, aes(x = Level, y = Salary), colour = "red") + 
  geom_line(aes(x = dataset$Level, y = predict(regressor, newdata = dataset)), colour = "blue") +
  ggtitle("Decision Tree Regression Fit") +
  xlab("Level") +
  ylab("Salary")


# 4.0 - Plotting Decision Tree Regression (Higher Resolution)
X_grid = seq(min(dataset$Level), max(dataset$Level), 0.01)
ggplot() +
  geom_point(data = dataset, aes(x = Level, y = Salary), colour = "red") + 
  geom_line(aes(x = X_grid, y = predict(regressor, newdata = data.frame(Level = X_grid))), colour = "blue") +
  ggtitle("Decision Tree Regression Fit") +
  xlab("Level") +
  ylab("Salary")
