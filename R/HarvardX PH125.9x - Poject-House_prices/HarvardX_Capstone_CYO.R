##########################################################
# Create Ames House Price set, validation set (best fitting models: k-fold, cross validation)
##########################################################

# Note: this process could take a couple of minutes

library(tidyverse)
library(caret)
library(data.table)
library(ggplot2)
library(knitr)
library(stringr)
library(readr)
library(rpart)
library(leaps)
library(corrplot)
library(randomForest)
library(forecast)

# The data was downloaded from: https://www.kaggle.com/c/house-prices-advanced-regression-techniques/
# The downloaded file is stored in the project current directory, inside the \data folder
setwd("C:/Users/muril/Documents/_projects/DataScience/R/HarvardX PH125.9x - Poject-House_prices")

# Read the train and test .csv file
HP <- as.data.frame(read_csv(file.path(getwd(),"/data/train.csv"), col_names = TRUE))

# Dealing with features with high null ratio
missing_rows <- HP[!complete.cases(HP),]
nrow(missing_rows) # At first, there are 1460 missing rows

# Checking the quantity of NULL values for each column, and remove columns with more than 40% NULL values
for(col in colnames(HP)){
  null_percent = length(which(is.na(HP[[col]]))) / length(HP[[col]])
  if(null_percent > 0.4){
    HP[[col]] <- NULL
  }
}

# After the first clean, there are still 366 missing rows
missing_rows <- HP[!complete.cases(HP),]
head(missing_rows)
nrow(missing_rows)
rm(missing_rows)

# Dealing with null values
# Summary of NAs per columns
NAcol <- which(colSums(is.na(HP)) > 0)
sort(colSums(sapply(HP[NAcol], is.na)), decreasing = TRUE)

# LotFrontaage Variable = 259 NAs
sum(is.na(HP$LotFrontage))

# Plotting the variable over the Neighborhoods possibilities
ggplot(HP[!is.na(HP$LotFrontage),], aes(x=as.factor(Neighborhood), y=LotFrontage)) +
  geom_bar(stat='summary', fun.y = "median", fill='blue') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Complete the NAs with the median of it neighborhood
for (i in 1:nrow(HP)){
  if(is.na(HP$LotFrontage[i])){
    HP$LotFrontage[i] <- as.integer(median(HP$LotFrontage[HP$Neighborhood==HP$Neighborhood[i]], na.rm=TRUE)) 
  }
}

# Garage Type Variable = 81 NAs
HP$GarageType[is.na(HP$GarageType)] <- 'No Garage'
HP$GarageFinish[is.na(HP$GarageFinish)] <- 'None'
HP$GarageQual[is.na(HP$GarageQual)] <- 'None'
HP$GarageCond[is.na(HP$GarageCond)] <- 'None'
HP$GarageYrBlt[is.na(HP$GarageYrBlt)] <- HP$YearBuilt[is.na(HP$GarageYrBlt)]
table(HP$GarageType)

# Basement Variables = 37 NAs
HP[!is.na(HP$BsmtExposure) & (is.na(HP$BsmtFinType2)|is.na(HP$BsmtQual)|is.na(HP$BsmtCond)|is.na(HP$BsmtFinType1)), c('BsmtExposure', 'BsmtFinType1', 'BsmtQual', 'BsmtCond', 'BsmtFinType2')]
HP$BsmtFinType2[333] <- names(sort(-table(HP$BsmtFinType2)))[1]

HP$BsmtExposure[is.na(HP$BsmtExposure)] <- 'None'
HP$BsmtQual[is.na(HP$BsmtQual)] <- 'None'
HP$BsmtCond[is.na(HP$BsmtCond)] <- 'None'
HP$BsmtFinType1[is.na(HP$BsmtFinType1)] <- 'None'
HP$BsmtFinType2[is.na(HP$BsmtFinType2)] <- 'None'# Separating numerical and categorical features

# Masonry veneer features = 8 NAs
HP$MasVnrType[is.na(HP$MasVnrType)] <- 'None'
HP$MasVnrArea[is.na(HP$MasVnrArea)] <-0

# Electrical Information
HP$Electrical[is.na(HP$Electrical)] <- names(sort(-table(HP$Electrical)))[1]

# Separating to choose the best variables
HP.categorical <- HP[sapply(HP, is.character)]
HP.numerical <- HP[sapply(HP, is.numeric)]

