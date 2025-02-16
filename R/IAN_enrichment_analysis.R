#' Save Results to File
#'
#' Helper function to save enrichment analysis results to a tab-separated text file.
#'
#' @param results The results object to save. Can be an `enrichResult` object, a data frame, or a list with an "error" element.
#' @param filename The name of the file to save the results to.
#' @param type Character string specifying the type of results being saved. Must be "original" or "filtered". Default is "original".
#'
#' @return None (side effect: saves a file).
#'

save_results <- function(results, filename, type = "original") {
  if (is.null(results) || (is.list(results) && "error" %in% names(results))) {
    message(paste("Warning: No results to save for", filename, type, "results."))
    return()
  }
  
  if (type == "original") {
    if (methods::is(results, "enrichResult") || methods::is(results, "data.frame")) {
      tryCatch({
        if (methods::is(results, "enrichResult")) {
          write.table(results@result, file = filename, sep = "\t", row.names = FALSE, quote = FALSE)
        } else {
          write.table(results, file = filename, sep = "\t", row.names = FALSE, quote = FALSE)
        }
      }, error = function(e) {
        message(paste("Error saving original results to", filename, ":", e$message))
      })
    } else {
      message(paste("Warning: Cannot save original results for", filename, "as it is not an enrichResult object or data.frame."))
    }
  } else {
    tryCatch({
      write.table(results, file = filename, sep = "\t", row.names = FALSE, quote = FALSE)
    }, error = function(e) {
      message(paste("Error saving filtered results to", filename, ":", e$message))
    })
  }
}

#' Perform WikiPathway Enrichment Analysis
#'
#' Performs WikiPathway enrichment analysis using the `enrichWP` function from the `clusterProfiler` package.
#'
#' @param gene_ids A vector of gene identifiers (ENTREZIDs).
#' @param gene_mapping A data frame containing gene mappings between ENTREZID and SYMBOL. Must have columns named "ENTREZID" and "SYMBOL".
#' @param organism Character string specifying the organism. Must be "human" or "mouse".
#' @param pvalue Numeric value specifying the p-value threshold for filtering results. Default is 0.05.
#' @param output_dir Character string specifying the directory to save the results to. Default is "enrichment_results".
#'
#' @return A data frame containing the filtered WikiPathway enrichment results, or a list with an "error" element if the analysis fails.
#'
#' @importFrom clusterProfiler enrichWP
#' @importFrom dplyr filter arrange slice mutate left_join group_by summarize select
#' @importFrom tidyr unnest
#' @importFrom stringr strsplit
#' @export
perform_wp_enrichment <- function(gene_ids, gene_mapping, organism, pvalue = 0.05, output_dir = "enrichment_results") {
  if (missing(organism)) {
    stop("Error: The 'organism' argument is missing. Please specify either 'human' or 'mouse'.")
  }
  
  organism <- tolower(organism)
  
  if (organism == "human") {
    organism <- "Homo sapiens"
  } else if (organism == "mouse") {
    organism <- "Mus musculus"
  } else if (!(organism %in% c("human", "mouse"))){
    stop("Error: Invalid organism. Please specify either 'human' or 'mouse'.")
  }
  
  tryCatch({
    wp_enrichment <- enrichWP(gene = gene_ids, organism = organism)
    
    # Save original results
    save_results(wp_enrichment@result, file.path(output_dir, "wp_enrichment_original.txt"), type = "original")
    
    wp_enrichment_results <- wp_enrichment@result %>%
      dplyr::filter(pvalue < !!pvalue) %>%
      dplyr::arrange(pvalue) %>%
      dplyr::slice(1:min(nrow(.), 100)) %>%
      dplyr::mutate(geneID = strsplit(geneID, "/")) %>%
      tidyr::unnest(geneID) %>%
      dplyr::mutate(geneID = as.character(geneID)) %>%
      dplyr::left_join(gene_mapping, by = c("geneID" = "ENTREZID")) %>%
      dplyr::mutate(Gene = ifelse(!is.na(SYMBOL), SYMBOL, geneID)) %>%
      dplyr::group_by(ID, Description, pvalue) %>%
      dplyr::summarize(., geneID = paste(unique(geneID), collapse = ","),
                       Gene = paste(unique(Gene), collapse = ","), .groups = "drop") %>%
      dplyr::select(ID, Description, pvalue, Gene)
    
    # Save filtered results
    save_results(wp_enrichment_results, file.path(output_dir, "wp_enrichment_filtered.txt"), type = "filtered")
    
    return(wp_enrichment_results)
  }, error = function(e) {
    message(paste("Error in WikiPathway enrichment:", e$message))
    return(list(error = "WikiPathway Enrichment Failed", message = e$message))
  })
}


