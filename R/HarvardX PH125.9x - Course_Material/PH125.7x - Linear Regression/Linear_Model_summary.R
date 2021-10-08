library(tidyverse)
library(broom)
library(Lahman)
options(digits = 3)

# Pre Processing data
Team_small <- Teams %>%
  filter(yearID %in% 1961:2001) %>%
  mutate(avg_attendance = attendance/G, 
         run_per_game = R/G,
         HR_per_game = HR/G)

# Fitting a model Avg_Attendance = beta0 + beta1*Runs_per_game)
Team_small %>%
  do(tidy(lm(avg_attendance ~ run_per_game, data = .), conf.int = TRUE))

# Fitting a model Avg_Attendance = beta0 + beta1*Home_Runs_per_game)
Team_small %>%
  do(tidy(lm(avg_attendance ~ HR_per_game, data = .), conf.int = TRUE))

# Fitting a model Avg_Attendance = beta0 + beta1*Wins)
Team_small %>%
  do(tidy(lm(avg_attendance ~ W, data = .), conf.int = TRUE))

# Fitting a model Avg_Attendance = beta0 + beta1*Year)
Team_small %>%
  do(tidy(lm(avg_attendance ~ yearID, data = .), conf.int = TRUE))

# Correlation between wins and runs_per_game
cor(Team_small$W, Team_small$run_per_game)

# Correlation between wins and home_runs_per_game
cor(Team_small$W, Team_small$HR_per_game)

# Find Win Stratum with more than 20 data_points
Team_small_w_strata <- Team_small %>%
  mutate(win_strata = round(W/10, 0)) %>%
  filter(win_strata >=5 & win_strata <= 10 )

sum(Team_small_w_strata$win_strata == 5)
sum(Team_small_w_strata$win_strata == 6)
sum(Team_small_w_strata$win_strata == 7)
sum(Team_small_w_strata$win_strata == 8)
sum(Team_small_w_strata$win_strata == 9)
sum(Team_small_w_strata$win_strata == 10)

# Function to get slope and standard errror for each win stratum
get_slope <- function(data, Y, X){
  fit <- lm(Y ~ X, data = data)
  data.frame(slope = fit$coefficients[2], 
             se = summary(fit)$coefficient[2,2])
}

# Getting slope and standard error for Average Attendance = intercept + slope*run_per_game
Team_small_w_strata %>%
  group_by(win_strata) %>%
  do(get_slope(., .$avg_attendance, .$run_per_game))

# Getting slope and standard error for Average Attendance = intercept + slope*home_run_per_game
Team_small_w_strata %>%
  group_by(win_strata) %>%
  do(get_slope(., .$avg_attendance, .$HR_per_game))

# Multivariate Regression: Average_Attendance = beta0 + beta1*runs_per_game + beta2*HR_per_game + beta3*wins + beta4*yearID
fit <- Team_small %>%
  do(tidy(lm(avg_attendance ~ run_per_game + HR_per_game + W + yearID, data = .)))

# Evaluating Mutivariate Regression Model
run_pg <- 5
HR_pg <- 1.2
Wg <- 80
year <- 1960
eval <- fit$estimate[1] + fit$estimate[2]*run_pg + fit$estimate[3]*HR_pg + fit$estimate[4]*Wg + fit$estimate[5]*year

# Creating a column with predicted Average Attendance for Teams on 2002
Teams_p <- Teams %>%
  filter(yearID == 2002) %>%
  mutate(avg_attendance = attendance/G, 
         run_per_game = R/G,
         HR_per_game = HR/G) %>%
  mutate(attendance_predict = fit$estimate[1] + fit$estimate[2]*.$run_per_game + fit$estimate[3]*.$HR_per_game + fit$estimate[4]*.$W + fit$estimate[5]*.$yearID) %>%
  select(avg_attendance, attendance_predict)

# Correlation between real and predicted attendance average
cor(Teams_p$avg_attendance, Teams_p$attendance_predict)
