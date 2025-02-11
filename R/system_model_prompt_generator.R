# system_model_prompt_generator.R
library(stringr)
library(dplyr)

# Function to extract and process the system network, and return a prompt for the rest of the analysis
generate_system_model_prompt <- function(llm_response, gene_symbols, experimental_design = NULL) {
  
  # Extract the system network from LLM response
  pattern <- "\\s*```(?i)tsv\\s*([\\s\\S]*?)\\s*```\\s*"
  matches <- str_match_all(llm_response, pattern)[[1]]
  
  if (nrow(matches) > 0) {
    system_network_tsv <- matches[, 2]
  } else {
    message("No TSV block found in the LLM response.")
    return(NULL)
  }
  
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
                   "Here is the revised system network in TSV format:\n", system_network_tsv, "\n\n",
                   
                   "**Instructions:**\n",
                   "Analyze the provided system network, in the context of the provided differentially expressed genes, and the experimental design. Provide a short summary/overview of the system, based on your analysis. Also, based on your analysis, describe how the potential upstream regulators and key genes could be affecting the phenotype through their target genes and pathways. Propose a mechanistic model based on your analysis and provide a short hypothesis about the molecular mechanism contributing to the phenotype, based on the identified relationships. Based on the mechanistic model that you have proposed, generate a network representation of the *system model*. I want the system model to be a bigger picture representation of the system, showing important players. \n\n",
                   
                   "Here's an example of the desired output format:\n",
                   
                   "*System Overview*\n",
                   " - The provided network reveals a complex interplay of genes and pathways implicated in immune response, inflammation, and cell adhesion.  The differentially expressed genes (DEGs) identified through RNA-Seq analysis of peripheral blood from uveitis patients provide crucial context.\n\n",
                   
                   "*Potential Upstream Regulators and Key Genes:*\n",
                   " - Several genes emerge as potential upstream regulators:
                  * **RELB:** This transcription factor is centrally positioned, directly targeting both GBP5 (involved in interferon signaling) and CD274 (PD-L1, involved in T cell costimulation).  Its influence on these genes suggests a role in shaping the immune response.

                  * **SMAD4:**  A key mediator of TGF-β signaling, SMAD4's association with FN1 (fibronectin), a crucial component of the extracellular matrix and focal adhesions, highlights its potential role in regulating cell adhesion and tissue remodeling processes relevant to inflammation.\n\n",
                   
                   "*Mechanistic Model*\n",
                   " - The identified relationships suggest a mechanistic model where upstream regulators like RELB and SMAD4 influence the phenotype (uveitis) through their downstream targets.  RELB's regulation of GBP5 and CD274 suggests a modulation of interferon signaling and T cell activity, potentially contributing to the inflammatory response characteristic of uveitis.\n\n",
                   
                   "*System Model*\n",
                   "```tsv\n",
                   "Node1\tInteraction\tNode2\n",
                   "RELB\ttargets\tGBP5\n",
                   "SMAD4\ttargets\tFN1\n",
                   "ATF3\tinteracts\tFN1\n",
                   "SMAD4\tassociated with\tAcute Inflammatory Response\n",
                   "C1QA\tassociated with\tImmune Response\n",
                   "```\n\n",
                   
                   "*Hypothesis*\n",
                   " - The observed changes in gene expression in peripheral blood from uveitis patients reflect a systemic dysregulation of immune responses and cell adhesion processes.  Specifically, we hypothesize that dysregulation of RELB and SMAD4 activity leads to altered expression of their target genes (GBP5, CD274, FN1), resulting in an amplified inflammatory response, impaired immune regulation, and altered tissue remodeling, contributing to the development and progression of uveitis.  The specific etiology of uveitis (axial spondyloarthritis, sarcoidosis, etc.) may influence the specific pattern of DEG expression and the relative contribution of these pathways.\n\n", 
                   
                   "\n\n**Note:** Please keep your response under 6100 words. Do not include anyother Note.\n\n"
  )
  
  return(prompt)
}