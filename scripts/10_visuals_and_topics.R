# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 10: Visuals & Topic Modeling
# Description: Generates industry comparison plots and latent topic clusters.
# =========================================================================

# 1. LOAD PACKAGES
library(tidyverse)
library(topicmodels)
library(tidytext)
library(reshape2)

# 2. LOAD DATA
matrix_data <- read_csv("data_processed/firm_value_matrix.csv")
v2_data <- read_csv("data_preprocessed/firms_values_preprocessed_v2.csv")

# -------------------------------------------------------------------------
# 3. VISUALIZATION: Industry Logic Comparison
# -------------------------------------------------------------------------
message("Step 1: Generating Industry Logic Plot...")

plot_data <- matrix_data %>%
  pivot_longer(cols = c(professional_logic, commercial_logic, innovation_logic), 
               names_to = "Logic", values_to = "Score") %>%
  mutate(Logic = str_remove(Logic, "_logic") %>% str_to_title())

ggplot(plot_data, aes(x = Logic, y = Score, fill = industry)) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  theme_minimal(base_size = 14) +
  labs(
    title = "Comparison of Organizational Identity Logics",
    subtitle = "Average logic frequency: Law vs. Consulting",
    y = "Mean Score", 
    x = "Identity Narrative",
    fill = "Industry"
  ) +
  scale_fill_manual(values = c("Consulting" = "#2c3e50", "Law" = "#e74c3c")) +
  theme(legend.position = "bottom", plot.title = element_text(face = "bold"))

# Save the plot
ggsave("data_processed/industry_logic_comparison.png", width = 10, height = 6)
message("Success: Plot saved to data_processed/industry_logic_comparison.png")

# -------------------------------------------------------------------------
# 4. TOPIC MODELING: Identifying Latent Narratives
# -------------------------------------------------------------------------
message("Step 2: Running Latent Dirichlet Allocation (LDA)...")

# Prepare the Document-Term-Matrix (DTM)
dtm_prep <- v2_data %>%
  mutate(document_id = row_number()) %>%
  unnest_tokens(word, content) %>%
  anti_join(stop_words) %>%
  # Filter out generic terms and legal suffixes to reduce noise
  filter(!str_detect(word, "[0-9]|llp|limited|firm|services|clients|business|company")) %>%
  count(document_id, word) %>%
  cast_dtm(document_id, word, n)

# Run LDA with 3 Topics
lda_model <- LDA(dtm_prep, k = 3, control = list(seed = 1234))

# REFINEMENT: Extract ONLY the top 10 terms per topic (solves the 2772 rows issue)
top_essence <- tidy(lda_model, matrix = "beta") %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup() %>%
  arrange(topic, -beta)

# 5. CONSOLE OUTPUT & EXPORT
message("--- TOP WORDS PER IDENTIFIED TOPIC ---")
print(top_essence, n = 30)

write_csv(top_essence, "data_processed/lda_topic_summary.csv")
message("Success: Topic summary saved to data_processed/lda_topic_summary.csv")
print(top_terms)

# 4. EXPORT TOPICS
write_csv(top_terms, "data_processed/lda_topics_summary.csv")
message("Topic summary saved to data_processed/lda_topics_summary.csv")