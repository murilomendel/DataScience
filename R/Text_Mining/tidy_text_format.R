library(tidyverse)
library(dplyr)
library(tidytext)

data("stop_words")


# TIDY TEXT FORMAT -> A table with ONE-TOKEN-PER-ROW

#Text NOT in tidy text format
text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

# Converting text to a tibble
text_df <- tibble(line = 1:4, text = text)

# Converting to Tidy text format (ONE-TOKEN-PER-DOCUMENT-PER-ROW)
text_df %>% unnest_tokens(word, text) # By default, unnest_tokens() convert tokens to lowercase

# Jane Austen - Transformating to tidy format - Example
library(janeaustenr)

# Tracking line numbers, chapter with mutate
original_books <- austen_books() %>% 
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                ignore_case = TRUE)))) %>%
  ungroup()

# Converting book to Tidy text format
tidy_books <- original_books %>%
  unnest_tokens(word, text)

# Removing stop words
tidy_books <- tidy_books %>%
  anti_join(stop_words)

# Counting most common words
tidy_books %>%
  count(word, sort = TRUE)

# Removing words containing digits
tidy_book <- tidy_book %>%
  filter(!str_detect(word, "\\d"))