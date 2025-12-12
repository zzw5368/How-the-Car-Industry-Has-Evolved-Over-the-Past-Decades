# 03_analysis.R
# Purpose: Use cleaned datasets to create plots and summary statistics.
# Save figures into `images/` for use in the README and presentation.

library(tidyverse)
library(lubridate)

path_clean  <- "data_clean"
path_images <- "images"

if (!dir.exists(path_images)) {
  dir.create(path_images)
}

# Load cleaned data -------------------------------------------------------

cpi_vehicles_clean    <- readRDS(file.path(path_clean, "cpi_vehicles_clean.rds"))
fuel_prices_clean     <- readRDS(file.path(path_clean, "fuel_prices_clean.rds"))
ev_adoption_clean     <- readRDS(file.path(path_clean, "ev_adoption_clean.rds"))
vehicle_prices_joined <- readRDS(file.path(path_clean, "vehicle_prices_joined.rds"))

# 1) Trend: CPI for new vehicles over time --------------------------------

p_vehicle_cpi <- cpi_vehicles_clean %>%
  ggplot(aes(x = year, y = cpi_new_vehicles)) +
  geom_line() +
  labs(
    title = "CPI for New Vehicles Over Time",
    x = "Year",
    y = "CPI (New Vehicles)"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(path_images, "vehicle_cpi_trend.png"),
  plot = p_vehicle_cpi,
  width = 8, height = 5
)

# 2) Trend: EV adoption over time -----------------------------------------

p_ev_adoption <- ev_adoption_clean %>%
  ggplot(aes(x = year, y = ev_count)) +
  geom_line() +
  labs(
    title = "Electric Vehicle Adoption Over Time",
    x = "Year",
    y = "Number of EVs (or registrations)"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(path_images, "ev_adoption_trend.png"),
  plot = p_ev_adoption,
  width = 8, height = 5
)

# 3) Trend: Fuel prices over time -----------------------------------------

p_fuel_prices <- fuel_prices_clean %>%
  ggplot(aes(x = date, y = fuel_price)) +
  geom_line() +
  labs(
    title = "Fuel Prices Over Time",
    x = "Year",
    y = "Fuel Price (per gallon)"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(path_images, "fuel_price_trend.png"),
  plot = p_fuel_prices,
  width = 8, height = 5
)

# 4) Simple summary table example -----------------------------------------

vehicle_summary <- vehicle_prices_joined %>%
  group_by(year) %>%
  summarise(
    avg_cpi_vehicles = mean(cpi_new_vehicles, na.rm = TRUE),
    avg_cpi_overall  = mean(cpi_all_items, na.rm = TRUE)
  )

print(vehicle_summary)

