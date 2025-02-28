# Function Parameters in the IAN Package: Intelligent Analysis of Omics Data for Discovery

This document details the parameters used in each function within the IAN R package.

## 1. `IAN` Function

*   **`experimental_design`:** `Character string`. A description of the experimental design (optional, default is `NULL`).
*   **`deseq_results`:** `Data frame`. A data frame containing DESeq2 results (required if `input_type` is `"deseq"`).
*   **`markeringroup`:** `Data frame`. A data frame containing marker genes (required if `input_type` is `"findmarker"`, default is `NULL`).
*   **`deg_file`:** `Character string`. Path to a file containing differentially expressed genes (required if `input_type` is `"custom"`, default is `NULL`).
*   **`gene_type`:** `Character string`. Specifies the gene identifier type in the input data. Must be one of `"ENSEMBL"`, `"ENTREZID"`, or `"SYMBOL"` (required if `input_type` is `"deseq"`, `"findmarker"`, or `"custom"`, default is `NULL`).
*   **`organism`:** `Character string`. Specifies the organism. Must be `"human"` or `"mouse"` (required if `input_type` is `"deseq"`, `"findmarker"`, or `"custom"`, default is `NULL`).
*   **`input_type`:** `Character string`. Specifies the input type. Must be one of `"findmarker"`, `"deseq"`, or `"custom"` (default is `NULL`).
*   **`pvalue`:** `Numeric`. Specifies the p-value threshold for filtering results. Default is `0.05`.
*   **`ont`:** `Character string`. Specifies the GO ontology to use. Must be one of `"BP"` (biological process), `"CC"` (cellular component), or `"MF"` (molecular function). Default is `"BP"`.
*   **`score_threshold`:** `Numeric`. Specifies the minimum combined score for STRING interactions. Default is `0`.
*   **`output_dir`:** `Character string`. Specifies the directory to save the results to. Default is `"enrichment_results"`.
*   **`model`:** `Character string`. Specifies the Gemini model to use. Default is `"gemini-1.5-flash-latest"`.
*   **`temperature`:** `Numeric`. Controls the randomness of the LLM response. Default is `0`.
*   **`api_key_file`:** `Character string`. Specifies the path to the file containing the Gemini API key (default is `NULL`).

## 2. `map_gene_ids` Function

*   **`input_type`:** `Character string`. Specifies the input type. Must be one of `"findmarker"`, `"deseq"`, or `"custom"`.
*   **`markers`:** `Data frame`. A data frame containing marker genes (required if `input_type` is `"findmarker"`).
*   **`deg_file`:** `Character string`. Path to a file containing differentially expressed genes (required if `input_type` is `"custom"`).
*   **`organism`:** `Character string`. Specifies the organism. Must be `"human"` or `"mouse"`.
*   **`gene_type`:** `Character string`. Specifies the gene identifier type in the input data. Must be one of `"ENSEMBL"`, `"ENTREZID"`, or `"SYMBOL"`.
*   **`pvalue`:** `Numeric`. Specifies the p-value threshold for filtering marker genes (used if `input_type` is `"findmarker"`). Default is `0.05`.
*   **`log2FC`:** `Numeric`. Specifies the log2 fold change threshold for filtering marker genes (used if `input_type` is `"findmarker"`). Default is `1`.
*   **`deseq_results`:** `Data frame`. A data frame containing DESeq2 results (required if `input_type` is `"deseq"`).

## 3. `save_results` Function

*   **`results`:** `Object`. The results object to save. Can be an `enrichResult` object, a data frame, or a list with an "error" element.
*   **`filename`:** `Character string`. The name of the file to save the results to.
*   **`type`:** `Character string`. Specifies the type of results being saved. Must be `"original"` or `"filtered"`. Default is `"original"`.

## 4. `perform_wp_enrichment` Function

*   **`gene_ids`:** `Vector`. A vector of gene identifiers (ENTREZIDs).
*   **`gene_mapping`:** `Data frame`. A data frame containing gene mappings between ENTREZID and SYMBOL. Must have columns named `"ENTREZID"` and `"SYMBOL"`.
*   **`organism`:** `Character string`. Specifies the organism. Must be `"human"` or `"mouse"`.
*   **`pvalue`:** `Numeric`. Specifies the p-value threshold for filtering results. Default is `0.05`.
*   **`output_dir`:** `Character string`. Specifies the directory to save the results to. Default is `"enrichment_results"`.

