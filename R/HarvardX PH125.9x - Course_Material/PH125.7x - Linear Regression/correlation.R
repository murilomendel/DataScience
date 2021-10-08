library(dslabs)
library(dplyr)
library(tidyverse)
library(HistData)

options(digits = 3)

data("GaltonFamilies")
galton_heights <- GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)
galton_heights

# Considering both are normal distributions, it's possible to compute each mean and standard deviation
galton_heights %>% summarize(mean(father), sd(father), mean(son), sd(son))

# Plotting both heights on a scatter plot to see it relationship
galton_heights %>% ggplot(aes(father, son)) +
  geom_point() +
  labs(title = "Father Heights Vs. Son Heights") +
  ylab("Son Height (inches)") +
  xlab("Father height (inches)") +
  theme(plot.title = element_text(hjust = 0.5))

# It's possible to define a correlation coeficient
galton_heights %>% summarize(cor(father, son))

# Sample correlation is a Random variable
set.seed(0)
R <- sample_n(galton_heights, 25, replace = TRUE) %>% 
  summarize(cor(father, son))
R

# Monte-Carlo simulation to see the distribution of it random variable
B <- 10000
N <- 25
R <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>%
  summarize(r = cor(father, son)) %>% .$r
})
data.frame(R) %>% ggplot(aes(R)) + geom_histogram(binwidth = 0.05, color = "black")

mean(R)

#-----------------------------------------------------------------------------------#
# Correlation is not always a good summary of the relationship between two variables.

# Predicted height of a son with a 72 inch tall father
conditional_avg <- galton_heights %>% filter(round(father) == 72) %>%
  summarize(avg = mean(son)) %>% .$avg
conditional_avg

# ----------------------------------------------------------------------------------#
# Correlation is not always a good summary of the relationship between two variables.

# Stratify father's heights to make a boxplot of son heights
galton_heights %>% mutate(father_strata = factor(round(father))) %>%
  ggplot(aes(father_strata, son)) +
  geom_boxplot() +
  geom_point() +
  labs(title = "Father height factors Vs. son height") +
  ylab("Son Height (inch)s") +
  xlab("Father Height (inch)") +
  theme(plot.title = element_text(hjust = 0.5))


# Scatterplot for father heights Vs Son Average height for each factos with a line wich slope is equal to the correlation
r <- galton_heights %>% summarize(r = cor(father, son)) %>% .$r
galton_heights %>%
  mutate(father = round(father)) %>%
  group_by(father) %>%
  summarize(son = mean(son)) %>%
  mutate(z_father = scale(father), z_son = scale(son)) %>%
  ggplot(aes(z_father, z_son)) +
  geom_point() +
  geom_abline(intercept = 0, slope = r) +
  labs(title = "Father height factors Vs. son height") +
  ylab("Son Height (inch)") +
  xlab("Father Height (inch)") +
  theme(plot.title = element_text(hjust = 0.5))


# Assetment
set.seed(1989)
library(HistData)
data("GaltonFamilies")

# Filtering data for mother and daughter
female_heights <- GaltonFamilies %>%
  filter(gender == "female") %>%
  group_by(family) %>%
  sample_n(1) %>%
  ungroup() %>%
  select(mother, childHeight) %>%
  rename(daughter = childHeight)

# Mean, standard deviation and rô coeficients
mu_x <- mean(female_heights$mother)
mu_y <- mean(female_heights$daughter)
s_x <- sd(female_heights$mother)
s_y <- sd(female_heights$daughter)
r <- cor(female_heights$mother, female_heights$daughter)

m_1 <- r * s_y / s_x
b_1 <- mu_y - m_1*mu_x

m_2 <- r * s_x / s_y
b_2 <- mu_x - m_2*mu_y
r*r*100
