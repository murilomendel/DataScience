library(tidyverse)
library(dplyr)
library(dslabs)

# Bayesian Statistics
# Randomly selecting 100000 people
# 1 in 3900 for the disease prevalence in the population
prev <- 0.00025
N <- 100000
outcome <- sample(c("Disease", "Healthy"), N, replace = TRUE, prob = c(prev, 1-prev))

N_D <- sum(outcome == "Disease")
N_H <- sum(outcome == "Healthy")

# Test accuracy has 99%
accuracy <- 0.99
test <- vector("character", N)

# Testing Individuals
test[outcome == "Disease"] <- sample(c("+", "-"), N_D, replace = TRUE, prob = c(accuracy, 1-accuracy))
test[outcome == "Healthy"] <- sample(c("-", "+"), N_H, replace = TRUE, prob = c(accuracy, 1-accuracy))

# Crearing results table
table(outcome, test)

