#' IAN_gene_id_mapper.R
#'
#' Maps gene identifiers from various input types (findmarker, DESeq2, or custom file) to ENTREZID and SYMBOL.
#'
#' @param input_type Character string specifying the input type. Must be one of "findmarker", "deseq", or "custom".
#' @param markers Data frame containing marker genes (required if `input_type` is "findmarker").
#' @param deg_file Path to a file containing differentially expressed genes (required if `input_type` is "custom").
#' @param organism Character string specifying the organism. Must be "human" or "mouse".
#' @param gene_type Character string specifying the gene identifier type in the input data. Must be one of "ENSEMBL", "ENTREZID", or "SYMBOL".
#' @param pvalue Numeric value specifying the p-value threshold for filtering marker genes (used if `input_type` is "findmarker"). Default is 0.05.
#' @param log2FC Numeric value specifying the log2 fold change threshold for filtering marker genes (used if `input_type` is "findmarker"). Default is 1.
#' @param deseq_results Data frame containing DESeq2 results (required if `input_type` is "deseq").
#'
#' @return A data frame with two columns: ENTREZID and SYMBOL, containing the mapped gene identifiers.
#'
#'
#' @importFrom clusterProfiler bitr
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @export
map_gene_ids <- function(input_type, markers = NULL, deg_file = NULL, organism = NULL, gene_type = NULL, pvalue = 0.05, log2FC = 1, deseq_results = NULL) {
  # Input validation
  if (!(organism %in% c("human", "mouse"))) {
    stop("Unsupported organism. Choose 'human' or 'mouse'.")
  }
  if (!(input_type %in% c("findmarker", "deseq", "custom"))) {
    stop("Invalid input_type. Choose from 'findmarker', 'deseq', or 'custom'.")
  }
  
  if (input_type == "findmarker" && is.null(markers)) {
    stop("Markers object is required for input_type 'findmarker'.")
  }
  if (input_type == "findmarker" && is.null(gene_type)) {
    stop("gene_type is required for input_type 'findmarker'.")
  }
  if (input_type == "findmarker" && !(gene_type %in% c("ENSEMBL", "ENTREZID", "SYMBOL"))) {
    stop("Invalid gene_type for 'findmarker' input. Choose from 'ENSEMBL', 'ENTREZID', or 'SYMBOL'.")
  }
  if (input_type == "custom" && is.null(gene_type)) {
    stop("gene_type is required for input_type 'custom'.")
  }
  if (input_type == "custom" && !(gene_type %in% c("ENSEMBL", "ENTREZID", "SYMBOL"))) {
    stop("Invalid gene_type for 'custom' input. Choose from 'ENSEMBL', 'ENTREZID', or 'SYMBOL'.")
  }
  if (input_type == "deseq" && is.null(deseq_results)) {
    stop("deseq_results object is required for input_type 'deseq'.")
  }
  if (input_type == "deseq" && is.null(gene_type)) {
    stop("gene_type is required for input_type 'deseq'.")
  }
  if (input_type == "deseq" && !(gene_type %in% c("ENSEMBL", "ENTREZID", "SYMBOL"))) {
    stop("Invalid gene_type for 'deseq' input. Choose from 'ENSEMBL', 'ENTREZID', or 'SYMBOL'.")
  }
  if (input_type == "deseq" && is.null(organism)) {
    stop("organism is required for input_type 'deseq'.")
  }
  
  # Check for necessary packages
  if (!requireNamespace("clusterProfiler", quietly = TRUE)) {
    stop("The 'clusterProfiler' package is required. Please install it using: BiocManager::install('clusterProfiler')")
  }
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    stop("The 'BiocManager' package is required. Please install it using: install.packages('BiocManager')")
  }
  
  # Set organism database
  human_db <- "org.Hs.eg.db"
  mouse_db <- "org.Mm.eg.db"
  organism_db <- switch(organism,
                        "human" = human_db,
                        "mouse" = mouse_db)
  
  # Check if organism database is installed
  if (!requireNamespace(organism_db, quietly = TRUE)) {
    stop(paste("The", organism_db, "database is not installed. Please install it using: BiocManager::install('", organism_db, "')", sep = ""))
  }
  
  # Load necessary libraries
  library(organism_db, character.only = TRUE)
  
  # Prepare gene list and fromType based on input type
  if (input_type == "findmarker") {
    markers <- markers %>%
#      dplyr::filter(p_val < pvalue & abs(avg_log2FC) > log2FC)
      dplyr::filter(.data[["p_val"]] < pvalue & abs(.data[["avg_log2FC"]]) > log2FC)
    genes <- rownames(markers)
    genes <- sub("\\..*", "", genes)
    deglist <- genes
    fromType <- gene_type
  } else if (input_type == "deseq") {
    deglist <- rownames(deseq_results)
    fromType <- gene_type
  }  else if (input_type == "custom") {
    deglist <- tryCatch({
      read.table(deg_file, header = FALSE, colClasses = "character")[, 1]
    }, error = function(e) {
      stop(paste("Error reading DEG file:", e$message))
    })
    fromType <- gene_type
  }
  
  # Map gene IDs (for custom and findmarker)
  gene_list <- if (input_type %in% c("custom", "findmarker", "deseq")) {
    tryCatch({
      suppressWarnings(clusterProfiler::bitr(
        deglist,
        fromType = fromType,
        toType = c("SYMBOL", "ENTREZID"),
        OrgDb = organism_db
      ))
    }, error = function(e) {
      warning(paste("Error during gene ID mapping:", e$message))
      return(data.frame(ENTREZID = character(0), SYMBOL = character(0)))
    })
  } else {
    data.frame(ENTREZID = deglist, SYMBOL = deglist)
  }
  
  # Select only ENTREZID and SYMBOL columns (for custom and findmarker)
  gene_list <- if (input_type %in% c("custom", "findmarker", "deseq") && nrow(gene_list) > 0) {
    gene_list[, c("ENTREZID", "SYMBOL")]
  } else {
    gene_list
  }
  
  return(gene_list)
}