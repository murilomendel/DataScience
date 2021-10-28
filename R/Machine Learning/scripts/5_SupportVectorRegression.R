# Support Vector Regression - SVR
library(dplyr)
library(ggplot2)
library(e1071)

# 1.0 - Reading Dataset
dataset <- read.csv('./input/Position_Salaries.csv')
dataset <- dataset[2:3]

# 2.0 - Fitting SVR Model
svr = svm(formula = Salary ~ .,
          data = dataset,
          type = 'eps-regression')


# 3.0 - Prediction
y_pred = predict(svr, newdata = data.frame(Level = 6.5))

# 4.0 - Plotting Polynomial Regression
ggplot() +
  geom_point(data = dataset, aes(x = Level, y = Salary), colour = "red") + 
  geom_line(aes(x = dataset$Level, y = predict(svr, newdata = dataset)), colour = "blue") +
  ggtitle("Polynomial Regression Fit") +
  xlab("Level") +
  ylab("Salary")
