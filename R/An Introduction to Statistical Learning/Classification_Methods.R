library(ISLR)
library(MASS) # LDA, QDA
library(class) # KNN

names(Smarket) # Data set columns

dim(Smarket) # Data set dimensions

summary(Smarket) # Data set Summary

# There not seems to have a correlation between todays volume with the past days
cor(Smarket[,-9]) # Correlation between numerical variables

attach(Smarket) # fix dataset for further operations

# Volume is increasing over the time
plot(Volume) # plot volume variable


# ----------------------------------------------------------------------------------------------------------------------- #
# LOGISTIC REGRESSION
# ----------------------------------------------------------------------------------------------------------------------- #

# Logistic regression to predict Direction using lag1 to lag5 and volume
glm.fit <- glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
               data = Smarket,
               family = binomial)
summary(glm.fit)

# p-values are so high, which shows that it's not a very good approach
coef(glm.fit)
summary(glm.fit)$coef

glm.probs <- predict(glm.fit, type = "response") # type = "response" argument tells R to output probablities of the form P(Y = 1 | X)
glm.probs[1:10]

contrasts(Direction)
glm.pred = rep("Down", 1250)
glm.pred[glm.probs > 0.5] = "Up"


table(glm.pred, Direction)
mean(glm.pred == Direction) # Accuracy = (TN + TP)/ Sample Size


# Partitioning the data set into values from 2001 to 2004
train = (Year < 2005)
Smarket.2005 = Smarket[!train,]
dim(Smarket.2005)
Direction.2005 = Direction[!train]

# Fit the model using the training data (2001 to 2004)
glm.fit = glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
              data = Smarket,
              family = binomial,
              subset = train)

# Predict from 2005 data
glm.probs = predict(glm.fit, Smarket.2005, type = "response")

glm.pred = rep("Down", 252)
glm.pred[glm.probs > 0.5] = "Up"
table(glm.pred, Direction.2005)

mean(glm.pred == Direction.2005)
mean(glm.pred != Direction.2005)

# Refit by logistic regression using only the two predictors with the lowest p-value: Lag1, Lag2
glm.fit = glm(Direction ~ Lag1 + Lag2,
              data = Smarket,
              family = binomial,
              subset = train)
glm.probs = predict(glm.fit, Smarket.2005, type = "response")
glm.pred = rep("Down", 252)
glm.pred[glm.probs > 0.5] = "Up"
table(glm.pred, Direction.2005)
mean(glm.pred == Direction.2005)

# ----------------------------------------------------------------------------------------------------------------------- #
# LINEAR DISCRIMINANT ANALYSIS (LDA)
# ----------------------------------------------------------------------------------------------------------------------- #

# Fitting a LDA model for the same Smarket dataset
lda.fit = lda(Direction ~ Lag1 + Lag2,
              data = Smarket,
              subset = train)
lda.fit
plot(lda.fit)

lda.pred = predict(lda.fit, Smarket.2005)
names(lda.pred) 
lda.pred$x
# class: contains LDA's predictions about the movement of the market 
# posterior: is a matrix whose kth column contains the posterior probability that the corresponding observation belongs to the kth class.
# x: contains the linear discriminants

lda.class = lda.pred$class
table(lda.class, Direction.2005)
mean(lda.class == Direction.2005)

# Applying 50% threshold to the posterior probabilities ( posterio probability = probability that the market will decrease)
sum(lda.pred$posterior[,1] >= 0.5)
sum(lda.pred$posterior[,1] < 0.5)

# 90% threshold for marketing decrease
sum(lda.pred$posterior[,1] > 0.9)

# ----------------------------------------------------------------------------------------------------------------------- #
# QUADRATIC DISCRIMINANT ANALYSIS (QDA)
# ----------------------------------------------------------------------------------------------------------------------- #
qda.fit = qda(Direction ~ Lag1 + Lag2,
              data = Smarket,
              subset = train)
qda.fit

qda.class = predict(qda.fit, Smarket.2005)$class
table(qda.class, Direction.2005)
mean(qda.class == Direction.2005)

#  The 60% Accuracy suggest that the quadratic form assumed by QDA may capture the true relationship more accurately than the linear
# forms assumed by LDA and logistic regression.

# ----------------------------------------------------------------------------------------------------------------------- #
# K-NEAREST NEIGHBOORS (KNN)
# ----------------------------------------------------------------------------------------------------------------------- #

# Binding La1 and Lag2 columns
train.X = cbind(Lag1, Lag2)[train,]
test.X = cbind(Lag1, Lag2)[!train,]
train.Direction = Direction[train]

set.seed(1) # if several observations are tied as nearest neighbors, then R will randomly break the tie.
knn.pred = knn(train.X, test.X, train.Direction, k = 1)
table(knn.pred, Direction.2005)

knn.pred = knn(train.X, test.X, train.Direction, k = 3)
table(knn.pred, Direction.2005)


# Caravan Data Set Study
dim(Caravan)
attach(Caravan)
summary(Purchase)

# Standardizing the data so that all variables are given a mean of zero and a standard deviation of one. All variables will be on a comparable scale
standardized.X = scale(Caravan[,-86])
Caravan[,-86]
standardized.X

# Splitting observations into training and test set
test = 1:1000
train.X = standardized.X[-test,]
test.X = standardized.X[test,]
train.Y = Purchase[-test]
test.Y = Purchase[test]

set.seed(1)

knn.pred = knn(train.X, test.X, train.Y, k = 1)
mean(test.Y != knn.pred)
mean(test.Y != "No")
table(knn.pred, test.Y)

# Increasing k to 3
knn.pred = knn(train.X, test.X, train.Y, k = 3)
table(knn.pred, test.Y)

# Increasing k to 5
knn.pred = knn(train.X, test.X, train.Y, k = 5)
table(knn.pred, test.Y)


# Logistic regression fit for Caravan data set
glm.fit = glm(Purchase ~ ., data = Caravan, family = binomial, subset = -test)
glm.probs = predict(glm.fit, Caravan[test,], type = "response")
]
glm.pred = rep("No", 1000)
glm.pred[glm.probs > 0.5] = "Yes"
table(glm.pred, test.Y)

glm.pred = rep("No", 1000)
glm.pred[glm.probs > 0.25] = "Yes"
table(glm.pred, test.Y)
