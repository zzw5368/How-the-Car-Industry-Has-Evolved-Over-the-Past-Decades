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
    date = date,
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
    date = date,
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
# AFDC Excel columns: Year, State, Electric Vehicle Registrations

ev_adoption_clean <- ev_adoption_raw %>%
  clean_names() %>%
  rename(
    year = year,
    state = state,
    ev_count = electric_vehicle_registrations
  ) %>%
  group_by(year) %>%                # sum over all states for national total
  summarise(ev_count = sum(ev_count, na.rm = TRUE), .groups = "drop") %>%
  arrange(year)

# 4) Clean fuel prices ----------------------------------------------
# The EIA Excel usually has columns: Date + price column.
# After clean_names(), look at names(fuel_prices_raw) if this fails
# and adjust the rename() line accordingly.

fuel_prices_clean <- fuel_prices_raw %>%
  clean_names()

# Print names once so you can check them if needed:
print(names(fuel_prices_clean))

# Here we *guess* the price column is the second column.
# If the name is different, replace the `fuel_price = ...` line with
# the actual column name you see printed above.
fuel_prices_clean <- fuel_prices_clean %>%
  rename(
    date = 1
  ) %>%
  mutate(
    date = as.Date(date),
    year = year(date)
  )

# If there is more than one price column, pick one here:
# Example (uncomment and adjust if needed):
# fuel_prices_clean <- fuel_prices_clean %>%
#   rename(
#     fuel_price = u_s_regular_conventional_retail_gasoline_prices_dollars_per_gallon
#   )

# For now, if the second column is the price:
if (ncol(fuel_prices_clean) >= 2) {
  fuel_prices_clean <- fuel_prices_clean %>%
    rename(fuel_price = 2) %>%
    mutate(fuel_price = as.numeric(fuel_price)) %>%
    drop_na(fuel_price) %>%
    select(year, date, fuel_price) %>%
    arrange(date)
}

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
