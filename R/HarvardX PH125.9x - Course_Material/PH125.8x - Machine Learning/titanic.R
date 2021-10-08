library(titanic)
library(caret)
library(tidyverse)
library(rpart)

options(digits = 3) # 3 significant digits

# Clean the data
titanic_clean <- titanic_train %>%
  mutate(Survived = factor(Survived),
         Embarked = factor(Embarked),
         Age = ifelse(is.na(Age), median(Age, na.rm = TRUE), Age),
         FamilySize = SibSp + Parch + 1) %>%
  select(Survived, Sex, Pclass, Age, Fare, SibSp, Parch, FamilySize, Embarked)

set.seed(42)

# Question 1
# Partitioning the data set inte train (80%) and test (20%)
test_index <- createDataPartition(titanic_clean$Survived, times = 1, p = 0.2, list = FALSE)

train <- titanic_clean[-test_index,]
test <- titanic_clean[test_index,]

# Proportion of survivers into training set
mean(train$Survived == 1)

# Question 2
set.seed(3)

# Randomly guessing y_hat
y_hat <- sample(c(0, 1), size = nrow(test), replace = TRUE)

# Random Model Accuracy
mean(as.factor(y_hat) == test$Survived)

# Proportion of females which Survived on training set
sum(train$Survived == 1 & train$Sex == "female") / sum(train$Sex == "female")

# Proportion of males which Survived on training set
sum(train$Survived == 1 & train$Sex == "male") / sum(train$Sex == "male")


# Predict Survived for women and not Survived for men
y_hat_s <- ifelse(test$Sex == "female", 1, 0)

# Model Accuracy
mean(as.factor(y_hat) == test$Survived)

# Which class passengers are more likely to survive than die
sum(train$Survived == 1 & train$Pclass == 1) / sum(train$Pclass == 1) # 1st Class
sum(train$Survived == 1 & train$Pclass == 2) / sum(train$Pclass == 2) # 2nd Class
sum(train$Survived == 1 & train$Pclass == 3) / sum(train$Pclass == 3) # 3rd Class

# Other way to compute survivals over Pclass
train %>% group_by(Pclass) %>%
  summarize(Survived = mean(Survived == 1))

# Predict Survived for 1st Class and not Survived for 2nd and 3rd
y_hat_c <- ifelse(test$Pclass == 1, 1, 0)

# Model Accuracy
mean(as.factor(y_hat) == test$Survived)

# Which sex and class combination are more likely to survive
train %>% group_by(Sex, Pclass) %>%
  summarize(Survived = mean(Survived == 1),
            Died = mean(Survived == 0))

# Predict female 1st and 2nd class combinatio survived and others died
y_hat_sc <- ifelse((test$Pclass < 3) & (test$Sex == "female") , 1, 0)

# Model Accuracy
mean(as.factor(y_hat) == test$Survived)

# Confusion MAtrices
# Sex Model
cm_s <- table(predicted = y_hat_s, actual = test$Survived)
cm_c <- table(predicted = y_hat_c, actual = test$Survived)
cm_sc <- table(predicted = y_hat_sc, actual = test$Survived)

confusionMatrix(data = factor(y_hat_s), reference = factor(test$Survived))
confusionMatrix(data = factor(y_hat_c), reference = factor(test$Survived))
confusionMatrix(data = factor(y_hat_sc), reference = factor(test$Survived))


# Sensitivity
sensitivity(cm_s)
sensitivity(cm_c)
sensitivity(cm_sc)

# Specificity
specificity(cm_s)
specificity(cm_c)
specificity(cm_sc)

# F-Score
F_meas(cm_s)
F_meas(cm_c)
F_meas(cm_sc)

# LDA Model to predict Survival from Fare
set.seed(1)
fit_lda <- train(Survived ~ Fare, data = train, method = "lda")
y_hat_lda <- predict(fit_lda, test)
confusionMatrix(data = y_hat_lda, reference = test$Survived)$overall["Accuracy"]

# QDA Model to predict Survival from Fare
set.seed(1)
fit_qda <- train(Survived ~ Fare, data = train, method = "qda")
y_hat_qda <- predict(fit_qda, test)
confusionMatrix(data = y_hat_qda, reference = test$Survived)$overall["Accuracy"]

# Logistic Regression
set.seed(1)
fit_glm <- train(Survived ~ Sex + Pclass + Fare + Age,
                 data = train,
                 method = "glm")
y_hat_glm <- predict(fit_glm, test)
confusionMatrix(data = y_hat_glm, reference = test$Survived)$overall["Accuracy"]

# KNN model
set.seed(6)
fit_knn <- train(Survived ~ .,
                 method = "knn",
                 tuneGrid = data.frame(k = seq(3, 51, 2)),
                 data = train)

# Optimal value of k
fit_knn$bestTune

# Accuracy Vs Neighbors (k)
plot(fit_knn)

y_hat_knn <- predict(fit_knn, test)
confusionMatrix(data = y_hat_knn, reference = test$Survived)$overall["Accuracy"]

# Cross-Validation on KNN with 10 fold where each partition consists of 10% of the total
set.seed(8)
fit_knn <- train(Survived ~ .,
                 method = "knn",
                 trControl = trainControl(method = "cv", number = 10, p = 0.9),
                 tuneGrid = data.frame(k = seq(3, 51, 2)),
                 data = train)
fit_knn$bestTune
y_hat_knn <- predict(fit_knn, test)
confusionMatrix(data = y_hat_knn, reference = test$Survived)$overall["Accuracy"]

# Classification Tree Model
set.seed(10)
fit_rpart <- train(Survived ~ .,
                   method = "rpart",
                   tuneGrid = data.frame(cp = seq(0, 0.05, 0.002)),
                   data = train)
fit_rpart$bestTune
y_hat_rpart <- predict(fit_rpart, test)
confusionMatrix(data = y_hat_rpart, reference = test$Survived)$overall["Accuracy"]

plot(fit_rpart$finalModel, margin = 0.1)
text(fit_rpart$finalModel, cex = 0.75)

# Random Forests model
set.seed(14)
fit_rf <- train(Survived ~ .,
                method = "rf",
                tuneGrid = data.frame(mtry = seq(1,7,1)),
                ntree = 100,
                data = train)
fit_rf
fit_rf$bestTune
y_hat_rf <- predict(fit_rf, test)
confusionMatrix(data = y_hat_rf, reference = test$Survived)$overall["Accuracy"]
varImp(fit_rf)
