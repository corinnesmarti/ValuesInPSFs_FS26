# Values and Identity Narratives in Professional Service Firms

**Course:** Data Mining and Large Language Models for Political and Social Sciences  
**University:** University of Lucerne  
**Term:** FS 2026  
**Student:** Corinne Marti  

## Project Goal
The goal of this project is to collect and analyze text data from the websites of elite Professional Service Firms (PSFs) such as consulting and law firms. By building a custom web scraping pipeline in R, this project extracts publicly communicated value statements to examine how these organizations construct legitimacy and organizational identity.

## Research Question
*How do professional service firms (consulting/law) communicate organizational values on their websites and which value narratives appear most frequently across different firms?*

## Data Source & Methodology
* **Sampling & Source:** A compiled seed list of approx. 50-100 leading Professional Service Firms (sampled via industry rankings, e.g., largest by revenue). The data targets the "About Us", "Purpose", "Values", and "Culture" sections of their respective websites.
* **Collection Method:** Automated web scraping using a custom R crawler (`rvest`, `polite`). The crawler reads the seed list and uses a regex-based heuristic to automatically identify and extract relevant value-related subpages across the sample.
* **Analysis:** The collected text corpus will be preprocessed and analyzed using classical text mining approaches (e.g., dictionary-based frequencies, TF-IDF, or topic modeling) to identify structural similarities in value narratives.

## Repository Structure
* `/scripts` - R scripts used to crawl links, extract text, and analyze data.
* `/data_raw` - Extracted HTML text (Not tracked by Git).
* `/data_preprocessed` - Cleaned datasets (Not tracked by Git).

## Reproducibility
To reproduce this project:
1. Clone this repository.
2. Install the required R packages (`tidyverse`, `rvest`, `polite`).
3. Run the scripts in the `/scripts` folder in numerical order.
*(Note: Automated data collection uses the polite package to respect server constraints and robots.txt rules).*