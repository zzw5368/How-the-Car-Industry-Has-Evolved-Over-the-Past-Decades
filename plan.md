# Project Plan: How the Car Industry Has Evolved Over the Past Decades

## 1. Introduction
This document outlines the plan for analyzing long-term changes in the automotive industry, focusing on car prices, electric vehicle (EV) adoption, fuel prices, and inflation. It details the data sources, cleaning procedures, analysis steps, tools, and deliverables that will guide the development of this project.

---

## 2. Project Objectives
The primary goals of this project are:

1. Measure how the average cost of vehicles has changed across decades, both nominally and adjusted for inflation.  
2. Analyze the growth of electric vehicle popularity and identify key periods of acceleration.  
3. Investigate how fuel prices have fluctuated and how those fluctuations relate to consumer trends.  
4. Study year-to-year inflation and its impact on automobile affordability.

By integrating these components, the project aims to provide a comprehensive picture of how economic and technological shifts have shaped the car industry.

---

## 3. Research Questions
This project will address the following guiding questions:

- How have new vehicle prices changed over the past several decades?  
- When did EV adoption begin to accelerate noticeably?  
- How volatile are historical fuel prices, and do they correspond to shifts in consumer behavior?  
- How do inflation rates influence vehicle affordability over time?  
- What external factors (policy changes, economic conditions, energy prices) might explain the observed trends?

---

## 4. Data Sources
Data will be obtained from the following **non-Kaggle**, reliable, openly accessible sources:

### 4.1 Vehicle Prices & Inflation
- U.S. Bureau of Labor Statistics — Consumer Price Index (New Vehicles)  
- Federal Reserve Economic Data (FRED)

### 4.2 Fuel Prices
- U.S. Energy Information Administration (EIA)

### 4.3 Electric Vehicle Adoption
- U.S. Department of Energy — Alternative Fuels Data Center  
- International Energy Agency (IEA)

Each dataset will be stored in the `data_raw/` folder before cleaning.

---

## 5. Data Wrangling Plan
All wrangling will be performed in R using **tidyverse**.

### 5.1 Cleaning Raw Data
- Standardize date formats (Year, Month, or Year-Quarter as applicable).  
- Remove missing or malformed entries.  
- Normalize variable names using `janitor::clean_names()`.  
- Convert all monetary variables to numeric.  
- Ensure EV counts, fuel prices, and price indices use consistent types.

### 5.2 Creating Tidy Datasets
- Convert wide data to long format when necessary.  
- Create inflation-adjusted prices using CPI.  
- Harmonize units (e.g., dollars, gallons, kWh, percentages).  
- Output final cleaned datasets to `data_clean/`.

---

## 6. Analysis Workflow

### 6.1 Exploratory Analysis
Using the cleaned data, the analysis will include:

- Time-series plots of new vehicle prices (nominal vs. inflation-adjusted).  
- EV adoption over time (counts and percent share).  
- Fuel prices by decade.  
- Inflation trend visualization.  
- Basic correlation checks (e.g., price vs. inflation, EV adoption vs. fuel prices).

### 6.2 Deeper Insights
Potential deeper analyses include:

- Identifying structural breakpoints in EV adoption.  
- Comparing periods of fuel price spikes to vehicle pricing behavior.  
- Measuring affordability trends using inflation-adjusted income and price data.  
- Highlighting policy milestones (e.g., EV tax credits, fuel economy standards) alongside the data.

---

## 7. Tools and Methods
- **R** for all data wrangling and analysis.  
- **tidyverse** for data manipulation.  
- **ggplot2** for visualization.  
- **lubridate** for handling dates.  
- **scales** for formatting values in plots.  
- `ggsave()` for exporting visuals to the `images/` directory.

---

## 8. Repository Organization
This plan corresponds to the structure outlined in the README:

```text
data_raw/        # Uncleaned raw datasets  
data_clean/      # Cleaned and tidy datasets  
scripts/         # R scripts (import, cleaning, analysis)  
images/          # Saved ggplot images  
presentation/    # Slides explaining data, methods, and findings  
plan.md          # This project plan
```


Scripts:
- `01_import.R`  
- `02_cleaning.R`  
- `03_analysis.R`  

---

## 9. Deliverables

### Required
- Full GitHub repository  
- Cleaned datasets  
- Visualizations  
- Finished README  

### Bonus
- Presentation slide deck  

---

## 10. Potential Challenges
- Missing historical data  
- Inconsistent measurements  
- Inflation adjustment complexity  
- Combining multiple time series  
- Data from different agencies with different formats  

---

## 11. Expected Outcome
A complete data-driven analysis of how the automotive industry has evolved, supported by well-documented code, clear visualizations, and insights about the economic and technological forces shaping the industry.
