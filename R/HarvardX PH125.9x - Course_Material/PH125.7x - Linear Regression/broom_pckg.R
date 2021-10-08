library(dslabs)
library(tidyverse)
library(dplyr)
library(Lahman)
library(broom)
options(digits = 3)

data("Teams")
Teams
as_tibble(Teams)

dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_strata = round(HR/G, 1),
         BB_per_game = BB / G,
         R_per_game = R / G) %>%
  filter(HR_strata >= 0.4 & HR_strata <= 1.2)


dat %>%  
  group_by(HR) %>%
  do(tidy(lm(R ~ BB, data = .), conf.int = TRUE)) %>%
  filter(term == "BB") %>%
  select(HR, estimate, conf.low, conf.high)


set.seed(1) # if you are using R 3.5 or earlier

# Filtering by parent_child pair
galton <- GaltonFamilies %>%
  group_by(family, gender) %>%
  sample_n(1) %>%
  ungroup() %>% 
  gather(parent, parentHeight, father:mother) %>%
  mutate(child = ifelse(gender == "female", "daughter", "son")) %>%
  unite(pair, c("parent", "child"))

# Data size
sum(galton$pair == "father_daughter")
sum(galton$pair == "father_son")

# Filtering by pair
f_d <- galton %>% filter(pair == "father_daughter")
f_s <- galton %>% filter(pair == "father_son")
m_d <- galton %>% filter(pair == "mother_daughter")
m_s <- galton %>% filter(pair == "mother_son")

# Correlation Study
cor(f_d$childHeight, f_d$parentHeight)
cor(f_s$childHeight, f_s$parentHeight)
cor(m_d$childHeight, m_d$parentHeight)
cor(m_d$childHeight, m_d$parentHeight)

# Modelling father,daughter pair
galton %>%  
  group_by(pair) %>% 
  filter(pair == "father_daughter") %>%
  do(tidy(lm(childHeight ~ parentHeight, data = .), conf.int = TRUE)) %>%
  summarize(int = conf.high - conf.low)

# Modelling father,son pair
galton %>%  
  group_by(pair) %>% 
  filter(pair == "father_son") %>%
  do(tidy(lm(childHeight ~ parentHeight, data = .), conf.int = TRUE)) %>%
  summarize(int = conf.high - conf.low)

# Modelling mother, son pair  
galton %>%  
  group_by(pair) %>% 
  filter(pair == "mother_son") %>%
  do(tidy(lm(childHeight ~ parentHeight, data = .), conf.int = TRUE))

# Modelling mother, daughter pair
galton %>%  
  group_by(pair) %>% 
  filter(pair == "mother_daughter") %>%
  do(tidy(lm(childHeight ~ parentHeight, data = .), conf.int = TRUE)) %>%
  summarize(int = conf.high - conf.low)
