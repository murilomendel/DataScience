## Simple Linear Regression

# Reading Dataset
dataset <- read.csv('./input/Salary_Data.csv')


# Splitting into training/test
base::set.seed(123)
split <- sample.split(dataset$Salary, SplitRatio = 2/3)

training_set <- base::subset(dataset, split == TRUE)
test_set <- base::subset(dataset, split == FALSE)


# Fitting Linear Model
regressor = stats::lm(formula = Salary ~ YearsExperience,
                       data = training_set)

base::summary(regressor)

# Predicting on Test Set
y_pred <- stats::predict(regressor, newdata = test_set)


# Plotting Results

# Training Set
ggplot() +
  geom_point(aes(x = training_set$YearsExperience, y = training_set$Salary),
             colour = 'red') +
  geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
            colour = 'blue') +
  ggtitle('Salary Vs. Experience (Training Set') +
  xlab('Years of Experience') +
  ylab('Salary')

# Test Set
ggplot() +
  geom_point(aes(x = test_set$YearsExperience, y = test_set$Salary),
             colour = 'red') +
  geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
            colour = 'blue') +
  ggtitle('Salary Vs. Experience (Test Set') +
  xlab('Years of Experience') +
  ylab('Salary')
