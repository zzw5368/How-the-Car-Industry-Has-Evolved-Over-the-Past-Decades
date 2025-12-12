# 02_cleaning.R
# Purpose: Clean and tidy the raw datasets, then save them to `data_clean/`.

library(tidyverse)
library(lubridate)
library(janitor)

path_clean <- "data_clean"

# Load raw data saved by 01_import.R --------------------------------

cpi_vehicles_raw <- readRDS(file.path(path_clean, "cpi_vehicles_raw.rds"))
inflation_raw    <- readRDS(file.path(path_clean, "inflation_raw.rds"))
ev_adoption_raw  <- readRDS(file.path(path_clean, "ev_adoption_raw.rds"))
fuel_prices_raw  <- readRDS(file.path(path_clean, "fuel_prices_raw.rds"))

# 1) Clean CPI for new vehicles -------------------------------------
# FRED CSV columns: DATE, CUUR0000SETA01

cpi_vehicles_clean <- cpi_vehicles_raw %>%
  clean_names() %>%
  rename(
    date = observation_date,
    cpi_new_vehicles = cuur0000seta01
  ) %>%
  mutate(
    date = as.Date(date),
    year = year(date),
    cpi_new_vehicles = as.numeric(cpi_new_vehicles)
  ) %>%
  select(year, date, cpi_new_vehicles) %>%
  arrange(date)


# 2) Clean overall CPI ----------------------------------------------
# FRED CSV columns: DATE, CPIAUCSL

inflation_clean <- inflation_raw %>%
  clean_names() %>%
  rename(
    date = observation_date,
    cpi_all_items = cpiaucsl
  ) %>%
  mutate(
    date = as.Date(date),
    year = year(date),
    cpi_all_items = as.numeric(cpi_all_items)
  ) %>%
  select(year, date, cpi_all_items) %>%
  arrange(date)


# 3) Clean EV adoption data -----------------------------------------
# After importing with skip = 2, the first column should be state,
# and one of the numeric columns should be the total EV registrations.

library(stringr)

ev_adoption_clean <- ev_adoption_raw %>%
  janitor::clean_names() %>%
  # First column is state name
  rename(state = 1)

# Find all numeric columns (these are the EV counts by whatever categories)
numeric_cols <- names(ev_adoption_clean)[sapply(ev_adoption_clean, is.numeric)]

# Use the LAST numeric column as the total EV registrations
total_col <- numeric_cols[length(numeric_cols)]

ev_adoption_clean <- ev_adoption_clean %>%
  mutate(
    ev_count = as.numeric(.data[[total_col]]),
    year = 2023
  ) %>%
  select(year, state, ev_count) %>%
  # Drop totals / blanks / NA rows
  filter(
    !is.na(ev_count),
    state != "",
    !str_detect(state, "total|Total")
  ) %>%
  arrange(desc(ev_count))




# 4) Clean fuel prices ----------------------------------------------
# After reading sheet = "Data 1", the first column is dates,
# and there are several numeric columns for different fuel products.
# We'll:
#   - make names clean
#   - treat column 1 as date
#   - use the *first numeric column* as our main fuel price series.

fuel_prices_clean <- fuel_prices_raw %>%
  clean_names()

# Find the first numeric column (one of the price series)
price_cols <- names(fuel_prices_clean)[sapply(fuel_prices_clean, is.numeric)]

fuel_prices_clean <- fuel_prices_clean %>%
  rename(date = 1) %>%              # first column is dates
  mutate(
    date = as.Date(date),
    fuel_price = as.numeric(.data[[price_cols[1]]]),
    year = lubridate::year(date)
  ) %>%
  drop_na(date, fuel_price) %>%
  select(year, date, fuel_price) %>%
  arrange(date)



# 5) Join vehicle CPI with overall CPI -------------------------------

vehicle_prices_joined <- cpi_vehicles_clean %>%
  left_join(inflation_clean, by = c("year", "date"))

# Save cleaned datasets ----------------------------------------------

write_csv(cpi_vehicles_clean,     file.path(path_clean, "cpi_vehicles_clean.csv"))
write_csv(inflation_clean,        file.path(path_clean, "inflation_clean.csv"))
write_csv(ev_adoption_clean,      file.path(path_clean, "ev_adoption_clean.csv"))
write_csv(fuel_prices_clean,      file.path(path_clean, "fuel_prices_clean.csv"))
write_csv(vehicle_prices_joined,  file.path(path_clean, "vehicle_prices_joined.csv"))

saveRDS(cpi_vehicles_clean,     file.path(path_clean, "cpi_vehicles_clean.rds"))
saveRDS(inflation_clean,        file.path(path_clean, "inflation_clean.rds"))
saveRDS(ev_adoption_clean,      file.path(path_clean, "ev_adoption_clean.rds"))
saveRDS(fuel_prices_clean,      file.path(path_clean, "fuel_prices_clean.rds"))
saveRDS(vehicle_prices_joined,  file.path(path_clean, "vehicle_prices_joined.rds"))
