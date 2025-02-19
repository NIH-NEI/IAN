#' IAN_visualize_system_model.R
#'
#' Extracts the system model network from an LLM response in TSV format and visualizes it using the `visNetwork` package.
#'
#' @param llm_response Character string containing the LLM response with the system network in TSV format.
#' @param html_file Character string specifying the name of the HTML file to save the visualization to. Default is "system_model_network.html".
#' @param gene_symbols A vector of gene symbols used in the analysis.
#'
#' @return A `visNetwork` object representing the system model network, or NULL if no valid TSV block is found or the visualization fails.
#'
#' @importFrom stringr str_match_all str_split
#' @importFrom dplyr %>% rename select distinct mutate
#' @importFrom visNetwork visNetwork visEdges visNodes visOptions visSave
#' @importFrom igraph graph_from_data_frame
#' @importFrom utils head
#' @importFrom utils read.table
#' @export
visualize_system_model <- function(llm_response, html_file = "system_model_network.html", gene_symbols) {
  
  id <- NULL
  target <- NULL
  from <- NULL
  to <- NULL
  
  message("Starting visualize_system_model function...")
  
  # Extract the system network from LLM response
  pattern <- "\\s*```(?i)tsv\\s*([\\s\\S]*?)\\s*```\\s*"
  matches <- str_match_all(llm_response, pattern)[[1]]
  
  if (nrow(matches) > 0) {
    system_network_tsv <- matches[, 2]
    message("TSV block extracted successfully.")
    message("First few lines of TSV:\n", paste(head(strsplit(system_network_tsv, "\n")[[1]], 3), collapse = "\n")) 
  } else {
    message("No TSV block found in the LLM response.")
    return(NULL)
  }
  
  # Read the TSV data into a data frame
  system_network_df <- tryCatch({
    # Read with header = TRUE and remove col.names
    read.table(text = system_network_tsv, header = TRUE, sep = "\t", stringsAsFactors = FALSE, comment.char="",  allowEscapes = TRUE,  quote = "",  fill = TRUE,  flush = TRUE,   check.names = FALSE)
  }, error = function(e) {
    message("Error reading TSV data:", e$message)
    return(NULL)
  })
  
  if (is.null(system_network_df) || ncol(system_network_df) < 3) {
    if(is.null(system_network_df)){
      message("system_network_df is NULL.")
    } else {
      message("Number of columns in system_network_df is: ", ncol(system_network_df))
    }
    message("TSV data not in the expected format (3 columns).")
    return(NULL)
  }
  
  # Select only the first three columns
  system_network_df <- system_network_df[, 1:3, drop = FALSE]
  
  # Rename columns
  colnames(system_network_df) <- c("source", "interaction", "target")
  message("TSV data successfully read into system_network_df.")
  
  # 1. Create Nodes Data Frame
  # 1. Create Nodes Data Frame with labels and groups
  nodes <- data.frame(id = unique(c(system_network_df$source, system_network_df$target)),
                      stringsAsFactors = FALSE)
  
  # Add a group column based on whether the node is in gene_symbols
  nodes <- nodes %>%
    mutate(group = ifelse(id %in% gene_symbols, "Gene", "Process")) %>%
    mutate(label = id) # Add a newline to process labels
  
  
  # 2. Create Edges Data Frame (without labels)
  edges <- system_network_df %>%
    dplyr::rename(from = source, to = target) %>%
    dplyr::select(from, to) %>%
    distinct(from, to)
  
  vis_network_model <- visNetwork(nodes = nodes, edges = edges) %>%
    visEdges(arrows = "to") %>% 
    visNodes(size = 20,  # Adjust node size as needed
             font = list(size = 24)) %>%  # Increase node label size
    #visPhysics(solver = "barnesHut", barnesHut = list(gravitationalConstant = -5000,  springConstant = 0.04 , springLength= 100 ) ) %>%
    visOptions(highlightNearest = TRUE)  # Highlight nodes when hovering
  
  
  # Save the visualization as an HTML file
  visSave(vis_network_model, file = html_file)
  
  message("System model network visualization saved to: ", html_file)
  
  return(vis_network_model)
  
}