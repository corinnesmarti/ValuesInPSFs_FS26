# Values and Identity Narratives in Professional Service Firms

**Course:** Data Mining and LLMs for Political and Social Sciences  
**University:** University of Lucerne  
**Term:** FS 2026  
**Student:** Corinne Sybille Marti  

## Project Goal
The goal of this project is to collect and analyze text data from the websites of elite Professional Service Firms (PSFs), specifically management consultancies and law firms. By building a custom web scraping pipeline in R, this project extracts publicly communicated value statements to examine how these organizations construct legitimacy, signal professionalism, and shape their organizational identity in the digital age.

## Research Question
How do professional service firms (consulting vs. law) communicate organizational values on their websites, and which value narratives appear most frequently across different firms?

## Data Source & Methodology
* **Sampling & Source:** A compiled seed list of 60 leading Professional Service Firms (sampled via industry rankings). The data collection targeted the "About Us", "Purpose", "Values", and "Culture" sections of their corporate websites. In total, 39 firms were successfully scraped.
* **Collection Method:** Automated ethical web scraping using a custom R crawler (`rvest`, `polite`). The crawler used a regex-based heuristic to automatically identify and extract relevant identity-related subpages while strictly respecting `robots.txt` rules and host server limits.
* **Analysis:** The collected text corpus was cleaned, tokenized, and analyzed using two main approaches:
  1. **Quantitative Scoring:** A dictionary-based approach mapping texts onto three institutional logics (Professional, Commercial, Innovation).
  2. **Topic Modeling:** Latent Dirichlet Allocation (LDA) to identify underlying latent narrative clusters across the industries.

## Repository Structure
* `/scripts/` - R scripts used to crawl links, extract HTML, and process the text data (numbered sequentially).
* `/data_raw/` - Extracted raw HTML text (Not tracked by Git due to size/reproducibility).
* `/data_preprocessed/` - Cleaned and filtered datasets (Not tracked by Git).
* `/data_processed/` - Final aggregated CSVs (e.g., `firm_value_matrix.csv`, `lda_topic_summary.csv`) and generated plots.
* `psf_seed_list.csv` - The initial list of targeted firms.
* `report.qmd` - The Quarto document containing the theoretical framework, complete analysis pipeline, and interpretations.
* `report.html` - The final rendered interactive HTML report.

## Reproducibility
To reproduce the findings of this project:
1. Clone this repository to your local machine.
2. Ensure you have R and RStudio installed, along with Quarto.
3. Install the required R packages: `tidyverse`, `rvest`, `polite`, `tidytext`, `topicmodels`, `ggplot2`, `reshape2`, and `knitr`.
4. Run the data collection and processing scripts in the `/scripts/` folder in numerical order. *(Note: Depending on server responses and polite crawl delays, scraping may take some time).*
5. Open `report.qmd` and click **Render** to compile the final analysis and visualizations.

## LLM Disclosure
In accordance with the University of Lucerne guidelines, Gemini 3 Flash (Google) was used as an AI assistant during this project. It provided support for code generation (regex heuristics, LDA pipeline), debugging technical errors within the Quarto environment, and linguistic refinement of the academic English text. All outputs were manually verified, and the conceptual framing remains the sole responsibility of the author.
1. Clone this repository.
2. Install the required R packages (`tidyverse`, `rvest`, `polite`).
3. Run the scripts in the `/scripts` folder in numerical order.
*(Note: Automated data collection uses the polite package to respect server constraints and robots.txt rules).*
