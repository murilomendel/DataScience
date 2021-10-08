library(tidyverse)
library(caret)
library(genefilter)
library(dslabs)

data("mnist_27")

set.seed(1996)
n <- 1000
p <- 10000
x <- matrix(rnorm(n*p), n, p)
colnames(x) <- paste("x", 1:ncol(x), sep = "_")
y <- rbinom(n, 1, 0.5) %>% factor()

x_subset <- x[ , sample(p, 100)]

# Cross Validation with linear model
fit <- train(x_subset, y, method = "glm")
fit$results

# Evaluating most statistically significant values
tt <- colttests(x,y)
pvals <- tt$p.value

# Filtering p-values <= 0.01 keeping it indexes
tt %>% filter(p.value <= 0.01)

ind <- which(pvals <= 0.01)
length(ind)

# Redefining x_subset for the values most statistically significant
x_subset <- x[ ,ind]
fit <- train(x_subset, y, method = "glm")
fit$results

# Cross-Validation with Knn
fit <- train(x_subset, y, method = "knn", tuneGrid = data.frame(k = seq(101, 301, 25)))
ggplot(fit)


# Training Knn to select best k for gene expression dataset
fit <- train(tissue_gene_expression$x, tissue_gene_expression$y, method = "knn", tuneGrid = data.frame(k = seq(1,7,2)))
fit
ggplot(fit)


# BOOTSRAP STUDY
n <- 10^6
income <- 10^(rnorm(n, log10(45000), log10(3)))
qplot(log10(income), bins = 30, color = I("black"))

m <- median(income)
m

set.seed(1)
N <- 250
X <- sample(income, N)
M <- median(X)
M



# Bootstrap samples in an approximately normal distribution
B <- 10^5
M_stars <- replicate(B, {
  X_star <- sample(X, N, replace = TRUE)
  M_star <- median(X_star)
})

quantile(M, c(0.05, 0.95))

quantile(M_stars, c(0.05, 0.95))

set.seed(1995)

# Creating bootstrap samples
indexes <- createResample(mnist_27$train$y, 10)

# Number of times 3, 4 and 7 indexes appear
sum(indexes[[1]] == 3)
sum(indexes$Resample01 == 4)
sum(indexes$Resample01 == 7)

# Number of times index 3 appear on the entire bootstrap
x <- sapply(indexes, function(ind){
  sum(ind == 3)
})
sum(x)

y <- rnorm(100, 0, 1)
quantile(y, 0.75)

set.seed(1)

B <- 10^4
quantile_75 <- replicate(B, {
  y <- rnorm(100,0,1)
  quantile(y, 0.75)
})

mean(quantile_75)
sd(quantile_75)

# Bootstrap for y
indexes <- createResample(y, 10000)

quantile_bootstrap <- sapply(indexes, function(ind){
  boot_y <- y[ind]
  quantile(boot_y, 0.75)
})

mean(quantile_bootstrap)
sd(quantile_bootstrap)
