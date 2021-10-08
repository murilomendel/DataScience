library(tidyverse)
library(pdftools)
options(digits = 3)
# PDF report Path
fn <- system.file("extdata", "RD-Mortality-Report_2015-18-180531.pdf", package="dslabs")

# Command to open PDF
system("cmd.exe", input = paste("start", fn))

# Reading pdf report
txt <- pdf_text(fn)
class(txt)

# Splitting data by next row command \n
x <- txt[[9]] %>% str_split(pattern = "\n")

# Getting first element of list x
s <- x[[1]]

# Removing spaces into the left of each element
s <- str_trim(s)
s[header_index]

# Preserving header index
header_index <- str_which(s, "2015")[1]

# Spliting header string by spaces
header <- s[header_index] %>% str_split("\\s+")

# Getting the first element of header list
month <- header[[1]][1]

# Getting all elements except the firts
header <- header[[1]][-1]
header
# Getting tail index
tail_index <- str_which(s, "^Total")

n <- str_count(s, "\\d+")

# Elements With only one digit
one_digit_index <- which(n == 1)

# Removing elements: Before Header Index, After Tail Index and Index of rows with one digit
s <- s[-c(1:header_index,tail_index:length(s), one_digit_index)]

# Removing all non digit elements keeping spaces
s <- str_remove_all(s, "[^\\d\\s]")

# Converting s into a matrix with just day and death count data
s <- str_split_fixed(s, "\\s+", n = 6)[,1:5]

# Creating a data frame, adding columns and setting columns to numeric
tab <- data.frame(s) %>% setNames(c("day", header))
tab$day <- as.numeric(tab$day)
tab$`2015` <- as.numeric(tab$`2015`)
tab$`2016` <- as.numeric(tab$`2016`)
tab$`2017` <- as.numeric(tab$`2017`)
tab$`2018` <- as.numeric(tab$`2018`)

# Mean number of deaths in September 2015, 2016
mean(tab$`2015`)
mean(tab$`2016`)
mean(tab$`2017`[1:19])
mean(tab$`2017`[20:30])

tab <- tab %>% gather(year, deaths, -day) %>% 
  mutate(deaths = as.numeric(deaths))

tab

tab %>% ggplot() +
  geom_line(aes(x = day, y = deaths, color = year)) +
  geom_vline(xintercept = 20)
