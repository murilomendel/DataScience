library(dslabs)

data("research_funding_rates")

research_funding_rates

# Two by Two table of (men/women) Vs(awarded/not_awarded)
two_by_two <- research_funding_rates %>%
  select(-discipline) %>%
  summarize_all(funs(sum)) %>%
  summarize(yes_men = awards_men,
            no_men = applications_men - awards_men,
            yes_women = awards_women,
            no_women = applications_women - awards_women) %>%
  gather %>%
  separate(key, c("awarded", "gender")) %>%
  spread(gender, value)
two_by_two         

# Percentage of men awarded
two_by_two$men[2]/sum(two_by_two$men)*100

# Percentage of women awarded
two_by_two$women[2]/sum(two_by_two$women)*100

chisq_test <- two_by_two %>% select(-awarded) %>% chisq.test()
chisq_test


# Simpsons PArados????
dat <- research_funding_rates %>% 
  mutate(discipline = reorder(discipline, success_rates_total)) %>%
  rename(success_total = success_rates_total,
         success_men = success_rates_men,
         success_women = success_rates_women) %>%
  gather(key, value, -discipline) %>%
  separate(key, c("type", "gender")) %>%
  spread(type, value) %>%
  filter(gender != "total")

dat %>% ggplot(aes(discipline, success, col = gender, size = applications)) + geom_point()

admissions %>% ggplot(aes(major, admitted, col = gender, size = applicants)) + geom_point()
