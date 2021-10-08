library(rvest)
library(dslabs)
library(tidyverse)

# Assetments Web Scraping

#Web page tha contains information about Major League Baseball payrolls
url <- "https://web.archive.org/web/20181024132313/http://www.stevetheump.com/Payrolls.htm"
h <- read_html(url)

# Tables in HTML are associated with the table node. 
# Using html_nodes() function and the table node type to extract the first table. Store it in an object nodes:
nodes <- html_nodes(h, "table")
html_text(nodes[[4]])
html_table(nodes[[4]])

tab_1 <- html_table(nodes[[10]])
tab_2 <- html_table(nodes[[19]])

#Remove 1st row and 1st column and rename columns
tab_1 <- tab_1[-1,-1] %>% setNames(c("Team", "Payroll", "Average"))
#colnames(tab_1) <- c("Team", "Payroll", "Average")

#Remove 1st row and rename columns
tab_2 <- tab_2[-1,] %>% setNames(c("Team", "Payroll", "Average"))
#colnames(tab_2) <- c("Team", "Payroll", "Average")

tab_12 <- full_join(tab_1, tab_2, by = "Team")
tab_12

url <- "https://en.wikipedia.org/w/index.php?title=Opinion_polling_for_the_United_Kingdom_European_Union_membership_referendum&oldid=896735054"
h <- read_html(url)
nodes <- html_nodes(h, "table")

tab <- html_text(nodes[[1]])
tab <- html_table(nodes[[5]], fill = TRUE)
tab