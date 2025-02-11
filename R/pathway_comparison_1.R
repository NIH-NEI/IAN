library(dplyr)
library(stringr)

# Helper function to save results to a text file
save_results <- function(results, filename, type = "original") {
  if (is.null(results) || (is.list(results) && "error" %in% names(results))) {
    message(paste("Warning: No results to save for", filename, type, "results."))
    return()
  }
  
  tryCatch({
    if (is.list(results) && !is.data.frame(results)) {
      # Convert list of vectors to a data frame
      results_df <- data.frame(matrix(unlist(lapply(results, function(x) paste(x, collapse = ", "))), nrow = 1, byrow = TRUE), stringsAsFactors = FALSE)
      colnames(results_df) <- names(results)
      write.table(results_df, file = filename, sep = "\t", row.names = FALSE, quote = FALSE)
    } else {
      write.table(results, file = filename, sep = "\t", row.names = FALSE, quote = FALSE)
    }
  }, error = function(e) {
    message(paste("Error saving filtered results to", filename, ":", e$message))
  })
}

# Function to perform pathway comparison
perform_pathway_comparison <- function(gene_symbols, kegg_results, wp_results, reactome_results, go_results, output_dir = "enrichment_results") {
  
  # Check if any results are NULL
  if (is.null(kegg_results) && is.null(wp_results) && is.null(reactome_results) && is.null(go_results)) {
    message("Warning: No valid pathway results provided for comparison.")
    return(list(error = "No valid pathway results provided"))
  }
  
  tryCatch({
    # Convert gene_symbols to a character vector if it's a factor
    if (is.factor(gene_symbols)) {
      gene_symbols <- as.character(gene_symbols)
    }
    
    # Extract gene lists from each pathway analysis
    kegg_genes <- if (!is.null(kegg_results) && nrow(kegg_results) > 0) {
      kegg_results$Gene
    } else {
      character(0)
    }
    
    wp_genes <- if (!is.null(wp_results) && nrow(wp_results) > 0) {
      wp_results$Gene
    } else {
      character(0)
    }
    
    reactome_genes <- if (!is.null(reactome_results) && nrow(reactome_results) > 0) {
      reactome_results$Gene
    } else {
      character(0)
    }
    
    go_genes <- if (!is.null(go_results) && nrow(go_results) > 0) {
      go_results$Gene
    } else {
      character(0)
    }
    
    # Combine all pathway gene lists into a single vector
    pathway_genes <- unique(c(unlist(strsplit(kegg_genes, ",")),
                              unlist(strsplit(wp_genes, ",")),
                              unlist(strsplit(reactome_genes, ","))))
    
    # Find DEGs not in any pathways
    no_pathway_genes <- setdiff(gene_symbols, pathway_genes)
    
    # Combine all gene lists
    all_genes <- unique(c(unlist(strsplit(kegg_genes, ",")),
                          unlist(strsplit(wp_genes, ",")),
                          unlist(strsplit(reactome_genes, ",")),
                          unlist(strsplit(go_genes, ","))))
    
    # Find overlaps
    kegg_overlap <- all_genes[all_genes %in% unlist(strsplit(kegg_genes, ","))]
    wp_overlap <- all_genes[all_genes %in% unlist(strsplit(wp_genes, ","))]
    reactome_overlap <- all_genes[all_genes %in% unlist(strsplit(reactome_genes, ","))]
    go_overlap <- all_genes[all_genes %in% unlist(strsplit(go_genes, ","))]
    
    # Find unique genes
    kegg_unique <- setdiff(unlist(strsplit(kegg_genes, ",")), c(unlist(strsplit(wp_genes, ",")), unlist(strsplit(reactome_genes, ",")), unlist(strsplit(go_genes, ","))))
    wp_unique <- setdiff(unlist(strsplit(wp_genes, ",")), c(unlist(strsplit(kegg_genes, ",")), unlist(strsplit(reactome_genes, ",")), unlist(strsplit(go_genes, ","))))
    reactome_unique <- setdiff(unlist(strsplit(reactome_genes, ",")), c(unlist(strsplit(kegg_genes, ",")), unlist(strsplit(wp_genes, ",")), unlist(strsplit(go_genes, ","))))
    go_unique <- setdiff(unlist(strsplit(go_genes, ",")), c(unlist(strsplit(kegg_genes, ",")), unlist(strsplit(wp_genes, ",")), unlist(strsplit(reactome_genes, ","))))
    
    # Create a list to store the results
    comparison_results <- list(
      kegg_overlap = kegg_overlap,
      wp_overlap = wp_overlap,
      reactome_overlap = reactome_overlap,
      go_overlap = go_overlap,
      kegg_unique = kegg_unique,
      wp_unique = wp_unique,
      reactome_unique = reactome_unique,
      go_unique = go_unique,
      no_pathway_genes = no_pathway_genes
    )
    
    # Print the results for inspection
    # print("Pathway Comparison Results:")
    # print(comparison_results)
    
    # Save the results
    save_results(comparison_results, file.path(output_dir, "pathway_comparison.txt"), type = "filtered")
    
    return(comparison_results)
    
  }, error = function(e) {
    message(paste("Error in pathway comparison:", e$message))
    return(list(error = "Pathway Comparison Failed", message = e$message))
  })
}
