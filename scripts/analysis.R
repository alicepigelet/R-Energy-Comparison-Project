# Load required libraries
library(tidyverse)

# Load the data
data <- read_csv("data/clean_energy_comparison.csv")

# Rename columns for convenience
colnames(data) <- c("Material", "Process_Stage", "Energy_Value", "CO2_Value", "Notes", "Source")

# Plot energy values by stage
energy_plot <- data %>%
  filter(!is.na(Energy_Value)) %>%
  ggplot(aes(x = Material, y = Energy_Value, fill = Process_Stage)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(
    title = "Energy Use by Material and Process Stage",
    y = "Energy (GJ per ton)",
    x = "Material"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
ggsave("energy_by_stage.png", plot = energy_plot, width = 8, height = 5)

# Plot CO2 values by stage
co2_plot <- data %>%
  filter(!is.na(CO2_Value)) %>%
  ggplot(aes(x = Material, y = CO2_Value, fill = Process_Stage)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(
    title = "CO₂ Emissions by Material and Process Stage",
    y = "CO₂ Emissions (kg per ton)",
    x = "Material"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
ggsave("co2_by_stage.png", plot = co2_plot, width = 8, height = 5)

# Calculate total energy and CO2 per material
totals <- data %>%
  group_by(Material) %>%
  summarise(
    Total_Energy = sum(Energy_Value, na.rm = TRUE),
    Total_CO2 = sum(CO2_Value, na.rm = TRUE)
  ) %>%
  mutate(CO2_per_GJ = Total_CO2 / Total_Energy)

# Print final totals
print(totals)
