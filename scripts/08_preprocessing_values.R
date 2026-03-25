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

# =========================================================================
# 3. DEFINE REFINED VALUE DICTIONARY
# =========================================================================

# We combine normative values (ethics) and instrumental values (client-success)
# based on PSF literature (Maister, Greenwood)

value_keywords <- paste0(
  "value|believe|belief|integrity|ethics|excellence|trust|responsibility|",
  "mission|vision|culture|commitment|stewardship|diversity|inclusion|",
  "purpose|sustainable|sustainability|responsible|pro bono|community|",
  "partnership|collaboration|thrive|empower|dedication|standards"
)

# 4. Filter and Create Preprocessed Dataset
data_values_preprocessed <- data_clean %>%
  # Filter for paragraphs containing any of these keywords
  filter(str_detect(content, regex(value_keywords, ignore_case = TRUE))) %>%
  # Add a helper column to see which keyword was found (useful for later)
  mutate(has_normative_core = str_detect(content, regex("integrity|ethics|trust|responsibility|purpose|stewardship", ignore_case = TRUE)))

# 5. Save to the PREPROCESSED folder
write_csv(data_values_preprocessed, "data_preprocessed/firms_values_preprocessed_v2.csv")

# 6. Final Summary
message("--------------------------------------------------")
message(paste("ROWS IN CLEANED DATA        :", nrow(data_clean)))
message(paste("ROWS IN NEW PREPROCESSED    :", nrow(data_values_preprocessed)))
message("File: data_preprocessed/firms_values_preprocessed_v2.csv")
message("--------------------------------------------------")

# Quick check of the 143 Value-Paragraphs
library(tidytext)

# Read the refined preprocessed data
v2_data <- read_csv("data_processed/merged_firms_cleaned.csv") %>%
  filter(str_detect(content, regex("value|believe|belief|integrity|ethics|excellence|trust|responsibility|mission|vision|culture|commitment|stewardship|diversity|inclusion|purpose|sustainable|sustainability|responsible|pro bono|community|partnership|collaboration|thrive|empower|dedication|standards", ignore_case = TRUE)))

# Count the words in these specific 143 rows
v2_data %>%
  unnest_tokens(word, content) %>%
  anti_join(stop_words) %>%
  filter(!str_detect(word, "[0-9]")) %>%
  count(word, sort = TRUE) %>%
  head(15)
