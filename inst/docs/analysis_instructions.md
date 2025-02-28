# Analysis Instructions for LLM Prompts in the IAN Package

This report details the analysis instructions provided to the Large Language Model (LLM) within the Integrated Network Analysis (IAN) R package. These instructions are designed to guide the LLM in summarizing, interpreting, and generating hypotheses based on multi-omics data.

## 1. Pathway Enrichment Analysis Prompts (WikiPathways, KEGG, Reactome)

These instructions are used to guide the LLM in analyzing pathway enrichment results from WikiPathways, KEGG, and Reactome databases.

**Analysis Instructions:**

1.  **Summary and Categorization:**
    *   Provide a one-paragraph summary (about 4 lines) of the significantly enriched [Pathway Database Name] pathways. Consider the experimental design, if given.
    *   Categorize the enriched pathways into broad functional groups and count the number of enriched concepts in each category. *Include only the top 4 categories*.

2.  **Known Roles and Upstream Regulators:**
    *   Provide a concise summary (about 4 lines) of the enriched pathways with their known roles in the context of our experiment, based on the current scientific literature.
    *   Based on the genes contributing to the enriched pathways, predict potential upstream regulators (transcription factors, kinases etc.,) that could be driving this phenotype. Provide a list of potential candidates with supporting reasoning.

3.  **Interaction Networks and Similar Systems:**
    *   Based on the genes involved in the enriched pathways and also found in the string data, suggest possible interactions or relationships between the enriched pathway genes. Mention any known protein-protein interactions, regulatory relationships or shared functional roles.
    *   Based on the enriched pathways and the genes involved, explore if there are other systems similar to our study, reported in the scientific literature, that might be of interest.

4.  **Hub Gene Identification:**
    *   Let's identify hub genes *think step-by-step*:
        *   First, identify genes that are enriched in *multiple* pathways.
        *   Second, identify genes that are enriched in GO analysis results (if GO analysis was performed), that are also enriched in our pathways.
        *   Third, identify genes represented in the enriched pathways that also have high combined network scores in the string network properties data.
        *   Fourth, identify genes represented in the enriched pathways that are also found in our ChEA enrichment results.
        *   Finally, integrate, compare, and analyze results from the first four steps to identify potential hub genes.
    *   List the potential hub genes and provide a single-line description of how you concluded them as a hub gene. *Explain your reasoning for each step*.
    *   *Review your hub genes list and ensure that each listed hub gene is indeed present in the corresponding provided data. If necessary, revise your answer*.

5.  **Drug Target/Marker/Kinase/Ligand Analysis:**
    *   For each hub gene, briefly note if it is a known potential drug target or marker, and if it is a kinase or a ligand, and if any of these kinases or ligands are potential drug targets.

6.  **Novelty Exploration:**
    *   Based on your analysis above, explore if there are any novel findings in our data. Are there any unexpected connections, pathways, or transcription factors that have not been previously reported in the literature? If so, please list them and provide a brief explanation of why they are novel.

7.  **Hypothesis Generation:**
    *   Integrate the findings from all the above to develop a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the enriched concepts.

8.  **System Representation Network:**
    *   Based on the identified hub genes and their associated GO terms, pathways, chea terms, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.
        *   Node1 should be the hub gene, *formatted in uppercase*.
        *   Edge should be 'associated with'.
        *   Node2 should be *a single GO term, formatted in 'Title Case'*, or a pathway name, *formatted in 'Title Case'*, or a transcription factor, *formatted in uppercase*.
    *   Check if the nodes identified above are grounded in the provided data. In the explanation column, include a note stating whether the network interaction in each row is grounded in the provided data.
    *   *Review the above network and ensure that every interaction included meets the grounding criteria and that each interaction includes only one hub gene and one GO term, pathway or target gene. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.
    *   Format the output within a `tsv` block, by adding ```tsv before the network content and ``` after the network content.

## 2. ChEA Transcription Factor Enrichment Prompt

