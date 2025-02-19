#' IAN_llm_prompts.R
#'
#' This script defines functions to create prompts for Large Language Models (LLMs) based on various enrichment analysis results.
#' The prompts are designed to guide the LLM in analyzing the data and generating insights about the underlying biological mechanisms.
#'
#' @section Functions:
#' \describe{
#'   \item{\code{\link{create_llm_prompt_wp}}}{: Creates an LLM prompt for WikiPathways enrichment analysis.}
#'   \item{\code{\link{create_llm_prompt_kegg}}}{: Creates an LLM prompt for KEGG enrichment analysis.}
#'   \item{\code{\link{create_llm_prompt_reactome}}}{: Creates an LLM prompt for Reactome enrichment analysis.}
#'   \item{\code{\link{create_llm_prompt_chea}}}{: Creates an LLM prompt for ChEA enrichment analysis.}
#'   \item{\code{\link{create_llm_prompt_go}}}{: Creates an LLM prompt for GO enrichment analysis.}
#'   \item{\code{\link{create_llm_prompt_string}}}{: Creates an LLM prompt for STRING interaction analysis.}
#' }
#'
#' @name llm_prompts
#' @docType package
NULL

#' Create LLM Prompt for WikiPathways Enrichment Analysis
#'
#' Creates a prompt for a Large Language Model (LLM) to analyze WikiPathways enrichment results,
#' along with other relevant data such as ChEA transcription factor enrichment, STRING protein-protein interaction data,
#' and Gene Ontology (GO) enrichment results.
#'
#' @param enrichment_results A data frame containing WikiPathways enrichment results.
#' @param analysis_type Character string specifying the type of analysis (e.g., "WikiPathways").
#' @param chea_results A data frame containing ChEA transcription factor enrichment results (optional).
#' @param string_results A list containing STRING protein-protein interaction data (optional).
#' @param gene_symbols A vector of gene symbols used in the analysis.
#' @param string_network_properties A data frame containing STRING network properties (optional).
#' @param go_results A data frame containing Gene Ontology (GO) enrichment results (optional).
#' @param experimental_design A character string describing the experimental design (optional).
#'
#' @return A character string containing the LLM prompt.
#'
#' @export
create_llm_prompt_wp <- function(enrichment_results, analysis_type, chea_results = NULL, string_results = NULL, gene_symbols = NULL, string_network_properties = NULL, go_results = NULL, experimental_design = NULL) {
  if (is.null(enrichment_results) || nrow(enrichment_results) == 0) {
    return(paste0("No significant results found for ", analysis_type, " analysis."))
  }
  
  formatted_results <- paste0(
    "**", analysis_type, " Analysis Results:**\n\n",
    paste(
      sprintf(
        "Pathway ID: %s\nDescription: %s\nP-value: %f\nGenes: %s\n\n",
        enrichment_results$ID,
        enrichment_results$Description,
        enrichment_results$pvalue,
        enrichment_results$Gene
      ),
      collapse = ""
    )
  )
  
  chea_text <- if (!is.null(chea_results) && nrow(chea_results) > 0) {
    paste0("\n**ChEA Transcription Factor Enrichment Results:**\n",
           paste(
             mapply(
               function(term, pvalue, genes) {
                 sprintf("Term: %s, P-value: %f, Genes: %s", term, pvalue, genes)
               },
               chea_results$Term,
               chea_results$P.value,
               chea_results$Genes
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No ChEA results available.**\n"
  }
  
  string_text <- if (!is.null(string_results) && !is.null(string_results$interactions) && nrow(string_results$interactions) > 0) {
    paste0("\n**STRING Protein-Protein Interaction Data:**\n",
           paste(
             mapply(
               function(protein1, protein2, score) {
                 sprintf("Protein 1: %s, Protein 2: %s, Combined Score: %f", protein1, protein2, score)
               },
               string_results$interactions$Protein1,
               string_results$interactions$Protein2,
               string_results$interactions$combined_score
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING interactions available.**\n"
  }
  
  string_network_text <- if (!is.null(string_results) && !is.null(string_results$network_properties) && nrow(string_results$network_properties) > 0) {
    
    num_nodes <- nrow(string_results$network_properties)
    
    if (num_nodes > 100) {
      network_properties_to_use <- head(string_results$network_properties, 100)
    } else {
      network_properties_to_use <- string_results$network_properties
    }
    
    paste0("\n**STRING Network Properties Data:**\n",
           paste(
             mapply(
               function(node, score) {
                 sprintf("Node: %s, Combined Network Score: %f", node, score)
               },
               network_properties_to_use$node,
               network_properties_to_use$combined_score_prop
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING network properties available.**\n"
  }
  
  go_text <- if (!is.null(go_results) && nrow(go_results) > 0) {
    paste0("\n**Gene Ontology (GO) Enrichment Results:**\n",
           paste(
             mapply(
               function(description, pvalue, genes) {
                 sprintf("Description: %s, P-value: %f, Genes: %s", description, pvalue, genes)
               },
               go_results$Description,
               go_results$pvalue,
               go_results$Gene
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No GO results available.**\n"
  }
  
  prompt_start <- paste0(
    "I have performed a transcriptomics experiment comparing two conditions and identified a list of significantly differentially expressed genes (DEGs). Below is the data from my analysis:\n\n",
    
    "**List of Differentially Expressed Genes (DEGs):**\n",
    "This is a list of gene symbols that were found to be significantly differentially expressed in my experiment.\n",
    paste(gene_symbols, collapse = ", "), "\n\n"
  )
  
  if (!is.null(experimental_design) && experimental_design != "") {
    prompt_start <- paste0(prompt_start, "**Experimental Design:**\n",
                           "The experimental design is as follows: ", experimental_design, "\n\n")
  }
  
  prompt <- paste0(
    prompt_start,
    "**WikiPathways Pathway Enrichment Analysis Results:**\n",
    "This section contains the results of the WikiPathways pathway enrichment analysis performed on the DEGs. It includes the pathway ID, description, p-value, and the list of genes associated with each pathway.\n",
    formatted_results,
    
    "**ChEA Transcription Factor Enrichment Results:**\n",
    "This section contains the results of the ChEA transcription factor enrichment analysis performed on the DEGs. It includes the transcription factor term, p-value, and the list of genes associated with each transcription factor.\n",
    chea_text,
    
    "**STRING Protein-Protein Interaction Data:**\n",
    "This section contains the protein-protein interactions from the STRING database, based on the DEGs. It includes the interacting proteins and their combined scores.\n",
    string_text,
    
    "**STRING Network Properties Data:**\n",
    "This section contains the top 100 nodes from the STRING network, ranked by their combined network score. It includes the node and its combined network score.\n",
    string_network_text,
    
    "**Gene Ontology (GO) Enrichment Results:**\n",
    "This section contains the results of the Gene Ontology (GO) enrichment analysis performed on the DEGs. It includes the GO term description, p-value, and the list of genes associated with each GO term.\n",
    go_text,
    
    "\n\nMy goal is to analyze these enriched pathways and their respective genes, along with transcription factor enrichment and interaction data, to understand the underlying biological mechanisms of the system, identify critical genes and pathways, and explore potential regulatory elements. Perform all the analysis in the context of the experimental design, if given. \n\n",
    
    "**Analysis Instructions:**\n\n",
    
    "1. **Summary and Categorization:**\n",
    "   - Provide a one-paragraph summary (about 4 lines) of the significantly enriched WikiPathways pathways. Consider the experimental design, if given. \n",
    "   - Categorize the enriched pathways into broad functional groups and count the number of enriched concepts in each category. *Include only the top 4 categories*.\n\n",
    
    "2. **Known Roles and Upstream Regulators:**\n",
    "   - Provide a concise summary (about 4 lines) of the enriched pathways with their known roles in the context of our experiment, based on the current scientific literature.\n",
    "   - Based on the genes contributing to the enriched pathways, predict potential upstream regulators (transcription factors, kinases etc.,) that could be driving this phenotype. Provide a list of potential candidates with supporting reasoning.\n\n",
    
    "3. **Interaction Networks and Similar Systems:**\n",
    "   - Based on the genes involved in the enriched pathways and also found in the string data, suggest possible interactions or relationships between the enriched pathway genes. Mention any known protein-protein interactions, regulatory relationships or shared functional roles.\n",
    "   - Based on the enriched pathways and the genes involved, explore if there are other systems similar to our study, reported in the scientific literature, that might be of interest.\n\n",
    
    "4. **Hub Gene Identification:**\n",
    "   - Let's identify hub genes *think step-by-step*:\n",
    "     - First, identify genes that are enriched in *multiple* pathways.\n",
    "     - Second, identify genes that are enriched in GO analysis results (if GO analysis was performed), that are also enriched in our pathways.\n",
    "     - Third, identify genes represented in the enriched pathways that also have high combined network scores in the string network properties data.\n",
    "     - Fourth, identify genes represented in the enriched pathways that are also found in our ChEA enrichment results.\n",
    "     - Finally, integrate, compare, and analyze results from the first four steps to identify potential hub genes.\n",
    
    "   - List the potential hub genes and provide a single-line description of how you concluded them as a hub gene. *Explain your reasoning for each step*.\n",
    
    "   - *Review your hub genes list and ensure that each listed hub gene is indeed present in the corresponding provided data. If necessary, revise your answer*.\n\n",
    
    "5. **Drug Target/Marker/Kinase/Ligand Analysis:**\n",
    "   - For each hub gene, briefly note if it is a known potential drug target or marker, and if it is a kinase or a ligand, and if any of these kinases or ligands are potential drug targets.\n\n",
    
    "6. **Novelty Exploration:**\n",
    "   - Based on your analysis above, explore if there are any novel findings in our data. Are there any unexpected connections, pathways, or transcription factors that have not been previously reported in the literature? If so, please list them and provide a brief explanation of why they are novel.\n\n",
    
    "7. **Hypothesis Generation:**\n",
    "   - Integrate the findings from all the above to develop a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the enriched concepts.\n\n",
    
    "8. **System Representation Network:**\n",
    "   - Based on the identified hub genes and their associated GO terms, pathways, chea terms, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.\n",
    "     - Node1 should be the hub gene, *formatted in uppercase*.\n",
    "     - Edge should be 'associated with'. \n",
    "     - Node2 should be *a single GO term, formatted in 'Title Case'*, or a pathway name, *formatted in 'Title Case'*, or a transcription factor, *formatted in uppercase*.\n",
    "   - Check if the nodes identified above are grounded in the provided data. In the explanation column, include a note stating whether the network interaction in each row is grounded in the provided data.\n",
    "   - *Review the above network and ensure that every interaction included meets the grounding criteria and that each interaction includes only one hub gene and one GO term, pathway or transcription factor. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.\n",
    "   - Format the output within a ```tsv block, by adding ```tsv before the network content and ``` after the network content.\n",
    
    "\n\n**Example Output:**\n",
    "**1. Summary and Categorization:**\n",
    "The enriched WikiPathways primarily involve immune response and cell signaling pathways. These can be categorized into:\n",
    "- Immune Response Pathways: 4 enriched pathways\n",
    "- Cell Signaling Pathways: 2 enriched pathways\n\n",
    
    "**2. Known Roles and Upstream Regulators:**\n",
    "The enriched immune response pathways are known to be involved in inflammation and immune cell activation. Potential upstream regulators include transcription factors such as NFKB and STAT family members, which are known to regulate immune response genes.\n\n",
    
    "**3. Interaction Networks and Similar Systems:**\n",
    "Genes within the enriched pathways show interactions related to immune cell signaling and cytokine production. Similar systems reported in the literature include studies on autoimmune diseases and inflammatory conditions.\n\n",
    
    "**4. Hub Gene Identification:**\n",
    "**Step 1: Genes enriched in multiple pathways:**\n",
    "FN1 (Focal adhesion, ECM-receptor interaction, Cytoskeleton in muscle cells, AGE-RAGE signaling pathway in diabetic complications, Amoebiasis, Small cell lung cancer)
    C1QA (Efferocytosis, Complement and coagulation cascades, Alcoholic liver disease, Chagas disease, Staphylococcus aureus infection, Coronavirus disease - COVID-19, Systemic lupus erythematosus)
    C1QB (Efferocytosis, Complement and coagulation cascades, Alcoholic liver disease, Chagas disease, Staphylococcus aureus infection, Coronavirus disease - COVID-19, Systemic lupus erythematosus).\n\n",
    
    "**Step 2: Genes enriched in GO and pathways:**\n",
    "FN1 (multiple pathways, acute inflammatory response, acute-phase response, cell recognition, etc.)
    ANK2 (multiple GO terms related to actin and cardiac muscle, pathways)
    NOS1AP (multiple GO terms related to action potential and cardiac muscle, pathways).\n\n",
    
    "**Step 3: Genes with high STRING network scores:**\n",
    "FN1 (Combined Network Score: 2.734623)
    ANKRD22 (Combined Network Score: 2.422102)
    CD274 (Combined Network Score: 2.243023).\n\n",
    
    "**Step 4: Genes in ChEA enrichment results:**\n",
    "GBP5 (RELB, SMAD4, PCGF4)
    CD274 (RELB, IRF1, SMAD4)
    LRP1B (TFAP2C, PCGF4).\n\n",
    
    "**Integrated Analysis:**\n",
    "FN1, C1QA, C1QB, C1QC, ANK2, and CD274 emerge as potential hub genes based on their presence in multiple KEGG pathways, GO terms, and high STRING network scores.  Several genes are also present in ChEA results, further supporting their central role.\n\n",
    
    "**Potential Hub Genes:**\n",
    "- **FN1:**  Enriched in multiple pathways and GO terms related to ECM, cell adhesion, and inflammation.
    - **C1QA, C1QB, C1QC:**  Core components of the complement system, enriched in multiple pathways and GO terms related to immune response.
    - **ANK2:**  Involved in actin cytoskeleton dynamics and cardiac muscle function, enriched in multiple GO terms and pathways.
    - **CD274:**  A key immune checkpoint molecule, enriched in pathways and GO terms related to T cell co-stimulation and immune regulation.\n\n",
    
    "**5. Drug Target/Marker/Kinase/Ligand Analysis:**\n",
    "- **FN1 (Fibronectin):**  Not a direct drug target, but its role in cell adhesion makes it a potential indirect target for therapies modulating inflammation.
    - **C1QA, C1QB, C1QC (Complement components):**  Not typically direct drug targets, but their involvement in complement-mediated inflammation makes them potential biomarkers.
    - **ANK2 (Ankyrin-2):**  Not a known drug target.
    - **CD274 (PD-L1):**  A well-established drug target in cancer immunotherapy; antibodies blocking its interaction with PD-1 are used clinically.\n\n",
    
    "**6. Novelty Exploration:**\n",
    "The strong enrichment of pathways related to infectious diseases (Pertussis, Coronavirus, Staphylococcus aureus, Amoebiasis, Chagas disease) in the context of uveitis is potentially novel and warrants further investigation.  While infections can trigger uveitis, the specific pathways highlighted here may reveal novel mechanisms linking infection and uveitis pathogenesis.  The unexpected connections between complement activation and infectious disease pathways could be a novel finding.\n\n",
    
    "**7. Hypothesis Generation:**\n",
    "Uveitis pathogenesis involves a complex interplay between dysregulated immune responses, primarily driven by complement activation and T cell co-stimulation, and impaired ECM remodeling.  This leads to chronic inflammation and tissue damage.  The involvement of infectious disease pathways suggests that microbial triggers or dysbiosis may contribute to the initiation or exacerbation of uveitis.  Upstream regulators like NF-kb, IRFs, AP-1, and SMAD family members likely orchestrate these processes.\n\n",
    
    "**8. System Representation Network:**\n",
    "```tsv\n",
    "Node1\tEdge\tNode2\tExplanation\n",
    "FN1\tassociated with\tCell Adhesion Molecules\tGrounded in provided data (KEGG, GO, STRING)\n",
    "FN1\tassociated with\tAcute Inflammatory Response\tGrounded in provided data (KEGG, GO, STRING)\n",
    "C1QA\tassociated with\tComplement Activation\tGrounded in provided data (KEGG, GO, STRING)\n",
    "C1QA\tassociated with\tImmune Response\tGrounded in provided data (KEGG, GO, STRING)\n",
    "ANK2\tassociated with\tActin Filament-Based Movement\tGrounded in provided data (KEGG, GO, STRING)\n",
    "CD274\tassociated with\tT Cell Costimulation\tGrounded in provided data (KEGG, GO, STRING)\n",
    "```\n\n",
    
    "\n**Note:** Please keep your response under 6100 words. Do not include anyother Note."
  )
  return(prompt)
}

#' Create LLM Prompt for KEGG Enrichment Analysis
#'
#' Creates a prompt for a Large Language Model (LLM) to analyze KEGG enrichment results,
#' along with other relevant data such as ChEA transcription factor enrichment, STRING protein-protein interaction data,
#' and Gene Ontology (GO) enrichment results.
#'
#' @param enrichment_results A data frame containing KEGG enrichment results.
#' @param analysis_type Character string specifying the type of analysis (e.g., "KEGG").
#' @param chea_results A data frame containing ChEA transcription factor enrichment results (optional).
#' @param string_results A list containing STRING protein-protein interaction data (optional).
#' @param gene_symbols A vector of gene symbols used in the analysis.
#' @param string_network_properties A data frame containing STRING network properties (optional).
#' @param go_results A data frame containing Gene Ontology (GO) enrichment results (optional).
#' @param experimental_design A character string describing the experimental design (optional).
#'
#' @return A character string containing the LLM prompt.
#'
#' @export
create_llm_prompt_kegg <- function(enrichment_results, analysis_type, chea_results = NULL, string_results = NULL, gene_symbols = NULL, string_network_properties = NULL, go_results = NULL, experimental_design = NULL) {
  if (is.null(enrichment_results) || nrow(enrichment_results) == 0) {
    return(paste0("No significant results found for ", analysis_type, " analysis."))
  }
  
  formatted_results <- paste0(
    "**", analysis_type, " Analysis Results:**\n\n",
    paste(
      sprintf(
        "Pathway ID: %s\nDescription: %s\nP-value: %f\nGenes: %s\n\n",
        enrichment_results$ID,
        enrichment_results$Description,
        enrichment_results$pvalue,
        enrichment_results$Gene
      ),
      collapse = ""
    )
  )
  
  chea_text <- if (!is.null(chea_results) && nrow(chea_results) > 0) {
    paste0("\n**ChEA Transcription Factor Enrichment Results:**\n",
           paste(
             mapply(
               function(term, pvalue, genes) {
                 sprintf("Term: %s, P-value: %f, Genes: %s", term, pvalue, genes)
               },
               chea_results$Term,
               chea_results$P.value,
               chea_results$Genes
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No ChEA results available.**\n"
  }
  
  string_text <- if (!is.null(string_results) && !is.null(string_results$interactions) && nrow(string_results$interactions) > 0) {
    paste0("\n**STRING Protein-Protein Interaction Data:**\n",
           paste(
             mapply(
               function(protein1, protein2, score) {
                 sprintf("Protein 1: %s, Protein 2: %s, Combined Score: %f", protein1, protein2, score)
               },
               string_results$interactions$Protein1,
               string_results$interactions$Protein2,
               string_results$interactions$combined_score
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING interactions available.**\n"
  }
  
  string_network_text <- if (!is.null(string_results) && !is.null(string_results$network_properties) && nrow(string_results$network_properties) > 0) {
    
    num_nodes <- nrow(string_results$network_properties)
    
    if (num_nodes > 100) {
      network_properties_to_use <- head(string_results$network_properties, 100)
    } else {
      network_properties_to_use <- string_results$network_properties
    }
    
    paste0("\n**STRING Network Properties Data:**\n",
           paste(
             mapply(
               function(node, score) {
                 sprintf("Node: %s, Combined Network Score: %f", node, score)
               },
               network_properties_to_use$node,
               network_properties_to_use$combined_score_prop
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING network properties available.**\n"
  }
  
  go_text <- if (!is.null(go_results) && nrow(go_results) > 0) {
    paste0("\n**Gene Ontology (GO) Enrichment Results:**\n",
           paste(
             mapply(
               function(description, pvalue, genes) {
                 sprintf("Description: %s, P-value: %f, Genes: %s", description, pvalue, genes)
               },
               go_results$Description,
               go_results$pvalue,
               go_results$Gene
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No GO results available.**\n"
  }
  
  prompt_start <- paste0(
    "I have performed a transcriptomics experiment comparing two conditions and identified a list of significantly differentially expressed genes (DEGs). Below is the data from my analysis:\n\n",
    
    "**List of Differentially Expressed Genes (DEGs):**\n",
    "This is a list of gene symbols that were found to be significantly differentially expressed in my experiment.\n",
    paste(gene_symbols, collapse = ", "), "\n\n"
  )
  
  if (!is.null(experimental_design) && experimental_design != "") {
    prompt_start <- paste0(prompt_start, "**Experimental Design:**\n",
                           "The experimental design is as follows: ", experimental_design, "\n\n")
  }
  
  prompt <- paste0(
    prompt_start,
    "**KEGG Pathway Enrichment Analysis Results:**\n",
    "This section contains the results of the KEGG pathway enrichment analysis performed on the DEGs. It includes the pathway ID, description, p-value, and the list of genes associated with each pathway.\n",
    formatted_results,
    
    "**ChEA Transcription Factor Enrichment Results:**\n",
    "This section contains the results of the ChEA transcription factor enrichment analysis performed on the DEGs. It includes the transcription factor term, p-value, and the list of genes associated with each transcription factor.\n",
    chea_text,
    
    "**STRING Protein-Protein Interaction Data:**\n",
    "This section contains the protein-protein interactions from the STRING database, based on the DEGs. It includes the interacting proteins and their combined scores.\n",
    string_text,
    
    "**STRING Network Properties Data:**\n",
    "This section contains the top 100 nodes from the STRING network, ranked by their combined network score. It includes the node and its combined network score.\n",
    string_network_text,
    
    "**Gene Ontology (GO) Enrichment Results:**\n",
    "This section contains the results of the Gene Ontology (GO) enrichment analysis performed on the DEGs. It includes the GO term description, p-value, and the list of genes associated with each GO term.\n",
    go_text,
    
    "\n\nMy goal is to analyze these enriched pathways and their respective genes, along with transcription factor enrichment and interaction data, to understand the underlying biological mechanisms of the system, identify critical genes and pathways, and explore potential regulatory elements. Perform all the analysis in the context of the experimental design, if given. \n\n",
    
    "**Analysis Instructions:**\n\n",
    
    "1. **Summary and Categorization:**\n",
    "   - Provide a one-paragraph summary (about 4 lines) of the significantly enriched KEGG pathways. Consider the experimental design, if given. \n",
    "   - Categorize the enriched pathways into broad functional groups and count the number of enriched concepts in each category. *Include only the top 4 categories*.\n\n",
    
    "2. **Known Roles and Upstream Regulators:**\n",
    "   - Provide a concise summary (about 4 lines) of the enriched pathways with their known roles in the context of our experiment, based on the current scientific literature.\n",
    "   - Based on the genes contributing to the enriched pathways, predict potential upstream regulators (transcription factors, kinases etc.,) that could be driving this phenotype. Provide a list of potential candidates with supporting reasoning.\n\n",
    
    "3. **Interaction Networks and Similar Systems:**\n",
    "   - Based on the genes involved in the enriched pathways and also found in the string data, suggest possible interactions or relationships between the enriched pathway genes. Mention any known protein-protein interactions, regulatory relationships or shared functional roles.\n",
    "   - Based on the enriched pathways and the genes involved, explore if there are other systems similar to our study, reported in the scientific literature, that might be of interest.\n\n",
    
    "4. **Hub Gene Identification:**\n",
    "   - Let's identify hub genes *think step-by-step*:\n",
    "     - First, identify genes that are enriched in *multiple* pathways.\n",
    "     - Second, identify genes that are enriched in GO analysis results (if GO analysis was performed), that are also enriched in our pathways.\n",
    "     - Third, identify genes represented in the enriched pathways that also have high combined network scores in the string network properties data.\n",
    "     - Fourth, identify genes represented in the enriched pathways that are also found in our ChEA enrichment results.\n",
    "     - Finally, integrate, compare, and analyze results from the first four steps to identify potential hub genes.\n",
    
    "   - List the potential hub genes and provide a single-line description of how you concluded them as a hub gene. *Explain your reasoning for each step*.\n",
    
    "   - *Review your hub genes list and ensure that each listed hub gene is indeed present in the corresponding provided data. If necessary, revise your answer*.\n\n",
    
    "5. **Drug Target/Marker/Kinase/Ligand Analysis:**\n",
    "   - For each hub gene, briefly note if it is a known potential drug target or marker, and if it is a kinase or a ligand, and if any of these kinases or ligands are potential drug targets.\n\n",
    
    "6. **Novelty Exploration:**\n",
    "   - Based on your analysis above, explore if there are any novel findings in our data. Are there any unexpected connections, pathways, or transcription factors that have not been previously reported in the literature? If so, please list them and provide a brief explanation of why they are novel.\n\n",
    
    "7. **Hypothesis Generation:**\n",
    "   - Integrate the findings from all the above to develop a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the enriched concepts.\n\n",
    
    "8. **System Representation Network:**\n",
    "   - Based on the identified hub genes and their associated GO terms, pathways, chea terms, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.\n",
    "     - Node1 should be the hub gene, *formatted in uppercase*.\n",
    "     - Edge should be 'associated with'. \n",
    "     - Node2 should be *a single GO term, formatted in 'Title Case'*, or a pathway name, *formatted in 'Title Case'*, or a transcription factor, *formatted in uppercase*.\n",
    "   - Check if the nodes identified above are grounded in the provided data. In the explanation column, include a note stating whether the network interaction in each row is grounded in the provided data.\n",
    "   - *Review the above network and ensure that every interaction included meets the grounding criteria and that each interaction includes only one hub gene and one GO term, pathway or transcription factor. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.\n",
    "   - Format the output within a ```tsv block, by adding ```tsv before the network content and ``` after the network content.\n",
    
    "\n\n**Example Output:**\n",
    "**1. Summary and Categorization:**\n",
    "The enriched KEGG pathways primarily involve immune response and cell signaling pathways. These can be categorized into:\n",
    "- Immune Response Pathways: 4 enriched pathways\n",
    "- Cell Signaling Pathways: 2 enriched pathways\n\n",
    
    "**2. Known Roles and Upstream Regulators:**\n",
    "The enriched immune response pathways are known to be involved in inflammation and immune cell activation. Potential upstream regulators include transcription factors such as NFKB and STAT family members, which are known to regulate immune response genes.\n\n",
    
    "**3. Interaction Networks and Similar Systems:**\n",
    "Genes within the enriched pathways show interactions related to immune cell signaling and cytokine production. Similar systems reported in the literature include studies on autoimmune diseases and inflammatory conditions.\n\n",
    
    "**4. Hub Gene Identification:**\n",
    "**Step 1: Genes enriched in multiple pathways:**\n",
    "FN1 (Focal adhesion, ECM-receptor interaction, Cytoskeleton in muscle cells, AGE-RAGE signaling pathway in diabetic complications, Amoebiasis, Small cell lung cancer)
    C1QA (Efferocytosis, Complement and coagulation cascades, Alcoholic liver disease, Chagas disease, Staphylococcus aureus infection, Coronavirus disease - COVID-19, Systemic lupus erythematosus)
    C1QB (Efferocytosis, Complement and coagulation cascades, Alcoholic liver disease, Chagas disease, Staphylococcus aureus infection, Coronavirus disease - COVID-19, Systemic lupus erythematosus).\n\n",
    
    "**Step 2: Genes enriched in GO and pathways:**\n",
    "FN1 (multiple pathways, acute inflammatory response, acute-phase response, cell recognition, etc.)
    ANK2 (multiple GO terms related to actin and cardiac muscle, pathways)
    NOS1AP (multiple GO terms related to action potential and cardiac muscle, pathways).\n\n",
    
    "**Step 3: Genes with high STRING network scores:**\n",
    "FN1 (Combined Network Score: 2.734623)
    ANKRD22 (Combined Network Score: 2.422102)
    CD274 (Combined Network Score: 2.243023).\n\n",
    
    "**Step 4: Genes in ChEA enrichment results:**\n",
    "GBP5 (RELB, SMAD4, PCGF4)
    CD274 (RELB, IRF1, SMAD4)
    LRP1B (TFAP2C, PCGF4).\n\n",
    
    "**Integrated Analysis:**\n",
    "FN1, C1QA, C1QB, C1QC, ANK2, and CD274 emerge as potential hub genes based on their presence in multiple KEGG pathways, GO terms, and high STRING network scores.  Several genes are also present in ChEA results, further supporting their central role.\n\n",
    
    "**Potential Hub Genes:**\n",
    "- **FN1:**  Enriched in multiple pathways and GO terms related to ECM, cell adhesion, and inflammation.
    - **C1QA, C1QB, C1QC:**  Core components of the complement system, enriched in multiple pathways and GO terms related to immune response.
    - **ANK2:**  Involved in actin cytoskeleton dynamics and cardiac muscle function, enriched in multiple GO terms and pathways.
    - **CD274:**  A key immune checkpoint molecule, enriched in pathways and GO terms related to T cell co-stimulation and immune regulation.\n\n",
    
    "**5. Drug Target/Marker/Kinase/Ligand Analysis:**\n",
    "- **FN1 (Fibronectin):**  Not a direct drug target, but its role in cell adhesion makes it a potential indirect target for therapies modulating inflammation.
    - **C1QA, C1QB, C1QC (Complement components):**  Not typically direct drug targets, but their involvement in complement-mediated inflammation makes them potential biomarkers.
    - **ANK2 (Ankyrin-2):**  Not a known drug target.
    - **CD274 (PD-L1):**  A well-established drug target in cancer immunotherapy; antibodies blocking its interaction with PD-1 are used clinically.\n\n",
    
    "**6. Novelty Exploration:**\n",
    "The strong enrichment of pathways related to infectious diseases (Pertussis, Coronavirus, Staphylococcus aureus, Amoebiasis, Chagas disease) in the context of uveitis is potentially novel and warrants further investigation.  While infections can trigger uveitis, the specific pathways highlighted here may reveal novel mechanisms linking infection and uveitis pathogenesis.  The unexpected connections between complement activation and infectious disease pathways could be a novel finding.\n\n",
    
    "**7. Hypothesis Generation:**\n",
    "Uveitis pathogenesis involves a complex interplay between dysregulated immune responses, primarily driven by complement activation and T cell co-stimulation, and impaired ECM remodeling.  This leads to chronic inflammation and tissue damage.  The involvement of infectious disease pathways suggests that microbial triggers or dysbiosis may contribute to the initiation or exacerbation of uveitis.  Upstream regulators like NF-kB, IRFs, AP-1, and SMAD family members likely orchestrate these processes.\n\n",
    
    "**8. System Representation Network:**\n",
    "```tsv\n",
    "Node1\tEdge\tNode2\tExplanation\n",
    "FN1\tassociated with\tCell Adhesion Molecules\tGrounded in provided data (KEGG, GO, STRING)\n",
    "FN1\tassociated with\tAcute Inflammatory Response\tGrounded in provided data (KEGG, GO, STRING)\n",
    "C1QA\tassociated with\tComplement Activation\tGrounded in provided data (KEGG, GO, STRING)\n",
    "C1QA\tassociated with\tImmune Response\tGrounded in provided data (KEGG, GO, STRING)\n",
    "ANK2\tassociated with\tActin Filament-Based Movement\tGrounded in provided data (KEGG, GO, STRING)\n",
    "CD274\tassociated with\tT Cell Costimulation\tGrounded in provided data (KEGG, GO, STRING)\n",
    "```\n\n",
    
    "\n**Note:** Please keep your response under 6100 words. Do not include anyother Note.\n\n"
  )
  return(prompt)
}


#' Create LLM Prompt for Reactome Pathway Enrichment Analysis
#'
#' Creates a prompt for a Large Language Model (LLM) to analyze Reactome pathway enrichment results,
#' along with other relevant data such as ChEA transcription factor enrichment, STRING protein-protein interaction data,
#' and Gene Ontology (GO) enrichment results.
#'
#' @param enrichment_results A data frame containing Reactome pathway enrichment results.
#' @param analysis_type Character string specifying the type of analysis (e.g., "Reactome").
#' @param chea_results A data frame containing ChEA transcription factor enrichment results (optional).
#' @param string_results A list containing STRING protein-protein interaction data (optional).
#' @param gene_symbols A vector of gene symbols used in the analysis.
#' @param string_network_properties A data frame containing STRING network properties (optional).
#' @param go_results A data frame containing Gene Ontology (GO) enrichment results (optional).
#' @param experimental_design A character string describing the experimental design (optional).
#'
#' @return A character string containing the LLM prompt.
#'
#' @export
create_llm_prompt_reactome <- function(enrichment_results, analysis_type, chea_results = NULL, string_results = NULL, gene_symbols = NULL, string_network_properties = NULL, go_results = NULL, experimental_design = NULL) {
  if (is.null(enrichment_results) || nrow(enrichment_results) == 0) {
    return(paste0("No significant results found for ", analysis_type, " analysis."))
  }
  
  formatted_results <- paste0(
    "**", analysis_type, " Analysis Results:**\n\n",
    paste(
      sprintf(
        "Pathway ID: %s\nDescription: %s\nP-value: %f\nGenes: %s\n\n",
        enrichment_results$ID,
        enrichment_results$Description,
        enrichment_results$pvalue,
        enrichment_results$Gene
      ),
      collapse = ""
    )
  )
  
  chea_text <- if (!is.null(chea_results) && nrow(chea_results) > 0) {
    paste0("\n**ChEA Transcription Factor Enrichment Results:**\n",
           paste(
             mapply(
               function(term, pvalue, genes) {
                 sprintf("Term: %s, P-value: %f, Genes: %s", term, pvalue, genes)
               },
               chea_results$Term,
               chea_results$P.value,
               chea_results$Genes
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No ChEA results available.**\n"
  }
  
  string_text <- if (!is.null(string_results) && !is.null(string_results$interactions) && nrow(string_results$interactions) > 0) {
    paste0("\n**STRING Protein-Protein Interaction Data:**\n",
           paste(
             mapply(
               function(protein1, protein2, score) {
                 sprintf("Protein 1: %s, Protein 2: %s, Combined Score: %f", protein1, protein2, score)
               },
               string_results$interactions$Protein1,
               string_results$interactions$Protein2,
               string_results$interactions$combined_score
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING interactions available.**\n"
  }
  
  string_network_text <- if (!is.null(string_results) && !is.null(string_results$network_properties) && nrow(string_results$network_properties) > 0) {
    
    num_nodes <- nrow(string_results$network_properties)
    
    if (num_nodes > 100) {
      network_properties_to_use <- head(string_results$network_properties, 100)
    } else {
      network_properties_to_use <- string_results$network_properties
    }
    
    paste0("\n**STRING Network Properties Data:**\n",
           paste(
             mapply(
               function(node, score) {
                 sprintf("Node: %s, Combined Network Score: %f", node, score)
               },
               network_properties_to_use$node,
               network_properties_to_use$combined_score_prop
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING network properties available.**\n"
  }
  
  go_text <- if (!is.null(go_results) && nrow(go_results) > 0) {
    paste0("\n**Gene Ontology (GO) Enrichment Results:**\n",
           paste(
             mapply(
               function(description, pvalue, genes) {
                 sprintf("Description: %s, P-value: %f, Genes: %s", description, pvalue, genes)
               },
               go_results$Description,
               go_results$pvalue,
               go_results$Gene
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No GO results available.**\n"
  }
  
  prompt_start <- paste0(
    "I have performed a transcriptomics experiment comparing two conditions and identified a list of significantly differentially expressed genes (DEGs). Below is the data from my analysis:\n\n",
    
    "**List of Differentially Expressed Genes (DEGs):**\n",
    "This is a list of gene symbols that were found to be significantly differentially expressed in my experiment.\n",
    paste(gene_symbols, collapse = ", "), "\n\n"
  )
  
  if (!is.null(experimental_design) && experimental_design != "") {
    prompt_start <- paste0(prompt_start, "**Experimental Design:**\n",
                           "The experimental design is as follows: ", experimental_design, "\n\n")
  }
  
  prompt <- paste0(
    prompt_start,
    "**Reactome Pathway Enrichment Analysis Results:**\n",
    "This section contains the results of the Reactome pathway enrichment analysis performed on the DEGs. It includes the pathway ID, description, p-value, and the list of genes associated with each pathway.\n",
    formatted_results,
    
    "**ChEA Transcription Factor Enrichment Results:**\n",
    "This section contains the results of the ChEA transcription factor enrichment analysis performed on the DEGs. It includes the transcription factor term, p-value, and the list of genes associated with each transcription factor.\n",
    chea_text,
    
    "**STRING Protein-Protein Interaction Data:**\n",
    "This section contains the protein-protein interactions from the STRING database, based on the DEGs. It includes the interacting proteins and their combined scores.\n",
    string_text,
    
    "**STRING Network Properties Data:**\n",
    "This section contains the top 100 nodes from the STRING network, ranked by their combined network score. It includes the node and its combined network score.\n",
    string_network_text,
    
    "**Gene Ontology (GO) Enrichment Results:**\n",
    "This section contains the results of the Gene Ontology (GO) enrichment analysis performed on the DEGs. It includes the GO term description, p-value, and the list of genes associated with each GO term.\n",
    go_text,
    
    "\n\nMy goal is to analyze these enriched pathways and their respective genes, along with transcription factor enrichment and interaction data, to understand the underlying biological mechanisms of the system, identify critical genes and pathways, and explore potential regulatory elements. Perform all the analysis in the context of the experimental design, if given. \n\n",
    
    "**Analysis Instructions:**\n\n",
    
    "1. **Summary and Categorization:**\n",
    "   - Provide a one-paragraph summary (about 4 lines) of the significantly enriched Reactome pathways. Consider the experimental design, if given. \n",
    "   - Categorize the enriched pathways into broad functional groups and count the number of enriched concepts in each category. *Include only the top 4 categories*.\n\n",
    
    "2. **Known Roles and Upstream Regulators:**\n",
    "   - Provide a concise summary (about 4 lines) of the enriched pathways with their known roles in the context of our experiment, based on the current scientific literature.\n",
    "   - Based on the genes contributing to the enriched pathways, predict potential upstream regulators (transcription factors, kinases etc.,) that could be driving this phenotype. Provide a list of potential candidates with supporting reasoning.\n\n",
    
    "3. **Interaction Networks and Similar Systems:**\n",
    "   - Based on the genes involved in the enriched pathways and also found in the string data, suggest possible interactions or relationships between the enriched pathway genes. Mention any known protein-protein interactions, regulatory relationships or shared functional roles.\n",
    "   - Based on the enriched pathways and the genes involved, explore if there are other systems similar to our study, reported in the scientific literature, that might be of interest.\n\n",
    
    "4. **Hub Gene Identification:**\n",
    "   - Let's identify hub genes *think step-by-step*:\n",
    "     - First, identify genes that are enriched in *multiple* pathways.\n",
    "     - Second, identify genes that are enriched in GO analysis results (if GO analysis was performed), that are also enriched in our pathways.\n",
    "     - Third, identify genes represented in the enriched pathways that also have high combined network scores in the string network properties data.\n",
    "     - Fourth, identify genes represented in the enriched pathways that are also found in our ChEA enrichment results.\n",
    "     - Finally, integrate, compare, and analyze results from the first four steps to identify potential hub genes.\n",
    
    "   - List the potential hub genes and provide a single-line description of how you concluded them as a hub gene. *Explain your reasoning for each step*.\n",
    
    "   - *Review your hub genes list and ensure that each listed hub gene is indeed present in the corresponding provided data. If necessary, revise your answer*.\n\n",
    
    "5. **Drug Target/Marker/Kinase/Ligand Analysis:**\n",
    "   - For each hub gene, briefly note if it is a known potential drug target or marker, and if it is a kinase or a ligand, and if any of these kinases or ligands are potential drug targets.\n\n",
    
    "6. **Novelty Exploration:**\n",
    "   - Based on your analysis above, explore if there are any novel findings in our data. Are there any unexpected connections, pathways, or transcription factors that have not been previously reported in the literature? If so, please list them and provide a brief explanation of why they are novel.\n\n",
    
    "7. **Hypothesis Generation:**\n",
    "   - Integrate the findings from all the above to develop a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the enriched concepts.\n\n",
    
    "8. **System Representation Network:**\n",
    "   - Based on the identified hub genes and their associated GO terms, pathways, chea terms, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.\n",
    "     - Node1 should be the hub gene, *formatted in uppercase*.\n",
    "     - Edge should be 'associated with'. \n",
    "     - Node2 should be *a single GO term, formatted in 'Title Case'*, or a pathway name, *formatted in 'Title Case'*, or a transcription factor, *formatted in uppercase*.\n",
    "   - Check if the nodes identified above are grounded in the provided data. In the explanation column, include a note stating whether the network interaction in each row is grounded in the provided data.\n",
    "   - *Review the above network and ensure that every interaction included meets the grounding criteria and that each interaction includes only one hub gene and one GO term, pathway or transcription factor. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.\n",
    "   - Format the output within a ```tsv block, by adding ```tsv before the network content and ``` after the network content.\n",
    
    "\n\n**Example Output:**\n",
    "**1. Summary and Categorization:**\n",
    "The enriched Reactome pathways primarily involve immune response and cell signaling pathways. These can be categorized into:\n",
    "- Immune Response Pathways: 4 enriched pathways\n",
    "- Cell Signaling Pathways: 2 enriched pathways\n\n",
    
    "**2. Known Roles and Upstream Regulators:**\n",
    "The enriched immune response pathways are known to be involved in inflammation and immune cell activation. Potential upstream regulators include transcription factors such as NFKB and STAT family members, which are known to regulate immune response genes.\n\n",
    
    "**3. Interaction Networks and Similar Systems:**\n",
    "Genes within the enriched pathways show interactions related to immune cell signaling and cytokine production. Similar systems reported in the literature include studies on autoimmune diseases and inflammatory conditions.\n\n",
    
    "**4. Hub Gene Identification:**\n",
    "**Step 1: Genes enriched in multiple pathways:**\n",
    "FN1 (Focal adhesion, ECM-receptor interaction, Cytoskeleton in muscle cells, AGE-RAGE signaling pathway in diabetic complications, Amoebiasis, Small cell lung cancer)
    C1QA (Efferocytosis, Complement and coagulation cascades, Alcoholic liver disease, Chagas disease, Staphylococcus aureus infection, Coronavirus disease - COVID-19, Systemic lupus erythematosus)
    C1QB (Efferocytosis, Complement and coagulation cascades, Alcoholic liver disease, Chagas disease, Staphylococcus aureus infection, Coronavirus disease - COVID-19, Systemic lupus erythematosus).\n\n",
    
    "**Step 2: Genes enriched in GO and pathways:**\n",
    "FN1 (multiple pathways, acute inflammatory response, acute-phase response, cell recognition, etc.)
    ANK2 (multiple GO terms related to actin and cardiac muscle, pathways)
    NOS1AP (multiple GO terms related to action potential and cardiac muscle, pathways).\n\n",
    
    "**Step 3: Genes with high STRING network scores:**\n",
    "FN1 (Combined Network Score: 2.734623)
    ANKRD22 (Combined Network Score: 2.422102)
    CD274 (Combined Network Score: 2.243023).\n\n",
    
    "**Step 4: Genes in ChEA enrichment results:**\n",
    "GBP5 (RELB, SMAD4, PCGF4)
    CD274 (RELB, IRF1, SMAD4)
    LRP1B (TFAP2C, PCGF4).\n\n",
    
    "**Integrated Analysis:**\n",
    "FN1, C1QA, C1QB, C1QC, ANK2, and CD274 emerge as potential hub genes based on their presence in multiple Reactome pathways, GO terms, and high STRING network scores.  Several genes are also present in ChEA results, further supporting their central role.\n\n",
    
    "**Potential Hub Genes:**\n",
    "- **FN1:**  Enriched in multiple pathways and GO terms related to ECM, cell adhesion, and inflammation.
    - **C1QA, C1QB, C1QC:**  Core components of the complement system, enriched in multiple pathways and GO terms related to immune response.
    - **ANK2:**  Involved in actin cytoskeleton dynamics and cardiac muscle function, enriched in multiple GO terms and pathways.
    - **CD274:**  A key immune checkpoint molecule, enriched in pathways and GO terms related to T cell co-stimulation and immune regulation.\n\n",
    
    "**5. Drug Target/Marker/Kinase/Ligand Analysis:**\n",
    "- **FN1 (Fibronectin):**  Not a direct drug target, but its role in cell adhesion makes it a potential indirect target for therapies modulating inflammation.
    - **C1QA, C1QB, C1QC (Complement components):**  Not typically direct drug targets, but their involvement in complement-mediated inflammation makes them potential biomarkers.
    - **ANK2 (Ankyrin-2):**  Not a known drug target.
    - **CD274 (PD-L1):**  A well-established drug target in cancer immunotherapy; antibodies blocking its interaction with PD-1 are used clinically.\n\n",
    
    "**6. Novelty Exploration:**\n",
    "The strong enrichment of pathways related to infectious diseases (Pertussis, Coronavirus, Staphylococcus aureus, Amoebiasis, Chagas disease) in the context of uveitis is potentially novel and warrants further investigation.  While infections can trigger uveitis, the specific pathways highlighted here may reveal novel mechanisms linking infection and uveitis pathogenesis.  The unexpected connections between complement activation and infectious disease pathways could be a novel finding.\n\n",
    
    "**7. Hypothesis Generation:**\n",
    "Uveitis pathogenesis involves a complex interplay between dysregulated immune responses, primarily driven by complement activation and T cell co-stimulation, and impaired ECM remodeling.  This leads to chronic inflammation and tissue damage.  The involvement of infectious disease pathways suggests that microbial triggers or dysbiosis may contribute to the initiation or exacerbation of uveitis.  Upstream regulators like NF-kB, IRFs, AP-1, and SMAD family members likely orchestrate these processes.\n\n",
    
    "**8. System Representation Network:**\n",
    "```tsv\n",
    "Node1\tEdge\tNode2\tExplanation\n",
    "FN1\tassociated with\tCell Adhesion Molecules\tGrounded in provided data (Reactome, GO, STRING)\n",
    "FN1\tassociated with\tAcute Inflammatory Response\tGrounded in provided data (Reactome, GO, STRING)\n",
    "C1QA\tassociated with\tComplement Activation\tGrounded in provided data (Reactome, GO, STRING)\n",
    "C1QA\tassociated with\tImmune Response\tGrounded in provided data (Reactome, GO, STRING)\n",
    "ANK2\tassociated with\tActin Filament-Based Movement\tGrounded in provided data (Reactome, GO, STRING)\n",
    "CD274\tassociated with\tT Cell Costimulation\tGrounded in provided data (Reactome, GO, STRING)\n",
    "```\n\n",
    
    "\n**Note:** Please keep your response under 6100 words. Do not include anyother Note.\n\n"
  )
  return(prompt)
}


#' Create LLM Prompt for ChEA Enrichment Analysis
#'
#' Creates a prompt for a Large Language Model (LLM) to analyze ChEA (ChIP-X Enrichment Analysis) results,
#' along with other relevant data such as pathway enrichment results and STRING protein-protein interaction data.
#'
#' @param enrichment_results A data frame containing ChEA enrichment results. Must have columns "Term", "P.value", and "Genes".
#' @param analysis_type Character string specifying the type of analysis (e.g., "ChEA").
#' @param pathway_results A list containing pathway enrichment results (KEGG, WikiPathways, Reactome, GO) (optional).
#' @param string_results A list containing STRING protein-protein interaction data (optional).
#' @param gene_symbols A vector of gene symbols used in the analysis.
#' @param string_network_properties A data frame containing STRING network properties (optional).
#' @param experimental_design A character string describing the experimental design (optional).
#'
#' @return A character string containing the LLM prompt.
#'
#' @export
create_llm_prompt_chea <- function(enrichment_results, analysis_type, pathway_results = NULL, string_results = NULL, gene_symbols = NULL, string_network_properties = NULL, experimental_design = NULL) {
  if (is.null(enrichment_results) || nrow(enrichment_results) == 0) {
    return(paste0("No significant results found for ", analysis_type, " analysis."))
  }
  
  # Check for necessary columns. Handle missing columns gracefully.
  required_cols <- c("Term", "P.value", "Genes")
  missing_cols <- setdiff(required_cols, names(enrichment_results))
  if (length(missing_cols) > 0) {
    return(paste0("Error: Insufficient data for ", analysis_type, " analysis."))
  }
  
  formatted_results <- paste0(
    "**", analysis_type, " Analysis Results:**\n\n",
    paste(
      mapply(
        function(term, pvalue, genes) {
          sprintf(
            "Term: %s\nP-value: %f\nGenes: %s\n\n",
            term,
            pvalue,
            genes
          )
        },
        enrichment_results$Term,
        enrichment_results$P.value,
        enrichment_results$Genes
      ),
      collapse = ""
    )
  )
  
  pathway_text <- if (!is.null(pathway_results)) {
    pathway_text_parts <- c()
    
    if (!is.null(pathway_results$kegg) && nrow(pathway_results$kegg) > 0) {
      kegg_text <- paste0("**KEGG:**\n",
                          paste(
                            mapply(
                              function(id, description, pvalue, genes) {
                                sprintf("ID: %s, Description: %s, P-value: %f, Genes: %s", id, description, pvalue, genes)
                              },
                              pathway_results$kegg$ID,
                              pathway_results$kegg$Description,
                              pathway_results$kegg$pvalue,
                              pathway_results$kegg$Gene
                            ),
                            collapse = "\n"
                          ))
      pathway_text_parts <- c(pathway_text_parts, kegg_text)
    }
    
    if (!is.null(pathway_results$wp) && nrow(pathway_results$wp) > 0) {
      wp_text <- paste0("**WikiPathways:**\n",
                        paste(
                          mapply(
                            function(id, description, pvalue, genes) {
                              sprintf("ID: %s, Description: %s, P-value: %f, Genes: %s", id, description, pvalue, genes)
                            },
                            pathway_results$wp$ID,
                            pathway_results$wp$Description,
                            pathway_results$wp$pvalue,
                            pathway_results$wp$Gene
                          ),
                          collapse = "\n"
                        ))
      pathway_text_parts <- c(pathway_text_parts, wp_text)
    }
    
    if (!is.null(pathway_results$reactome) && nrow(pathway_results$reactome) > 0) {
      reactome_text <- paste0("**Reactome:**\n",
                              paste(
                                mapply(
                                  function(id, description, pvalue, genes) {
                                    sprintf("ID: %s, Description: %s, P-value: %f, Genes: %s", id, description, pvalue, genes)
                                  },
                                  pathway_results$reactome$ID,
                                  pathway_results$reactome$Description,
                                  pathway_results$reactome$pvalue,
                                  pathway_results$reactome$Gene
                                ),
                                collapse = "\n"
                              ))
      pathway_text_parts <- c(pathway_text_parts, reactome_text)
    }
    
    if (!is.null(pathway_results$go) && nrow(pathway_results$go) > 0) {
      go_text <- paste0("**GO:**\n",
                        paste(
                          mapply(
                            function(description, pvalue, genes) {
                              sprintf("Description: %s, P-value: %f, Genes: %s", description, pvalue, genes)
                            },
                            pathway_results$go$Description,
                            pathway_results$go$pvalue,
                            pathway_results$go$Gene
                          ),
                          collapse = "\n"
                        ))
      pathway_text_parts <- c(pathway_text_parts, go_text)
    }
    
    if (length(pathway_text_parts) > 0) {
      paste0("\n**Pathway Results:**\n", paste(pathway_text_parts, collapse = "\n"), "\n")
    } else {
      "\n**No pathway results available.**\n"
    }
  } else {
    "\n**No pathway results available.**\n"
  }
  
  string_text <- if (!is.null(string_results) && !is.null(string_results$interactions) && nrow(string_results$interactions) > 0) {
    paste0("\n**STRING Protein-Protein Interaction Data:**\n",
           paste(
             mapply(
               function(protein1, protein2, score) {
                 sprintf("Protein 1: %s, Protein 2: %s, Combined Score: %f", protein1, protein2, score)
               },
               string_results$interactions$Protein1,
               string_results$interactions$Protein2,
               string_results$interactions$combined_score
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING interactions available.**\n"
  }
  
  string_network_text <- if (!is.null(string_results) && !is.null(string_results$network_properties) && nrow(string_results$network_properties) > 0) {
    
    num_nodes <- nrow(string_results$network_properties)
    
    if (num_nodes > 100) {
      network_properties_to_use <- head(string_results$network_properties, 100)
    } else {
      network_properties_to_use <- string_results$network_properties
    }
    
    paste0("\n**STRING Network Properties Data:**\n",
           paste(
             mapply(
               function(node, score) {
                 sprintf("Node: %s, Combined Network Score: %f", node, score)
               },
               network_properties_to_use$node,
               network_properties_to_use$combined_score_prop
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING network properties available.**\n"
  }
  
  prompt_start <- paste0(
    "I have performed a transcriptomics experiment comparing two conditions and identified a list of significantly differentially expressed genes (DEGs). Below is the data from my analysis:\n\n",
    
    "**List of Differentially Expressed Genes (DEGs):**\n",
    "This is a list of gene symbols that were found to be significantly differentially expressed in my experiment.\n",
    paste(gene_symbols, collapse = ", "), "\n\n"
  )
  
  if (!is.null(experimental_design) && experimental_design != "") {
    prompt_start <- paste0(prompt_start, "**Experimental Design:**\n",
                           "The experimental design is as follows: ", experimental_design, "\n\n")
  }
  
  prompt <- paste0(
    prompt_start,
    "**", analysis_type, " Enrichment Analysis Results:**\n",
    "This section contains the results of the ", analysis_type, " enrichment analysis performed on the DEGs. It includes the transcription factor term, p-value, and the list of genes associated with each transcription factor.\n",
    formatted_results,
    
    "**Pathway Results:**\n",
    "This section contains the results of the pathway enrichment analyses performed on the DEGs. It includes the pathway ID, description, p-value, and the list of genes associated with each pathway. If a pathway is not present, the section will mention 'No pathway results available'.\n",
    pathway_text,
    
    "**STRING Protein-Protein Interaction Data:**\n",
    "This section contains the protein-protein interactions from the STRING database, based on the DEGs. It includes the interacting proteins and their combined scores.\n",
    string_text,
    
    "**STRING Network Properties Data:**\n",
    "This section contains the top 100 nodes from the STRING network, ranked by their combined network score. It includes the node and its combined network score.\n",
    string_network_text,
    
    "\n\nMy goal is to analyze the enriched transcription factors and their target genes, along with pathway enrichment and interaction data, to understand the underlying biological mechanisms of the system, identify critical genes and pathways, and explore potential regulatory elements. Perform all the analysis in the context of the experimental design, if given.\n\n",
    
    "**Analysis Instructions:**\n\n",
    
    "1. **Summary of Enriched Transcription Factors:**\n",
    "   - Provide a summary (about 4 lines) of the significantly enriched transcription factors. Consider the experimental design, if given.\n\n",
    
    "2. **Regulatory Network Analysis:**\n",
    "   - Based on the enriched transcription factors and the target genes, identify any known upstream regulators (like transcription factors, signaling pathways etc.,) that might modulate the system, as a master regulator. Please also note the target genes of these transcription factors, and the pathways these target genes are enriched in.\n\n",
    
    "3. **Novel Interactions:**\n",
    "   - Based on the enriched transcription factors and their target genes, identify any unexpected or novel transcription factor-gene interactions that has not been previously reported in the literature. Also, explore where such novel interactions are reported as known in the scientific literature.\n\n",
    
    "4. **Cross-Analysis:**\n",
    "   - Based on the target genes of these transcription factors, are there any potential connections or overlaps with pathways identified by KEGG, WikiPathways, Reactome, or GO? If so, please list the pathways and the genes they share with the target genes of these transcription factors.\n",
    "   - Are there any protein-protein interactions from STRING that support the findings of these transcription factors, based on their target genes? If so, please list the interacting proteins and their combined scores.\n",
    "   - Also, are there any important genes based on the STRING network properties that are also target genes of these transcription factors? If so, please list the genes and their combined network scores.\n\n",
    
    "5. **Hypothesis Generation:**\n",
    "   - Based on the above analysis, formulate a hypothesis regarding the roles of the enriched transcription factors and their target genes from our DEG, in driving the gene expression changes observed in our experiment. Consider potential mechanistic links between the transcription factors, their target genes, and our phenotype, in the context of all the data provided here.\n\n",
    
    "6. **System Representation Network:**\n",
    "   - Based on the enriched transcription factors and their target genes that are associated with pathways in our enriched pathway data, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.\n",
    "     - Node1 should be *a transcription factor, formatted in uppercase*.\n",
    "     - Edge should be 'associated with'. \n",
    "     - Node2 should be *a single pathway name, formatted in 'Title Case'*, or *a target gene, formatted in uppercase*. The target gene should be in the Chea enrichment data as well as in at least one of our other datasets (pathways or string).\n",
    "   - Check if the nodes identified above are grounded in the provided Chea, pathways, or string data. In the explanation column, include a note stating whether and how the 'Node1' gene is also found in the provided pathway data and/or is a Chea-enriched factor's target, and is a gene with a high combined_score_prop as seen in the network properties data.\n",
    "   - *Review the above network and ensure that every interaction included meets the grounding criteria, that each interaction includes only one transcription factor and one pathway or target gene. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.\n",
    "   - Format the output within a ```tsv block, by adding ```tsv before the network content and ``` after the network content.\n",
    
    "\n\n**Example Output:**\n",
    "**1. Summary of Enriched Transcription Factors:**\n",
    "The ChEA analysis revealed several significantly enriched transcription factors (TFs) in the differentially expressed genes (DEGs) from the uveitis versus healthy control comparison.  RELB, TFAP2C, POU5F1, and SMAD4 showed the most significant enrichment (p-values < 0.04). These TFs are known to be involved in immune responses, cell differentiation, and development, aligning with the inflammatory nature of uveitis and the use of whole blood RNA-Seq.  The enrichment of these TFs suggests a complex interplay of regulatory mechanisms underlying the observed gene expression changes in uveitis.\n\n",
    
    "**2. Regulatory Network Analysis:**\n",
    "Based on the provided data, several TFs emerge as potential upstream regulators.  RELB, a member of the NF-kB family, is strongly implicated, given its association with genes like *GBP5* and *CD274*, both involved in immune responses.  These genes are also enriched in pathways related to interferon signaling (Reactome, GO), complement activation (Reactome, WikiPathways, GO), and cell adhesion molecules (KEGG).  SMAD4, a key component of the TGF-b signaling pathway, also shows significant enrichment and regulates genes involved in focal adhesion, ECM-receptor interaction, and cytoskeleton organization (KEGG, WikiPathways, Reactome).  The overlap of RELB and SMAD4 target genes in pathways like ECM-receptor interaction and cell adhesion molecules suggests a potential coordinated regulatory mechanism.  TFAP2C, involved in cell differentiation and development, and POU5F1, a pluripotency factor, may play more subtle roles, potentially influencing the overall cellular context of the immune response.\n\n",
    
    "**3. Novel Interactions:**\n",
    "Identifying truly *novel* interactions requires extensive literature review beyond the scope of this analysis.  However, some interactions warrant further investigation. For example, the association of TFAP2C with genes like *KCNK17* (potassium channel) and *NOS1AP* (nitric oxide synthase adaptor protein) in the context of uveitis requires further exploration.  Similarly, the involvement of POU5F1, typically associated with pluripotency, in regulating genes like *ROR1* (receptor tyrosine kinase) in this inflammatory context is intriguing and needs further investigation to determine if this is a novel finding or a previously underappreciated role of POU5F1 in immune-related processes.  The literature should be consulted to determine if these interactions have been previously reported in the context of uveitis or similar inflammatory conditions.\n\n",
    
    "**4. Cross-Analysis:**\n",
    "Several cross-analyses reveal strong connections between the TF target genes and the enriched pathways:\n",
    "* **Complement System:** RELB, TFAP2C, and PCGF4 target genes (*C1QA, C1QB, C1QC, C4BPA*) are heavily enriched in KEGG, WikiPathways, and Reactome pathways related to complement activation and coagulation cascades.  This is strongly supported by STRING interactions showing high combined scores between these complement components.\n",
    "* **Cell Adhesion and ECM:** SMAD4 and TFAP2C target genes (*FN1, COL4A3, COL4A4, PARVA*) are significantly enriched in KEGG and Reactome pathways related to focal adhesion, ECM-receptor interaction, and collagen biosynthesis.  STRING interactions confirm strong associations between *COL4A3* and *COL4A4*, and between *FN1* and several other genes in this group.  *FN1* also has a high combined network score in the STRING network properties data.\n",
    "* **Immune Response:** RELB and IRF1 target genes (*GBP1, GBP5, GBP6, CD274, PDCD1LG2*) are enriched in Reactome and GO pathways related to interferon signaling and T cell costimulation.  STRING interactions show strong associations between *CD274* and *PDCD1LG2*, and between various *GBP* genes.  *CD274* also has a high combined network score in the STRING network properties data.\n",
    "* **STRING Network Properties:**  Several genes with high combined network scores in the STRING network properties data are also target genes of the enriched TFs.  These include *FN1*, *ANKRD22*, *CD274*, and *C1QC*, all of which are involved in the pathways mentioned above.\n\n",
    
    "**5. Hypothesis Generation:**\n",
    "Based on the integrated analysis, we hypothesize that the observed gene expression changes in uveitis patients compared to healthy controls are driven by a complex interplay of enriched transcription factors, primarily RELB and SMAD4.  RELB, through its regulation of genes involved in the complement system and interferon signaling, contributes to the inflammatory response characteristic of uveitis.  SMAD4, by regulating genes involved in cell adhesion and ECM remodeling, may influence the tissue architecture and immune cell infiltration in the affected tissues.  The involvement of TFAP2C and POU5F1 suggests a broader impact on cell differentiation and the overall cellular context of the immune response.  The strong enrichment of pathways related to complement activation, cell adhesion, and immune responses further supports this hypothesis.  The observed interactions between these TFs and their target genes, supported by STRING data, suggest a coordinated regulatory network contributing to the pathogenesis of uveitis.\n\n",
    
    "**6. System Representation Network:**\n",
    "```tsv\n",
    "Node1\tEdge\tNode2\tExplanation\n",
    "RELB\tassociated with\tComplement And Coagulation Cascades\tGrounded: RELB targets GBP5 and CD274, both present in this pathway.\n",
    "RELB\tassociated with\tInterferon Signaling\tGrounded: RELB targets GBP5 and CD274, both present in this pathway.\n",
    "RELB\tassociated with\tGBP5\tGrounded: RELB directly targets GBP5.\n",
    "RELB\tassociated with\tCD274\tGrounded: RELB directly targets CD274.\n",
    "SMAD4\tassociated with\tFocal Adhesion\tGrounded: SMAD4 targets FN1, present in this pathway.\n",
    "SMAD4\tassociated with\tECM-Receptor Interaction\tGrounded: SMAD4 targets FN1, present in this pathway.\n",
    "SMAD4\tassociated with\tFN1\tGrounded: SMAD4 directly targets FN1.\n",
    "TFAP2C\tassociated with\tCell Adhesion Molecules\tGrounded: TFAP2C targets NRCAM, present in this pathway.\n",
    "TFAP2C\tassociated with\tNRCAM\tGrounded: TFAP2C directly targets NRCAM.\n",
    "```\n\n",
    
    "\n\n**Note:** Please keep your response under 6100 words. Do not include anyother Note.\n\n"
  )
  
  return(prompt)
}


#' Create LLM Prompt for GO Enrichment Analysis
#'
#' Creates a prompt for a Large Language Model (LLM) to analyze Gene Ontology (GO) enrichment results,
#' along with other relevant data such as ChEA transcription factor enrichment and STRING protein-protein interaction data.
#'
#' @param enrichment_results A data frame containing GO enrichment results. Must have columns "Description", "pvalue", and "Gene".
#' @param analysis_type Character string specifying the type of analysis (e.g., "GO").
#' @param chea_results A data frame containing ChEA transcription factor enrichment results (optional).
#' @param string_results A list containing STRING protein-protein interaction data (optional).
#' @param gene_symbols A vector of gene symbols used in the analysis.
#' @param string_network_properties A data frame containing STRING network properties (optional).
#' @param experimental_design A character string describing the experimental design (optional).
#'
#' @return A character string containing the LLM prompt.
#'
#' @export
create_llm_prompt_go <- function(enrichment_results, analysis_type, chea_results = NULL, string_results = NULL, gene_symbols = NULL, string_network_properties = NULL, experimental_design = NULL) {
  if (is.null(enrichment_results) || nrow(enrichment_results) == 0) {
    return(paste0("No significant results found for ", analysis_type, " analysis."))
  }
  
  # Check for necessary columns. Handle missing columns gracefully.
  required_cols <- c("Description", "pvalue", "Gene")
  missing_cols <- setdiff(required_cols, names(enrichment_results))
  if (length(missing_cols) > 0) {
    return(paste0("Error: Insufficient data for ", analysis_type, " analysis."))
  }
  
  formatted_results <- paste0(
    "**", analysis_type, " Analysis Results:**\n\n",
    paste(
      sprintf(
        "Description: %s\nP-value: %f\nGenes: %s\n\n",
        enrichment_results$Description,
        enrichment_results$pvalue,
        enrichment_results$Gene
      ),
      collapse = ""
    )
  )
  
  chea_text <- if (!is.null(chea_results) && nrow(chea_results) > 0) {
    paste0("\n**ChEA Transcription Factor Enrichment Results:**\n",
           paste(
             mapply(
               function(term, pvalue, genes) {
                 sprintf("Term: %s, P-value: %f, Genes: %s", term, pvalue, genes)
               },
               chea_results$Term,
               chea_results$P.value,
               chea_results$Genes
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No ChEA results available.**\n"
  }
  
  string_text <- if (!is.null(string_results) && !is.null(string_results$interactions) && nrow(string_results$interactions) > 0) {
    paste0("\n**STRING Protein-Protein Interaction Data:**\n",
           paste(
             mapply(
               function(protein1, protein2, score) {
                 sprintf("Protein 1: %s, Protein 2: %s, Combined Score: %f", protein1, protein2, score)
               },
               string_results$interactions$Protein1,
               string_results$interactions$Protein2,
               string_results$interactions$combined_score
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING interactions available.**\n"
  }
  
  string_network_text <- if (!is.null(string_results) && !is.null(string_results$network_properties) && nrow(string_results$network_properties) > 0) {
    
    num_nodes <- nrow(string_results$network_properties)
    
    if (num_nodes > 100) {
      network_properties_to_use <- head(string_results$network_properties, 100)
    } else {
      network_properties_to_use <- string_results$network_properties
    }
    
    paste0("\n**STRING Network Properties Data:**\n",
           paste(
             mapply(
               function(node, score) {
                 sprintf("Node: %s, Combined Network Score: %f", node, score)
               },
               network_properties_to_use$node,
               network_properties_to_use$combined_score_prop
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No STRING network properties available.**\n"
  }
  
  prompt_start <- paste0(
    "I have performed a transcriptomics experiment comparing two conditions and identified a list of significantly differentially expressed genes (DEGs). Below is the data from my analysis:\n\n",
    
    "**List of Differentially Expressed Genes (DEGs):**\n",
    "This is a list of gene symbols that were found to be significantly differentially expressed in my experiment.\n",
    paste(gene_symbols, collapse = ", "), "\n\n"
  )
  
  if (!is.null(experimental_design) && experimental_design != "") {
    prompt_start <- paste0(prompt_start, "**Experimental Design:**\n",
                           "The experimental design is as follows: ", experimental_design, "\n\n")
  }
  
  prompt <- paste0(
    prompt_start,
    "**", analysis_type, " Enrichment Analysis Results:**\n",
    "This section contains the results of the ", analysis_type, " enrichment analysis performed on the DEGs. It includes the GO term description, p-value, and the list of genes associated with each GO term.\n",
    formatted_results,
    
    "**ChEA Transcription Factor Enrichment Results:**\n",
    "This section contains the results of the ChEA transcription factor enrichment analysis performed on the DEGs. It includes the transcription factor term, p-value, and the list of genes associated with each transcription factor.\n",
    chea_text,
    
    "**STRING Protein-Protein Interaction Data:**\n",
    "This section contains the protein-protein interactions from the STRING database, based on the DEGs. It includes the interacting proteins and their combined scores.\n",
    string_text,
    
    "**STRING Network Properties Data:**\n",
    "This section contains the top 100 nodes from the STRING network, ranked by their combined network score. It includes the node and its combined network score.\n",
    string_network_text,
    
    "\n\nMy goal is to analyze these enriched GO terms and their respective genes, along with transcription factor enrichment and interaction data, to understand the underlying biological mechanisms of the system, identify critical genes and pathways, and explore potential regulatory elements. Perform all the analysis in the context of the experimental design, if given.\n\n",
    
    "**Analysis Instructions:**\n\n",
    
    "1. **Summary and Categorization:**\n",
    "   - Provide a one-paragraph summary (about 4 lines) of the significantly enriched GO terms. Consider the experimental design, if given.\n",
    "   - Categorize the enriched GO terms into broad functional groups and count the number of enriched concepts in each category. *Include only the top 4 categories*.\n\n",
    
    "2. **Known Roles and Upstream Regulators:**\n",
    "   - Provide a concise summary (about 4 lines) of the enriched GO terms with their known roles in the context of our experiment, based on the current scientific literature.\n",
    "   - Based on the genes contributing to the enriched GO terms, predict potential upstream regulators (transcription factors, kinases etc.,) that could be driving this phenotype. Provide a list of potential candidates with supporting reasoning.\n\n",
    
    "3. **Interaction Networks and Similar Systems:**\n",
    "   - Based on the genes involved in the enriched GO terms and also found in the string data, suggest possible interactions or relationships between the enriched GO term genes. Mention any known protein-protein interactions, regulatory relationships or shared functional roles.\n",
    "   - Based on the enriched GO terms and the genes involved, explore if there are other systems similar to our study, reported in the scientific literature, that might be of interest.\n\n",
    
    "4. **Cross-Analysis:**\n",
    "   - Based on the genes involved in these GO terms, are there any potential connections or overlaps with transcription factors that might regulate these genes, as identified by ChEA analysis? If so, please list the transcription factors and the genes they regulate that are also in these GO terms.\n",
    "   - Are there any protein-protein interactions from STRING that support the findings of these GO terms, based on the genes involved? If so, please list the interacting proteins and their combined scores.\n",
    "   - Also, are there any important genes based on the STRING network properties that are also in these GO terms? If so, please list the genes and their combined network scores.\n\n",
    
    "5.  **Hypothesis Generation:**\n",
    "   - Integrate the findings from all the above to develop a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the enriched concepts.\n\n",
    
    "6. **System Representation Network:**\n",
    "   - Based on the enriched GO terms, their associated genes, and the provided ChEA and STRING data, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.\n",
    "     - Node1 should be *a gene enriched in a GO term, formatted in uppercase*.\n",
    "     - Edge should be 'associated with'. \n",
    "     - Node2 should be *a single GO term, formatted in 'Title Case'*.\n",
    "   - Check if the nodes identified above are grounded in the provided data. In the 'Explanation' column, include a note stating whether and how the 'Node1' gene is also found in the provided ChEA and/or STRING data (mention if it's a target of a TF from ChEA or if it has STRING interactions or a high network score). *If the gene is not present in ChEA or STRING data, the row should be removed from the network.*\n",
    "   - *Review the above network and ensure that every interaction included meets the grounding criteria, that each interaction includes only one gene and one GO term, and that any gene included in the network is also present in the provided Chea or string data. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.\n",
    "   - Format the output within a ```tsv block, by adding ```tsv before the network content and ``` after the network content.\n",
    
    "\n\n**Example Output:**\n",
    "**1. Summary and Categorization:**\n",
    "The significantly enriched GO terms reveal a strong dysregulation of the immune system in uveitis patients compared to healthy controls.  Specifically, numerous GO terms related to B cell and T cell mediated immunity, complement activation, and acute inflammatory responses are highly enriched.  This suggests a complex interplay of humoral and cellular immune responses contributing to the pathogenesis of uveitis.\n\n",
    
    "**Categorization of Enriched GO Terms:**\n",
    "- **Immune Response:**  20 terms\n",
    "- **Cell Movement and Contraction (actin-based):** 7 terms\n",
    
    "**2. Known Roles and Upstream Regulators:**\n",
    "The enriched GO terms strongly implicate immune dysregulation in uveitis.  B cell and T cell mediated immunity, complement activation, and acute inflammatory responses are all hallmarks of inflammatory diseases.  The involvement of the complement system suggests a potential role for innate immunity in the disease process.  The enrichment of terms related to cell movement and contraction hints at potential involvement of immune cell migration and tissue remodeling.\n\n",
    
    "**Potential Upstream Regulators:**\n",
    "Based on the genes involved in the enriched GO terms, several transcription factors and other potential upstream regulators emerge as candidates:\n",
    "* **RELB:**  This transcription factor is implicated in inflammation and is enriched in the ChEA analysis, regulating *GBP5*, *CD274*, *MMP19*, and *GPR84*, all of which are involved in immune responses.\n",
    "* **SMAD4:** This transcription factor, involved in TGF-b signaling, is also enriched in the ChEA analysis and regulates several genes involved in immune response, cell morphogenesis, and cell contraction.\n",
    
    "**3. Interaction Networks and Similar Systems:**\n",
    "The STRING data reveals numerous interactions between the genes involved in the enriched GO terms.  For example, the complement components (C1QA, C1QB, C1QC) show strong interactions, as expected.  Several interactions are observed between genes involved in immune response (e.g., *FCGR1A*, *CD274*, *PDCD1LG2*, *GBP1*, *GBP5*, *GBP6*), indicating a coordinated response.  Interactions are also observed between genes involved in cell movement and contraction (*ANK2*, *NOS1AP*, *FGF13*, *PARVA*), suggesting a functional relationship.  The high scores for interactions between Y-chromosome genes (e.g., *UTY*, *KDM5D*, *USP9Y*, *DDX3Y*) suggest a potential sex-specific component to the disease.\n\n",
    "Similar systems reported in the literature include other inflammatory eye diseases, such as age-related macular degeneration and multiple sclerosis, which also show dysregulation of immune responses and complement activation.  Studies on these diseases could provide valuable insights into the mechanisms underlying uveitis.\n\n",
    
    "**4. Cross-Analysis:**\n",
    "**ChEA and GO Term Overlap:**\n",
    "* **RELB:** Regulates *GBP5*, *CD274*, *MMP19*, and *GPR84*, all involved in multiple immune response GO terms.\n",
    "* **PCGF4:** Regulates *GBP6*, *C1QB*, *GBP5*, *C1QA*, *C4BPA*, *CACNA1E*, *LRP1B*, *GDF7*, *FHAD1*, *COL4A4*, *LYPD6B*, *ROR1*, *OTX1*, *FCGR1A*, *GBP1*, *ATF3*, and *C1QC*, involved in immune response, cell morphogenesis, and cell contraction GO terms.\n\n",
    
    "**STRING and GO Term Overlap:**\n",
    "Numerous STRING interactions support the GO term enrichments.  High-scoring interactions are observed between complement components (C1QA, C1QB, C1QC), genes involved in immune response (*FCGR1A*, *CD274*, *PDCD1LG2*, *GBP1*, *GBP5*, *GBP6*), and genes involved in cell movement and contraction (*ANK2*, *NOS1AP*, *FGF13*, *PARVA*).  See the STRING data for specific interactions and scores.\n\n",
    
    "**STRING Network Properties and GO Term Overlap:**\n",
    "* **FN1:** Combined Network Score: 2.734623 (involved in multiple GO terms related to immune response, cell morphogenesis, and cell adhesion).\n",
    "* **ANKRD22:** Combined Network Score: 2.422102 (involved in immune response and cell morphology GO terms).\n",
    "* **CD274:** Combined Network Score: 2.243023 (involved in T cell costimulation and multiple immune response GO terms).\n",
    "* **SERPING1:** Combined Network Score: 1.537007 (involved in complement activation and multiple immune response GO terms).\n\n",
    
    "**5. Hypothesis Generation:**\n",
    "Uveitis in this cohort is characterized by a complex interplay of dysregulated immune responses.  The significant enrichment of GO terms related to B cell and T cell mediated immunity, complement activation, and acute inflammatory responses suggests a multi-faceted inflammatory process.  Upstream regulators such as RELB, SMAD4, TFAP2C, POU5F1, IRF1, and PCGF4, identified through ChEA analysis, likely play crucial roles in orchestrating this response.  The STRING data reveals extensive interactions between the genes involved in these pathways, highlighting the coordinated nature of the immune dysregulation.  The high network scores for genes like *FN1*, *ANKRD22*, *CD274*, and *FCGR1A* further emphasize their importance in the disease process.  The presence of Y-chromosome genes suggests a potential sex-specific component.  Further investigation into these interactions and regulatory elements is warranted to fully elucidate the molecular mechanisms underlying uveitis pathogenesis.\n\n",
    
    "**6. System Representation Network:**\n",
    "```tsv\n",
    "Node1\tEdge\tNode2\tExplanation\n",
    "C1QA\tassociated with\tComplement Activation\tPresent in ChEA (PCGF4 target) and STRING (high network score)\n",
    "C1QB\tassociated with\tComplement Activation\tPresent in ChEA (PCGF4 target) and STRING (high network score)\n",
    "FCGR1A\tassociated with\tImmune Response\tPresent in ChEA (PCGF4 target) and STRING (high network score)\n",
    "```\n\n",
    
    "\n\n**Note:** Please keep your response under 6100 words. Do not include any other Note.\n\n"
  )
  return(prompt)
}


#' Create LLM Prompt for STRING Interaction Analysis
#'
#' Creates a prompt for a Large Language Model (LLM) to analyze STRING protein-protein interaction data,
#' along with other relevant data such as pathway enrichment results and ChEA transcription factor enrichment.
#'
#' @param interaction_results A list containing STRING interaction results. Must have elements `interactions` (data frame of interactions) and `network_properties` (data frame of network properties).
#' @param analysis_type Character string specifying the type of analysis (e.g., "STRING").
#' @param pathway_results A list containing pathway enrichment results (KEGG, WikiPathways, Reactome, GO) (optional).
#' @param chea_results A data frame containing ChEA transcription factor enrichment results (optional).
#' @param gene_symbols A vector of gene symbols used in the analysis.
#' @param string_network_properties A data frame containing STRING network properties (optional).
#' @param experimental_design A character string describing the experimental design (optional).
#'
#' @return A character string containing the LLM prompt.
#'
#' @export
create_llm_prompt_string <- function(interaction_results, analysis_type, pathway_results = NULL, chea_results = NULL, gene_symbols = NULL, string_network_properties = NULL, experimental_design = NULL) {
  if (is.null(interaction_results) || is.null(interaction_results$interactions) || nrow(interaction_results$interactions) == 0) {
    return(paste0("No significant results found for ", analysis_type, " analysis."))
  }
  
  formatted_results <- paste0(
    "**", analysis_type, " Analysis Results:**\n\n",
    paste(
      sprintf(
        "Protein 1: %s\nProtein 2: %s\nCombined Score: %f\n\n",
        interaction_results$interactions$Protein1,
        interaction_results$interactions$Protein2,
        interaction_results$interactions$combined_score
      ),
      collapse = ""
    )
  )
  
  # Add network properties to the prompt if available
  network_properties_text <- ""
  if (!is.null(interaction_results$network_properties) && nrow(interaction_results$network_properties) > 0) {
    
    formatted_network_properties <- paste0(
      "**Network Properties:**\n\n",
      paste(
        sprintf(
          "Node: %s\nCombined Network Score: %f\n\n",
          interaction_results$network_properties$node,
          interaction_results$network_properties$combined_score_prop
        ),
        collapse = ""
      )
    )
    
    network_properties_text <- paste0("\n\n**Network Properties:**\n\n",formatted_network_properties)
  } else {
    network_properties_text <- "\n\n**No Network Properties Available**\n\n"
  }
  
  pathway_text <- if (!is.null(pathway_results)) {
    pathway_text_parts <- c()
    
    if (!is.null(pathway_results$kegg) && nrow(pathway_results$kegg) > 0) {
      kegg_text <- paste0("**KEGG:**\n",
                          paste(
                            mapply(
                              function(id, description, pvalue, genes) {
                                sprintf("ID: %s, Description: %s, P-value: %f, Genes: %s", id, description, pvalue, genes)
                              },
                              pathway_results$kegg$ID,
                              pathway_results$kegg$Description,
                              pathway_results$kegg$pvalue,
                              pathway_results$kegg$Gene
                            ),
                            collapse = "\n"
                          ))
      pathway_text_parts <- c(pathway_text_parts, kegg_text)
    }
    
    if (!is.null(pathway_results$wp) && nrow(pathway_results$wp) > 0) {
      wp_text <- paste0("**WikiPathways:**\n",
                        paste(
                          mapply(
                            function(id, description, pvalue, genes) {
                              sprintf("ID: %s, Description: %s, P-value: %f, Genes: %s", id, description, pvalue, genes)
                            },
                            pathway_results$wp$ID,
                            pathway_results$wp$Description,
                            pathway_results$wp$pvalue,
                            pathway_results$wp$Gene
                          ),
                          collapse = "\n"
                        ))
      pathway_text_parts <- c(pathway_text_parts, wp_text)
    }
    
    if (!is.null(pathway_results$reactome) && nrow(pathway_results$reactome) > 0) {
      reactome_text <- paste0("**Reactome:**\n",
                              paste(
                                mapply(
                                  function(id, description, pvalue, genes) {
                                    sprintf("ID: %s, Description: %s, P-value: %f, Genes: %s", id, description, pvalue, genes)
                                  },
                                  pathway_results$reactome$ID,
                                  pathway_results$reactome$Description,
                                  pathway_results$reactome$pvalue,
                                  pathway_results$reactome$Gene
                                ),
                                collapse = "\n"
                              ))
      pathway_text_parts <- c(pathway_text_parts, reactome_text)
    }
    
    if (!is.null(pathway_results$go) && nrow(pathway_results$go) > 0) {
      go_text <- paste0("**GO:**\n",
                        paste(
                          mapply(
                            function(description, pvalue, genes) {
                              sprintf("Description: %s, P-value: %f, Genes: %s", description, pvalue, genes)
                            },
                            pathway_results$go$Description,
                            pathway_results$go$pvalue,
                            pathway_results$go$Gene
                          ),
                          collapse = "\n"
                        ))
      pathway_text_parts <- c(pathway_text_parts, go_text)
    }
    
    if (length(pathway_text_parts) > 0) {
      paste0("\n**Pathway Results:**\n", paste(pathway_text_parts, collapse = "\n"), "\n")
    } else {
      "\n**No pathway results available.**\n"
    }
  } else {
    "\n**No pathway results available.**\n"
  }
  
  chea_text <- if (!is.null(chea_results) && nrow(chea_results) > 0) {
    paste0("\n**ChEA Transcription Factor Enrichment Results:**\n",
           paste(
             mapply(
               function(term, pvalue, genes) {
                 sprintf("Term: %s, P-value: %f, Genes: %s", term, pvalue, genes)
               },
               chea_results$Term,
               chea_results$P.value,
               chea_results$Genes
             ),
             collapse = "\n"
           ), "\n")
  } else {
    "\n**No ChEA results available.**\n"
  }
  
  prompt_start <- paste0(
    "I have performed a transcriptomics experiment comparing two conditions and identified a list of significantly differentially expressed genes (DEGs). Below is the data from my analysis:\n\n",
    
    "**List of Differentially Expressed Genes (DEGs):**\n",
    "This is a list of gene symbols that were found to be significantly differentially expressed in my experiment.\n",
    paste(gene_symbols, collapse = ", "), "\n\n"
  )
  
  if (!is.null(experimental_design) && experimental_design != "") {
    prompt_start <- paste0(prompt_start, "**Experimental Design:**\n",
                           "The experimental design is as follows: ", experimental_design, "\n\n")
  }
  
  prompt <- paste0(
    prompt_start,
    "**", analysis_type, " Analysis Results:**\n",
    "This section contains the protein-protein interaction data from the STRING database, based on the DEGs. It includes the interacting proteins and their combined scores.\n",
    formatted_results,
    
    "**Network Properties:**\n",
    "This section contains the network properties data from the STRING database, based on the DEGs. It includes the nodes and their combined network scores.\n",
    network_properties_text,
    
    "**Pathway Results:**\n",
    "This section contains the results of the pathway enrichment analyses performed on the DEGs. It includes the pathway ID, description, p-value, and the list of genes associated with each pathway. If a pathway is not present, the section will mention 'No pathway results available'.\n",
    pathway_text,
    
    "**ChEA Transcription Factor Enrichment Results:**\n",
    "This section contains the results of the ChEA transcription factor enrichment analysis performed on the DEGs. It includes the transcription factor term, p-value, and the list of genes associated with each transcription factor.\n",
    chea_text,
    
    "\n\nMy goal is to analyze these protein-protein interactions and their network properties, along with pathway enrichment and transcription factor enrichment data, to understand the underlying biological mechanisms of the system, identify critical genes and pathways, and explore potential regulatory elements. Perform all the analysis in the context of the experimental design, if given.\n\n",
    
    "**Analysis Instructions:**\n\n",
    
    "1.  **Summary of Interactions:**\n",
    "   - Provide a one-paragraph summary (about 4 lines) of the genes with the high network properties based combined_score_prop, in the context of their other interacting partners. Consider the experimental design, if given. \n\n",
    
    "2. **Key Interactions and Network Topology:**\n",
    "   - Identify the most significant genes, and their interacting partners, using the network properties based combined_score_prop, and the provided interactions data. Explain the biological relevance of these interactions in the context of our experiment and the properties based combined_score_prop.\n",
    "   - Describe the overall structure of the interaction network, in the context of the properties based combined_score_prop and the provided interactions data. Are there any hub proteins or clusters of highly interconnected proteins, with large combined_score_prop based on their network properties? What does this suggest about the system's organization?\n\n",
    
    "3. **Functional Implications and Upstream Regulators:**\n",
    "   - Based on the known functions of the genes with high network properties based combined_score_prop, and their interacting partners, what are the potential functional implications of these interactions? How might these interactions contribute to the observed phenotype?\n",
    "   - Based on the interaction network, in the context of the network properties based combined_score_prop, predict potential upstream regulators (transcription factors, kinases etc.,) that could be driving this phenotype. Provide a list of potential candidates with supporting reasoning.\n\n",
    
    "4. **Cross-Analysis:**\n",
    "   - Based on the proteins with large combined_score_prop, and their interacting partners, are there any potential connections or overlaps with pathways identified by KEGG, WikiPathways, Reactome or GO? If so, please list the pathways and the genes they share with the interacting proteins.\n",
    "   - Are there any transcription factors from ChEA that might regulate these proteins with large combined_score_prop and their interacting partners? If so, please list the transcription factors and the genes they regulate that are also in these interacting proteins.\n\n",
    
    "5.  **Hypothesis Generation:**\n",
    "   - Integrate the findings from all the above to develop a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the interacting proteins, in the context of the network properties based combined_score_prop, their regulatory elements and their enriched pathways.\n\n",
    
    "6. **System Representation Network:**\n",
    "   - Based on the identified genes with high combined_score_prop, and the interacting proteins, and their associated pathways or associated chea factors, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.\n",
    "     - Node1 should be *a gene with high combined network score, based on the network properties data, formatted in uppercase*.\n",
    "     - Edge should be 'associated with'. \n",
    "     - Node2 should be *a single pathway name or ontology term, formatted in 'Title Case'*, or a transcription factor, *formatted in uppercase*.\n",
    "   - Check if the nodes identified above are grounded in the provided data. In the 'Explanation' column, include a note stating whether and how the 'Node1' gene is also present in the provided pathway data and/or is a Chea-enriched factor's target, and is a gene with a high combined_score_prop as seen in the network properties data.\n",
    "   - *Review the above network and ensure that every interaction included meets the grounding criteria, that each interaction includes only one gene and one pathway, GO term, or transcription factor. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.\n",
    "   - Format the output within a ```tsv block, by adding ```tsv before the network content and ``` after the network content.\n",
    
    "\n\n**Example Output:**\n",
    "**1. Summary of Interactions:**\n",
    "The STRING analysis reveals a highly interconnected network of proteins, predominantly centered around the complement system (C1QA, C1QB, C1QC) and immune response genes (CD274, PDCD1LG2, FCGR1A).  These interactions, particularly the high scores, suggest a complex interplay between immune response, complement activation, and extracellular matrix dynamics in uveitis.\n\n",
    
    "**2. Key Interactions and Network Topology:**\n",
    "Based on the combined network scores from STRING, FN1, ANKRD22, CD274, and FCGR1A stand out as key proteins.  FN1 interacts with numerous proteins, including MYOM2, indicating involvement in cytoskeletal remodeling. ANKRD22 interacts with several immune-related proteins (e.g., CD274, GBP5, IFI27, APOL4), suggesting a role in immune regulation. The network exhibits a scale-free topology, with a few hub proteins (FN1, ANKRD22, CD274, FCGR1A) connected to many other proteins, and many proteins with fewer connections. This suggests a modular organization, where distinct functional modules interact to contribute to the overall phenotype.\n\n",
    
    "**3. Functional Implications and Upstream Regulators:**\n",
    "The high network scores and interactions suggest several functional implications. FN1's involvement in extracellular matrix (ECM) remodeling points to alterations in tissue structure and inflammation. ANKRD22's interactions with immune-related proteins suggest a role in modulating immune responses. CD274 and PDCD1LG2's interaction highlights the importance of immune checkpoint regulation in uveitis. FCGR1A's interactions with complement components and other immune genes suggest a role in immune cell activation and inflammation.\n\n",
    "Potential upstream regulators could include transcription factors involved in immune response (e.g., RELB, IRF1, SMAD4, TFAP2C) and those involved in development and cell differentiation (e.g., POU5F1). RELB's association with several immune-related genes (GBP5, CD274, MMP19, GPR84) suggests a role in inflammatory responses.  SMAD4's involvement in multiple pathways (ECM, immune response) suggests a broader regulatory role. TFAP2C's association with genes involved in immune regulation and cell signaling suggests a role in coordinating these processes.\n\n",
    
    "**4. Cross-Analysis:**\n",
    "Several connections exist between the high-scoring proteins and the enriched pathways.  FN1, COL4A3, and COL4A4 are present in multiple pathways related to ECM-receptor interaction, focal adhesion, and collagen biosynthesis.  C1QA, C1QB, and C1QC are central to complement activation pathways.  CD274 and PDCD1LG2 are key players in immune checkpoint pathways. \n\n",
    "Several ChEA transcription factors regulate genes involved in these interactions.  RELB regulates GBP5 and CD274, both involved in immune responses. SMAD4 regulates FN1, ANK2, and ETV7, all involved in ECM remodeling and immune regulation.  TFAP2C regulates several genes involved in immune regulation and cell signaling.  POU5F1 regulates genes involved in development and cell differentiation.  These transcription factors could be acting as upstream regulators of the observed interactions.\n\n",
    
    "**5. Hypothesis Generation:**\n",
    "Uveitis pathogenesis in this cohort involves a complex interplay between immune dysregulation, complement activation, and extracellular matrix remodeling.  The Y-chromosome gene cluster suggests sex-specific influences on these processes.  Upstream regulators, such as RELB, SMAD4, TFAP2C, and POU5F1, likely coordinate the expression of key genes involved in these pathways.\n\n",
    
    "**6. System Representation Network:**\n",
    "```tsv\n",
    "Node1\tEdge\tNode2\tExplanation\n",
    "FN1\tassociated with\tFocal Adhesion\tFN1 is present in the Focal Adhesion pathway and has a high combined network score (2.734623).\n",
    "FN1\tassociated with\tECM-Receptor Interaction\tFN1 is present in the ECM-Receptor Interaction pathway and has a high combined network score (2.734623).\n",
    "FN1\tassociated with\tCollagen Biosynthesis and Modifying Enzymes\tFN1 is present in the Collagen Biosynthesis and Modifying Enzymes pathway and has a high combined network score (2.734623).\n",
    "ANKRD22\tassociated with\tMyeloid Leukocyte Activation\tANKRD22 is present in the Myeloid Leukocyte Activation pathway and has a high combined network score (2.422102).\n",
    "CD274\tassociated with\tT Cell Costimulation\tCD274 is present in the T Cell Costimulation pathway and has a high combined network score (2.243023).\n",
    "```\n\n",
    
    "\n\n**Note:** Please keep your response under 6100 words. Do not include anyother Note.\n\n"
  )
  return(prompt)
}