## 5. `perform_kegg_enrichment` Function

*   **`gene_ids`:** `Vector`. A vector of gene identifiers (ENTREZIDs).
*   **`gene_mapping`:** `Data frame`. A data frame containing gene mappings between ENTREZID and SYMBOL. Must have columns named `"ENTREZID"` and `"SYMBOL"`.
*   **`organism`:** `Character string`. Specifies the organism. Must be `"human"` or `"mouse"`.
*   **`pvalue`:** `Numeric`. Specifies the p-value threshold for filtering results. Default is `0.05`.
*   **`output_dir`:** `Character string`. Specifies the directory to save the results to. Default is `"enrichment_results"`.

## 6. `perform_reactome_enrichment` Function

*   **`gene_ids`:** `Vector`. A vector of gene identifiers (ENTREZIDs).
*   **`gene_mapping`:** `Data frame`. A data frame containing gene mappings between ENTREZID and SYMBOL. Must have columns named `"ENTREZID"` and `"SYMBOL"`.
*   **`organism`:** `Character string`. Specifies the organism. Must be `"human"` or `"mouse"`.
*   **`pvalue`:** `Numeric`. Specifies the p-value threshold for filtering results. Default is `0.05`.
*   **`output_dir`:** `Character string`. Specifies the directory to save the results to. Default is `"enrichment_results"`.

## 7. `perform_chea_enrichment` Function

*   **`gene_symbols`:** `Vector`. A vector of gene symbols.
*   **`organism`:** `Character string`. Specifies the organism. Must be `"human"` or `"mouse"`.
*   **`pvalue`:** `Numeric`. Specifies the p-value threshold for filtering results. Default is `0.05`.
*   **`output_dir`:** `Character string`. Specifies the directory to save the results to. Default is `"enrichment_results"`.

## 8. `perform_go_enrichment` Function

*   **`gene_ids`:** `Vector`. A vector of gene identifiers (ENTREZIDs).
*   **`gene_mapping`:** `Data frame`. A data frame containing gene mappings between ENTREZID and SYMBOL. Must have columns named `"ENTREZID"` and `"SYMBOL"`.
*   **`organism`:** `Character string`. Specifies the organism. Must be `"human"` or `"mouse"`.
*   **`ont`:** `Character string`. Specifies the GO ontology to use. Must be one of `"BP"` (biological process), `"CC"` (cellular component), or `"MF"` (molecular function). Default is `"BP"`.
*   **`pvalue`:** `Numeric`. Specifies the p-value threshold for filtering results. Default is `0.05`.
*   **`output_dir`:** `Character string`. Specifies the directory to save the results to. Default is `"enrichment_results"`.

## 9. `perform_string_interactions` Function

*   **`gene_mapping`:** `Data frame`. A data frame containing gene mappings between SYMBOL and STRING_id. Must have columns named `"SYMBOL"` and `"STRING_id"`.
*   **`organism`:** `Character string`. Specifies the organism. Must be `"human"` or `"mouse"`.
*   **`score_threshold`:** `Numeric`. Specifies the minimum combined score for interactions. Default is `0`.
*   **`output_dir`:** `Character string`. Specifies the directory to save the results to. Default is `"enrichment_results"`.

## 10. `make_gemini_request` Function

*   **`prompt`:** `Character string`. Contains the prompt to send to the Gemini API.
*   **`temperature`:** `Numeric`. Controls the randomness of the response.
*   **`max_output_tokens`:** `Integer`. Specifies the maximum number of tokens in the response.
*   **`api_key`:** `Character string`. Contains the Gemini API key.
*   **`model_query`:** `Character string`. Specifies the model to query.
*   **`delay_seconds`:** `Numeric`. Specifies the delay in seconds after sending the request.

## 11. `generate_network_revision_prompt` Function

