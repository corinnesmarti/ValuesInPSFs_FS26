# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 10: Visuals & Topic Modeling (Final Analysis)
# =========================================================================

install.packages("topicmodels")
install.packages("reshape2")
library(topicmodels)
library(tidyverse)
library(tidytext)
library(topicmodels)
library(reshape2)

# 1. LOAD DATA
matrix_data <- read_csv("data_processed/firm_value_matrix.csv")
v2_data <- read_csv("data_preprocessed/firms_values_preprocessed_v2.csv")

# -------------------------------------------------------------------------
# 2. VISUALIZATION: Industry Logic Comparison
# -------------------------------------------------------------------------
message("Generating Industry Logic Plot...")

plot_data <- matrix_data %>%
  pivot_longer(cols = c(professional_logic, commercial_logic, innovation_logic), 
               names_to = "Logic", values_to = "Score") %>%
  mutate(Logic = str_remove(Logic, "_logic") %>% str_to_title())

ggplot(plot_data, aes(x = Logic, y = Score, fill = industry)) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  theme_minimal() +
  labs(
    title = "Comparison of Organizational Logics",
    subtitle = "Average frequency of logic-specific keywords per industry",
    y = "Average Score", 
    x = "Identity Narrative",
    fill = "Industry"
  ) +
  scale_fill_manual(values = c("Consulting" = "#2c3e50", "Law" = "#e74c3c")) +
  theme(legend.position = "bottom")

# Save the plot for your thesis
ggsave("data_processed/industry_logic_comparison.png", width = 10, height = 6)
message("Plot saved to data_processed/industry_logic_comparison.png")

# -------------------------------------------------------------------------
# 3. TOPIC MODELING: Identifying Latent Narratives
# -------------------------------------------------------------------------
message("Running Topic Modeling (LDA)...")

# Prepare the Document-Term-Matrix (DTM)
# We need to filter out very common words that don't add meaning
dtm_prep <- v2_data %>%
  mutate(document_id = row_number()) %>%
  unnest_tokens(word, content) %>%
  anti_join(stop_words) %>%
  # Remove legal suffixes and very common generic words
  filter(!str_detect(word, "[0-9]|llp|limited|firm|services|clients|business")) %>%
  count(document_id, word) %>%
  cast_dtm(document_id, word, n)

# Run Latent Dirichlet Allocation (LDA) - 3 Topics
# 3 Topics are usually perfect to see: 1. Ethics/Law, 2. Growth/Market, 3. Future/People
lda_model <- LDA(dtm_prep, k = 3, control = list(seed = 1234))

# Get the "Beta" (word-topic probabilities)
topics <- tidy(lda_model, matrix = "beta")

# Get Top 10 words per topic for interpretation
top_terms <- topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup() %>%
  arrange(topic, -beta)

# Display the topics in the console
message("--- TOP WORDS PER TOPIC ---")
print(top_terms)

# 4. EXPORT TOPICS
write_csv(top_terms, "data_processed/lda_topics_summary.csv")
message("Topic summary saved to data_processed/lda_topics_summary.csv")