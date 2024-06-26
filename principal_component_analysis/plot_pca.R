#!/usr/bin/env Rscript

library(argparse)
library(ggplot2)


args = commandArgs(trailingOnly=TRUE)

# Read in eigenvector
pca <- read.table(args[1], header=F) # ex. PCA.eigenvec

# Read in eigenval
eigenval <- read.table(args[2], header=F) # ex. PCA.eigenval

pca <- pca[,-1]
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))

pve <- data.frame(PC = 1:16, pve = eigenval/sum(eigenval)*100)
plot_eigenval <- ggplot(pve, aes(x=PC, y=V1))+geom_bar(stat='identity', color = '#1f78b4', fill = '#1f78b4')+ylab("Percentage variance explained")+theme_bw()+scale_fill_grey()+theme(text = element_text(size = 14))
ggsave('pca/percentage_variance_pca_noWaterBuffalo.pdf', width = 20, height = 20, units = "cm")

# calculate cumulative sum
cumsum(pve$V1)
pca$color <- c("#7570b3", "#7570b3", "#7570b3", "#7570b3", "#7570b3", "#7570b3", "#d95f02", "#d95f02", "#1b9e77", "#1b9e77", "#1b9e77", "#1b9e77", "#e7298a", "#e7298a", "#d95f02", "#d95f02")
pca_p1_p2 <- ggplot(pca, aes(PC1, PC2))+geom_point(size = 5, fill = pca$color, alpha = 0.7, colour="black", pch = 21)+theme_bw()+theme(text = element_text(size = 16))
pca_p1_p2 + xlab(paste0("Principal component analysis 1 (", signif(pve$V1[1], 3), "%)")) + ylab(paste0("Principal component analysis 2 (", signif(pve$V1[2], 3), "%)"))
ggsave("pca/pca1_vs_pca2_noWaterBuffalo.pdf", width = 20, height = 20, units = "cm")

pca_p2_p3 <- ggplot(pca, aes(PC2, PC3))+geom_point(size = 5, fill = pca$color, alpha = 0.7, colour="black", pch = 21)+theme_bw()+theme(text = element_text(size = 16))
pca_p2_p3 + xlab(paste0("Principal component analysis 2 (", signif(pve$V1[2], 3), "%)")) + ylab(paste0("Principal component analysis 3 (", signif(pve$V1[3], 3), "%)"))
ggsave("pca/pca2_vs_pca3_noWaterBuffalo.pdf", width = 20, height = 20, units = "cm")

