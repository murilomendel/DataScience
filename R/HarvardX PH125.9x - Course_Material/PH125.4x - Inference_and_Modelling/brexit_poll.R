library(dslabs)
library(tidyverse)
library(dplyr)

options(digits = 3)
data("brexit_polls")

p <- 0.481 # oficcial proportion voting "Remain"
d <- 2*p-1 # oficial Spread

# Consider a poll with a sample N = 1500 voters
N <- 1500

# Expected total voters in the sample choosing "Remain"
total_remain_voters <- N*p

# Standard Error of the total number of voters in the sample choosing "Remain"
se_total_remain_voters <- sqrt(p*(1-p)*N)

# Expected value of x_hat
x_hat <- p

# Standard Error of x_hat
se_xhat <- sqrt(x_hat*(1-x_hat)/N)

# Expected value of spread
d <- 2*x_hat-1

# Standard Error of Spread
se_d <- 2*sqrt(p*(1-p)/N)

head(brexit_polls)

brexit_polls <- brexit_polls %>%
  mutate(x_hat = (spread + 1)/2)

# Mean of observed spread
mean(brexit_polls$spread)

# Standard Deviation of observed spread
sd(brexit_polls$spread)

# Average of x_hat
mean(brexit_polls$x_hat)

#Standard deviation of x_hat
sd(brexit_polls$x_hat)


# YouGov poll
brexit_polls[1,]
# mean
m <- mean(brexit_polls[1,]$x_hat)

# standard deviation
s <- sqrt(m*(1-m)/brexit_polls[1,]$samplesize)

# Upper band confidence interval 95%
ci_upbound <- m + 2*s
ci_upbound <- m + qnorm(0.95)*s

# Lower band confidence interval 95%1
ci_lowbound <- m - 2*s
ci_lowbound <- m - qnorm(0.95)*s
                        
june_polls <- brexit_polls %>%
  filter(enddate >= "2016-06-01") %>%
  mutate(se_x_hat = sqrt(x_hat*(1-x_hat)/samplesize),
         se_spread = 2*se_x_hat,
         low_bound = spread - qnorm(0.975)*se_spread,
         up_bound = spread + qnorm(0.975)*se_spread,
         hit = (low_bound <= -0.038 & up_bound >= -0.038))

mean(june_polls$low_bound < 0 & june_polls$up_bound > 0)
mean(june_polls$low_bound > 0)
mean(june_polls$hit)

june_polls %>% group_by(pollster) %>%
  summarise(mean(hit))

# Boxplot for pollsters of spread
june_polls %>% ggplot() +
  geom_boxplot(aes(poll_type, spread))  


# refactoring data frame
combined_by_type <- june_polls %>%
  group_by(poll_type) %>%
  summarize(N = sum(samplesize),
            spread = sum(spread*samplesize)/N,
            p_hat = (spread + 1)/2)

# Upper and lower bound for spreads
combined_by_type <- combined_by_type %>% mutate(lower = spread - (qnorm(0.975)*2*sqrt(p_hat*(1-p_hat)/N)),
                            upper = spread + (qnorm(0.975)*2*sqrt(p_hat*(1-p_hat)/N)))

combined_by_type$upper - combined_by_type$lower


# Defining brexit hit
brexit_hit <- brexit_polls %>%
  mutate(p_hat = (spread + 1)/2,
         se_spread = 2*sqrt(p_hat*(1-p_hat)/samplesize),
         spread_lower = spread - qnorm(.975)*se_spread,
         spread_upper = spread + qnorm(.975)*se_spread,
         hit = spread_lower < -0.038 & spread_upper > -0.038) %>%
  select(poll_type, hit)

brexit_hit_table <- table( brexit_hit$hit, brexit_hit$poll_type)

chisq_test <- table(brexit_hit$poll_type, brexit_hit$hit) %>% 
  chisq.test()

# Online Odds
odds_On <- (48 / (48+37)) / (37/ (48+37))

#Telephone Odds
odds_Tel <- (10 / (10+32)) / (32 / (10+32))

# Odds Ratio
odds_On/odds_Tel

brexit_polls

brexit_polls %>%
  ggplot(aes(enddate, spread, color = poll_type)) +
  geom_point() +
  geom_smooth(method = "loess") +
  ggtitle("Average Yearly Temperatures in New Haven")
