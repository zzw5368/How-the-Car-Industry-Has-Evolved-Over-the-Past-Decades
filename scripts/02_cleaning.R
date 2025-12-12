# 02_cleaning.R
# Purpose: Clean and tidy the raw datasets, then save them to `data_clean/`.

library(tidyverse)
library(lubridate)
library(janitor)

path_clean <- "data_clean"

# Load previously imported raw data --------------------------------------

cpi_vehicles_raw <- readRDS(file.path(path_clean, "cpi_vehicles_raw.rds"))
fuel_prices_raw  <- readRDS(file.path(path_clean, "fuel_prices_raw.rds"))
ev_adoption_raw  <- readRDS(file.path(path_clean, "ev_adoption_raw.rds"))
inflation_raw    <- readRDS(file.path(path_clean, "inflation_raw.rds"))

# Helper: clean names and basic checks -----------------------------------

clean_basic <- function(df) {
  df %>%
    clean_names() %>%
    distinct()
}

cpi_vehicles_clean <- cpi_vehicles_raw %>%
  clean_basic() %>%
  # TODO: adjust column names to your actual file
  mutate(
    year = as.integer(year),
    cpi_new_vehicles = as.numeric(cpi_new_vehicles)
  ) %>%
  arrange(year)

fuel_prices_clean <- fuel_prices_raw %>%
  clean_basic() %>%
  # TODO: adjust to actual columns (e.g., date, price_per_gallon)
  mutate(
    date = ymd(date),
    year = year(date),
    fuel_price = as.numeric(fuel_price)
  ) %>%
  arrange(date)

ev_adoption_clean <- ev_adoption_raw %>%
  clean_basic() %>%
  # TODO: adjust to actual columns (e.g., year, ev_count)
  mutate(
    year = as.integer(year),
    ev_count = as.numeric(ev_count)
  ) %>%
  arrange(year)

inflation_clean <- inflation_raw %>%
  clean_basic() %>%
  # TODO: adjust to actual columns (e.g., year, cpi_all_items)
  mutate(
    year = as.integer(year),
    cpi_all_items = as.numeric(cpi_all_items)
  ) %>%
  arrange(year)

# Example: create a combined inflation-adjusted vehicle price index -------

# This is a placeholder join; you’ll tailor it once you see your columns.
vehicle_prices_joined <- cpi_vehicles_clean %>%
  left_join(inflation_clean, by = "year")

# Save cleaned datasets ---------------------------------------------------

write_csv(cpi_vehicles_clean,      file.path(path_clean, "cpi_vehicles_clean.csv"))
write_csv(fuel_prices_clean,       file.path(path_clean, "fuel_prices_clean.csv"))
write_csv(ev_adoption_clean,       file.path(path_clean, "ev_adoption_clean.csv"))
write_csv(inflation_clean,         file.path(path_clean, "inflation_clean.csv"))
write_csv(vehicle_prices_joined,   file.path(path_clean, "vehicle_prices_joined.csv"))

# Optionally also save as RDS
saveRDS(cpi_vehicles_clean,     file.path(path_clean, "cpi_vehicles_clean.rds"))
saveRDS(fuel_prices_clean,      file.path(path_clean, "fuel_prices_clean.rds"))
saveRDS(ev_adoption_clean,      file.path(path_clean, "ev_adoption_clean.rds"))
saveRDS(inflation_clean,        file.path(path_clean, "inflation_clean.rds"))
saveRDS(vehicle_prices_joined,  file.path(path_clean, "vehicle_prices_joined.rds"))