#' Perform KEGG Enrichment Analysis
#'
#' Performs KEGG enrichment analysis using the `enrichKEGG` function from the `clusterProfiler` package.
#'
#' @param gene_ids A vector of gene identifiers (ENTREZIDs).
#' @param gene_mapping A data frame containing gene mappings between ENTREZID and SYMBOL. Must have columns named "ENTREZID" and "SYMBOL".
#' @param organism Character string specifying the organism. Must be "human" or "mouse".
#' @param pvalue Numeric value specifying the p-value threshold for filtering results. Default is 0.05.
#' @param output_dir Character string specifying the directory to save the results to. Default is "enrichment_results".
#'
#' @return A data frame containing the filtered KEGG enrichment results, or a list with an "error" element if the analysis fails.
#'
#' @importFrom clusterProfiler enrichKEGG
#' @importFrom dplyr filter arrange slice mutate left_join group_by summarize select
#' @importFrom tidyr unnest
#' @importFrom stringr strsplit
#' @export
perform_kegg_enrichment <- function(gene_ids, gene_mapping, organism, pvalue = 0.05, output_dir = "enrichment_results") {
  
  # Check organism input
  organism <- tolower(organism)
  if (!(organism %in% c("human", "mouse"))) {
    stop("Error: Invalid organism. Please specify either 'human' or 'mouse'.")
  }
  
  # Suppress the warning message for database loading
  suppressWarnings({
    # Function to check and install the database if needed
    install_organism_db <- function(organism) {
      organism_db <- switch(organism,
                            "human" = "org.Hs.eg.db",
                            "mouse" = "org.Mm.eg.db",
                            stop("Unsupported organism. Please choose from 'human' or 'mouse'.")
      )
      
      if (!requireNamespace(organism_db, quietly = TRUE)) {
        cat(paste("The", organism_db, "database is not installed. Installing...\n"))
        BiocManager::install(organism_db)
      }
      
      # Use :: to access the library function from the specific package
      library(organism_db, character.only = TRUE)
      return(organism_db)
    }
    # Convert organism name to a standard code used by clusterProfiler
    organism_code <- switch(organism,
                            "human" = "hsa",
                            "mouse" = "mmu",
                            stop("Unsupported organism. Please choose from 'human' or 'mouse'.")
    )
    # 1. Check and install the database if needed
    tryCatch({
      organism_db <- install_organism_db(organism)
    }, error = function(e) {
      message(paste("Error in install_organism_db:", e$message))
      return(e$message)
    })
  })
  
  tryCatch({
    kegg_enrichment <- enrichKEGG(gene = gene_ids, organism = organism_code)
    
    # Save original results
    save_results(kegg_enrichment@result, file.path(output_dir, "kegg_enrichment_original.txt"), type = "original")
    
    kegg_enrichment_results <- kegg_enrichment@result %>%
      dplyr::filter(pvalue < !!pvalue) %>%
      dplyr::arrange(pvalue) %>%
      dplyr::slice(1:min(nrow(.), 100)) %>%
      dplyr::mutate(geneID = strsplit(geneID, "/")) %>%
      tidyr::unnest(geneID) %>%
      dplyr::mutate(geneID = as.character(geneID)) %>%
      dplyr::left_join(gene_mapping, by = c("geneID" = "ENTREZID")) %>%
      dplyr::mutate(Gene = ifelse(!is.na(SYMBOL), SYMBOL, geneID)) %>%
      dplyr::group_by(ID, Description, pvalue) %>%
      dplyr::summarize(., geneID = paste(unique(geneID), collapse = ","),
                       Gene = paste(unique(Gene), collapse = ","), .groups = "drop") %>%
      dplyr::select(ID, Description, pvalue, Gene)
    
    # Save filtered results
    save_results(kegg_enrichment_results, file.path(output_dir, "kegg_enrichment_filtered.txt"), type = "filtered")
    
    return(kegg_enrichment_results)
  }, error = function(e) {
    message(paste("Error in KEGG enrichment:", e$message))
    return(list(error = "KEGG Enrichment Failed", message = e$message))
  })
}



