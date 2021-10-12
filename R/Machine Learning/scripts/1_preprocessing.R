## Data Preprocessing ##

library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(caTools)

# Suppose a simple dataset:
# - Country (Categorical): France, Spain, Germany.
# - Age (Numerical).
# - Salary (Numerical).
# - Purchased (Categorical): Response


# 1) Reading dataset
dataset <- read.csv('./input/Data.csv')


# 2) Replacing missing value
dataset$Age <- base::ifelse(base::is.na(dataset$Age),
                            ave(dataset$Age, FUN = function(x) mean(x, na.rm = TRUE)),
                            dataset$Age)

dataset <- dataset %>% 
  dplyr::mutate_at('Salary', ~base::ifelse(base::is.na(.), base::mean(dataset$Salary, na.rm = TRUE), .))


# 3) Encoding categorical data
dataset$Country = base::factor(dataset$Country,
                               levels = c('France', 'Spain', 'Germany'),
                               labels = c(1, 2, 3))

dataset$Purchased = base::factor(dataset$Purchased,
                               levels = c('No', 'Yes'),
                               labels = c(0, 1))


# 4) Splitting data into training and test.
base::set.seed(123)
split <- sample.split(dataset$Purchased, SplitRatio = 0.8)

training_set <- base::subset(dataset, split == TRUE)
test_set <- base::subset(dataset, split == FALSE)


# 5) Feature Scaling
training_set[, 2:3] = base::scale(training_set[, 2:3])
test_set[, 2:3] = base::scale(test_set[, 2:3])
