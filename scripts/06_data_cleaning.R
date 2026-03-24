# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 06: Data Cleaning
# Description: Removes noise (cookies, footers, short menu items) from text.
# =========================================================================

library(tidyverse)

# 1. Load the merged data
master_raw <- read_csv("data_processed/merged_firms_raw.csv")

# 2. Start Cleaning
master_cleaned <- master_raw %>%
  # Remove exact duplicates (often occurs with footers)
  distinct(company, content, .keep_all = TRUE) %>%
  
  # Remove very short snippets (likely menu items or buttons)
  # We count words by looking for spaces
  mutate(word_count = str_count(content, "\\w+")) %>%
  filter(word_count > 5) %>%
  
  # Filter out typical "web noise" using keywords (Case Insensitive)
  filter(!str_detect(content, regex("cookie|privacy policy|all rights reserved|copyright|subscribe|contact us", ignore_case = TRUE))) %>%
  
  # Optional: Remove paragraphs that are just addresses or phone numbers
  filter(!str_detect(content, "[0-9]{3,}-[0-9]{3,}"))

# 3. Save the clean version
write_csv(master_cleaned, "data_processed/merged_firms_cleaned.csv")

# 4. Final Comparison
message("--------------------------------------------------")
message(paste("ROWS BEFORE CLEANING :", nrow(master_raw)))
message(paste("ROWS AFTER CLEANING  :", nrow(master_cleaned)))
message(paste("REMOVED NOISE ROWS   :", nrow(master_raw) - nrow(master_cleaned)))
message("Clean data saved to 'data_processed/merged_firms_cleaned.csv'")
message("--------------------------------------------------")

# New Ranking after Cleaning
master_cleaned %>%
  count(company, sort = TRUE) %>%
  head(10)