#' Perform Reactome Pathway Enrichment Analysis
#'
#' Performs Reactome pathway enrichment analysis using the `enrichPathway` function from the `ReactomePA` package.
#'
#' @param gene_ids A vector of gene identifiers (ENTREZIDs).
#' @param gene_mapping A data frame containing gene mappings between ENTREZID and SYMBOL. Must have columns named "ENTREZID" and "SYMBOL".
#' @param organism Character string specifying the organism. Must be "human" or "mouse".
#' @param pvalue Numeric value specifying the p-value threshold for filtering results. Default is 0.05.
#' @param output_dir Character string specifying the directory to save the results to. Default is "enrichment_results".
#'
#' @return A data frame containing the filtered Reactome pathway enrichment results, or a list with an "error" element if the analysis fails.
#'
#' @importFrom ReactomePA enrichPathway
#' @importFrom dplyr filter arrange slice mutate left_join group_by summarize select
#' @importFrom tidyr unnest
#' @importFrom stringr strsplit
#' @export
perform_reactome_enrichment <- function(gene_ids, gene_mapping, organism, pvalue = 0.05, output_dir = "enrichment_results") {
  
  # Check organism input
  organism <- tolower(organism)
  if (!(organism %in% c("human", "mouse"))) {
    stop("Error: Invalid organism. Please specify either 'human' or 'mouse'.")
  }
  
  
  tryCatch({
    reactome_enrichment <- enrichPathway(gene = gene_ids, organism = organism)
    
    # Save original results
    save_results(reactome_enrichment@result, file.path(output_dir, "reactome_enrichment_original.txt"), type = "original")
    
    reactome_enrichment_results <- reactome_enrichment@result %>%
      dplyr::filter(pvalue < !!pvalue) %>%
      dplyr::arrange(pvalue) %>%
      dplyr::slice(1:min(nrow(.), 100)) %>%
      dplyr::mutate(geneID = strsplit(geneID, "/")) %>%
      tidyr::unnest(geneID) %>%
      dplyr::mutate(geneID = as.character(geneID)) %>%
      dplyr::left_join(gene_mapping, by = c("geneID" = "ENTREZID")) %>%
      dplyr::mutate(Gene = ifelse(!is.na(SYMBOL), SYMBOL, geneID)) %>%
      dplyr::group_by(ID, Description, pvalue) %>%
      dplyr::summarize(., geneID = paste(unique(geneID), collapse = ","),
                       Gene = paste(unique(Gene), collapse = ","), .groups = "drop") %>%
      dplyr::select(ID, Description, pvalue, Gene)
    
    # Save filtered results
    save_results(reactome_enrichment_results, file.path(output_dir, "reactome_enrichment_filtered.txt"), type = "filtered")
    
    return(reactome_enrichment_results)
  }, error = function(e) {
    message(paste("Error in Reactome enrichment:", e$message))
    return(list(error = "Reactome Enrichment Failed", message = e$message))
  })
}



