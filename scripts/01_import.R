# 01_import.R
# Purpose: Import raw datasets for car prices, EV adoption, fuel prices, and inflation.
# All raw data should live in the `data_raw/` folder.

# Load packages -----------------------------------------------------------

library(tidyverse)
library(readr)
library(readxl)


# Set paths ---------------------------------------------------------------

# NOTE: When using this in an RStudio project, your working directory
# should be the project root (where the .Rproj file lives).
path_raw   <- "data_raw"
path_clean <- "data_clean"

# Create data_clean folder if it doesn't exist yet
if (!dir.exists(path_clean)) {
  dir.create(path_clean)
}

# Import datasets ---------------------------------------------------------

cpi_vehicles_raw <- read_csv("data_raw/cpi_new_vehicles.csv")

fuel_prices_raw <- read_excel("data_raw/PET_PRI_GND_DCUS_NUS_W.xls", skip = 2)

# Example: EV registrations / adoption data
ev_adoption_raw <- read_csv(file.path(path_raw, "ev_adoption.csv"))

# Example: general inflation / CPI
inflation_raw <- read_csv(file.path(path_raw, "cpi_all_items.csv"))

# Quick structure checks --------------------------------------------------

glimpse(cpi_vehicles_raw)
glimpse(fuel_prices_raw)
glimpse(ev_adoption_raw)
glimpse(inflation_raw)

# Save raw objects ---------------------------------------------

saveRDS(cpi_vehicles_raw, file.path(path_clean, "cpi_vehicles_raw.rds"))
saveRDS(fuel_prices_raw,  file.path(path_clean, "fuel_prices_raw.rds"))
saveRDS(ev_adoption_raw,  file.path(path_clean, "ev_adoption_raw.rds"))
saveRDS(inflation_raw,    file.path(path_clean, "inflation_raw.rds"))
