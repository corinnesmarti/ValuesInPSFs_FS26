# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 01: Base crawler test --> ethical link extraction & heuristic
# =========================================================================

# 1. Load required packages
library(tidyverse) # for data manipulation 
library(rvest)     # for web scraping
library(polite)    # for ethical web scraping (robots.txt compliance)

# 2. Define a test URL
test_url <- "https://www.unilu.ch"

# 3. Introduce ourselves and check robots.txt using polite::bow()
session <- bow(
  url = test_url,
  user_agent = "Academic Research Project - University of Lucerne (Student)",
  force = TRUE
)

# 4. Download the HTML content politely
page_html <- scrape(session)

# 5. Extract ALL links and remove empty ones immediately (Crash-Prevention!)
all_links <- tibble(
  link_text = page_html %>% html_nodes("a") %>% html_text(trim = TRUE),
  link_url  = page_html %>% html_nodes("a") %>% html_attr("href")
) %>% 
  filter(!is.na(link_url) & !is.na(link_text)) # Filtert leere Zeilen heraus

# 6. The Heuristic: Filter for relevant "About us" / "Values" pages
value_pages <- all_links %>%
  filter(
    str_detect(link_url, "(?i)about|values|purpose|mission|vision|leitbild|ueber-uns") |
      str_detect(link_text, "(?i)about|values|purpose|mission|vision|leitbild|über uns")
  )

# 7. Print the filtered results
print("Hier sind die gefundenen Wert-Seiten:")
print(value_pages)