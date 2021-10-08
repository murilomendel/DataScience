library(dslabs)
library(dplyr)
library(tidyverse)
library(HistData)
library(Lahman)
ds_theme_set()
options(digits = 3)


data("GaltonFamilies")

set.seed(1983)
galton_heights <- GaltonFamilies %>%
  filter(gender == "male") %>%
  group_by(family) %>%
  sample_n(1) %>%
  ungroup() %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

rss <- function(beta0, beta1, data){
  resid <- galton_heights$son - (beta0+beta1*galton_heights$father)
  return(sum(resid^2))
}

# plot RSS as a function of beta1 when beta0=25
beta1 = seq(0, 1, len=nrow(galton_heights))
results <- data.frame(beta1 = beta1,
                      rss = sapply(beta1, rss, beta0 = 36))
results %>% ggplot(aes(beta1, rss)) + geom_line() + 
  geom_line(aes(beta1, rss))

fit <- lm(son ~ father, data = galton_heights)
summary(fit)
fit$coefficients
# Monte Carlo simulation
B <- 1000
N <- 50
lse <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>% 
    lm(son ~ father, data = .) %>% 
    .$coef 
})
lse <- data.frame(beta_0 = lse[1,], beta_1 = lse[2,]) 

# Plot the distribution of beta_0 and beta_1
library(gridExtra)
p1 <- lse %>% ggplot(aes(beta_0)) + geom_histogram(binwidth = 5, color = "black") 
p2 <- lse %>% ggplot(aes(beta_1)) + geom_histogram(binwidth = 0.1, color = "black") 
grid.arrange(p1, p2, ncol = 2)



dat <- Teams %>%
  filter(yearID %in% 1961:2001) %>%
  mutate(HR_per_game = HR/G,
         BB_per_game = BB/G,
         R_per_game = R/G)

# R_per_game = B0 + B1*HR_per_game + B2*BB_per_game
lm(R_per_game ~ HR_per_game + BB_per_game, data = dat)
lm(R_per_game ~ BB_per_game, data = dat)

set.seed(1989)

female_heights <- GaltonFamilies %>%     
  filter(gender == "female") %>%     
  group_by(family) %>%     
  sample_n(1) %>%
  ungroup() %>%     
  select(mother, childHeight) %>%     
  rename(daughter = childHeight)
female_heights


fit_f <- female_heights %>% lm(mother ~ daughter, data = .)
fit_f
summary(fit_f)
cor(female_heights$mother, female_heights$daughter)

Y <- predict(fit_f, se.fit = TRUE)
fit_f$coefficients[1] + fit_f$coefficients[2] * female_heights$daughter[1]
