library(tree)
library(ISLR)
attach(Carseats)

# Create prediction variable
High = ifelse(Sales <= 8, "No", "Yes")

# Join the categorical prediction variable to the dataset
Carseats = data.frame(Carseats, High)

# Fit a Regression Tree
tree.carseats = tree(High ~ .-Sales, data = Carseats)
tree.carseats = tree(High???.-Sales, Carseats)
summary(tree.carseats)

plot(tree.carseats)

# Fitting Regression Trees
