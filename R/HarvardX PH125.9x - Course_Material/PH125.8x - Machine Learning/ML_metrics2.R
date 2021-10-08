library(caret)
data(iris)

# Removing setosa Specie
iris <- iris[-which(iris$Species=='setosa'),]
y <- iris$Species

set.seed(2)

test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE )

test <- iris[test_index,]
train <- iris[-test_index,]

# Analysing Features mean values for Iris Virginica and Versicolor
train %>% filter(Species == "virginica") %>% summarize(mean(Sepal.Length), mean(Sepal.Width), mean(Petal.Length), mean(Petal.Width))
train %>% filter(Species == "versicolor") %>% summarize(mean(Sepal.Length), mean(Sepal.Width), mean(Petal.Length), mean(Petal.Width))


# examine accuracy for Sepal Length
cutoff_sl <- seq(min(train$Sepal.Length), max(train$Sepal.Length), by = 0.1)
accuracy_sl <- map_dbl(cutoff_sl, function(x){
  y_hat <- ifelse(train$Sepal.Length > x, "virginica", "versicolor") %>% 
    factor(levels = levels(test$Species))
  mean(y_hat == train$Species)
})
cutoff_sl
accuracy_sl

# examine accuracy for Sepal Length
cutoff_sw <- seq(min(train$Sepal.Width), max(train$Sepal.Width), by = 0.1)
accuracy_sw <- map_dbl(cutoff_sw, function(x){
  y_hat <- ifelse(train$Sepal.Width > x, "virginica", "versicolor") %>% 
    factor(levels = levels(test$Species))
  mean(y_hat == train$Species)
})
cutoff_sw
accuracy_sw

# examine accuracy for Sepal Length
cutoff_pl <- seq(min(train$Petal.Length), max(train$Petal.Length), by = 0.1)
accuracy_pl <- map_dbl(cutoff_pl, function(x){
  y_hat <- ifelse(train$Petal.Length > x, "virginica", "versicolor") %>% 
    factor(levels = levels(test$Species))
  mean(y_hat == train$Species)
})

cutoff_pl
accuracy_pl

# examine accuracy for Sepal Length
cutoff_pw <- seq(min(train$Petal.Width), max(train$Petal.Width), by = 0.1)
accuracy_pw <- map_dbl(cutoff_pw, function(x){
  y_hat <- ifelse(train$Petal.Width > x, "virginica", "versicolor") %>% 
    factor(levels = levels(test$Species))
  mean(y_hat == train$Species)
})
cutoff_pw
accuracy_pw

max(accuracy_pl)
max(accuracy_pw)
max(accuracy_sl)
max(accuracy_sw)


# Smallest and Smartest way
foo <- function(x){
  rangedValues <- seq(range(x)[1],range(x)[2],by=0.1)
  sapply(rangedValues,function(i){
    y_hat <- ifelse(x>i,'virginica','versicolor')
    mean(y_hat==train$Species)
  })
}
predictions <- apply(train[,-5],2,foo)
sapply(predictions,max)	

# Smart Petal length cutoff
cutoff_pl[which.max(accuracy_pl)]

# Computing model accuracy for Petal Length cutoff = 4.7
y_hat <- ifelse(test$Petal.Length > cutoff_pl[which.max(accuracy_pl)], "virginica", "versicolor") %>% factor(levels = levels(test$Species))
mean(test$Species == y_hat)


# Checking if other feature could achieve best results in test set
foo <- function(x){
  rangedValues <- seq(range(x)[1],range(x)[2],by=0.1)
  sapply(rangedValues,function(i){
    y_hat <- ifelse(x>i,'virginica','versicolor')
    mean(y_hat==test$Species)
  })
}
predictions <- apply(test[,-5],2,foo)
sapply(predictions,max)	

# Exploratory data analysis
plot(iris,pch=21,bg=iris$Species)

# Considering both (Petal_length > cutoff_pl) OR (Petal_width > cutoff_pw)
y_hat <- ifelse((test$Petal.Length > cutoff_pl[which.max(accuracy_pl)]) |
                (test$Petal.Width > cutoff_pw[which.max(accuracy_pw)]), "virginica", "versicolor") %>%
  factor(levels = levels(test$Species))
mean(test$Species == y_hat)

