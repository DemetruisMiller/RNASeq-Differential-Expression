de_results <- de_results %>%
  mutate(Expression = case_when(
    logFC >= 1 & FDR < 0.05 ~ "Up-regulated",
    logFC <= -1 & FDR < 0.05 ~ "Down-regulated",
    TRUE ~ "Not Significant"
  ))

volcano_plot <- ggplot(de_results, aes(x = logFC, y = -log10(FDR), color = Expression)) +
  geom_point(alpha = 0.6, size = 1.5) +
  scale_color_manual(values = c("royalblue", "grey", "firebrick")) +
  theme_minimal() +
  labs(title = "Volcano Plot", x = "log2 Fold Change", y = "-log10 FDR")
print(volcano_plot)
ggsave("volcano_plot.png", width = 8, height = 6, dpi = 300)

write.csv(up_regulated, "up_regulated_genes.csv", row.names = FALSE)
write.csv(down_regulated, "down_regulated_genes.csv", row.names = FALSE)

ma_plot <- ggplot(de_results, aes(x = logCPM, y = logFC, color = Expression)) +
  geom_point(alpha = 0.6, size = 1.5) +
  scale_color_manual(values = c("royalblue", "grey", "firebrick")) +
  theme_minimal() +
  labs(title = "MA Plot", x = "Average Expression (logCPM)", y = "Log Fold Change (logFC)")
print(ma_plot)
ggsave("ma_plot.png", width = 8, height = 6, dpi = 300)

save.image("hemp_rnaseq_analysis.RData")

