# Probability positive Test given disease person
p_positive_disease <- 0.85
# Probability positive Test given disease person
p_negative_disease <- 1 - p_positive_disease
# Probability of negative test given disease person
p_negative_healthy <- 0.90
# Probability of negative test given healthy person
p_positive_healthy<- 1 - p_negative_healthy
# Disease probability
p_disease <- 0.02
# Healthy probability
p_healthy <- 0.98
# Positive probability
p_positive <- p_positive_healthy*p_healthy + p_positive_disease*p_disease
# Negative probability
p_negative <- p_negative_healthy*p_healthy + p_negative_disease*p_disease

set.seed(1)
disease <- sample(c(0,1), size = 1e6, replace = TRUE, prob = c(0.98, 0.02))

test <- rep(NA, 1e6)
test[disease==0] <- sample(c(0,1), size = sum(disease == 0), replace = TRUE, prob = c(0.90, 0.10))
test[disease==1] <- sample(c(0,1), size = sum(disease == 1), replace = TRUE, prob = c(0.15, 0.85))

mean(test == 1)
mean(disease[which(test == 0)] == 1)
mean(disease[which(test == 1)] == 1)
mean(disease[which(test == 1)] == 1) / mean(disease == 1)
             
library(dslabs)
data("heights")

ps <- seq(0, 1, 0.1)

heights %>%
  mutate(g = cut(height, quantile(height, ps), include.lowest = TRUE)) %>%
  group_by(g) %>%
  summarize(p = mean(sex == "Male"), height = mean(height)) %>%
  qplot(height, p, data = .)

# Creating data from bivariate normal distribution
Sigma <- 9 * matrix(c(1,0.5,0.5,1), 2, 2)
dat <- MASS::mvrnorm(n = 10000, c(69, 69), Sigma) %>%
  data.frame() %>% setNames(c("x", "y"))

ps <- seq(0, 1, 0.1)
dat %>%
  mutate(g = cut(x, quantile(x, ps), include.lowest = TRUE)) %>%
  group_by(g) %>%
  summarize(y = mean(y), x = mean(x)) %>%
  qplot(x, y, data = .)