#' Perform ChEA Enrichment Analysis
#'
#' Performs ChEA (ChIP-X Enrichment Analysis) using the `enrichr` function from the `enrichR` package.
#'
#' @param gene_symbols A vector of gene symbols.
#' @param organism Character string specifying the organism. Must be "human" or "mouse".
#' @param pvalue Numeric value specifying the p-value threshold for filtering results. Default is 0.05.
#' @param output_dir Character string specifying the directory to save the results to. Default is "enrichment_results".
#'
#' @return A data frame containing the filtered ChEA enrichment results, or a list with an "error" element if the analysis fails.
#'
#' @importFrom enrichR setEnrichrSite enrichr
#' @importFrom dplyr filter select
#' @export
perform_chea_enrichment <- function(gene_symbols, organism, pvalue = 0.05, output_dir = "enrichment_results") {
  
  # Check organism input
  organism <- tolower(organism)
  if (!(organism %in% c("human", "mouse"))) {
    stop("Error: Invalid organism. Please specify either 'human' or 'mouse'.")
  }
  
  # Function to check for internet connection
  has_internet <- function() {
    !inherits(try(suppressWarnings(readLines(con = "https://www.google.com", n = 1)), silent = TRUE), "try-error")
  }
  
  if (!has_internet()) {
    message("Warning: No internet connection detected. Skipping ChEA enrichment.")
    return(list(error = "ChEA Enrichment Skipped", message = "No internet connection"))
  }
  
  tryCatch({
    setEnrichrSite("Enrichr")
    
    # Check gene_symbols
    if (length(gene_symbols) == 0 || all(is.na(gene_symbols))) {
      message("Warning: gene_symbols is empty or contains only NAs. Returning NULL.")
      return(list(error = "ChEA Enrichment Failed", message = "Empty or NA gene symbols"))
    }
    
    enriched <- enrichr(gene_symbols, c("ChEA_2022"))
    
    if (!"ChEA_2022" %in% names(enriched)) {
      message("Warning: 'ChEA_2022' not found in enriched results. Returning NULL.")
      return(list(error = "ChEA Enrichment Failed", message = "'ChEA_2022' not found"))
    }
    
    chea_results <- enriched$ChEA_2022 %>%
      dplyr::filter(P.value <= !!pvalue) %>%
      dplyr::select(Term, P.value, Genes)
    
    # Filter based on organism
    if (organism == "human") {
      chea_results <- chea_results %>%
        dplyr::filter(grepl("Human", Term, ignore.case = TRUE))
    } else if (organism == "mouse") {
      chea_results <- chea_results %>%
        dplyr::filter(grepl("Mouse", Term, ignore.case = TRUE))
    }
    
    # Save original results
    save_results(enriched$ChEA_2022, file.path(output_dir, "chea_enrichment_original.txt"), type = "original")
    
    # Save filtered results
    save_results(chea_results, file.path(output_dir, "chea_enrichment_filtered.txt"), type = "filtered")
    
    return(chea_results)
  }, error = function(e) {
    message(paste("Error in ChEA enrichment:", e$message))
    return(list(error = "ChEA Enrichment Failed", message = e$message))
  })
}





