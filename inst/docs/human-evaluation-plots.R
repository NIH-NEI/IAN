# human-evaluation-plots.R
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(reshape2)

# Read the data from a tab-delimited file
data <- read.table("/evaluation/human-evaluation.txt", header = TRUE, sep = "\t")

################# Box Whisker Plot Showing Distribution of Individual Metrics
# Define the desired order of metrics
metric_order <- c("Accuracy", "Relevance", "Clarity", "Trustworthiness", "Overall Satisfaction")

# Reorder the data based on the specified order
data <- data %>%
  mutate(Metric = factor(Metric, levels = metric_order))

# Calculate the number of data points for each metric
n_data <- data %>%
  group_by(Metric) %>%
  summarize(n = n())

# Create the box plot with n labels
ggplot(data, aes(x = Metric, y = Score, fill = Metric)) +
  geom_boxplot() +
  geom_text(data = n_data, aes(x = Metric, y = -0.5, label = paste0("n = ", n)), size = 3) +  # Add n labels
  labs(title = "Distribution of Individual Metrics", x = "Metric", y = "Score") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

ggsave("metrics-distribution.png", width = 10, height = 10, units = "cm")


############## FREQUENCY PLOTS
# Frequecy plot colored by Expert
# Create the frequency plot with expert level split
ggplot(data, aes(x = Score, fill = Expert)) +
  geom_histogram(binwidth = 1, color = "black", position = "dodge") +
  labs(title = "Frequency Distribution of Scores by Expert Level", x = "Score", y = "Frequency") +
  theme_bw() +
  geom_text(stat = "count", aes(label = ..count.., y = ..count.. + 1), position = position_dodge(width = 1), vjust = +0.5)

ggsave("frequency-distribution-dataset.png", width = 12, height = 12, units = "cm")

# Frequency plot colored by Metrics
# Create the frequency table
freq_table <- data %>%
  group_by(Metric, Score) %>%
  summarize(Count = n())

# Create the colored frequency table plot
ggplot(freq_table, aes(x = Score, y = Count, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Frequency Table of Scores by Metric", x = "Score", y = "Count") +
  theme_bw()
ggsave("frequency-table.png", width = 15, height = 10, units = "cm")

############### Summary statistics
# Calculate summary statistics for each metric
summary_stats <- data %>%
  group_by(Metric) %>%
  summarize(
    Mean = mean(Score),
    Median = median(Score),
    Min = min(Score),
    Max = max(Score),
    StdDev = sd(Score)
  )

# Print the summary statistics table
View(summary_stats)

##################### Tests
library(dplyr)
library(effsize)

# Assuming your data is stored in a dataframe called 'data'
# Make sure your data has columns named: Metric, Score, ExpertN, Expert, DataSet, ExpertD

# Function to perform Wilcoxon test and calculate effect size Table 6
perform_wilcoxon_test <- function(metric) {
  # Filter data for the specified metric
  metric_data <- data[data$Metric == metric, ]

  # Perform Wilcoxon test
  test_result <- wilcox.test(Score ~ Expert, data = metric_data)

  # Calculate Cliff's Delta effect size
  effect_size <- cliff.delta(metric_data$Score[metric_data$Expert == "Senior"],
                             metric_data$Score[metric_data$Expert == "Junior"])

  # Return results as a list
  return(list(
    p_value = test_result$p.value,
    effect_size = effect_size$estimate
  ))
}

# List of metrics to test
metrics_to_test <- c("Accuracy", "Relevance", "Clarity", "Trustworthiness", "Overall Satisfaction")

# Perform tests and calculate effect sizes for each metric
results <- lapply(metrics_to_test, perform_wilcoxon_test)

# Apply Bonferroni correction to p-values
adjusted_p_values <- p.adjust(unlist(lapply(results, "[[", "p_value")), method = "bonferroni")

# Combine results into a dataframe
results_df <- data.frame(
  Metric = metrics_to_test,
  P_value = adjusted_p_values,
  Effect_Size = unlist(lapply(results, "[[", "effect_size"))
)

# Print the results
View(results_df)

# Test for skewness towards 5
wilcox.test(data$Score, mu = 5, alternative = "less")
