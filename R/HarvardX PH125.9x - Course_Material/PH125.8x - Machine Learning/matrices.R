library(tidyverse)
library(dslabs)
library(matrixStats)

# MATRICES
# Tranforming vector to matrix
my_vector <- 1:15
mat <- matrix(my_vector, 5, 3)
mat <- matrix(my_vector, 5, 3, byrow = TRUE)

# Recycle values of vector to fill the matrix
matrix(my_vector, 5, 5, byrow = TRUE)


# Import mnist data set
if(!exists("mnist")) mnist <- read_mnist()


x <- mnist$train$images[1:1000,]
y <- mnist$train$labels[1:1000]

grid <- matrix(x[3,], 28, 28)
image(1:28, 1:28, grid[, 28:1])

# Row and Column Summaries and Apply
sums <- rowSums(x)
avg <- rowMeans(x)
avg

# Plotting RowMean per Digit
data_frame(labels = as.factor(y), row_averages = avg) %>%
  qplot(labels, row_averages, data = ., geom = "boxplot")

avgs <- apply(x, 1, mean)
sds <- apply(x, 2, sd)

# Study the variation of each pixel and remove columns associated to pixels that don't change much
sds <- colSds(x)
qplot(sds, bins = "30", color = I("black"))
# Heat image for pixels with higher standard deviations
image(1:28, 1:28, matrix(sds, 28, 28)[, 28:1])

# Removing uninformative rows and columns
new_x <- x[ ,colSds(x) > 60]
dim(new_x)

# Preserve the matrix class
class(x[ , 1, drop = FALSE])
dim(x[ , 1, drop = FALSE])

# Histogram of all the predictors
qplot(as.vector(x), bins = 30, color = I("black"))

# Binarize the data
bin_x <- x
bin_x[bin_x < 255/2] <- 0
bin_x[bin_x > 255/2] <- 1
bin_X <- (x < 255/2)*1
bin_X

# Standarize a Matrix
x_mean_0 <- sweep(x, 2, colMeans(x)) # Subrtract
x_standarized <- sweep(x_mean_0, 2, colSds(x), FUN = "/") # divide by standard error
x_standarized

# Matrix multiplication is made by the following command: %*%
t(x) %*% x # Cross-product
crossprod(x)

# Compute inverse of a function
solve(x)

# qr decomposition
qr(x)

set.seed(1)
a <- replicate(1000,{
  sample(rnorm(1000), 100, replace = TRUE)
})

sd(a)
x <- matrix(rnorm(100*10), 100, 10)
dim(x)
nrow(x)
ncol(x)

x <- 1:nrow(x)
x <- sweep(x, 1, 1:nrow(x), "+")

my_vector <- matrix(rnorm(25), 5, 5)

x <- mnist$train$images
x > 50 & x < 205

sum(x > 50 & x < 205) / (60000*784)
