library(dslabs)
library(dplyr)
library(tidyverse)
library(Lahman)
ds_theme_set()

# Examine data from 1961 to 2001
# Scatter plor for Home Runs Per Game Vs. Runs per game
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_per_game = HR/G,
         R_per_game = R/G) %>%
  ggplot(aes(HR_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  labs(title = "Home Runs Vs. Runs") + # graph title
  ylab("Runs (per Game)") + # x label title
  xlab("Home Runs (per Game)") + # y label title
  theme(plot.title = element_text(hjust = 0.5)) # Title centered
# Teams with more runs tended to score more runs

# Relationship between stolen bases and wins
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(SB_per_game = SB/G,
         R_per_game = R/G) %>%
  ggplot(aes(SB_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  labs(title = "Stolen Bases Vs. Runs") +
  ylab("Runs (per game)") +
  xlab("Stolen Bases (per game") +
  theme(plot.title = element_text(hjust = 0.5))
# Not clear Relationship.

# Relationship between Bases on Balls and Runs
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(BB_per_game = BB/G,
         R_per_game = R/G) %>%
  ggplot(aes(BB_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  labs(title = "Bases on Balls Vs. Runs") +
  ylab("Runs (per game)") +
  xlab("Bases on Balls (per game") +
  theme(plot.title = element_text(hjust = 0.5))
# Teams with more Bases on Balls tended to have more runs

# Relationship between At Bats and Runs
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(AB_per_game = AB/G,
         R_per_game = R/G) %>%
  ggplot(aes(AB_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  labs(title = "At Bats Vs. Runs") +
  ylab("Runs (per game)") +
  xlab("At Bats (per game") +
  theme(plot.title = element_text(hjust = 0.5))
# Teams with more bats tended to have more runs

# Relationship between Win rate and Fielding errors
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(WR_per_game = W/G,
         E_per_game = E/G) %>%
  ggplot(aes(WR_per_game, E_per_game)) +
  geom_point(alpha = 0.5) +
  labs(title = "Winning Rate Vs. Fielding Errors") +
  ylab("Fielding Errors (per game)") +
  xlab("Winning rate") +
  theme(plot.title = element_text(hjust = 0.5))
# Teams with less errors tended to have more wins

# Relationship between Triples and Doubles
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(X3B_per_game = X3B/G,
         X2B_per_game = X2B/G) %>%
  ggplot(aes(X3B_per_game, X2B_per_game)) +
  geom_point(alpha = 0.5) +
  labs(title = "Triples Vs. Doubles") +
  ylab("Triples (per game)") +
  xlab("Doubles (per game") +
  theme(plot.title = element_text(hjust = 0.5))
# Teams with more bats tended to have more runs

# Correlation coeficient between runs and bats
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(AB_per_game = AB/G,
         R_per_game = R/G) %>%
  summarize(cor(AB_per_game, R_per_game))

# Correlation coeficient between Wins runs and Errors
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(W_per_game = W/G,
         E_per_game = E/G) %>%
  summarize(cor(W_per_game, E_per_game))

# Correlation coeficient between X2B and X3B
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(X3B_per_game = X3B/G,
         X2B_per_game = X2B/G) %>%
  summarize(cor(X2B_per_game, X3B_per_game))
