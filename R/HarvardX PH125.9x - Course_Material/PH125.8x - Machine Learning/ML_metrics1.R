library(dslabs)
library(dplyr)
library(lubridate)
library(tidyverse)
library(caret)
data(reported_heights)

options(digits = 3)

dat <- mutate(reported_heights, date_time = ymd_hms(time_stamp)) %>%
  filter(date_time >= make_date(2016, 01, 25) & date_time < make_date(2016, 02, 1)) %>%
  mutate(type = ifelse(day(date_time) == 25 & hour(date_time) == 8 & between(minute(date_time), 15, 30), "inclass","online")) %>%
  select(sex, type)

y <- factor(dat$sex, c("Female", "Male"))
x <- dat$type

dat_online <- dat %>%
  filter(type == "online")

dat_inclass <- dat %>%
  filter(type == "inclass")

# Percent of Female on online group
mean(dat_online$sex == "Female")

# PErcent of Female on inclass group
mean(dat_inclass$sex == "Female")

# Predictor
x <- dat$type

# Outcome
y <- dat$sex

# Computing model accuracy, given students which took online classes are Male and in person classes are Female 
y_hat <- ifelse(x == "online", "Male", "Female") %>% factor(levels = levels(as.factor(dat$sex)))
mean(y == y_hat)

# Confusion Matrix
cm <- table(predicted = y_hat, actual = y)

# Model Sensitivity
sensitivity(cm)
sensitivity(table(predicted = y_hat, actual = y))
sensitivity(y_hat, y)

# Model Specificity
specificity(y_hat, y)

# Prevalence of Females in the dataset
mean(dat$sex == "Female")

