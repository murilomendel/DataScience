library(MASS)
library(ISLR)
library(car)

# LINEAR REGRESSION STUDY
fix(Boston) # Permits edit the dataset
names(Boston) # Columns names

?Boston # Detailed information about Boston Data Set

# Linear regression medv = beta0 + beta1*lstat
# medv: median value of owner-occupied homes in \$1000s
# lstat: lower status of the population (percent)
attach(Boston) # Databaset is attached to the R search path. No need to specify data on lm(data = ) argument.

lm.fit = lm(medv ~ lstat)
summary(lm.fit)

names(lm.fit) # Linear Regression pieces of information
coef(lm.fit) # acces coeficients information
lm.fit$coef # Access coeficients information
confint(lm.fit) # confidence intervals

predict(lm.fit, data.frame(lstat = (c(5, 10, 15))), interval = "confidence")
predict(lm.fit, data.frame(lstat = (c(5, 10, 15))), interval = "prediction")

plot(lstat, medv) 
abline(lm.fit) # Plot f(x) fitted

# The abline can be used to draw any line
abline(lm.fit) # Plot f(x) fitted
abline(lm.fit, lwd = 3)
abline(lm.fit, lwd = 3, col = "red")
plot(lstat, medv, col = "red")
plot(lstat, medv, pch = "+")
plot(1:20, 1:20, pch = 1:20)

# Compute residuals of a linear regression
plot(predict(lm.fit), residuals(lm.fit))

# Compute studentized residuals of a linear regression
plot(predict(lm.fit), rstudent(lm.fit))

# On the basis of the residual plots, there is some evidence of non-linearity
# Compute leverage statistics
plot(hatvalues(lm.fit))
which.max(hatvalues(lm.fit)) # Index of largest element

# MULTIPLE LINEAR REGRESSION
lm.fit = lm(medv ~ lstat + age, data = Boston)
summary(lm.fit)

# fitting with all of 13 predictors
lm.fit = lm(medv ~ ., data = Boston)
summary(lm.fit)
?summary.lm # help for lm
summary(lm.fit)$r.sq # R-squared
summary(lm.fit)$sigma # RSE
vif(lm.fit) # Collinearity VIF measure

# Fitting a MLR for all predictors except one
lm.fit1 = lm(medv ~ .-age, data = Boston)
summary(lm.fit1)
lm.fit1 = update(lm.fit, ~ .-age)

# Interaction Terms
summary(lm(medv ~ lstat*age, data = Boston)) # Add two predictiors and a interaction term between both
summary(lm(medv ~ lstat + age + lstat:age, data = Boston)) # Add two predictiors and a interaction term between both

# Non-Linear Transformation
lm.fit2 = lm(medv ~ lstat + I(lstat^2))
summary(lm.fit2)

# Quantify the extent which the quadratic fit is superior to the linear fit
lm.fit = lm(medv ~ lstat)
anova(lm.fit, lm.fit2)

par(mfrow = c(2,2))
plot(lm.fit2)

# Fifth-order polynomial fit
lm.fit5 = lm(medv ~ poly(lstat, 5))
summary(lm.fit5)

# Log transformation
summary(lm(medv ~ log(rm), data = Boston))


# QUALITATIVE PREDICTORS
fix(Carseats)
names(Carseats)
lm.fit = lm(Sales ~ . + Income:Advertising + Price:Age, data = Carseats)
summary(lm.fit)

attach(Carseats)
contrasts(ShelveLoc)
?contrasts
