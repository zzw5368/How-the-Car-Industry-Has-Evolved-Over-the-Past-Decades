# 03_analysis.R
# Purpose: Use cleaned datasets to create plots and summary statistics.
# Figures are saved into `images/`.

library(tidyverse)
library(lubridate)

path_clean  <- "data_clean"
path_images <- "images"

if (!dir.exists(path_images)) {
  dir.create(path_images)
}

# Load cleaned data -------------------------------------------------

cpi_vehicles_clean    <- readRDS(file.path(path_clean, "cpi_vehicles_clean.rds"))
inflation_clean       <- readRDS(file.path(path_clean, "inflation_clean.rds"))
ev_adoption_clean     <- readRDS(file.path(path_clean, "ev_adoption_clean.rds"))
fuel_prices_clean     <- readRDS(file.path(path_clean, "fuel_prices_clean.rds"))
vehicle_prices_joined <- readRDS(file.path(path_clean, "vehicle_prices_joined.rds"))

# 1) CPI for new vehicles -------------------------------------------

p_vehicle_cpi <- cpi_vehicles_clean %>%
  ggplot(aes(x = year, y = cpi_new_vehicles)) +
  geom_line() +
  labs(
    title = "CPI for New Vehicles Over Time",
    x = "Year",
    y = "CPI (New Vehicles Index)"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(path_images, "vehicle_cpi_trend.png"),
  plot = p_vehicle_cpi,
  width = 8, height = 5
)

# 2) EV adoption – Top 10 states in 2023 -----------------------------

ev_top10 <- ev_adoption_clean %>%
  arrange(desc(ev_count)) %>%
  slice_head(n = 10)

p_ev <- ggplot(ev_top10, aes(x = reorder(state, ev_count), y = ev_count)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 U.S. States by EV Registrations (2023)",
    x = "State",
    y = "Number of Registered EVs"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(path_images, "ev_adoption_trend.png"),
  plot = p_ev,
  width = 8,
  height = 5
)



# 3) Fuel prices over time ------------------------------------------

p_fuel_prices <- fuel_prices_clean %>%
  ggplot(aes(x = date, y = fuel_price)) +
  geom_line() +
  labs(
    title = "U.S. Fuel Prices Over Time",
    x = "Year",
    y = "Dollars per Gallon"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(path_images, "fuel_price_trend.png"),
  plot = p_fuel_prices,
  width = 8, height = 5
)

# 4) Simple summary table -------------------------------------------

vehicle_summary <- vehicle_prices_joined %>%
  group_by(year) %>%
  summarise(
    avg_cpi_vehicles = mean(cpi_new_vehicles, na.rm = TRUE),
    avg_cpi_overall  = mean(cpi_all_items,    na.rm = TRUE),
    .groups = "drop"
  )

print(vehicle_summary)
