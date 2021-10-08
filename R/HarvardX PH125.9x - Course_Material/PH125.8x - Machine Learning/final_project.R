library(dslabs)
library(dplyr)
library(tidyverse)
library(matrixStats)
library(RColorBrewer)
library(caret)

data("brca")
modelLookup("gamLoess")
options(digits = 3)

# Vector of calssifications: B = Benign, M = Malign
brca$y

# Properties of shape and size of cell nuclei extrated from biopsy microscope image
brca$x

# Sample size
length(brca$y)
dim(brca$x)[1]

# Number of predictiors
length(colnames(brca$x))
dim(brca$x)[2]

# Proportion of malignants
mean(brca$y == "M")

# Highest Mean Column
which.max(colMeans(brca$x))

# Lowest Standard Deviation Column
which.min(colSds(brca$x))

# Calculatinf columns Mean and Standard Deviations
brca_colmeans <- colMeans(brca$x)
brca_colstds <- colSds(brca$x)

# Subtracting the mean on each row
x_centered <- sweep(brca$x, 2, brca_colmeans)
# Dividing each row by standard error
x_scaled <- sweep(x_centered, 2, brca_colstds, FUN = "/")

colMedians(swp)[1]
colSds(swp)[1]

# OR
sd(x_scaled[,1])
median(x_scaled[,1])

malign_index <- which(brca$y == "M")
benign_index <- which(brca$y == "B")

# Samples Distance
d_samples <- dist(x_scaled)

dist_BtoB <- as.matrix(d_samples)[1, brca$y == "B"]
mean(dist_BtoB[2:length(dist_BtoB)])

dist_BtoM <- as.matrix(d_samples)[1, brca$y == "M"]
mean(dist_BtoM)

# Scaled Matrix Heatmap
d_features <- dist(t(x_scaled))
heatmap(as.matrix(d_features), labRow = NA, labCol = NA)

# Clustering 30 features
h <- hclust(d_features)
groups <- cutree(h, k = 5)
split(names(groups), groups)


# PCA ANALYSIS
pc <- prcomp(x_scaled)
summary(pc) # Cumulative Proportion is the amount of data explained till this component
summary(pc)$importance[3,]

# Scatter plot of PC1 Vs PC2 colored by tumor type
data.frame(pc_1 = pc$x[,1], pc_2 = pc$x[,2],
           classification = brca$y) %>%
  ggplot(aes(pc_1, pc_2, color = classification)) +
  geom_point()

# Boxplot of 10 first PCs gouped by tumor type
data.frame(type = brca$y, pc$x[,1:10]) %>%
  gather(key = "PC", value = "value", -type) %>%
  ggplot(aes(PC, value, fill = type)) +
  geom_boxplot()


# Partitioning data set into training and testing
set.seed(1)    # if using R 3.6 or later
test_index <- createDataPartition(brca$y, times = 1, p = 0.2, list = FALSE)
test_x <- x_scaled[test_index,]
test_y <- brca$y[test_index]
train_x <- x_scaled[-test_index,]
train_y <- brca$y[-test_index]

# Prportion of taining set that is benign
mean(train_y == "B")

# Prportion of test set that is benign
mean(test_y == "B")

# Takes a matrix of observations x, and a k-means object k as input
predict_kmeans <- function(x, k) {
  centers <- k$centers    # extract cluster centers
  # calculate distance to cluster centers
  distances <- sapply(1:nrow(x), function(i){
    apply(centers, 1, function(y) dist(rbind(x[i,], y)))
  })
  max.col(-t(distances))  # select cluster with min distance to center
}


# Kmeans Model
set.seed(3)
k <- kmeans(train_x, centers = 2)
kmeans_pred <- ifelse(predict_kmeans(as.matrix(test_x), k) == 1,"B", "M")
mean(kmeans_pred == test_y)

# Benignant Tumors
b_index <- which(test_y == "B")

# Proportion of Benigns Tumors correctly predicted
mean(kmeans_pred[b_index] == "B")
sensitivity(factor(kmeans_pred), test_y, positive = "B")

# Malignant Tumors
m_index <- which(test_y == "M")

# Proportion of Maligns Tumors correctly predicted
mean(kmeans_pred[m_index] == "M")
sensitivity(factor(kmeans_pred), test_y, positive = "M")


# Logistic Regression
fit_logreg <- train(train_x, train_y, method = "glm")
logreg_pred = predict(fit_logreg, newdata = test_x)
mean(logreg_pred == test_y)

# QDA and LDA Model
fit_qda <- train(train_x, train_y, method = "qda")
fit_lda <- train(train_x, train_y, method = "lda")
qda_pred <- predict(fit_qda, test_x)
lda_pred <- predict(fit_lda, test_x)
mean(qda_pred == test_y)
mean(lda_pred == test_y)

# LOESS Model
set.seed(5)
fit_loess <- train(train_x, train_y, method = "gamLoess")
loess_pred <- predict(fit_loess, test_x)
mean(loess_pred == test_y)

# KNN Model
set.seed(7)
fit_knn <- train(train_x, train_y, method = "knn",
                 tuneGrid = data.frame(k = seq(3,21,1)))
knn_pred <- predict(fit_knn, test_x)
mean(knn_pred == test_y)
fit_knn$bestTune

# Random Forests Model
set.seed(9)
fit_rf <- train(train_x, train_y, method = "rf",
                tuneGrid = data.frame(mtry = seq(3, 9, 2)),
                importance = TRUE)
rf_pred <- predict(fit_rf, test_x)
fit_rf$bestTune
mean(rf_pred == test_y)
varImp(fit_rf)

# Ensemble Model - k-means, logistic regression, LDA, QDA, loess, k-nearest neighbors, and random forest

ensemble <- cbind(glm = logreg_pred == "B", lda = lda_pred == "B", qda = qda_pred == "B", loess = loess_pred == "B", rf = rf_pred == "B", knn = knn_pred == "B", kmeans = kmeans_pred == "B")

ensemble_pred <- ifelse(rowMeans(ensemble) > 0.5, "B", "M")
mean(ensemble_preds == test_y)

models <- c("K means", "Logistic regression", "LDA", "QDA", "Loess", "K nearest neighbors", "Random forest", "Ensemble")
accuracy <- c(mean(kmeans_pred == test_y),
              mean(logreg_pred == test_y),
              mean(lda_pred == test_y),
              mean(qda_pred == test_y),
              mean(loess_pred == test_y),
              mean(knn_pred == test_y),
              mean(rf_pred == test_y),
              mean(ensemble_pred == test_y))
data.frame(Model = models, Accuracy = accuracy)
