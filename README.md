# Project Title

How the Car Industry Has Evolved Over the Past Decades

This project analyzes long-term trends in the car industry, focusing on vehicle pricing, the rise of electric vehicles (EVs), historical fuel costs, and year-to-year inflation. The goal is to understand how economic and technological changes have shaped consumer behavior and industry growth.

## Overview

Over the past several decades, the automotive industry has undergone transformational change in response to shifting consumer preferences, environmental policy, new technologies, and macroeconomic pressures.
This project aims to:

- Examine how car prices have changed over time (adjusted for inflation).

- Analyze EV adoption trends and identify when growth accelerated.

- Investigate how fuel prices influence consumer decisions.

- Explore connections between inflation, affordability, and transportation costs.

The repository contains data wrangling scripts, cleaned datasets, visualizations, and analytical notes that reveal major patterns in the industry’s evolution.

## Interesting Insight

One preliminary insight suggests that EV adoption surged sharply after 2015, coinciding with declining battery costs and expanded government incentives—marking a clear turning point in automotive technology and consumer adoption.

## Data Sources and Acknowledgements

Data Sources

- Car Prices & Inflation

-- U.S. Bureau of Labor Statistics (New Vehicles CPI)

-- Federal Reserve Economic Data (FRED)
 
- Fuel Prices

-- U.S. Energy Information Administration (EIA)

- Electric Vehicle Adoption

-- U.S. Department of Energy – Alternative Fuels Data Center

International Energy Agency (IEA)

Acknowledgements

- Course instructors for project guidance

- Authors of packages used in this project, including tidyverse, ggplot2, lubridate, and others

- Contributors of referenced datasets and documentation

## Current Plan

This project is being developed in several structured phases:

###Phase 1 — Data Collection

- Acquire multi-decade datasets for vehicle prices, EV adoption, fuel costs, and inflation.

- Verify source reliability and licensing requirements.

### Phase 2 — Data Wrangling

- Clean inconsistencies across datasets.

- Normalize year formats, units, and categorical labels.

- Convert datasets into tidy (long-format) tables.

- Adjust historical prices for inflation (real dollars).

### Phase 3 — Exploratory Data Analysis

- Generate trend plots for EV counts, fuel prices, inflation, and MSRP patterns.

- Identify turning points, correlations, and structural changes.

### Phase 4 — Insight Development

- Compare EV growth against fuel prices and inflation.

- Determine affordability trends over time.

- Highlight challenges (missing years, inconsistent reporting, inflation adjustments).

### Phase 5 — Presentation & Documentation

- Develop slide deck explaining:

- Data sources

-- Wrangling steps

-- Key variables

-- Main findings

-- Challenges encountered

- Finalize repository structure and analysis scripts.

# Repo Structure
```
project-root/
│
├── data_raw/                # Original datasets (uncleaned)
├── data_clean/              # Cleaned and tidy datasets
├── scripts/                 # R scripts for importing, wrangling, and analyzing data
│     ├── 01_import.R
│     ├── 02_cleaning.R
│     └── 03_analysis.R
│
├── images/                  # Exported ggplot2 visualizations
│
├── presentation/            # Slides for presenting data sources and findings
│
├── README.md                # Project documentation (this file)
└── plan.md                  # Detailed project plan and workflow notes
```
Key Files

02_cleaning.R: Handles transformation of raw data into tidy format.

03_analysis.R: Generates plots and statistical summaries.

presentation/ contains the bonus-eligible presentation materials.

# Authors

Zhan Xin Wang

zzw5368@psu.edu
