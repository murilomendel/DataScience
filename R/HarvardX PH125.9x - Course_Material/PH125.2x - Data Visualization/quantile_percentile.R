library(tidyverse)
library(dslabs)
data(heights)

index <- heights$sex=="Male"
x <- heights$height[index]
z <- scale(x)

# proportion of data below 69.5
mean(x <= 69.5)

# calculate observed and theoretical quantiles
p <- seq(0.05, 0.95, 0.05)
observed_quantiles <- quantile(x, p)
theoretical_quantiles <- qnorm(p, mean = mean(x), sd = sd(x))

# make QQ-plot
plot(theoretical_quantiles, observed_quantiles)
abline(0,1)

# make QQ-plot with scaled values
observed_quantiles <- quantile(z, p)
theoretical_quantiles <- qnorm(p) 
plot(theoretical_quantiles, observed_quantiles)
abline(0,1)

# Percentiles
male <- heights$height[heights$sex=="Male"]
female <- heights$height[heights$sex=="Female"]
male_percentiles <- quantile(male, seq(.1, .9, .2))
female_percentiles <- quantile(female, seq(.1, .9, .2))
df <- data.frame(female = female_percentiles, male = male_percentiles)
print(df)
