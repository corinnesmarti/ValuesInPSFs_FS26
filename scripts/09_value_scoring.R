# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 09: Value Variable Scoring
# Description: Creates a firm-level matrix of identity scores.
# =========================================================================

library(tidyverse)

# 1. Load the preprocessed value data (the 143 paragraphs)
v2_data <- read_csv("data_preprocessed/firms_values_preprocessed_v2.csv")

# 2. Define our "Value Dictionaries" based on your Top 15 results
# We group them into 3 clear identity narratives
dict_professional <- "legal|partnership|people|trust|standards|ethics|integrity|pro bono"
dict_commercial   <- "clients|services|business|growth|value|solutions|market|profit"
dict_innovation   <- "sustainability|sustainable|innovation|ai|digital|future|technology"

# 3. Calculate Scores per Firm
# We count how many times words from each dictionary appear per firm
firm_value_matrix <- v2_data %>%
  mutate(
    score_professional = str_count(tolower(content), dict_professional),
    score_commercial   = str_count(tolower(content), dict_commercial),
    score_innovation   = str_count(tolower(content), dict_innovation)
  ) %>%
  group_by(company) %>%
  summarise(
    professional_logic = sum(score_professional),
    commercial_logic   = sum(score_commercial),
    innovation_logic   = sum(score_innovation),
    total_value_statements = n()
  ) %>%
  # Add industry info back from our original seeds
  left_join(read_csv("psf_seed_list.csv") %>% select(company, industry), by = "company")

# 4. Save the Final Matrix
write_csv(firm_value_matrix, "data_processed/firm_value_matrix.csv")

# 5. Quick look at the results (Consulting vs Law averages)
industry_comparison <- firm_value_matrix %>%
  group_by(industry) %>%
  summarise(
    avg_professional = mean(professional_logic),
    avg_commercial   = mean(commercial_logic),
    avg_innovation   = mean(innovation_logic)
  )

message("--------------------------------------------------")
message("INDUSTRY COMPARISON (AVERAGE SCORES):")
print(industry_comparison)
message("--------------------------------------------------")