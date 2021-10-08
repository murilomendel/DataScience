# NON-LINEAR MODELLING
library(ISLR)
library(ggplot2)
library(dslabs)
library(tidyverse)
library(dplyr)
attach(Wage)

# Fitting polynomial regression
fit = lm(wage ~ poly(age,4), data = Wage)
coef(summary(fit))

fit2 = lm(wage ~ poly(age,4, raw = T), data = Wage)
coef(summary(fit2))

fit2a = lm(wage ~ age + I(age^2) + I(age^3) + I(age^4), data = Wage)
coef(summary(fit2a))

fit2b = lm(wage ~ cbind(age, age^24, age^3, age^4), data = Wage)
coef(summary(fit2a))

# Make predictions for each age band
agelims = range(age)
age.grid = seq(from = agelims[1], to = agelims[2])
preds = predict(fit, newdata = list(age = age.grid), se = TRUE)
se.bands = cbind(preds$fit + 2*preds$se.fit, preds$fit - 2 * preds$se.fit)
se.bands

# Plotting the results
par(mfrow = c(1,2), mar = c(4.5, 4.5, 1, 1), oma = c(0, 0, 4, 0))
plot(age, wage, xlim = agelims, cex = .5, col = "darkgrey")
title("Degree -4 Polynomial ",outer =T)
lines(age.grid, preds$fit, lwd = 2, col = "blue")
matlines(age.grid, se.bands, lwd = 1, col = "blue", lty = 3)

preds2 = predict(fit2, newdata = list(age = age.grid), se = TRUE)
max(abs(preds2$fit - preds$fit))

# Deciding which polynomial function to use with ANOVA function(Analysis of variance)
fit.1 = lm(wage ~age, data = Wage)
fit.2 = lm(wage ~poly(age,2), data = Wage)
fit.3 = lm(wage ~poly(age,3), data = Wage)
fit.4 = lm(wage ~poly(age,4), data = Wage)
fit.5 = lm(wage ~poly(age,5), data = Wage)
anova(fit.1, fit.2, fit.3, fit.4, fit.5)

# p-values are the same as ANOVA
coef(summary(fit.5))

# ANOVA works whether or not we used orthogonal polynomials
fit.1 = lm(wage ~ age, data = Wage)
fit.1 = lm(wage ~ education + poly(age, 2), data = Wage)
fit.1 = lm(wage ~ education + poly(age,3), data = Wage)
anova(fit.1, fit.2, fit.3)

# Cross-Validation
fit = glm(I(wage>250) ~ poly(age,4), data = Wage, family = binomial)
preds = predict(fit, newdata = list(age = age.grid), se = T)
pfit = exp(preds$fit)/(1 + exp(preds$fit))
se.bands.logit = cbind(preds$fit + 2*preds$se.fit, preds$fit - 2*preds$se.fit)
se.bands = exp(se.bands.logit)/(1 + exp(se.bands.logit))
preds = predict(fit, newdata = list(age = age.grid), type = "response", se = T)

# Right hand plot
plot(age, I(wage > 250), xlim = agelims, type = "n", ylim = c(0, .2))
points(jitter(age), I((wage > 250)/5), cex = .5, pch= "|", col = "darkgrey")
lines(age.grid, pfit, lwd = 2, col = "blue")
matlines(age.grid, se.bands, lwd = 1, col = "blue", lty = 3)
par(mfrow = c(1,1))


# SPLINES
library(splines)
fit = lm(wage ~ bs(age, knots = c(25, 40, 60)), data = Wage)
pred = predict(fit, newdata = list(age = age.grid), se = T)
plot(age, wage, col = "gray")
lines(age.grid, pred$fit, lwd = 2)
lines(age.grid, pred$fit + 2*pred$se, lty = "dashed")
lines(age.grid, pred$fit - 2*pred$se, lty = "dashed")

# GAMs
# 
gam1 = lm(wage ~ ns(year,4) + ns(age, 5) + education, data = Wage)

library(gam)
gam.m3 = gam(wage ~ s(year,4) + s(age,5) + education, data = Wage)
par(mfrow = c(1,3))
plot(gam.m3, se = TRUE, col = "blue")
