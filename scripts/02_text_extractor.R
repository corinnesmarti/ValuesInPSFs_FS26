# =========================================================================
# Project: Values and Identity Narratives in Professional Service Firms
# Script 02: Text Extractor (Scraping the actual value statements)
# =========================================================================

# 1. Load required packages
library(tidyverse) 
library(rvest)     
library(polite)    

# 2. Define the target URL (The exact 'Values' page we found in Script 01)
target_url <- "https://www.bain.com/about/what-we-believe/"

# 3. Introduce ourselves politely to the server
session <- bow(
  url = target_url,
  user_agent = "Academic Research Project - University of Lucerne (Student)",
  force = TRUE
)

# 4. Download the HTML content
page_html <- scrape(session)

# 5. Extract the text paragraphs (<p> tags)
# We select all paragraphs on the page and extract the clean text
raw_text <- page_html %>%
  html_nodes("p") %>%
  html_text(trim = TRUE)

# 6. Create a structured table (tibble) for our dataset
text_data <- tibble(
  company = "Bain & Company",
  url = target_url,
  paragraph = raw_text
) %>%
  # Remove completely empty paragraphs to keep the data clean
  filter(paragraph != "")

# 7. Print the first few sentences to check if it worked
print("Hier sind die ersten Sätze von Bain:")
print(head(text_data, 5))

# 8. Save the raw data securely to our data_raw folder
# NEU: Wir sagen R, es soll den Ordner 'data_raw' erstellen, falls er fehlt
dir.create("data_raw", showWarnings = FALSE)

# We use CSV (Comma Separated Values), which is the standard format for data analysis
write_csv(text_data, "data_raw/bain_what_we_believe.csv")
print(" SUCCESS: Daten wurden erfolgreich im Ordner 'data_raw' gespeichert")