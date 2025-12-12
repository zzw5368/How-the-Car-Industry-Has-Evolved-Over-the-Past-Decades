# 01_import.R
# Purpose: Import raw datasets for car prices, EV adoption, fuel prices, and inflation.
# Raw data files live in the `data_raw/` folder.

library(tidyverse)
library(readr)
library(readxl)

# paths -------------------------------------------------------------

path_raw   <- "data_raw"
path_clean <- "data_clean"

if (!dir.exists(path_clean)) {
  dir.create(path_clean)
}

# 1) CPI for new vehicles (FRED series CUUR0000SETA01)  -------------

cpi_vehicles_raw <- read_csv(
  file.path(path_raw, "cpi_new_vehicles.csv"),
  show_col_types = FALSE
)

# 2) Overall CPI (FRED series CPIAUCSL) -----------------------------

inflation_raw <- read_csv(
  file.path(path_raw, "cpi_overall.csv"),
  show_col_types = FALSE
)

# 3) EV adoption data (AFDC Excel)
# Skip the first 2 metadata rows so the real header row is used
ev_adoption_raw <- read_excel(
  path = file.path(path_raw, "ev_adoption.xlsx"),
  skip = 2
)


# 4) Fuel price data (EIA Excel)
# Read the actual data sheet, not the "Contents" sheet
fuel_prices_raw <- read_excel(
  path = file.path(path_raw, "fuel_price.xls"),
  sheet = "Data 1",
  skip = 2
)


# Quick checks ------------------------------------------------------

glimpse(cpi_vehicles_raw)
glimpse(inflation_raw)
glimpse(ev_adoption_raw)
glimpse(fuel_prices_raw)

# Save raw versions as RDS (so cleaning script can load them) -------

saveRDS(cpi_vehicles_raw, file.path(path_clean, "cpi_vehicles_raw.rds"))
saveRDS(inflation_raw,    file.path(path_clean, "inflation_raw.rds"))
saveRDS(ev_adoption_raw,  file.path(path_clean, "ev_adoption_raw.rds"))
saveRDS(fuel_prices_raw,  file.path(path_clean, "fuel_prices_raw.rds"))

saveRDS(inflation_raw,    file.path(path_clean, "inflation_raw.rds"))
