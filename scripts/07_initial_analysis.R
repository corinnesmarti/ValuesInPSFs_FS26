# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 07: Initial Text Analysis
# Description: Basic word frequency to see what PSFs talk about.
# =========================================================================

install.packages("tidytext")
library(tidytext)
library(tidyverse)
library(tidytext) # Falls nicht installiert: install.packages("tidytext")

# 1. Load the cleaned data
data_clean <- read_csv("data_processed/merged_firms_cleaned.csv")

# 2. Tokenization: Break paragraphs into single words
word_counts <- data_clean %>%
  unnest_tokens(word, content) %>%
  # Remove "Stopwords" (the, and, of, and common German ones if necessary)
  # For now, let's just use the English ones
  anti_join(stop_words) %>%
  # Remove numbers
  filter(!str_detect(word, "[0-9]")) %>%
  count(word, sort = TRUE)

# 3. Show Top 20 Words
message("--------------------------------------------------")
message("THE TOP 20 IDENTITY WORDS IN YOUR DATASET:")
print(head(word_counts, 20))
message("--------------------------------------------------")

# 4. Save for later
write_csv(word_counts, "data_processed/word_frequency_overview.csv")