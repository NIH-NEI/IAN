#' Generate Network Revision Prompt
#'
#' Generates a prompt for a Large Language Model (LLM) to revise a system representation network,
#' integrating information from STRING protein-protein interaction data and experimental design.
#'
#' @param file_path Character string specifying the path to the text file containing the initial network data in TSV format.
#' @param gene_symbols A vector of gene symbols used in the analysis.
#' @param experimental_design A character string describing the experimental design (optional).
#' @param string_results A list containing STRING protein-protein interaction data (optional).
#'
#' @return A character string containing the LLM prompt, or NULL if the network data is invalid or the file cannot be processed.
#'
#' @importFrom stringr str_match_all str_split str_to_upper
#' @importFrom dplyr filter transmute bind_rows
#' @importFrom readr read_tsv
#' @export
generate_network_revision_prompt <- function(file_path, gene_symbols, experimental_design = NULL, string_results = NULL) {
  
  #' Extract and Combine TSV Blocks from a Text File
  #'
  #' Extracts TSV (tab-separated values) blocks enclosed in ```tsv ... ``` tags from a text file and combines them into a single data frame.
  #'
  #' @param file_path Character string specifying the path to the text file.
  #'
  #' @return A data frame containing the combined TSV data, or NULL if no valid TSV blocks are found or the file cannot be processed.
  extract_and_combine_tsv_blocks <- function(file_path) {
    tryCatch({
      # Read the file
      text <- readChar(file_path, file.info(file_path)$size)
      
      # Regular expression to find TSV blocks
      pattern <- "\\s*```(?i)tsv\\s*([\\s\\S]*?)\\s*```\\s*"
      
      matches <- str_match_all(text, pattern)[[1]]
      
      if (nrow(matches) > 0) {
        # Extract the TSV content
        tsv_contents <- matches[, 2]
        
        processed_dfs <- lapply(tsv_contents, function(tsv_content) {
          tryCatch({
            
            lines <- str_split(tsv_content, "\n", simplify = TRUE)
            lines <- lines[lines != ""] #remove empty strings
            
            if (length(lines) == 0) {
              return(NULL)
            }
            
            # Process header line
            header_line <- lines[1]
            header_fields <- str_split(header_line, "\\t", simplify = TRUE)
            num_header_fields <- length(header_fields)
            
            
            # Process data lines
            processed_lines <- lapply(lines[-1], function(line) {
              fields <- str_split(line, "\\t", simplify = TRUE)
              num_fields <- length(fields)
              
              if(num_fields < num_header_fields) {
                fields <- c(fields, rep("", num_header_fields - num_fields)) # Pad with empty strings if fewer columns
              } else if (num_fields > num_header_fields){
                fields <- fields[1:num_header_fields] #Truncate columns if there are too many
              }
              paste(fields, collapse = "\t") # Re-combine to form the tsv row.
            })
            
            processed_tsv_content <- paste(c(header_line, unlist(processed_lines)), collapse = "\n")
            
            df <- read.csv(text = processed_tsv_content, stringsAsFactors = FALSE, header=TRUE, row.names = NULL, fill = FALSE, sep = "\t")
            return(df)
            
          }, error = function(e){
            message(paste("Error processing TSV block:", e$message))
            return(NULL)
          })
          
        })
        
        # Remove any NULL data frames resulting from failed reads
        processed_dfs <- processed_dfs[!sapply(processed_dfs, is.null)]
        
        # Combine all data frames
        if (length(processed_dfs) > 0){
          combined_df <- bind_rows(processed_dfs)
          return(combined_df)
        } else {
          message("No valid TSV blocks to combine.")
          return(NULL)
        }
        
      } else {
        message("No TSV blocks found in the file.")
        return(NULL)
      }
    }, error = function(e) {
      message(paste("Error processing file:", e$message))
      return(NULL)
    })
  }
  
  # Extract and combine network data
  combined_df <- extract_and_combine_tsv_blocks(file_path)
  
  # Check if combined data frame exists
  if (is.null(combined_df)) {
    message("No valid network data to process.")
    return(NULL)
  }
  
  # 2. Extract Genes from Combined Data Frame
  all_genes <- unique(unlist(c(combined_df$Node1, combined_df$Node2)))
  all_genes <- all_genes[all_genes != ""]  # Remove any empty strings
  
  # Convert to uppercase to match string data
  all_genes <- toupper(all_genes)
  
  
  # 3. Find STRING Interactions
  if (!is.null(string_results) && !is.null(string_results$interactions) && nrow(string_results$interactions) > 0) {
    string_interactions <- string_results$interactions
    
    # Filter the string interactions to include only genes present in the extracted network
    filtered_string_interactions <- string_interactions %>%
      filter(Protein1 %in% all_genes & Protein2 %in% all_genes)
    
    # 4. Create New Dataframe of String based interactions
    if (nrow(filtered_string_interactions) > 0) {
      new_interactions <- filtered_string_interactions %>%
        transmute(
          Node1 = Protein1,
          Edge = "interacts with",
          Node2 = Protein2,
          Explanation = paste0("STRING interaction with combined score: ", combined_score)
        )
    } else {
      new_interactions <- NULL
      message("No string interaction for any genes in the combined network")
    }
  } else {
    new_interactions <- NULL
    message("No string interaction data available.")
  }
  
  # 5. Combine Original Network with String Network
  if (!is.null(new_interactions)) {
    # If new interaction, ensure the columns match
    combined_network <- bind_rows(combined_df, new_interactions)
    
    #Combined network is stored here for final use
  } else {
    combined_network <- combined_df
  }
  
  
  # Convert combined network data frame to a string representation
  combined_network_string <- paste(capture.output(print(combined_network, row.names = FALSE)), collapse = "\n")
  
  # Add experimental design, if available
  if (!is.null(experimental_design) && experimental_design != "") {
    experimental_design_str <- paste0("**Experimental Design:**\n",
                                      "The experimental design is as follows: ", experimental_design, "\n\n")
  } else {
    experimental_design_str <- ""
  }
  
  # Add gene symbols
  gene_symbols_str <- paste0("Differentially Expressed Genes: ", paste(gene_symbols, collapse = ", "), "\n\n")
  
  
  # Create the prompt for LLM, including STRING data
  prompt <- paste0(experimental_design_str, gene_symbols_str, 
                   "Here is a network content:\n", combined_network_string, "\n\n",
                   "**Instructions:**\n",
                   "Review the above combined_network_string data and revise it to represent a system network in TSV (tab-separated values) format with four columns. Identify the relationships between the nodes, where each node can be a gene, a GO term, or a pathway. Remove redundant rows, and combine rows with similar information into a single row, where appropriate. For each interaction, output a row where:\n",
                   "   - Node1 is the source node (a gene, formatted in uppercase).\n",
                   "   - Edge should be 'associated with' or 'interacts with' or 'targets'.\n",
                   "   - Node2 is the target node (a gene, a GO term, or a pathway, formatted in uppercase for genes, and in 'Title Case' for GO terms and pathways).\n",
                   "   - Explanation should specify how the source and target nodes are related. Use information from the provided data, to support this claim. Where available, mention relevant protein interactions, or pathway relationships that might support the identified association. \n",
                   "Enclose your revised results within a ```tsv block, with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.\n\n",
                   " - Check if the nodes identified above are grounded in the provided data. In the explanation column, include a note stating how and whether the network interaction in each row is grounded in the provided data.\n",
                   " - *Review the above network and ensure that every interaction included meets the grounding criteria and that each interaction includes only one gene as source and either one GO term or one pathway or one gene as the target. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.\n",
                   
                   "Here's an example of the desired output format:\n",
                   "*System Network*\n",
                   "```tsv\n",
                   "Node1\tEdge\tNode2\tExplanation\n",
                   "FN1\tassociated with\tAcute Inflammatory Response\tGrounded in provided data (GO, STRING) and is known to be important in inflammatory responses.\n",
                   "FN1\tassociated with\tCell Junction Disassembly\tGrounded in provided data (GO, STRING) and is known to be important in cell migration.\n",
                   "C1QA\tassociated with\tComplement Activation\tGrounded in provided data (GO, STRING) and is a key protein in the Complement pathway.\n",
                   "C1QA\tassociated with\tImmune Response\tGrounded in provided data (GO, STRING) and is involved in Immune Response.\n",
                   "CD274\tassociated with\tT Cell Costimulation\tGrounded in provided data (GO, STRING) and plays a role in T cell regulation.\n",
                   "ANK2\tassociated with\tCell Movement and Contraction\tGrounded in provided data (GO, STRING) and is important for cell motility and adhesion.\n",
                   "ATF3\tassociated with\tWnt Signaling\tGrounded in provided data (WikiPathways, ChEA) and regulates Wnt target genes.\n",
                   "GBP5\tassociated with\tPyroptosis\tGrounded in provided data (KEGG, GO, STRING) and is a marker of pyroptotic cell death.\n",
                   "RELB\tassociated with\tCD274\tGrounded: RELB directly regulates CD274.\n",
                   "SMAD4\tassociated with\tFocal Adhesion\tGrounded: SMAD4 regulates genes in the Focal Adhesion pathway.\n",
                   "```\n\n",
                   
                   
                   
                   "\n\n**Note:** Please keep your response under 6100 words. Do not include anyother Note.\n\n"
                   
  )
  
  return(prompt)
}