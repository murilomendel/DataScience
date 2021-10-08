library(purr)
library(tidyverse)
library(stringr)
library(dplyr)
library(rvest)
library(readr)
library(lubridate)
library(dslabs)
library(gutenbergr)
library(tidytext)
library(textdata)

data("stop_words")

options(digit = 3)


url <- "https://en.wikipedia.org/w/index.php?title=Opinion_polling_for_the_United_Kingdom_European_Union_membership_referendum&oldid=896735054"
tab <- read_html(url) %>% html_nodes("table")
polls <- tab[[5]] %>% html_table(fill = TRUE)
polls %>% head()
polls <- polls %>% setNames(c("dates", "remain", "leave", "undecided", "lead", "samplesize", "pollster", "poll_type", "notes"))
have_percent <- str_detect(polls$remain, "%$")
sum(have_percent)

as.numeric(str_replace(polls$remain, "%", ""))/100
parse_number(polls$remain)/100

str_replace_all(polls$undecided, "N/A", "0")
polls$undecided

temp <- str_extract_all(polls$dates, "\\d+\\s[a-zA-Z]{3,5}")
end_date <- sapply(temp, function(x) x[length(x)]) # take last element (handles polls that cross month boundaries)
end_date


data(brexit_polls)
ymd(brexit_polls$startdate) %>% month()

round_date(brexit_polls$enddate, unit = 'week') %>% filter(enddate == "2016-06-12")
brexit_polls %>% filter(round_date(enddate, unit = 'week') == "2016-06-12")
brexit_polls %>% filter(weekdays(enddate) == "domingo")

data("movielens")
movielens %>% head()
sort(table(year(ydm_hms(as_datetime(movielens$timestamp)))), decreasing = TRUE)
sort(table(hour(ymd_hms(as_datetime(movielens$timestamp)))), decreasing = TRUE)

gutenberg_metadata %>% head()
gutenberg_metadata %>% filter(str_detect(title, "Pride and Prejudice"))
gutenberg_works(title == "Pride and Prejudice")

# Tracking lines and chapters with mutate function
book <- gutenberg_download(1342) %>% 
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()

# Converting to tidy format
tidy_book <- book %>% unnest_tokens(word,text)

# Removing stop_words
tidy_book <- tidy_book %>%
  anti_join(stop_words)

# Removing token containing digits
tidy_book <- tidy_book %>%
  filter(!str_detect(word, "\\d"))

# Finding most common words
tidy_book %>% 
  count(word, sort = TRUE)

# Words appearing more than 100 times
tidy_book %>% 
  count(word, sort = TRUE) %>%
  filter(n >= 100)

# Loading afinn lexicon (sentiments)
afinn <- get_sentiments("afinn")

# Filtering by afinn words
afinn_sentiments <- tidy_book %>%
  inner_join(afinn)

afinn_sentiments
# Quantity of Afinn elements with positive value
afinn_sentiments %>% filter(value >= 0)


# # Quantity of Afinn elements with value equal 4
afinn_sentiments %>% filter(value == 4) %>%
  count()

