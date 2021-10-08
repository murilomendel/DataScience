library(dslabs)
library(dplyr)
library(tidyverse)
library(Lahman)
ds_theme_set()

# LINEAR MODELS

#Check confounding
# Stratification of Home Runs
dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_strata = round(HR/G, 1),
         BB_per_game = BB / G,
         R_per_game = R / G) %>%
  filter(HR_strata >= 0.4 & HR_strata <= 1.2)

# Scatterplot for each home run startum
dat %>%
  ggplot(aes(BB_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  facet_wrap( ~ HR_strata) +
  labs(title = "Relationship over Bases on Balls and Runs for eache Stratum of Home Runs") +
  ylab("Bases on Balls (per game)") +
  xlab("Runs (per_game)") +
  theme(plot.title = element_text(hjust = 0.5))

# Slope of regression line after stratifying by HR
dat %>%
  group_by(HR_strata) %>%
  summarize(slope = cor(BB_per_game, R_per_game)*sd(R_per_game)/sd(BB_per_game))


# Stratification of Bases on Balls
dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(BB_strata = round(BB/G, 1),
         HR_per_game = HR / G,
         R_per_game = R / G) %>%
  filter(BB_strata >= 2.8 & BB_strata <= 3.9)

# Scatterplot for each Base on Ball startum
dat %>%
  ggplot(aes(HR_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  facet_wrap( ~ BB_strata) +
  labs(title = "Relationship over Home Runs and Runs for eache Stratum of Bases on Balls") +
  ylab("Home Runs (per game)") +
  xlab("Runs (per_game)") +
  theme(plot.title = element_text(hjust = 0.5))

# Slope of regression line after stratifying by BB
dat %>%
  group_by(BB_strata) %>%
  summarize(slope = cor(HR_per_game, R_per_game)*sd(R_per_game)/sd(HR_per_game))
