# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 03: Master Scraper (Processing 60 Firms)
# Description: Uses a robust for-loop to ensure the scraper continues
#              even if SSL or Network errors occur.
# =========================================================================

library(tidyverse)
library(rvest)
library(polite)

# 1. Load the seed list
seeds <- read_csv("psf_seed_list.csv")

# 2. Define the Scraper Function
scrape_psf <- function(company_name, target_url) {
  
  message(paste("--- Now processing:", company_name, "---"))
  
  # Initialize a polite session
  session <- bow(
    url = target_url, 
    user_agent = "Academic Research Project - University of Lucerne (Student)",
    force = TRUE
  )
  
  # Download HTML and extract text
  page_html <- scrape(session)
  
  extracted_text <- page_html %>% 
    html_nodes("p") %>% 
    html_text(trim = TRUE)
  
  if(length(extracted_text) == 0) stop("No paragraphs found")
  
  # Create table
  firm_data <- tibble(
    company = company_name,
    url = target_url,
    content = extracted_text,
    scrape_date = Sys.Date()
  ) %>% 
    filter(content != "")
  
  # Save file
  file_safe_name <- str_replace_all(company_name, "[^[:alnum:]]", "_")
  file_path <- paste0("data_raw/", file_safe_name, ".csv")
  write_csv(firm_data, file_path)
  
  message(paste("Successfully saved:", file_safe_name))
}

# 3. The Robust Loop (Processing first 5 as a test)
# We use try() so that if one company fails, the loop continues to the next.
for (i in 1:5) {
  try({
    scrape_psf(seeds$company[i], seeds$url[i])
  }, silent = FALSE)
}

print("Pilot run finished! Check 'data_raw' for the results.")