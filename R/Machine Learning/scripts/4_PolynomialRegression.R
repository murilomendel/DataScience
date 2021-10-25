# Polynomial Regression
library(dplyr)
library(ggplot2)

# 1.0 - Reading Dataset
dataset <- read.csv('./input/Position_Salaries.csv')
dataset <- dataset[2:3]


# 2.0 - Fitting Linear Regression 
lin_reg <- stats::lm(Salary ~ ., 
              data = dataset)

# 2.1 - Plotting Linear Regression
ggplot() +
  geom_point(data = dataset, aes(x = Level, y = Salary), colour = "red") + 
  geom_line(aes(x = dataset$Level, y = predict(lin_reg, newdata = dataset)), colour = "blue") +
  ggtitle("Linear Regression Fit") +
  xlab("Level") +
  ylab("Salary")
  
# 2.2 - Predicting
y_pred = predict(lin_reg, newdata = data.frame(Level = 6.5))
  

# 3.0 - Fitting Polynomial Regression

# Create polynomial variables
dataset_poly <- dataset %>% dplyr::mutate(Level2 = Level^2,
                                        Level3 = Level^3) %>% 
                            dplyr::select(Level, Level2, Level3, Salary)
  
# Fitting Polynomial Regression
poly_reg <- lm(Salary ~ ., 
              data = dataset_poly)

# Checking results
summary(poly_reg)


# 3.1 - Plotting Polynomial Regression
ggplot() +
  geom_point(data = dataset_poly, aes(x = Level, y = Salary), colour = "red") + 
  geom_line(aes(x = dataset$Level, y = predict(poly_reg, newdata = dataset_poly)), colour = "blue") +
  ggtitle("Polynomial Regression Fit") +
  xlab("Level") +
  ylab("Salary")

# 2.2 - Predicting
y_pred_poly = predict(poly_reg, newdata = data.frame(Level = 6.5, Level2 = 6.5^2, Level3 = 6.5^3))
