# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 08: Data Preprocessing (Value Focus)
# Description: Isolates value-driven sentences and stores them in 
#              the preprocessed data folder.
# =========================================================================

library(tidyverse)

# 1. Create the preprocessed directory
if(!dir.exists("data_preprocessed")) dir.create("data_preprocessed")

# 2. Load the cleaned data
data_clean <- read_csv("data_processed/merged_firms_cleaned.csv")

# 3. Define a "Value Dictionary" 
# These words indicate that a firm is talking about its core beliefs
value_keywords <- "value|believe|belief|integrity|ethics|excellence|trust|responsibility|mission|vision|culture|commitment|stewardship|diversity|inclusion"

# 4. Filter for value-heavy paragraphs
data_values_only <- data_clean %>%
  filter(str_detect(content, regex(value_keywords, ignore_case = TRUE)))

# 5. Save to the PREPROCESSED folder
write_csv(data_values_only, "data_preprocessed/firms_values_preprocessed.csv")

# 6. Summary
message("--------------------------------------------------")
message(paste("ROWS IN CLEANED DATA      :", nrow(data_clean)))
message(paste("ROWS WITH VALUE KEYWORDS  :", nrow(data_values_only)))
message("Data saved to 'data_preprocessed/firms_values_preprocessed.csv'")
message("--------------------------------------------------")

# Let's see the new Top Words for these specific "Value-Paragraphs"
library(tidytext)
data_values_only %>%
  unnest_tokens(word, content) %>%
  anti_join(stop_words) %>%
  filter(!str_detect(word, "[0-9]")) %>%
  count(word, sort = TRUE) %>%
  head(10)