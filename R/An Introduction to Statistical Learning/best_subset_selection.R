# SUBSET SELECTION METHODS
# Baseball Player's salary on the basis of various statistics assossiated with performance in previous years
library(ISLR)
fix(Hitters)
names(Hitters)

dim(Hitters)
sum(is.na(Hitters$Salary))

Hitters = na.omit(Hitters)
dim(Hitters)
sum(is.na(Hitters))

library(leaps) # Best subset selection package
#   performs best sub-set selection by identifying the best model that contains a given number
# of predictors, where best is quantified using RSS.
regfit.full = regsubsets(Salary ~ ., Hitters)
summary(regfit.full)

# Fitting up to a 19-variable model
regfit.full = regsubsets(Salary ~ ., data = Hitters, nvmax = 19)
reg.summary = summary(regfit.full) # returns R2, RSS, adjusted R2, Cp, and BIC.
names(reg.summary)

# R2 Summary
reg.summary$rsq

par(mfrow = c(1,2)) # Facet plot region in 4 (2x2)
plot(reg.summary$rss, xlab = "Number of Variables", ylab = "RSS", type = "l")

plot(reg.summary$adjr2, xlab = "Number of Variables", ylab = "Adjusted Rsq", type = "l")
which.max(reg.summary$adjr2) # identify the best model
points(11, reg.summary$adjr2[11], col = "red", cex = 2, pch = 20) # Insert a red point in the best model position 

plot(reg.summary$cp,  xlab = "Number of Variables", ylab = "Cp", type = "l")
which.min(reg.summary$cp)
points(10, reg.summary$cp[10], col = "red", cex = 2, pch = 20) # Insert a red point in the best model position 

plot(reg.summary$bic,  xlab = "Number of Variables", ylab = "BIC", type = "l")
which.min(reg.summary$bic)
points(6, reg.summary$bic[6], col = "red", cex = 2, pch = 20) # Insert a red point in the best model position 

#Check help function
?plot.regsubsets
plot(regfit.full, scale = "r2")
plot(regfit.full, scale = "adjr2")
plot(regfit.full, scale = "Cp")
plot(regfit.full, scale = "bic")

coef(regfit.full, 6)

# FORWARD AND BACKWARD STEPWISE SELECTION
# Forward Subset Selection
regfit.fwd = regsubsets(Salary ~ ., Hitters, nvmax = 19, method = "forward")
summary(regfit.fwd)

# Backward Subset Selection
regfit.bwd = regsubsets(Salary ~ ., Hitters, nvmax = 19, method = "backward")
summary(regfit.bwd)

# Comparing models - Best Seven Variable
coef(regfit.full, 7) # Best Subset Selection
coef(regfit.fwd, 7) # Best Forward Subset Selection
coef(regfit.bwd, 7) # Best Backward Subset Selection

# Creating random train and test data
set.seed(1, sample.kind = "Rounding")
train = sample(c(TRUE, FALSE), nrow(Hitters), rep = TRUE)
test = (!train)

regfit.best = regsubsets(Salary ~ ., data = Hitters[train,], nvmax = 19)
test.mat = model.matrix(Salary ~ ., Hitters[test,]) # Build "X" matrix from data

# Computing MSE of best subset selection from test dataset
val.errors = rep(NA, 19)
for(i in 1:19){
  coefi = coef(regfit.best, id = i)
  pred = test.mat[,names(coefi)] %*% coefi
  val.errors[i] = mean((Hitters$Salary[test]-pred)^2)
}

# Best Set contain 7 variables
val.errors
which.min(val.errors)
coef(regfit.best, 10)

# Own predict method
predict.regsubsets = function(object, newdata, id, ...){
  form = as.formula(object$call[[2]])
  mat = model.matrix(form, newdata)
  coefi = coef(object, id = id)
  xvars = names(coefi)
  mat[,xvars] %*% coefi
}

regfit.best = regsubsets(Salary ~ ., data = Hitters, nvmax = 19)
coef(regfit.best, 10)

# k-fold cross validation
k = 10 # 10 folds
set.seed(1, sample.kind = "Rounding")
folds = sample(1:k, nrow(Hitters), replace = TRUE)
cv.errors = matrix(NA, k, 19, dimnames = list(NULL, paste(1:19)))
cv.errors

for(j in 1:k){
  best.fit = regsubsets(Salary ~ ., data = Hitters[folds != j,], nvmax = 19)
  for(i in 1:19){
    pred = predict(best.fit, Hitters[folds == j,], id = 1)
    cv.errors[j,i] = mean((Hitters$Salary[folds == j] - pred)^2)
  }
}

mean.cv.errors = apply(cv.errors, 2, mean)
mean.cv.errors

par(mfrow = c(1,1))
plot(mean.cv.errors, type = 'b')

reg.best = regsubsets(Salary ~ ., data = Hitters, nvmax = 19)
coef(reg.best, 11)

# RIDGE AND LASSO REGRESSION
x = model.matrix(Salary ~ ., Hitters)[,-1] # automatically transforms any qualitative variables into dummy variables.
y = Hitters$Salary

# Ridge Regression
library(glmnet)
grid = 10^seq(10, -2, length = 100)
ridge.mod = glmnet(x, y, alpha = 0, lambda = grid)
ridge.mod
dim(coef(ridge.mod))

ridge.mod$lambda[50]
coef(ridge.mod)[,50]
sqrt(sum(coef(ridge.mod)[-1,50]^2))

ridge.mod$lambda[60]
coef(ridge.mod)[,60]
sqrt(sum(coef(ridge.mod)[-1,60]^2))

predict(ridge.mod, s = 50, type = "coefficients")[1:20,]

# Splitting the samples
set.seed(1, sample.kind = "Rounding")
train = sample(1:nrow(x), nrow(x)/2)
test = (-train)
y.test = y[test]

ridge.mod = glmnet(x[train,], y[train], alpha = 0, lambda = grid, thresh = 1e-12)
ridge.pred = predict(ridge.mod, s = 4, newx = x[test,])
mean((ridge.pred - y.test)^2)

# Lasso Regression

lasso.mod = glmnet(x[train,], y[train], alpha = 1, lambda = grid)
plot(lasso.mod)

# PCR 
library(pls)
pcr.fit = pcr(Salary ~ ., data = Hitters, scale = TRUE, validation = "CV")
