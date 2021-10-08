library(tidyverse)
library(gridExtra)
library(dplyr)
library(dslabs)
data("polls_us_election_2016")

names(polls_us_election_2016)

# Filtering data by, state, end date, grade (keeping NAs)
polls <- polls_us_election_2016 %>% filter(state == "U.S." & enddate >= "2016-10-31" & (grade %in% c("A+", "A", "A-", "B+") | is.na(grade)))

# Adding Spread Estimate
polls <- polls %>% mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100)

# p is the proportion voting for Clinton
# (1 - p) is the proportion voting for Trump
# Spreads estimates are random variables with probability distribution that is approximately normal
# Expected value "d" is the election night spread
# Standard Error is 2*sqrt(p*(1-p)/N)

# Constructing a confidence interval based on the aggregated data
d_hat <- polls %>%
  summarize(d_hat = sum(spread * samplesize) / sum(samplesize)) %>%
  .$d_hat

# Estimated p
p_hat <- (d_hat+1)/2

# Getting the standard error
moe <- 1.96*2*sqrt(p_hat*(1-p_hat)/sum(polls$samplesize))

# Data appear not to be normal distributed
polls %>% ggplot(aes(spread)) +
  geom_histogram(color = "black", binwidth = .01)



# Data-Driven Models
# collect last result before the election for each pollster
one_poll_per_pollster <- polls %>% group_by(pollster) %>%
  filter(enddate == max(enddate)) %>%      # keep latest poll
  ungroup()

# histogram of spread estimates
one_poll_per_pollster %>%
  ggplot(aes(spread)) + geom_histogram(binwidth = 0.01)

# construct 95% confidence interval
results <- one_poll_per_pollster %>%
  summarize(avg = mean(spread), se = sd(spread)/sqrt(length(spread))) %>%
  mutate(start = avg - 1.96*se, end = avg + 1.96*se)
round(results*100, 1)

