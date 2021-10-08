library(caret)
library(dslabs)
library(tidyverse)

models <- c("glm", "lda", "naive_bayes", "svmLinear", "knn", "gamLoess", "multinom", "qda", "rf", "adaboost")

set.seed(1) # use `set.seed(1, sample.kind = "Rounding")` in R 3.6 or later
data("mnist_27")

# Fitting Models
fits <- lapply(models, function(model){ 
  print(model)
  train(y ~ ., method = model, data = mnist_27$train)
}) 

names(fits) <- models

# Matrix of predictions
predict <- sapply(fits, function(object)
  predict(object, newdata = mnist_27$test))

length(mnist_27$test$y)
length(models)

# Ensemble model accuracy
mean(predict == mnist_27$test$y)
acc <- colMeans(predict == mnist_27$test$y)
acc
mean(acc)


votes <- rowMeans(predict == 2) 
y_hat <- ifelse(votes > 0.5, 2, 7) %>% factor(levels(mnist_27$test$y))
mean(y_hat == mnist_27$test$y)
fits

# Model Accuracy
acc_hat <- sapply(fits, function(fit)
  min(fit$results$Accuracy))
mean(acc_hat)

# Select models with accuracy >= 0.8
best_model_index <- which(acc_hat >= 0.8)

# Matrix of predictions
predict_best <- sapply(fits[best_model_index], function(object)
  predict(object, newdata = mnist_27$test))

votes_best <- rowMeans(predict_best == 2)
y_hat_best <- ifelse(votes_best > 0.5, 2, 7) %>% factor(levels(mnist_27$test$y))
mean(y_hat_best == mnist_27$test$y)
