#' Perform Integrated Network Analysis
#'
#' This function performs an integrated network analysis, combining gene ID mapping, enrichment analysis,
#' multi-agent system execution, pathway comparison, network revision, system model generation, and visualization.
#'
#' @param experimental_design A character string describing the experimental design (optional, default is NULL).
#' @param markeringroup A data frame containing marker genes (required if `input_type` is "findmarker", default is NULL).
#' @param deg_file Path to a file containing differentially expressed genes (required if `input_type` is "custom", default is NULL).
#' @param gene_type Character string specifying the gene identifier type in the input data. Must be one of "ENSEMBL", "ENTREZID", or "SYMBOL" (required if `input_type` is "deseq", "findmarker", or "custom", default is NULL).
#' @param organism Character string specifying the organism. Must be "human" or "mouse" (required if `input_type` is "deseq", "findmarker", or "custom", default is NULL).
#' @param input_type Character string specifying the input type. Must be one of "findmarker", "deseq", or "custom" (default is NULL).
#' @param pvalue Numeric value specifying the p-value threshold for filtering results. Default is 0.05.
#' @param ont Character string specifying the GO ontology to use. Must be one of "BP" (biological process), "CC" (cellular component), or "MF" (molecular function). Default is "BP".
#' @param score_threshold Numeric value specifying the minimum combined score for STRING interactions. Default is 0.
#' @param output_dir Character string specifying the directory to save the results to. Default is "enrichment_results".
#' @param model Character string specifying the Gemini model to use. Default is "gemini-1.5-flash-latest".
#' @param temperature Numeric value controlling the randomness of the LLM response. Default is 0.
#' @param api_key_file Character string specifying the path to the file containing the Gemini API key (default is NULL).
#'
#' @return None (side effects: performs integrated network analysis and generates reports and visualizations).
#'
#' @importFrom dplyr %>%
#' @importFrom clusterProfiler enrichGO
#' @importFrom ReactomePA enrichPathway
#' @importFrom enrichR enrichr
#' @importFrom stringr str_match_all str_extract
#' @importFrom readr read_tsv
#' @importFrom visNetwork visNetwork visEdges visNodes visOptions visSave
#' @importFrom igraph graph_from_data_frame
#' @export
IAN <- function(experimental_design = NULL, deseq_results = NULL, markeringroup = NULL, deg_file = NULL, gene_type = NULL, organism = NULL, input_type = NULL, pvalue = 0.05, ont = "BP", score_threshold = 0, output_dir = "enrichment_results", model = "gemini-1.5-flash-latest", temperature = 0, api_key_file = NULL) {
  
  # Source the functions
  source("IAN/R/IAN_gene_id_mapper.R")
  source("IAN/R/IAN_enrichment_analysis.R")
  source("IAN/R/IAN_multi_agent_system.R")
  source("IAN/R/IAN_llm_prompts.R")
  source("IAN/R/IAN_create_combined_prompt.R") # Source the new file
  source("IAN/R/IAN_pathway_comparison.R") # Source the pathway comparison script
  source("IAN/R/IAN_network_prompt_generator.R") # Source the combined network prompt generator script
  source("IAN/R/IAN_system_model_prompt_generator.R") # Source the system model prompt generator script
  source("IAN/R/IAN_visualize_system_model.R") # To visualize system model
  
  # Load necessary libraries
  library(dplyr)
  library(clusterProfiler)
  library(ReactomePA)
  library(enrichR)
  library(stringr)
  #library(dplyr)
  library(readr)
  #library(tidyverse)
  
  # --- Configuration ---
  num_workers <- availableCores() - 1
  #model <- "gemini-1.5-flash-latest"  # Optimized
  #model <- "gemini-1.5-flash-8b"  # Or your preferred Gemini model
  #model <- "gemini-2.0-flash-exp"  # Or your preferred Gemini model
  
  model_query <- paste0(model, ":generateContent")
  #temperature <- 0
  max_output_tokens <- 8192
  #api_key_file <- "/Users/nagarajanv/OneDrive - National Institutes of Health/Research/singlecellassistant/api_keys.txt"  # **REPLACE with the actual path to your API key file**
  delay_seconds <- 5
  
  # Deseq RNAseq
  #experimental_design = "Peripheral blood samples were collected from 9 BD (Behcet’s disease) patients who fulfilled the 2013 International Criteria for BD and 10 HC (healthy controls). Total RNA was extracted from PBMCs and used for generating the RNA-Seq data. DESEq was used to identify differentially expressed genes between BD and HC samples"
  
  # Custom DEG
  #experimental_design = "Ninety subjects with uveitis including axial spondyloarthritis (n = 17), sarcoidosis (n = 13), inflammatory bowel disease (n = 12), tubulointerstitial nephritis with uveitis (n = 10), or idiopathic uveitis (n = 38) as well as 18 healthy controls were enrolled, predominantly at Oregon Health & Science University. RNA-Seq data generated from peripheral, whole blood was used to indentify differentially expressed genes between Uveitis patients and healthy controls."
  
  #experimental_design = "Ninety subjects with uveitis including axial spondyloarthritis (n = 17), sarcoidosis (n = 13), inflammatory bowel disease (n = 12), tubulointerstitial nephritis with uveitis (n = 10), or idiopathic uveitis (n = 38) as well as 18 healthy controls were enrolled, predominantly at Oregon Health & Science University. RNA-Seq data generated from peripheral, whole blood was used to indentify differentially expressed genes between Uveitis patients and healthy controls."
  
  #gene_type = "ENSEMBL" # one of ENSEMBL, ENTREZID, SYMBOL
  #deg_file <- "/Users/nagarajanv/OneDrive - National Institutes of Health/Research/smart-enrichment/Ian/Ianoriginal/data/uveitis-PIIS0002939421000271-deg.txt" # Replace with your file path
  #markers <- markeringroup
  #organism <- "human" # or 'mouse'
  #input_type <- "custom" # one of findmarker, deseq, custom
  
  #example
  #custom input_type = "custom", organism = "human", gene_type = "ENSEMBL"
  #deseq input_type = "deseq", organism = "human", gene_type = "ENSEMBL",
  #findmarker input_type = "findmarker", organism = "human", gene_type = "SYMBOL",
  
  # User-defined parameters for enrichment analysis
  #pvalue <- 0.05
  #ont <- "BP" # or "MF" or "CC"
  #score_threshold <- 0
  #output_dir <- "enrichment_results" # Directory to save output files
  params_file <- "analysis_parameters.txt" # File to save parameters
  
  # Read API Key and handle errors
  api_key <- tryCatch({
    readLines(api_key_file)
  }, error = function(e) {
    message(paste0("Error reading API key from ", api_key_file, ": ", e$message))
    return(NULL)
  })
  
  if (is.null(api_key) || length(api_key) == 0) {
    stop("API key not found or invalid. Please provide a valid api_key_file.")
  }
  
  # Function to save parameters to a text file
  save_parameters <- function(params, filename) {
    tryCatch({
      param_lines <- paste(names(params), "=", sapply(params, function(x) paste(x, collapse = ",")), collapse = "\n")
      writeLines(param_lines, filename)
      message(paste("Parameters saved to:", filename))
    }, error = function(e) {
      message(paste("Error saving parameters:", e$message))
    })
  }
  
  # Get the directory of the script
  args <- commandArgs(trailingOnly = FALSE)
  script_path <- sub("--file=", "", args[grep("--file=", args)])
  
  # Check if script_path is empty
  if (length(script_path) == 0 || script_path == "") {
    script_dir <- getwd() # Use current working directory if script_path is empty
  } else {
    script_dir <- dirname(script_path)
  }
  
  # Construct the full path to the output directory
  output_dir_path <- file.path(script_dir, output_dir)
  
  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir_path)) {
    dir.create(output_dir_path)
  }
  
  # Save parameters
  params <- list(
    experimental_design = experimental_design,
    gene_type = gene_type,
    organism = organism,
    input_type = input_type,
    deg_file = deg_file,
    pvalue = pvalue,
    ont = ont,
    score_threshold = score_threshold,
    model = model,
    temperature = temperature,
    #deseq_results = deseq_results,
    #markers = markeringroup,
    output_dir = output_dir
  )
  
  save_parameters(params, params_file)
  
  # Perform gene ID mapping
  if (input_type == "deseq") {
    gene_mapping <- map_gene_ids(
      input_type = input_type,
      organism = organism,
      gene_type = gene_type,
      deseq_results = deseq_results
    )
  } else if (input_type == "findmarker") {
    gene_mapping <- map_gene_ids(
      input_type = input_type,
      organism = organism,
      gene_type = gene_type,
      markers = markeringroup
    )
  } else if (input_type == "custom") {
    gene_mapping <- map_gene_ids(
      input_type = input_type,
      organism = organism,
      deg_file = deg_file,
      gene_type = gene_type
    )
  } else {
    stop("Invalid input_type")
  }
  
  # Check if gene_mapping is empty or an error
  if (is.null(gene_mapping) || (is.list(gene_mapping) && "error" %in% names(gene_mapping))) {
    print("Gene ID mapping failed. Please check your input parameters and data.")
  } else {
    # Extract gene IDs and symbols
    gene_ids <- gene_mapping$ENTREZID
    gene_symbols <- gene_mapping$SYMBOL # Get gene symbols from mapping
    
    # --- Perform Enrichment Analyses ---
    
    # Perform enrichment analyses
    wp_results <- perform_wp_enrichment(gene_ids, gene_mapping, organism = organism, pvalue = pvalue, output_dir = output_dir_path)
    kegg_results <- perform_kegg_enrichment(gene_ids, gene_mapping, organism = organism, pvalue = pvalue, output_dir = output_dir_path)
    reactome_results <- perform_reactome_enrichment(gene_ids, gene_mapping, organism = organism, pvalue = pvalue, output_dir = output_dir_path)
    go_results <- perform_go_enrichment(gene_ids, gene_mapping, organism = organism, ont = ont, pvalue = pvalue, output_dir = output_dir_path)
    chea_results <- perform_chea_enrichment(gene_symbols, organism = organism, pvalue = pvalue, output_dir = output_dir_path)
    string_results <- perform_string_interactions(gene_mapping, organism = organism, score_threshold = score_threshold, output_dir = output_dir_path)
    
    # --- Create LLM Prompts ---
    
    # Create LLM prompts for each analysis
    prompt_wp <- create_llm_prompt_wp(wp_results, "WikiPathways", chea_results, string_results, gene_symbols, string_results$network_properties, go_results, experimental_design)
    prompt_kegg <- create_llm_prompt_kegg(kegg_results, "KEGG", chea_results, string_results, gene_symbols, string_results$network_properties, go_results, experimental_design)  
    prompt_reactome <- create_llm_prompt_reactome(reactome_results, "Reactome", chea_results, string_results, gene_symbols, string_results$network_properties, go_results, experimental_design)
    prompt_chea <- create_llm_prompt_chea(chea_results, "ChEA", pathway_results = list(kegg = kegg_results, wp = wp_results, reactome = reactome_results, go = go_results), string_results = string_results, gene_symbols = gene_symbols, string_network_properties = string_results$network_properties, experimental_design = experimental_design)
    prompt_go <- create_llm_prompt_go(go_results, "GO", chea_results, string_results, gene_symbols, string_results$network_properties, experimental_design )
    prompt_string <- create_llm_prompt_string(string_results, "STRING", pathway_results = list(kegg = kegg_results, wp = wp_results, reactome = reactome_results, go = go_results), chea_results = chea_results, gene_symbols = gene_symbols, string_network_properties = string_results$network_properties, experimental_design = experimental_design)
    
    # Create lists of prompt types and prompts
    prompt_types <- list("WikiPathways pathway analysis", "KEGG Pathway analysis", "Reactome Pathway analysis", "Transcription factor enrichment analysis", "Gene Ontology analysis", "Protein-protein interaction network analysis")
    
    # Store prompts in a list
    prompts <- list(prompt_wp, prompt_kegg, prompt_reactome, prompt_chea, prompt_go, prompt_string)
    
    # --- Run the Multi-Agent System ---
    
    env_prompts <- Environment$new(prompts, prompt_types)
    
    results <- env_prompts$run_agents(make_gemini_request, temperature, max_output_tokens, api_key, model_query, delay_seconds, num_workers, max_retries = 3)
    
    # --- Pathway Comparison ---
    # Perform pathway comparison
    comparison_results <- perform_pathway_comparison(
      gene_symbols = gene_symbols,
      kegg_results = kegg_results,
      wp_results = wp_results,
      reactome_results = reactome_results,
      go_results = go_results,
      output_dir = output_dir_path
    )
    
    # Check if pathway comparison failed
    if (is.list(comparison_results) && "error" %in% names(comparison_results)) {
      message("Pathway comparison failed. Proceeding with LLM prompting without comparison results.")
      # Handle the error, e.g., log it or proceed without comparison results
      comparison_results <- NULL # Set to NULL to avoid issues in combined prompt
    } else {
      message("Pathway comparison completed successfully.")
      # You can now use comparison_results if needed
    }
    
    # Get the combined prompt from the results
    combined_prompt <- create_combined_prompt(results, gene_symbols, string_results, chea_results, string_results$network_properties, comparison_results)
    
    # Make final request to LLM
    final_response <- make_gemini_request(combined_prompt, temperature, max_output_tokens, api_key, model_query, delay_seconds)
    
    # Save agent responses to a file
    agent_response_file <- file.path(output_dir_path, "agent_responses.txt")
    tryCatch({
      # Open the file connection
      file_conn <- file(agent_response_file, "w")
      
      # Write agent responses
      for (i in seq_along(results)) {
        cat(paste0("Agent ", results[[i]]$agent_id, ":\n"), file = file_conn)
        if (is.null(results[[i]]$response)) {
          cat("Task failed.\n\n", file = file_conn)
        } else if (is.list(results[[i]]$response) && "error" %in% names(results[[i]]$response)) {
          cat(paste("Error:", results[[i]]$response$message), "\n\n", file = file_conn)
        } else if (is.null(results[[i]]$response) || results[[i]]$response == "No response from Gemini") {
          cat("No response from Gemini.\n\n", file = file_conn)
        } else {
          cat(results[[i]]$response, "\n\n", file = file_conn)
        }
      }
      
      # Close the file connection
      close(file_conn)
      
      message(paste("Agent responses saved to:", agent_response_file))
    }, error = function(e) {
      message(paste("Error saving agent responses:", e$message))
    })
    
    # --- Save the character vector to a file in the output directory ---
    file_conn_vector <- file(file.path(output_dir, "final_response.txt"), "w")
    writeLines(final_response, file_conn_vector)
    close(file_conn_vector)
    
    # --- Print results to console ---
    for (i in seq_along(results)) {
      cat(paste0("Agent ", results[[i]]$agent_id, ":\n"))
      if (is.null(results[[i]]$response)) {
        cat("Task failed.\n\n")
      } else if (is.list(results[[i]]$response) && "error" %in% names(results[[i]]$response)) {
        cat(paste("Error:", results[[i]]$response$message), "\n\n")
      } else if (is.null(results[[i]]$response) || results[[i]]$response == "No response from Gemini") {
        cat("No response from Gemini.\n\n")
      } else {
        cat(results[[i]]$response, "\n\n")
      }
    }
    
    cat(paste0("Final Response:\n"))
    if (is.list(final_response)) {
      if ("error" %in% names(final_response)) {
        cat(paste("Error:", final_response$error), "\n")
      } else {
        cat("Final response is a list, but no error message found.\n")
      }
    } else {
      cat(final_response, "\n\n")
    }
    
    # Network Processing
    
    # 1. Generate initial network revision prompt
    network_revision_prompt <- generate_network_revision_prompt(file.path(output_dir_path, "agent_responses.txt"), gene_symbols, experimental_design, string_results = string_results)
    
    # 2. Make initial request to LLM for network revision
    network_revision_response <- make_gemini_request(network_revision_prompt, temperature, max_output_tokens, api_key, model_query, delay_seconds)
    
    # --- Save the character vector to a file in the output directory ---
    file_conn_vector <- file(file.path(output_dir, "integrated_network.txt"), "w")
    writeLines(network_revision_response, file_conn_vector)
    close(file_conn_vector)
    
    # 3. Generate prompt for the rest of the analysis using the output of step 2
    system_model_prompt <- generate_system_model_prompt(network_revision_response, gene_symbols, experimental_design)
    
    # 4. Make final request to LLM
    system_model_response <- make_gemini_request(system_model_prompt,temperature, max_output_tokens, api_key, model_query, delay_seconds)
    
    file_conn_vector <- file(file.path(output_dir, "system_model.txt"), "w")
    writeLines(system_model_response, file_conn_vector)
    close(file_conn_vector)
    
    # Call the visualization function, passing the response and the desired HTML file name
    system_model_network = visualize_system_model(system_model_response, html_file = "system_model_network.html", gene_symbols)
    system_model_network
    
    # Extract the title from Step 7
    title_extraction <- stringr::str_extract(
      final_response,
      "(?s)(?<=Title\\*\\*\\n\\n).*?(?=\\n|$)" # modified the lookahead for single newline or end of string after title
    )
    
    # Check if the extraction was successful
    if (is.na(title_extraction)) {
      warning("Could not extract the title. Check the format of 'final_response' carefully.")
      title_extraction <- "" # Assign an empty string to avoid errors
    }
    
    # Print the extracted title (for verification)
    cat(title_extraction)
    
    # Store the extracted title in a variable
    report_title <- title_extraction
    
    library(igraph)
    rmarkdown::render("report_template.Rmd", output_dir = output_dir)
  }
}