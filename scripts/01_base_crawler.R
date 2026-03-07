# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 01: Base crawler test --> ethical link extraction
# =========================================================================

# 1. Load required packages
library(tidyverse) # for data manipulation 
library(rvest)     # for web scraping
library(polite)    # for ethical web scraping (robots.txt compliance)

# 2. Define a test URL
test_url <- "https://www.mckinsey.com"

# 3. Introduce ourselves and check robots.txt using polite::bow()
# This respects the website's rules and sets a clear academic user agent.
session <- bow(
  url = test_url,
  user_agent = "Academic Research Project - University of Lucerne (Student)",
  force = TRUE
)

# Print the session info to see if we are allowed to scrape
print(session)

# 4. Download the HTML content politely (automatically includes a delay if required)
page_html <- scrape(session)

# 5. Extract all links (<a> tags) from the homepage
# We create a structured table (tibble) with the link text and the URL
all_links <- tibble(
  link_text = page_html %>% html_nodes("a") %>% html_text(trim = TRUE),
  link_url  = page_html %>% html_nodes("a") %>% html_attr("href")
)

# 6. Display the first 10 results to check if it worked
print(head(all_links, 10))