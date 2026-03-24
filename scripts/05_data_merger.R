# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 05: Data Merger
# Description: Merges all individual firm CSVs into one master dataset.
# =========================================================================

library(tidyverse)

# 1. Create a directory for processed data
if(!dir.exists("data_processed")) dir.create("data_processed")

# 2. Get a list of all CSV files in the raw data folder
files_to_merge <- list.files("data_raw", pattern = "\\.csv$", full.names = TRUE)

# 3. Read all files and bind them into one big table (tibble)
# We use map_df to apply read_csv to every file and stack them
master_data <- files_to_merge %>%
  map_df(~read_csv(.))

# 4. Save the merged dataset
write_csv(master_data, "data_processed/merged_firms_raw.csv")

# 5. Show a quick summary of the merged data
message("--------------------------------------------------")
message(paste("TOTAL ROWS COLLECTED :", nrow(master_data)))
message(paste("TOTAL FIRMS IN DATA  :", n_distinct(master_data$company)))
message("Data saved to 'data_processed/merged_firms_raw.csv'")
message("--------------------------------------------------")

# Take a look at the first few rows
head(master_data)

# Load the merged data
master_data <- read_csv("data_processed/merged_firms_raw.csv")

# Create a ranking: Which firms have the most paragraphs?
firm_ranking <- master_data %>%
  count(company, sort = TRUE)

# Show the top 10
print("Top 10 firms by amount of text (paragraphs):")
print(head(firm_ranking, 10))

# Save this ranking for your notes
write_csv(firm_ranking, "data_processed/firm_text_volume_ranking.csv")