*   **`file_path`:** `Character string`. Specifies the path to the text file containing the initial network data in TSV format.
*   **`gene_symbols`:** `Vector`. A vector of gene symbols used in the analysis.
*   **`experimental_design`:** `Character string`. Describes the experimental design (optional).
*   **`string_results`:** `List`. Contains STRING protein-protein interaction data (optional).

## 12. `generate_system_model_prompt` Function

*   **`llm_response`:** `Character string`. Contains the LLM response with the system network in TSV format.
*   **`gene_symbols`:** `Vector`. A vector of gene symbols used in the analysis.
*   **`experimental_design`:** `Character string`. Describes the experimental design (optional).

## 13. `visualize_system_model` Function

*   **`llm_response`:** `Character string`. Contains the LLM response with the system network in TSV format.
*   **`html_file`:** `Character string`. Specifies the name of the HTML file to save the visualization to. Default is `"system_model_network.html"`.
*   **`gene_symbols`:** `Vector`. A vector of gene symbols used in the analysis.
*   **`output_dir`:** `Character string`. Specifies the directory to save the results to. Default is `"enrichment_results"`.

## 14. `perform_pathway_comparison` Function

*   **`gene_symbols`:** `Vector`. A vector of gene symbols used in the analysis.
*   **`kegg_results`:** `Data frame`. A data frame containing KEGG enrichment results.
*   **`wp_results`:** `Data frame`. A data frame containing WikiPathways enrichment results.
*   **`reactome_results`:** `Data frame`. A data frame containing Reactome enrichment results.
*   **`go_results`:** `Data frame`. A data frame containing GO enrichment results.
*   **`output_dir`:** `Character string`. Specifies the directory to save the results to. Default is `"enrichment_results"`.

## 15. `create_combined_prompt` Function

*   **`results`:** `List`. A list of results from individual agents. Each element should be a list with `agent_id` and `response` elements.
*   **`gene_symbols`:** `Vector`. A vector of gene symbols used in the analysis.
*   **`string_interactions`:** `List`. A list containing STRING protein-protein interaction data.
*   **`chea_results`:** `Data frame`. A data frame containing ChEA transcription factor enrichment results.
*   **`string_network_properties`:** `Data frame`. A data frame containing STRING network properties.
*   **`comparison_results`:** `List`. A list containing pathway comparison results.
*   **`experimental_design`:** `Character string`. Describes the experimental design (optional).

## 16. `create_llm_prompt_*` Functions

These functions (`create_llm_prompt_wp`, `create_llm_prompt_kegg`, `create_llm_prompt_reactome`, `create_llm_prompt_chea`, `create_llm_prompt_go`, `create_llm_prompt_string`) share a similar set of parameters:

*   **`enrichment_results`:** `Data frame`. A data frame containing the enrichment results (specific to the analysis type).
*   **`analysis_type`:** `Character string`. Specifies the type of analysis (e.g., `"WikiPathways"`, `"KEGG"`, `"Reactome"`, `"ChEA"`, `"GO"`, `"STRING"`).
*   **`pathway_results`:** `List`. (Optional, only in `create_llm_prompt_chea` and `create_llm_prompt_string`) A list containing pathway enrichment results (KEGG, WikiPathways, Reactome, GO).
*   **`chea_results`:** `Data frame`. (Optional) A data frame containing ChEA transcription factor enrichment results.
*   **`string_results`:** `List`. (Optional) A list containing STRING protein-protein interaction data.
*   **`gene_symbols`:** `Vector`. A vector of gene symbols used in the analysis.
*   **`string_network_properties`:** `Data frame`. (Optional) A data frame containing STRING network properties.
*   **`experimental_design`:** `Character string`. Describes the experimental design (optional).
*   **`interaction_results`:** `List`. (Only in `create_llm_prompt_string`) A list containing STRING interaction results. Must have elements `interactions` (data frame of interactions) and `network_properties` (data frame of network properties).

## 17. `Agent` Class

*   **`id`:** The ID of the agent.
*   **`prompt`:** The prompt for the agent.
*   **`prompt_type`:** The type of prompt for the agent.

## 18. `Environment` Class

*   **`prompts`:** A list of prompts for the agents.
*   **`prompt_types`:** A list of prompt types for the agents.

**NOTE:** Generated by Gemini. Reviewed and edited by Vijay Nagarajan
