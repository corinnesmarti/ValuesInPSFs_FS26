# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 04: Productive Master Scraper (Robust & Location-Independent)
# =========================================================================

library(tidyverse)
library(rvest)
library(polite)

# 1. Load the seed list from the root directory
# The path "psf_seed_list.csv" works when the RProject is active
seeds <- read_csv("psf_seed_list.csv")

# 2. Define the Scraper Function
scrape_psf <- function(company_name, target_url) {
  
  message(paste("--- Processing:", company_name, "---"))
  
  session <- bow(
    url = target_url, 
    user_agent = "Academic Research Project - University of Lucerne (Student)",
    force = TRUE
  )
  
  page_html <- scrape(session)
  
  extracted_text <- page_html %>% 
    html_nodes("p") %>% 
    html_text(trim = TRUE)
  
  if(length(extracted_text) == 0) stop("No text found")
  
  firm_data <- tibble(
    company = company_name,
    url = target_url,
    content = extracted_text,
    scrape_date = Sys.Date()
  ) %>% filter(content != "")
  
  # Save path: Ensures data goes to the root data_raw folder
  file_safe_name <- str_replace_all(company_name, "[^[:alnum:]]", "_")
  file_path <- paste0("data_raw/", file_safe_name, ".csv")
  
  write_csv(firm_data, file_path)
  message(paste("Saved successfully:", file_safe_name))
}

# 3. Create the folder if it's missing
if(!dir.exists("data_raw")) dir.create("data_raw")

# 4. The big harvest (all 60 firms)
# We use the robust loop to keep going even if some firms block us
for (i in 1:60) {
  try({
    scrape_psf(seeds$company[i], seeds$url[i])
  }, silent = FALSE)
}

print("All 60 firms processed! Check main 'data_raw' folder.")