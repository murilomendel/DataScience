library(dplyr)
library(dslabs)
library(tidyverse)
# Simulating dataset for 1000 schools
set.seed(1986)
n <- round(2^rnorm(1000, 8, 1))

# Assign quality for schools
set.seed(1)
mu <- round(80 + 2*rt(1000, 5))
range(mu)
schools <- data.frame(id = paste("PS",1:1000),
                      size = n,
                      quality = mu,
                      rank = rank(-mu))

# Top 10 schools
schools %>% top_n(10, quality) %>% arrange(desc(quality))

# Simulating test scores
set.seed(1)

mu <- round(80 + 2*rt(1000, 5))

scores <- sapply(1:nrow(schools), function(i){
  scores <- rnorm(schools$size[i], schools$quality[i], 30)
  scores
})
schools <- schools %>% mutate(score = sapply(scores, mean))

# Top 10 schools based on test average score
schools %>% top_n(10, score) %>% arrange(desc(score)) %>% summarise(m = median(size))

median(schools$size)

# Bottom 10 schools based on test average score
schools %>% arrange(score) %>% slice(1:10) %>% summarise(m = median(size))
schools %>% top_n(-10, score) %>% summarise(m = median(size))

schools %>% ggplot(aes(size, score)) +
  geom_point(alpha = 0.5) +
  geom_point(data = filter(schools, rank<=10), col = 2)

# Ovearll average for all schools
overall <- mean(sapply(scores, mean))

# Regularization
alpha <- 25
score_reg <- sapply(scores, function(x)  overall + sum(x-overall)/(length(x)+alpha))
schools %>% mutate(score_reg = score_reg) %>%
  top_n(10, score_reg) %>% arrange(desc(score_reg))

# Top 10 after regularization
schools %>% top_n(10, reg_score) %>% arrange(desc(reg_score))

# Finding best value for alpha
alphas <- seq(10,250)
rmse <- sapply(alphas, function(alpha){
  score_reg <- sapply(scores, function(x) overall+sum(x-overall)/(length(x)+alpha))
  sqrt(mean((score_reg - schools$quality)^2))
})
plot(alphas, rmse)
alphas[which.min(rmse)]

# Regularization with correct alpha
alpha <- 135
score_reg <- sapply(scores, function(x)  overall + sum(x-overall)/(length(x)+alpha))
schools %>% mutate(score_reg = score_reg) %>%
  top_n(10, score_reg) %>% arrange(desc(score_reg))

# WRONG : Regularization without overall
alphas <- seq(10,250)
rmse <- sapply(alphas, function(alpha){
  score_reg <- sapply(scores, function(x) sum(x)/(length(x)+alpha))
  sqrt(mean((score_reg - schools$quality)^2))
})
plot(alphas, rmse)
alphas[which.min(rmse)]