# Numerical features first look
# Calculating features correlation
numericalFeatures.correlation <- cor(HP.numerical, use = "pairwise.complete.obs")
numericalFeatures.correlation

corrplot(numericalFeatures.correlation, tl.col="black", tl.pos = "lt")

# Categorical feature first look
set.seed(1)
quick_RF <- randomForest(x=HP.categorical[1:1460,-76], y=HP.categorical$SalePrice[1:1460], ntree=100,importance=TRUE)
imp_RF <- importance(quick_RF)
imp_DF <- data.frame(Variables = row.names(imp_RF), MSE = imp_RF[,1])
imp_DF <- imp_DF[order(imp_DF$MSE, decreasing = TRUE),]

# Features with most importance
ggplot(imp_DF[1:20,], aes(x=reorder(Variables, MSE), y=MSE, fill=MSE)) + geom_bar(stat = 'identity') + labs(x = 'Variables', y= '% increase MSE if variable is randomly permuted') + coord_flip() + theme(legend.position="none")

# From these plot, we can select the numerical features with high correlation to the target variable 
selected_var <- c('LotFrontage','LotArea', 'OverallQual','YearBuilt','MasVnrArea',
                  'TotalBsmtSF','1stFlrSF','GrLivArea','FullBath','TotRmsAbvGrd',
                  'Fireplaces','GarageCars','GarageArea','Foundation','BsmtQual',
                  'ExterQual','KitchenQual','Exterior2nd','GarageType','Exterior1st',
                  'Neighborhood','HeatingQC','GarageFinish','BsmtFinType1','MSZoning',
                  'SalePrice')

HP <- HP[,selected_var]

HP[sapply(HP, is.character)] <- lapply(HP[sapply(HP, is.character)], as.factor)
HP[sapply(HP, is.factor)] <- lapply(HP[sapply(HP, is.factor)], as.numeric)


# Validation set will be 10% of train data
set.seed(1, sample.kind = "Rounding")
validation_index <- createDataPartition(y = HP$SalePrice,
                                        times = 1,
                                        p = 0.1,
                                        list = F)

HP.validation <- HP[validation_index,]
HP.train <- HP[-validation_index,]

rm(validation_index)


# The distribution is near to the normal distribution, instead of the houses which coasts more than $400,000
# These fact make the distribution edge to the left

# Machine Learning modeling

# Naive Approach

mean(HP$SalePrice) # Mean Sale Price is $180,921.2
sd(HP$SalePrice) # Standard Deviation is $79,442.5

mu <- mean(HP$SalePrice)

naive.rmse = RMSE(HP.validation$SalePrice, mu)
rmse.results <- tibble(Model = "01. Mean Sale Price Approach(Naive)",
                       RMSE = naive.rmse)

kable(rmse.results)


# Linear Regression

linearRegression.fit <- lm(SalePrice ~ ., data = HP.train)

linearRegression.predict <- predict(linearRegression.fit, newdata = HP.validation)
linearRegression.rmse <- RMSE(linearRegression.predict, HP.validation$SalePrice)

rmse.results <- rmse.results %>%
  bind_rows(tibble(Model = "02. Linear Regression",
                   RMSE = linearRegression.rmse))

kable(rmse.results)


# Decision Tree

decisionTree.fit <- rpart(SalePrice~.,
                          data = HP.train,
                          control = rpart.control(cp = 0.01))

plotcp(decisionTree.fit)

decisionTree.predict <- predict(decisionTree.fit,
                                newdata = HP.validation)

decisionTree.rmse <- RMSE(decisionTree.predict, HP.validation$SalePrice)

rmse.results <- rmse.results %>%
  bind_rows(tibble(Model = "03. Decision Tree",
                   RMSE = decisionTree.rmse))


# Lasso Regression

set.seed(27, sample.kind = "Rounding")
lasso.fit <- train(x = HP.train[,-26], y = HP.train$SalePrice,
                   method ='glmnet',
                   trControl = trainControl(method="cv", number=5),
                   tuneGrid = expand.grid(alpha = 1, lambda = seq(0.001,0.1,by = 0.0005))) 
lasso.fit$bestTune
lasso.rmse <- min(lasso.fit$results$RMSE)

rmse.results <- rmse.results %>%
  bind_rows(tibble(Model = "04. Lasso Regression",
                   RMSE = lasso.rmse))