#' Perform GO Enrichment Analysis
#'
#' Performs Gene Ontology (GO) enrichment analysis using the `enrichGO` function from the `clusterProfiler` package.
#'
#' @param gene_ids A vector of gene identifiers (ENTREZIDs).
#' @param gene_mapping A data frame containing gene mappings between ENTREZID and SYMBOL. Must have columns named "ENTREZID" and "SYMBOL".
#' @param organism Character string specifying the organism. Must be "human" or "mouse".
#' @param ont Character string specifying the GO ontology to use. Must be one of "BP" (biological process), "CC" (cellular component), or "MF" (molecular function). Default is "BP".
#' @param pvalue Numeric value specifying the p-value threshold for filtering results. Default is 0.05.
#' @param output_dir Character string specifying the directory to save the results to. Default is "enrichment_results".
#'
#' @return A data frame containing the filtered GO enrichment results, or NULL if the analysis fails.
#'
#' @importFrom clusterProfiler enrichGO
#' @importFrom dplyr filter arrange slice mutate left_join group_by summarize select
#' @importFrom tidyr unnest
#' @importFrom stringr strsplit
#' @export
perform_go_enrichment <- function(gene_ids, gene_mapping, organism, ont = "BP", pvalue = 0.05, output_dir = "enrichment_results") {
  
  # Check organism input
  organism <- tolower(organism)
  if (!(organism %in% c("human", "mouse"))) {
    stop("Error: Invalid organism. Please specify either 'human' or 'mouse'.")
  }
  
  # Suppress the warning message
  suppressWarnings({
    # Function to check and install the database if needed
    install_organism_db <- function(organism) {
      organism_db <- switch(organism,
                            "human" = "org.Hs.eg.db",
                            "mouse" = "org.Mm.eg.db",
                            stop("Unsupported organism. Please choose from 'human' or 'mouse'.")
      )
      
      if (!requireNamespace(organism_db, quietly = TRUE)) {
        cat(paste("The", organism_db, "database is not installed. Installing...\n"))
        BiocManager::install(organism_db)
      }
      
      # Use :: to access the library function from the specific package
      library(organism_db, character.only = TRUE)
      return(organism_db)
    }
    
    tryCatch({
      organism_db <- install_organism_db(organism)
    }, error = function(e) {
      message(paste("Error in install_organism_db:", e$message))
      return(e$message)
    })
  })
  
  tryCatch({
    
    go_enrichment <- clusterProfiler::enrichGO(gene = gene_ids, OrgDb = organism_db, ont=ont)
    
    # Save original results
    save_results(go_enrichment@result, file.path(output_dir, "go_enrichment_original.txt"), type = "original")
    
    go_enrichment_results <- go_enrichment@result
    
    go_enrichment_results <- go_enrichment_results %>%
      dplyr::filter(pvalue < !!pvalue) %>%
      dplyr::arrange(pvalue) %>%
      dplyr::slice(1:min(nrow(.), 100))
    
    go_enrichment_results <- go_enrichment_results %>%
      dplyr::mutate(geneID = strsplit(geneID, "/")) %>% 
      tidyr::unnest(geneID) %>%
      dplyr::mutate(geneID = as.character(geneID)) %>%
      dplyr::left_join(gene_mapping, by = c("geneID" = "ENTREZID")) %>%
      dplyr::mutate(Gene = ifelse(!is.na(SYMBOL), SYMBOL, geneID)) %>% 
      dplyr::group_by(Description, pvalue) %>%
      dplyr::summarize(., geneID = paste(unique(geneID), collapse = ", "),
                       Gene = paste(unique(Gene), collapse = ", "), .groups = "drop") 
    
    input_go_enrichment <- go_enrichment_results[, c("Description", "pvalue", "Gene")]
    
    # Save filtered results
    save_results(input_go_enrichment, file.path(output_dir, "go_enrichment_filtered.txt"), type = "filtered")
    
    return(input_go_enrichment)
  }, error = function(e) {
    message(paste("Error in GO enrichment:", e$message))
    return(NULL)
  })
}