**Analysis Instructions:**

1.  **Summary of Enriched Transcription Factors:**
    *   Provide a summary (about 4 lines) of the significantly enriched transcription factors. Consider the experimental design, if given.

2.  **Regulatory Network Analysis:**
    *   Based on the enriched transcription factors and the target genes, identify any known upstream regulators (like transcription factors, signaling pathways etc.,) that might modulate the system, as a master regulator. Please also note the target genes of these transcription factors, and the pathways these target genes are enriched in.

3.  **Novel Interactions:**
    *   Based on the enriched transcription factors and the target genes, identify any unexpected or novel transcription factor-gene interactions that has not been previously reported in the literature. Also, explore where such novel interactions are reported as known in the scientific literature.

4.  **Cross-Analysis:**
    *   Based on the target genes of these transcription factors, are there any potential connections or overlaps with pathways identified by KEGG, WikiPathways, Reactome, or GO? If so, please list the pathways and the genes they share with the target genes of these transcription factors.
    *   Are there any protein-protein interactions from STRING that support the findings of these transcription factors, based on their target genes? If so, please list the interacting proteins and their combined scores.
    *   Also, are there any important genes based on the STRING network properties that are also target genes of these transcription factors? If so, please list the genes and their combined network scores.

5.  **Hypothesis Generation:**
    *   Based on the above analysis, formulate a hypothesis regarding the roles of the enriched transcription factors and their target genes from our DEG, in driving the gene expression changes observed in our experiment. Consider potential mechanistic links between the transcription factors, their target genes, and our phenotype, in the context of all the data provided here.

6.  **System Representation Network:**
    *   Based on the enriched transcription factors and their target genes that are associated with pathways in our enriched pathway data, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.
        *   Node1 should be *a transcription factor, formatted in uppercase*.
        *   Edge should be 'associated with'.
        *   Node2 should be *a single pathway name, formatted in 'Title Case'*, or *a target gene, formatted in uppercase*. The target gene should be in the Chea enrichment data as well as in at least one of our other datasets (pathways or string).
    *   Check if the nodes identified above are grounded in the provided Chea, pathways, or string data. In the explanation column, include a note stating whether and how the 'Node1' gene is also found in the provided pathway data and/or is a Chea-enriched factor's target, and is a gene with a high combined_score_prop as seen in the network properties data.
    *   *Review the above network and ensure that every interaction included meets the grounding criteria, that each interaction includes only one transcription factor and one pathway or target gene. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.
    *   Format the output within a `tsv` block, by adding ```tsv before the network content and ``` after the network content.

## 3. GO Enrichment Prompt

**Analysis Instructions:**

1.  **Summary and Categorization:**
    *   Provide a one-paragraph summary (about 4 lines) of the significantly enriched GO terms. Consider the experimental design, if given.
    *   Categorize the enriched GO terms into broad functional groups and count the number of enriched concepts in each category. *Include only the top 4 categories*.

2.  **Known Roles and Upstream Regulators:**
    *   Provide a concise summary (about 4 lines) of the enriched GO terms with their known roles in the context of our experiment, based on the current scientific literature.

3.  **Interaction Networks and Similar Systems:**
    *   Based on the genes involved in the enriched GO terms and also found in the string data, suggest possible interactions or relationships between the enriched GO term genes. Mention any known protein-protein interactions, regulatory relationships or shared functional roles.

4.  **Cross-Analysis:**
    *   Based on the genes involved in these GO terms, are there any potential connections or overlaps with transcription factors that might regulate these genes, as identified by ChEA analysis? If so, please list the transcription factors and the genes they regulate that are also in these GO terms.
    *   Are there any protein-protein interactions from STRING that support the findings of these GO terms, based on the genes involved? If so, please list the interacting proteins and their combined scores.
    *   Also, are there any important genes based on the STRING network properties that are also in these GO terms? If so, please list the genes and their combined network scores.

