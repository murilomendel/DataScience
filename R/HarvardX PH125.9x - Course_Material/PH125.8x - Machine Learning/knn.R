library(dslabs)
library(caret)
library(purrr)
# K-Nearest Neighboors Study

# Fitting binomial smoother for comparisson purpose
fit_glm <- glm(y ~ x_1 + x_2, data = mnist_27$train, family = "binomial")
p_hat_logistic <- predict(fit_glm, mnist_27$test)
y_hat_logistic <- factor(ifelse(p_hat_logistic > 0.5, 7, 2))
confusionMatrix(data = y_hat_logistic, reference = mnist_27$test$y)$overall[1]

# K-Nearest Neighboors Fit
?knn3

# Quicker simple way to call knn
knn_fit <- knn3(y ~ ., data = mnist_27$train, k = 5) # First way to call this function (formula, dataset)

# Indicate for larger datasets
x <- as.matrix(mnist_27$train[,2:3])
y <- mnist_27$train$y
knn_fit <- knn3(x, y) # Second way to call this function (matrix of predictors, vector of outcomes)

# Predictions
y_hat_knn <- predict(knn_fit, mnist_27$test, type = "class")
confusionMatrix(data = y_hat_knn, reference = mnist_27$test$y)$overall["Accuracy"]

ks <- seq(3,251,2)


accuracy <- map_df(ks, function(k){
  fit <- knn3(y ~ ., data = mnist_27$train, k = k)
  y_hat <- predict(fit, mnist_27$train, type = "class")
  cm_train <- confusionMatrix(data = y_hat, reference = mnist_27$train$y)
  train_error <- cm_train$overall["Accuracy"]
  y_hat <- predict(fit, mnist_27$test, type = "class")
  cm_test <- confusionMatrix(data = y_hat, reference = mnist_27$test$y)
  test_error <- cm_test$overall["Accuracy"]
  
  list(train = train_error, test = test_error)
})


#pick the k that maximizes accuracy using the estimates built on the test data
ks[which.max(accuracy$test)]
max(accuracy$test)


# Heights dataset for Knn study
set.seed(1)
test_index <- createDataPartition(heights$height, times = 1, p = 0.5, list = FALSE)

train <- heights[-test_index,]
test <- heights[test_index,]

ks <- seq(1,101,3)

F_1 <- sapply(ks, function(k){
  fit <- knn3(sex ~ height, data = train, k = k)
  y_hat <- predict(fit, test, type = "class") %>%
    factor(levels = levels(train$sex))
  F_meas(data = y_hat, reference = test$sex)
})

plot(ks, F_1)
max(F_1)
ks[which.max(F_1)]

# Gene Dataset for knn study
data("tissue_gene_expression")
set.seed(1)

test_index <- createDataPartition(tissue_gene_expression$y, times = 1, p = 0.5, list = FALSE)

train_x = tissue_gene_expression$x[-test_index,]
test_x = tissue_gene_expression$x[test_index,]

train_y <- tissue_gene_expression$y[-test_index]
test_y <- tissue_gene_expression$y[test_index]

ks <- seq(1,11,2)

accuracy <- sapply(ks, function(k){
  fit <- knn3(train_x, train_y, k = k)
  y_hat <- predict(fit, test_x, type = "class")
  confusionMatrix(data = y_hat, reference = test_y)$overall["Accuracy"]
})

accuracy

set.seed(1)
library(caret)
y <- tissue_gene_expression$y
x <- tissue_gene_expression$x
test_index <- createDataPartition(y, list = FALSE)
sapply(seq(1, 11, 2), function(k){
  fit <- knn3(x[-test_index,], y[-test_index], k = k)
  y_hat <- predict(fit, newdata = data.frame(x=x[test_index,]),
                   type = "class")
  mean(y_hat == y[test_index])
})
