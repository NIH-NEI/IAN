#' IAN_create_combined_prompt.R
#'
#' Creates a combined prompt for a Large Language Model (LLM) by integrating results from multiple agents,
#' STRING protein-protein interaction data, ChEA transcription factor enrichment results, STRING network properties,
#' pathway comparison results, and experimental design information. The prompt includes an additional step to generate a title.
#'
#' @param results A list of results from individual agents. Each element should be a list with `agent_id` and `response` elements.
#' @param gene_symbols A vector of gene symbols used in the analysis.
#' @param string_interactions A list containing STRING protein-protein interaction data.
#' @param chea_results A data frame containing ChEA transcription factor enrichment results.
#' @param string_network_properties A data frame containing STRING network properties.
#' @param comparison_results A list containing pathway comparison results.
#' @param experimental_design A character string describing the experimental design (optional).
#'
#' @return A character string containing the combined LLM prompt.
#'
#' @export
create_combined_prompt <- function(results, gene_symbols, string_interactions, chea_results, string_network_properties, comparison_results, experimental_design = NULL) {
  
  # Start with a basic prompt template
  prompt <- "I performed a transcriptomic analysis, identified differentially expressed genes and performed enrichment analysis. Below are the analysis results:\n\n"
  
  # Add experimental design, if available
  if (!is.null(experimental_design) && experimental_design != "") {
    prompt <- paste0(prompt, "**Experimental Design:**\n",
                     "The experimental design is as follows: ", experimental_design, "\n\n")
  }
  
  # Add gene symbols
  prompt <- paste0(prompt, "Original Gene Symbols: ", paste(gene_symbols, collapse = ", "), "\n\n")
  
  # Add agent responses
  prompt <- paste0(prompt, "Agent Summaries:\n")
  for (i in seq_along(results)) {
    prompt <- paste0(prompt, "Agent ", results[[i]]$agent_id, ":\n")
    if (is.null(results[[i]]$response)) {
      prompt <- paste0(prompt, "Task failed.\n\n")
    } else if (is.list(results[[i]]$response) && "error" %in% names(results[[i]]$response)) {
      prompt <- paste0(prompt, "Error: ", results[[i]]$response$message, "\n\n")
    } else if (is.null(results[[i]]$response) || results[[i]]$response == "No response from Gemini") {
      prompt <- paste0(prompt, "No response from Gemini.\n\n")
    } else {
      prompt <- paste0(prompt, results[[i]]$response, "\n\n")
    }
  }
  
  # Add string interactions
  prompt <- paste0(prompt, "String Protein-Protein Interactions:\n")
  if (is.null(string_interactions) || (is.list(string_interactions) && "error" %in% names(string_interactions))) {
    prompt <- paste0(prompt, "No string interaction data available.\n")
  } else {
    if (!is.null(string_interactions$interactions) && nrow(string_interactions$interactions) > 0) {
      for (row in 1:nrow(string_interactions$interactions)) {
        prompt <- paste0(prompt, "Protein 1: ", string_interactions$interactions[row, "Protein1"],
                         ", Protein 2: ", string_interactions$interactions[row, "Protein2"],
                         ", Combined Score: ", string_interactions$interactions[row, "combined_score"], "\n")
      }
    } else {
      prompt <- paste0(prompt, "No string interactions found.\n")
    }
  }
  
  # Add ChEA results
  prompt <- paste0(prompt, "ChEA Transcription Factor Analysis:\n")
  if (is.null(chea_results) || (is.list(chea_results) && "error" %in% names(chea_results))) {
    prompt <- paste0(prompt, "No ChEA data available.\n")
  } else if (nrow(chea_results) == 0) {
    prompt <- paste0(prompt, "No significant ChEA results found.\n")
  } else {
    for (row in 1:nrow(chea_results)) {
      prompt <- paste0(prompt, "Term: ", chea_results[row, "Term"],
                       ", P-value: ", chea_results[row, "P.value"],
                       ", Genes: ", chea_results[row, "Genes"], "\n")
    }
  }
  
  # Add string network properties
  prompt <- paste0(prompt, "String Network Properties:\n")
  if (is.null(string_network_properties) || (is.list(string_network_properties) && "error" %in% names(string_network_properties))) {
    prompt <- paste0(prompt, "No string network properties data available.\n")
  } else if (nrow(string_network_properties) == 0) {
    prompt <- paste0(prompt, "No significant string network properties found.\n")
  } else {
    
    num_nodes <- nrow(string_network_properties)
    
    if (num_nodes > 100) {
      network_properties_to_use <- head(string_network_properties, 100)
    } else {
      network_properties_to_use <- string_network_properties
    }
    
    for (row in 1:nrow(network_properties_to_use)) {
      prompt <- paste0(prompt, "Node: ", network_properties_to_use[row, "node"],
                       ", Combined Network Score: ", network_properties_to_use[row, "combined_score_prop"], "\n")
    }
  }
  
  # Add pathway comparison results
  prompt <- paste0(prompt, "Pathway Comparison Results:\n")
  if (is.null(comparison_results) || (is.list(comparison_results) && "error" %in% names(comparison_results))) {
    prompt <- paste0(prompt, "No pathway comparison data available.\n")
  } else {
    
    # Helper function to format gene lists
    format_gene_list <- function(genes) {
      if (length(genes) == 0) {
        return("None")
      } else {
        return(paste(genes, collapse = ", "))
      }
    }
    
    prompt <- paste0(prompt, "KEGG Overlap: ", format_gene_list(comparison_results$kegg_overlap), "\n")
    prompt <- paste0(prompt, "WP Overlap: ", format_gene_list(comparison_results$wp_overlap), "\n")
    prompt <- paste0(prompt, "Reactome Overlap: ", format_gene_list(comparison_results$reactome_overlap), "\n")
    prompt <- paste0(prompt, "GO Overlap: ", format_gene_list(comparison_results$go_overlap), "\n")
    prompt <- paste0(prompt, "KEGG Unique: ", format_gene_list(comparison_results$kegg_unique), "\n")
    prompt <- paste0(prompt, "WP Unique: ", format_gene_list(comparison_results$wp_unique), "\n")
    prompt <- paste0(prompt, "Reactome Unique: ", format_gene_list(comparison_results$reactome_unique), "\n")
    prompt <- paste0(prompt, "GO Unique: ", format_gene_list(comparison_results$go_unique), "\n")
  }
  
  # Add the pathway comparison description (Option 3)
  prompt <- paste0(prompt, "\nTo aid in integrating the individual pathway responses, a pathway comparison analysis was conducted. This analysis identifies 'overlap' genes, which are present in multiple pathway results (KEGG, WikiPathways, Reactome, GO), suggesting shared biological functions. It also identifies 'unique' genes, which are specific to a single pathway, indicating more specialized roles. When integrating the pathway responses, consider how the shared and unique genes contribute to the overall biological system.\n\n")
  
  prompt <- paste0(prompt, "**Analysis Instructions:**\n\n",
                   "**Step 1: Analyze Individual Agent Summaries**\n",
                   "  - Review each agent's response individually and understand the analysis. Include the provided string network properties, pathway comparisons, chea results, list of differentially expressed genes, string results and experimental design (if provided) in your review, in addition to the agent summaries.\n\n",
                   
                   "**Step 2: Integrate Agent Summaries, Pathways and other data**\n",
                   "  - Considering the experimental design, and the data provided in the prompt (including the pathway comparison results, chea enrichment results, string network properties data and string interactions data), systematically integrate the information from different agent responses. Identify any similarities, differences, and complementary findings between them.\n",
                   "  - Systematically compare and integrate pathway results (KEGG, WikiPathways, Reactome, GO). Pay close attention to 'overlap' genes, which are present in multiple pathways, and 'unique' genes, which are specific to individual pathways.\n",
                   "  - Identify common themes and patterns across different agents and the additional data provided. What key biological processes are consistently highlighted? How do the unique and shared genes across pathways contribute to your understanding?\n\n",
                   
                   "**Step 3: Groundedness Check**\n",
                   "  - Ensure that the analysis results, from agents and integration in step 2, are grounded in the list of genes provided, as well as the pathway results. For example, if a pathway was identified, ensure that the genes mentioned in the pathway are also listed as differentially expressed in the beginning of the prompt.\n",
                   "  - Systematically check if any information from the summaries is not directly supported by the original list of genes, pathway data, string data or chea data. Note any inconsistencies or missing links.\n\n",
                   
                   "**Step 4: Regulatory Network Analysis**\n",
                   "  - Perform a detailed analysis focusing on the chea enrichment data, along with the agent responses, list of differentially expressed genes, the string network properties and the experimental design, to decipher potential regulatory network affecting our phenotype. Also discuss any potential novel interactions identified by ChEA. How do these novel transcription factor-gene interactions fit into the overall biological mechanisms identified from other data?\n\n",
                   
                   "**Step 5: Further Analysis:**\n",
                   "  - Provide a section on potential upstream regulators that could be driving this phenotype. List potential candidates with supporting reasoning, based on all the available data.\n",
                   "  - Provide a section on similar systems, reported in the scientific literature, that might be of interest based on your analysis.\n",
                   "  - Provide a hub gene identification section based on the integrated analysis, and the provided network properties. Explain how you concluded them as a hub gene.\n",
                   "  - For each hub gene, note if it is a known potential drug target or marker, and if it is a kinase or a ligand, and if any of these kinases or ligands are potential drug targets.\n",
                   "  - Provide a section on novelty exploration. Are there any unexpected connections, pathways, or transcription factors that have not been previously reported in the literature? If so, please list them and provide a brief explanation of why they are novel.\n\n",
                   "  - \n\n",
                   
                   "**Step 6: High-Level Summary**\n",
                   "  - Based on the above integrated analysis, provide a high-level summary describing the understood system. What are the key interconnected processes that are contributing to this phenotype? Include a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the enriched concepts. \n\n",
                   
                   "**Step 7: Title**\n",
                   "  - Based on the above integrated analysis, provide a single line title reflecting key findings. I want the title to have not more than 10 words. Include one important gene name identified as influencing the system, in the title. \n\n",
                   
                   "\n\n**Note:** Please keep your response under 6100 words. Do not include anyother Note.\n\n"
  )
  return(prompt)
}