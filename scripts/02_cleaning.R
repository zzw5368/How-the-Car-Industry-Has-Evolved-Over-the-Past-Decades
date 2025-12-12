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
# AFDC Excel is wide format: first column = state, next columns = years

ev_adoption_clean <- ev_adoption_raw %>%
  clean_names() %>%
  # First row contains headers; convert first row into column names
  row_to_names(row_number = 1) %>%
  clean_names() %>%
  # Now we pivot year columns into long format
  pivot_longer(
    cols = -state,
    names_to = "year",
    values_to = "ev_count"
  ) %>%
  mutate(
    year = as.numeric(year),
    ev_count = as.numeric(ev_count)
  ) %>%
  drop_na(ev_count) %>%
  group_by(year) %>%                # summarize to national total
  summarise(ev_count = sum(ev_count, na.rm = TRUE), .groups = "drop") %>%
  arrange(year)


# 4) Clean fuel prices ----------------------------------------------
# The EIA Excel usually has date in the first column and prices in the second.
# We make this robust by:
# - cleaning names
# - renaming col 1 -> date, col 2 -> fuel_price
# - parsing date with lubridate::ymd()
# - dropping rows with invalid dates/prices

fuel_prices_clean <- fuel_prices_raw %>%
  clean_names()

# Check the column names once in the console (optional):
print(names(fuel_prices_clean))

fuel_prices_clean <- fuel_prices_clean %>%
  # first column is the date, second is the price series
  rename(
    date = 1,
    fuel_price = 2
  ) %>%
  mutate(
    # try to parse many common date formats
    date = lubridate::ymd(date),
    fuel_price = as.numeric(fuel_price),
    year = lubridate::year(date)
  ) %>%
  # keep only rows where we successfully parsed both
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