5.  **Hypothesis Generation:**
    *   Integrate the findings from all the above to develop a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the enriched concepts.

6.  **System Representation Network:**
    *   Based on the enriched GO terms, their associated genes, and the provided ChEA and STRING data, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.
        *   Node1 should be *a gene enriched in a GO term, formatted in uppercase*.
        *   Edge should be 'associated with'.
        *   Node2 should be *a single GO term, formatted in 'Title Case'*.
    *   Check if the nodes identified above are grounded in the provided data. In the 'Explanation' column, include a note stating whether and how the 'Node1' gene is also found in the provided ChEA and/or STRING data (mention if it's a target of a TF from ChEA or if it has STRING interactions or a high network score). *If the gene is not present in ChEA or STRING data, the row should be removed from the network.*
    *   *Review the above network and ensure that every interaction included meets the grounding criteria, that each interaction includes only one gene and one GO term, and that any gene included in the network is also present in the provided Chea or string data. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.
    *   Format the output within a `tsv` block, by adding ```tsv before the network content and ``` after the network content.

## 4. STRING Interaction Analysis Prompt

**Analysis Instructions:**

1.  **Summary of Interactions:**
    *   Provide a one-paragraph summary (about 4 lines) of the genes with the high network properties based combined_score_prop, in the context of their other interacting partners. Consider the experimental design, if given.

2.  **Key Interactions and Network Topology:**
    *   Identify the most significant genes, and their interacting partners, using the network properties based combined_score_prop, and the provided interactions data. Explain the biological relevance of these interactions in the context of our experiment and the properties based combined_score_prop.
    *   Describe the overall structure of the interaction network, in the context of the properties based combined_score_prop and the provided interactions data. Are there any hub proteins or clusters of highly interconnected proteins, with large combined_score_prop based on their network properties? What does this suggest about the system's organization?

3.  **Functional Implications and Upstream Regulators:**
    *   Based on the known functions of the genes with high network properties based combined_score_prop, and their interacting partners, what are the potential functional implications of these interactions? How might these interactions contribute to the observed phenotype?
    *   Based on the interaction network, in the context of the network properties based combined_score_prop, predict potential upstream regulators (transcription factors, kinases etc.,) that could be driving this phenotype. Provide a list of potential candidates with supporting reasoning.

4.  **Cross-Analysis:**
    *   Based on the proteins with large combined_score_prop, and their interacting partners, are there any potential connections or overlaps with pathways identified by KEGG, WikiPathways, Reactome or GO? If so, please list the pathways and the genes they share with the interacting proteins.
    *   Are there any transcription factors from ChEA that might regulate these proteins with large combined_score_prop and their interacting partners? If so, please list the transcription factors and the genes they regulate that are also in these interacting proteins.

5.  **Hypothesis Generation:**
    *   Integrate the findings from all the above to develop a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the interacting proteins, in the context of the network properties based combined_score_prop, their regulatory elements and their enriched pathways.

6.  **System Representation Network:**
    *   Based on the identified genes with high combined_score_prop, and the interacting proteins, and their associated pathways or associated chea factors, generate a system representation network in TSV (tab-separated values) format with four columns: 'Node1', 'Edge', 'Node2', and 'Explanation'.
        *   Node1 should be *a gene with high combined network score, based on the network properties data, formatted in uppercase*.
        *   Edge should be 'associated with'.
        *   Node2 should be *a single pathway name or ontology term, formatted in 'Title Case'*, or a transcription factor, *formatted in uppercase*.
    *   Check if the nodes identified above are grounded in the provided data. In the 'Explanation' column, include a note stating whether and how the 'Node1' gene is also present in the provided pathway data and/or is a Chea-enriched factor's target, and is a gene with a high combined_score_prop as seen in the network properties data.
    *   *Review the above network and ensure that every interaction included meets the grounding criteria, that each interaction includes only one gene and one pathway, GO term, or transcription factor. If any interaction does not meet these criteria, remove it from the network and revise the explanation column accordingly*.
    *   Format the output within a `tsv` block, by adding ```tsv before the network content and ``` after the network content.

## 5. Combined Prompt

**Analysis Instructions:**

*   **Step 1: Analyze Individual Agent Summaries**
    *   Review each agent's response individually and understand the analysis. Include the provided string network properties, pathway comparisons, chea results, list of differentially expressed genes, string results and experimental design (if provided) in your review, in addition to the agent summaries.

*   **Step 2: Integrate Agent Summaries, Pathways and other data**
    *   Considering the experimental design, and the data provided in the prompt (including the pathway comparison results, chea enrichment results, string network properties data and string interactions data), systematically integrate the information from different agent responses. Identify any similarities, differences, and complementary findings between them.
    *   Systematically compare and integrate pathway results (KEGG, WikiPathways, Reactome, GO). Pay close attention to 'overlap' genes, which are present in multiple pathways, and 'unique' genes, which are specific to individual pathways.
    *   Identify common themes and patterns across different agents and the additional data provided. What key biological processes are consistently highlighted? How do the unique and shared genes across pathways contribute to your understanding?

*   **Step 3: Groundedness Check**
    *   Ensure that the analysis results, from agents and integration in step 2, are grounded in the list of genes provided, as well as the pathway results. For example, if a pathway was identified, ensure that the genes mentioned in the pathway are also listed as differentially expressed in the beginning of the prompt.
    *   Systematically check if any information from the summaries is not directly supported by the original list of genes, pathway data, string data or chea data. Note any inconsistencies or missing links.

*   **Step 4: Regulatory Network Analysis**
    *   Perform a detailed analysis focusing on the chea enrichment data, along with the agent responses, list of differentially expressed genes, the string network properties and the experimental design, to decipher potential regulatory network affecting our phenotype. Also discuss any potential novel interactions identified by ChEA. How do these novel transcription factor-gene interactions fit into the overall biological mechanisms identified from other data?

*   **Step 5: Further Analysis:**
    *   Provide a section on potential upstream regulators that could be driving this phenotype. List potential candidates with supporting reasoning, based on all the available data.
    *   Provide a section on similar systems, reported in the scientific literature, that might be of interest based on your analysis.
    *   Provide a hub gene identification section based on the integrated analysis, and the provided network properties. Explain how you concluded them as a hub gene.
    *   For each hub gene, note if it is a known potential drug target or marker, and if it is a kinase or a ligand, and if any of these kinases or ligands are potential drug targets.
    *   Provide a section on novelty exploration. Are there any unexpected connections, pathways, or transcription factors that have not been previously reported in the literature? If so, please list them and provide a brief explanation of why they are novel.

*   **Step 6: High-Level Summary**
    *   Based on the above integrated analysis, provide a high-level summary describing the understood system. What are the key interconnected processes that are contributing to this phenotype? Include a coherent hypothesis about the molecular mechanisms contributing to this phenotype. Focus on the interconnections between the enriched concepts.

*   **Step 7: Title**
    *   Based on the above integrated analysis, provide a single line title reflecting key findings. I want the title to have not more than 10 words. Include one important gene name identified as influencing the system, in the title.

## 6. System Model Prompt

**Analysis Instructions:**

*   Analyze the provided system network, in the context of the provided differentially expressed genes, and the experimental design. Provide a short summary/overview of the system, based on your analysis. Also, based on your analysis, describe how the potential upstream regulators and key genes could be affecting the phenotype through their target genes and pathways. Propose a mechanistic model based on your analysis and provide a short hypothesis about the molecular mechanism contributing to the phenotype, based on the identified relationships. Based on the mechanistic model that you have proposed, generate a network representation of the *system model*. I want the system model to be a bigger picture representation of the system, showing important players. Make sure in the above network representation of the system model each interaction includes only one gene as source and either one GO term or one pathway or one gene as the target.
