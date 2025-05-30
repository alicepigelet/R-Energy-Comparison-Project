# Load required libraries
library(tidyverse)

# Load the data
data <- read_csv("data/Energy comparison project.csv")

# View structure
glimpse(data)

# Convert material and stage to factors (optional: for ordered plots)
data <- data %>%
  mutate(
    Material = factor(Material),
    Process_Stage = factor(Process_Stage, levels = unique(Process_Stage))
  )

# Plot energy values (exclude totals and use common energy unit for comparability)
energy_plot <- data %>%
  filter(Process_Stage != "Total", Energy_Unit == "GJ/ton") %>%
  ggplot(aes(x = Material, y = Energy_Value, fill = Process_Stage)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(
    title = "Energy Use by Material and Process Stage",
    y = "Energy (GJ per ton)",
    x = "Material"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# Save energy plot
ggsave("visuals/energy_by_stage.png", plot = energy_plot, width = 8, height = 5)

# Plot CO₂ emissions (similar logic)
co2_plot <- data %>%
  filter(Process_Stage != "Total", CO2_Unit == "kg/ton") %>%
  ggplot(aes(x = Material, y = CO2_Value, fill = Process_Stage)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(
    title = "CO₂ Emissions by Material and Process Stage",
    y = "CO₂ Emissions (kg per ton)",
    x = "Material"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# Save CO₂ plot
ggsave("visuals/co2_by_stage.png", plot = co2_plot, width = 8, height = 5)

# Print complete total per material (summary table)
totals <- data %>%
  filter(Process_Stage == "Total") %>%
  select(Material, Type, Energy_Value, Energy_Unit, CO2_Value, CO2_Unit)

print(totals)
