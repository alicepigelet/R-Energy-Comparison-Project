library(tidyverse)

data <- read_csv("data/clean_energy_comparison.csv")

# Rename columns for convenience
colnames(data) <- c("Material", "Process_Stage", "Energy_Value", "CO2_Value", "Notes", "Source")

totals <- data %>%
  group_by(Material) %>%
  summarise(
    Total_Energy = sum(Energy_Value, na.rm = TRUE),
    Total_CO2 = sum(CO2_Value, na.rm = TRUE)
  )

# Plot total energy
ggplot(totals, aes(x = Material, y = Total_Energy, fill = Material)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Total Energy Use per Material",
    y = "Energy (GJ per ton)",
    x = "Material"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

ggsave("total_energy_per_material.png", width = 8, height = 5)

# Plot total CO₂
ggplot(totals, aes(x = Material, y = Total_CO2, fill = Material)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Total CO₂ Emissions per Material",
    y = "CO₂ Emissions (kg per ton)",
    x = "Material"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

ggsave("total_co2_per_material.png", width = 8, height = 5)

totals <- totals %>%
  mutate(CO2_per_GJ = Total_CO2 / Total_Energy)

# Plot ratio
ggplot(totals, aes(x = Material, y = CO2_per_GJ, fill = Material)) +
  geom_bar(stat = "identity") +
  labs(
    title = "CO₂ Emissions per GJ of Energy",
    y = "CO₂ per GJ (kg/GJ)",
    x = "Material"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

ggsave("co2_per_gj.png", width = 8, height = 5)

