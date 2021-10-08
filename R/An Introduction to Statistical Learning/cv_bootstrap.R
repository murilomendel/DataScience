# CROSS-VALIDATION AND BOOTSTRAP

library(ISLR)
library(boot)
set.seed(1, sample.kind = "Rounding")
attach(Auto)

train = sample(392,196)

# Fitting linear Regression
lm.fit = lm(mpg ~ horsepower, data = Auto, subset = train)
mean((mpg-predict(lm.fit, Auto))[-train]^2) # MSE for fit 1

# Fitting Quadradic Linear Regression
lm.fit2 = lm(mpg ~ poly(horsepower,2), data = Auto, subset = train)
mean((mpg-predict(lm.fit2, Auto))[-train]^2) # MSE for fit 1

# Fitting Cubic Linear Regression
lm.fit3 = lm(mpg ~ poly(horsepower,3), data = Auto, subset = train)
mean((mpg-predict(lm.fit3, Auto))[-train]^2) # MSE for fit 1

# If we choose a different training set instead, then we will obtain somewhat different errors on the validation set.
set.seed(2, sample.kind = "Rounding")

train=sample (392 ,196)

# Fitting linear Regression
lm.fit =lm(mpg???horsepower ,subset =train)
mean((mpg -predict (lm.fit ,Auto))[-train ]^2)

# Fitting Quadradic Linear Regression
lm.fit2=lm(mpg???poly(horsepower ,2) ,data=Auto ,subset =train )
mean((mpg -predict (lm.fit2 ,Auto))[-train ]^2)

# Fitting Cubic Linear Regression
lm.fit3=lm(mpg???poly(horsepower ,3) ,data=Auto ,subset =train )
mean((mpg -predict (lm.fit3 ,Auto))[-train ]^2)


# LEAVE-ONE-OUT CROSS-VALIDATION (LOOCV)
# Fitting Linear Regression
glm.fit = glm(mpg ~ horsepower, data = Auto)
coef(glm.fit)

# Showing both functions are the same
lm.fit = lm(mpg ~ horsepower, data = Auto)
coef(lm.fit)


# Fitting a Linear Regression
glm.fit = glm(mpg ~ horsepower, data = Auto)

cv.err = cv.glm(Auto, glm.fit)
cv.err$delta # Cross-Validation Error (LOOCV)


# Fitting for different polynoms
cv.error = rep(0,5)
for(i in 1:5){
  glm.fit = glm(mpg ~poly(horsepower,i), data = Auto)
  cv.error[i] = cv.glm(Auto, glm.fit)$delta[1]
}

cv.error

# K-FOLD CROSS-VALIDATION
set.seed(17, sample.kind = "Rounding")
cv.error.10 = rep(0,10)
for(i in 1:10){
  glm.fit = glm(mpg ~ poly(horsepower, i), data = Auto)
  cv.error.10[i] = cv.glm(Auto, glm.fit, K = 10)$delta[1]
}
cv.error.10

# BOOTSTRAP
# Function to evaluate alpha given the data and some indexes
alpha.fn = function(data, index){
  X = data$X[index]
  Y = data$Y[index]
  return((var(Y) - cov(X, Y))/(var(X) + var(Y) - 2*cov(X, Y)))
}
alpha.fn(Portfolio, 1:100)

set.seed(1, sample.kind = "Rounding")
# Bootstraping the data
alpha.fn(Portfolio, sample(100, 100, replace = TRUE))

boot(Portfolio, alpha.fn, R = 1000)

# Linear regression 
boot.fn=function (data ,index){
  return (coef(lm(mpg???horsepower ,data=data ,subset =index)))
}
boot.fn(Auto ,1:392)


set.seed (1, sample.kind = "Rounding")
boot.fn(Auto ,sample (392 ,392 , replace =T))

boot.fn(Auto ,sample (392 ,392 , replace =T))


boot(Auto, statistic = boot.fn, R = 1000)