#' Perform STRING Interaction Analysis
#'
#' Retrieves protein-protein interactions from the STRING database and performs network analysis.
#'
#' @param gene_mapping A data frame containing gene mappings between SYMBOL and STRING_id. Must have columns named "SYMBOL" and "STRING_id".
#' @param organism Character string specifying the organism. Must be "human" or "mouse".
#' @param score_threshold Numeric value specifying the minimum combined score for interactions. Default is 0.
#' @param output_dir Character string specifying the directory to save the results to. Default is "enrichment_results".
#'
#' @return A list containing two data frames: `interactions` (filtered STRING interactions) and `network_properties` (network properties of the genes).  Returns a list with an "error" element if the analysis fails.
#'
#' @importFrom STRINGdb STRINGdb
#' @importFrom plyr mapvalues
#' @importFrom dplyr select distinct arrange slice desc mutate scale
#' @importFrom igraph graph_from_data_frame simplify degree betweenness closeness eigen_centrality
#' @export
perform_string_interactions <- function(gene_mapping, organism, score_threshold = 0, output_dir = "enrichment_results") {
  library(STRINGdb)
  library(plyr)
  library(dplyr)
  library(igraph)
  
  # Validate organism input
  if (missing(organism)) {
    stop("Error: The 'organism' argument is missing. Please specify either 'human' or 'mouse'.")
  }
  organism <- tolower(organism)
  if (!(organism %in% c("human", "mouse"))) {
    stop("Error: Invalid organism. Please choose 'human' or 'mouse'.")
  }
  
  tryCatch({
    library(STRINGdb) # Load STRINGdb library here
    library(plyr)
    library(dplyr) # Load dplyr library here
    
    # Set species based on organism
    species <- ifelse(organism == "human", 9606, 10090)
    
    # Get current working directory for saving stringdb files
    current_wd <- getwd()
    
    # Initiate stringdb
    string_db <- STRINGdb$new(version = "12", species = species, score_threshold = score_threshold, input_directory = current_wd)
    
    # Map gene list to string id
    p_mapped <- string_db$map(gene_mapping, "SYMBOL", removeUnmappedRows = FALSE)
    
    # cat("Class of p_mapped after mapping:", class(p_mapped), "\n")
    # print(head(p_mapped))
    
    # Get interaction data
    string_interactions <- string_db$get_interactions(p_mapped$STRING_id)
    
    # Map gene names to ids
    string_interactions$Protein1 <- plyr::mapvalues(
      x = string_interactions$from,
      from = p_mapped$STRING_id,
      to = p_mapped$SYMBOL,
      warn_missing = FALSE
    )
    
    string_interactions$Protein2 <- plyr::mapvalues(
      x = string_interactions$to,
      from = p_mapped$STRING_id,
      to = p_mapped$SYMBOL,
      warn_missing = FALSE
    )
    
    
    # cat("Class of string_interactions before select:", class(string_interactions), "\n")
    # print(head(string_interactions))
    
    # Rearrange data columns
    deg_interactions <- tryCatch({
      library(dplyr)
      dplyr::select(string_interactions, Protein1, Protein2, combined_score)
    }, error = function(e) {
      message(paste("Error in dplyr::select:", e$message))
      return(NULL)
    })
    
    if (is.null(deg_interactions)) {
      return(list(error = "dplyr::select Failed", message = "Could not select columns"))
    }
    # Remove redundant rows
    deg_interactions <- deg_interactions %>% distinct()
    
    # Sort by score and keep top 1000
    deg_interactions <- deg_interactions %>%
      arrange(desc(combined_score)) %>%
      dplyr::slice(1:min(nrow(.), 1000))
    
    # --- Network Analysis ---
    
    # Create graph object
    graph <- igraph::graph_from_data_frame(deg_interactions[, 1:2], directed = FALSE)
    
    # Remove duplicate edges
    graph <- igraph::simplify(graph, remove.multiple = TRUE, remove.loops = TRUE)
    
    # Calculate network properties
    degree <- igraph::degree(graph)
    betweenness <- igraph::betweenness(graph)
    closeness <- igraph::closeness(graph)
    eigenvector_centrality <- igraph::eigen_centrality(graph)$vector
    
    # Create a dataframe for network properties
    node_properties <- data.frame(
      node = names(degree),
      degree = degree,
      betweenness = betweenness,
      closeness = closeness,
      eigenvector_centrality = eigenvector_centrality
    )
    
    # Add scaled properties
    node_properties <- node_properties %>%
      dplyr::mutate(degree_scaled = scale(degree),
                    betweenness_scaled = scale(betweenness),
                    closeness_scaled = scale(closeness),
                    eigenvector_scaled = scale(eigenvector_centrality)
      )
    
    # Calculate a combined property based on the scaled measures
    scaled_cols <- grep("_scaled$", names(node_properties), value = TRUE)
    
    node_properties <- node_properties %>% 
      dplyr::mutate(combined_score_prop = rowMeans(node_properties[, scaled_cols], na.rm = TRUE))
    
    # Sort genes by the combined score
    important_genes <- node_properties %>% 
      dplyr::arrange(desc(combined_score_prop))
    
    # Save network properties
    save_results(important_genes, file.path(output_dir, "string_network_properties.txt"), type = "filtered")
    
    # Save original results
    save_results(string_interactions, file.path(output_dir, "string_interactions_original.txt"), type = "original")
    
    # Save filtered results
    save_results(deg_interactions, file.path(output_dir, "string_interactions_filtered.txt"), type = "filtered")
    
    
    
    # Return both interaction and network data
    return(list(interactions = deg_interactions, network_properties = important_genes))
    
  }, error = function(e) {
    message(paste("Error in STRINGdb interaction retrieval:", e$message))
    return(list(error = "STRINGdb Interaction Retrieval Failed", message = e$message))
  })
}