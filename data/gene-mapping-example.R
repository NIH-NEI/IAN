# Example usage:
gene_type <- "ENSEMBL" # or "ENTREZID", "SYMBOL"
organism <- "human" # or 'mouse'
input_type <- "custom" # one of findmarker, deseq, custom
deseq_results <- resSigOrderedLFC_all
markers <- markeringroup
deg_file <- "/Users/nagarajanv/OneDrive - National Institutes of Health/Research/smart-enrichment/Ian/Ian/data/uveitis-PIIS0002939421000271-deg.txt" # Replace with your file path

########### cutom deg list
deg_file <- "/Users/nagarajanv/OneDrive - National Institutes of Health/Research/smart-enrichment/Ian/Ian/data/uveitis-PIIS0002939421000271-deg.txt" # Replace with your file path
head(read.table(deg_file))

########### seurat findmarkers
load("/Users/nagarajanv/OneDrive - National Institutes of Health/Research/singlecellassistant/Archive/data/pbmc.RData")
library(Seurat)
pbmc <- NormalizeData(pbmc)
pbmc <- FindVariableFeatures(pbmc)
all.genes <- rownames(pbmc)
pbmc <- ScaleData(pbmc, features = all.genes)
pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))
pbmc <- FindNeighbors(pbmc, dims = 1:10)
pbmc <- FindClusters(pbmc, resolution = 0.9)
markersall=FindAllMarkers(pbmc)
markeringroup = FindMarkers(pbmc, ident.1 = "0", ident.2 = "4")
head(pbmc)
pbmc <- RunUMAP(pbmc, dims = 1:10)
DimPlot(pbmc, reduction = "umap", label = T, repel = TRUE) 

########## deseq2 
library(DESeq2)
#library(tidyverse)
#library(dplyr)
# Download uveitis count matrix
# https://ftp.ncbi.nlm.nih.gov/geo/series/GSE198nnn/GSE198533/suppl/GSE198533%5FRaw%5Fgene%5Fcounts%5Fmatrix.csv.gz
countData <- read.csv("/Users/nagarajanv/OneDrive - National Institutes of Health/Research/smart-enrichment/Ian/Ian/data/GSE198533_Raw_gene_counts_matrix.csv", header = TRUE, sep = ",")
head(countData)
countData <- countData %>%
  dplyr::select(gene_id, ends_with("_count"))
head(countData)
metaData <- read.csv('/Users/nagarajanv/OneDrive - National Institutes of Health/Research/smart-enrichment/Ian/Ian/data/GSE198533_metadata.csv', header = TRUE, sep = ",")
metaData
dds <- DESeqDataSetFromMatrix(countData=countData, 
                              colData=metaData, 
                              design=~group, tidy = TRUE)
dds
dds <- DESeq(dds)
res <- results(dds)
head(results(dds, tidy=TRUE))

# Extract contrast results for HC vs BD (HC/BD)
results_all <- results(dds, contrast = c("group","HC","BD"))
# check results
results_all
head(results(dds, tidy=TRUE))
resultsNames(dds)
summary(results_all)
## Shrink pvalues - https://doi.org/10.1093/bioinformatics/bty895
results_all_lfc <- lfcShrink(dds, coef="group_HC_vs_BD", res=results_all)
head(results_all_lfc)
## Sort results based on pvalue column
resOrderedLFC_all <- results_all_lfc[order(results_all_lfc$pvalue),]
## Filter for significantly differentially open chromatin regions - padj 0.05, logfold 1 (fold 2)
resSigOrderedLFC_all <- subset(resOrderedLFC_all, padj < 0.05 & abs(log2FoldChange) >= 1)
resSigOrderedLFC_all <- as.data.frame(resSigOrderedLFC_all)
head(resSigOrderedLFC_all)
View(resSigOrderedLFC_all)
rownames(as.data.frame(resSigOrderedLFC_all))

#################

# Assuming you have a DESeq2 results object called 'resSigOrderedLFC_all'
# and it is already filtered for significant genes

# Example usage with deseq_results object:
mapped_genes_deseq <- map_gene_ids(
  input_type = "deseq",
  organism = "human",
  gene_type = "ENSEMBL",
  deseq_results = resSigOrderedLFC_all
)

# Example usage with findmarker object:
mapped_genes_findmarker <- map_gene_ids(
  input_type = "findmarker",
  organism = "human",
  gene_type = "SYMBOL",
  markers = markeringroup
)

# Example usage with custom object:
mapped_genes_custom <- map_gene_ids(
  input_type = "custom",
  organism = "human",
  deg_file = deg_file,
  gene_type = "ENSEMBL"
)

head(mapped_genes_deseq)
head(mapped_genes_findmarker)
head(mapped_genes_custom)

gene_mapping = mapped_genes_custom
