# LINEAR REGRESSION FOR PREDICTION
library(caret)
options(digits = 3)

# Creating Data Set
set.seed(1)
n <- 100
Sigma <- 9*matrix(c(1, 0.5,0.5,1), 2, 2)

dat <- MASS::mvrnorm(n = 100, c(69, 69), Sigma) %>%
  data.frame() %>% setNames(c("x", "y"))

# Fitting n models and evaluating it RMSA
set.seed(1)
RMSE <- replicate(n,{
  test_index = createDataPartition(dat$y, p = 0.5, list = FALSE)
  test_set <- dat[test_index,]
  train_set <- dat[-test_index,]
  fit <- lm(y ~ x, data = train_set)
  y_hat <- predict(fit, test_set)
  sqrt(mean((y_hat - test_set$y)^2)) 
})

mean(RMSE)
sd(RMSE)

# Larger Datasets
n <- c(100, 500, 1000, 5000, 10000)

foo <- function(n){
  dat <- MASS::mvrnorm(n, c(69, 69), Sigma) %>%
    data.frame() %>% setNames(c("x", "y"))
  replicate(100, {
      test_index <- createDataPartition(dat$y, p = 0.5, list = FALSE)
      test_set <- dat %>% slice(test_index)
      train_set <- dat %>% slice(-test_index)
      fit <- lm(y ~ x, data = train_set)
      y_hat <- predict(fit, test_set)
      sqrt(mean((y_hat - test_set$y)^2))
  })
}

set.seed(1)
result <- sapply(n, foo, simplify = FALSE)
mean(result[[1]])
sd(result[[1]])
mean(result[[2]])
sd(result[[2]])
mean(result[[3]])
sd(result[[3]])
mean(result[[4]])
sd(result[[4]])
mean(result[[5]])
sd(result[[5]])

# Increasing correlation between x and y
set.seed(1)
n <- 100
Sigma <- 9*matrix(c(1, 0.95,0.95,1), 2, 2)
dat <- MASS::mvrnorm(n = 100, c(69, 69), Sigma) %>%
  data.frame() %>% setNames(c("x", "y"))

# Fitting n models and evaluating it RMSA
set.seed(1)
RMSE <- replicate(n,{
  test_index = createDataPartition(dat$y, p = 0.5, list = FALSE)
  test_set <- dat[test_index,]
  train_set <- dat[-test_index,]
  fit <- lm(y ~ x, data = train_set)
  y_hat <- predict(fit, test_set)
  sqrt(mean((y_hat - test_set$y)^2)) 
})

mean(RMSE)
sd(RMSE)

# Question 6 Dataset
set.seed(1)
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.25, 0.75, 0.25, 1.0), 3, 3)
dat <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
  data.frame() %>% setNames(c("y", "x_1", "x_2"))

test_index <- createDataPartition(dat$y, times = 1, p = 0.5, list = FALSE)
test_set <- dat %>% slice(test_index)
train_set <- dat %>% slice(-test_index)

fit_x1 <- lm(y ~ x_1, data = train_set)
fit_x2 <- lm(y ~ x_2, data = train_set)
fit_x12 <- lm(y ~ x_1 + x_2, data = train_set)

y_hat_x1 <- predict(fit_x1, test_set)
y_hat_x2 <- predict(fit_x2, test_set)
y_hat_x12 <- predict(fit_x12, test_set)

RMSE_x1 <- sqrt(mean((y_hat_x1 - test_set$y)^2))
RMSE_x2 <- sqrt(mean((y_hat_x2 - test_set$y)^2))
RMSE_x12 <- sqrt(mean((y_hat_x12 - test_set$y)^2))

RMSE_x1
RMSE_x2
RMSE_x12


# X_1 and X_2 are high correlated
set.seed(1)
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.95, 0.75, 0.95, 1.0), 3, 3)
dat <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
  data.frame() %>% setNames(c("y", "x_1", "x_2"))
