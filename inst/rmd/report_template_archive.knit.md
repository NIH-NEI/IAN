---
# This RMD ....
# Authors : Vijay Nagarajan NEI/NIH, Junseok Jang NEI/NIH
title: "FN1-centered immune dysregulation in uveitis pathogenesis" #Multi-Agent System Analysis Report"
output:
  github_document:
    toc: true
---





## 1. Integrated Analysis Results
This report summarizes the results of a multi-agent-AI-system (IAN) based analysis performed using the provided list of differentially expressed genes. Results after IAN integrated all the individual agents responses is provided below:

### 1.1. High-Level Summary
Uveitis pathogenesis involves a complex interplay between dysregulated immune responses (complement activation, T cell co-stimulation, interferon signaling), ECM remodeling, and potentially neuronal dysfunction and infectious triggers.  FN1, a central ECM component, acts as a key hub, connecting immune, complement, and cytoskeletal processes.  RELB and SMAD4, as key transcription factors, orchestrate these processes, regulating genes involved in inflammation and ECM remodeling.  The high connectivity of Y-chromosome genes suggests a potential sex-specific component.  Infectious triggers and neuronal dysfunction may contribute to disease initiation or severity.

### 1.2. Affected Biological Processes
The integrated analysis reveals a complex interplay of immune dysregulation, ECM remodeling, and potentially neuronal dysfunction and infectious triggers in uveitis.  The complement system (C1QA, C1QB, C1QC, SERPING1, C4BPA) is consistently implicated across all analyses, indicating a central role in initiating and amplifying inflammation.  ECM remodeling (FN1, COL4A3, COL4A4) is highlighted, suggesting alterations in tissue structure contribute to the disease.  Immune responses, particularly T cell modulation (CD274, PDCD1LG2) and interferon signaling (GBP1, GBP5, GBP6), are consistently enriched.  Agent 2 and Agent 3 highlight the involvement of infectious disease pathways and neuronal signaling pathways, respectively, suggesting potential contributing factors.  Agent 4's transcription factor analysis points to RELB and SMAD4 as key regulators, influencing both immune response and ECM remodeling.  Agent 5's GO term analysis reinforces the importance of B and T cell mediated immunity and complement activation. Agent 6's STRING analysis identifies FN1 and ANKRD22 as central hubs, connecting various functional modules.  The high connectivity of Y-chromosome genes suggests a potential sex-specific component.

### 1.3. Potential Regulatory Networks
ChEA analysis reveals RELB, SMAD4, and TFAP2C as significantly enriched transcription factors. RELB, a key NF-κB component, regulates genes involved in interferon signaling and complement activation (GBP5, CD274). SMAD4, a central TGF-β effector, regulates genes involved in ECM-receptor interaction and cell adhesion (FN1, COL4A3, COL4A4).  TFAP2C's role appears more subtle, potentially influencing the cellular context of the immune response.  The overlap of RELB and SMAD4 target genes in pathways like ECM-receptor interaction suggests a coordinated regulatory mechanism.  Novel interactions, such as TFAP2C's association with KCNK17 and NOS1AP, and POU5F1's regulation of ROR1, warrant further investigation.
* **NF-κB (RELB):**  Master regulator of inflammation, consistently implicated across analyses.
* **SMAD family (SMAD4):**  Crucial for TGF-β signaling, involved in ECM remodeling and immune regulation.
* **STAT family:**  Mediates cytokine signaling and immune cell differentiation.
* **IRF family:**  Essential for interferon responses, relevant to the enriched immune and infectious disease pathways.
* **AP-1:**  Regulates cell proliferation, differentiation, and inflammation.

### 1.4. Potential Hub Genes

Based on consistent appearance across multiple analyses (pathway enrichments, GO terms, STRING network scores, ChEA results), the following emerge as strong hub gene candidates:

* **FN1:**  High STRING network score, multiple pathway enrichments (ECM, cell adhesion, inflammation).
* **CD274:**  High STRING network score, multiple pathway enrichments (T cell co-stimulation, immune checkpoint).
* **C1QA, C1QB, C1QC:**  High STRING network scores, multiple pathway enrichments (complement activation).
* **ANK2:**  Multiple pathway enrichments (actin cytoskeleton, cardiac muscle), high STRING network score.

**Drug Target/Marker/Kinase/Ligand Analysis:**

* **FN1:** Not a direct drug target, but its role in ECM remodeling makes it a potential indirect target.
* **CD274:**  Established drug target in cancer immunotherapy (anti-PD-L1 antibodies).
* **C1QA, C1QB, C1QC:** Potential biomarkers for inflammation.
* **ANK2:** Not a known drug target.  None of these are kinases or ligands.

### 1.5. Similar Systems

Other inflammatory eye diseases (age-related macular degeneration, diabetic retinopathy), systemic lupus erythematosus (SLE), and other autoimmune diseases with complement dysregulation and ECM remodeling show similarities.

### 1.6. Novelty Exploration

The strong enrichment of infectious disease pathways (Agent 2) and neuronal signaling pathways (Agent 3) in the context of uveitis, along with the specific transcription factor-gene interactions identified by ChEA (e.g., TFAP2C-KCNK17, POU5F1-ROR1), warrant further investigation to determine their novelty.

### 1.7. Download Full Analysis Report

Download the Full Integrated IAN Analysis Report Here:

[Open full final_response.txt text in new tab](final_response.txt)

## 2. System Model
IAN takes the integrated full analysis report and the integrated system network data from each of the agents response and puts forward a system model, which includes the system overview, mechanistic model and an hypothesis.

### 2.1. System Model and Overview
The nodes in yellow are "Genes" found in our list of DEGs. The Nodes in blue are either "Term/Concept" nodes or "Genes" not in our list of DEGs (coming from ChEA instead).


*(Network visualization omitted for Markdown output. Please refer to the HTML version or generate a static plot.)*

The provided network depicts a complex interplay of genes and pathways primarily involved in immune response, inflammation, and cell adhesion.  The differentially expressed genes (DEGs) identified via RNA-Seq in peripheral blood from uveitis patients provide crucial context for interpreting this network.  The system appears to center around the regulation of immune cell activity and extracellular matrix remodeling, both key processes in inflammatory conditions like uveitis.  Several transcription factors and signaling molecules emerge as potential upstream regulators influencing these processes.

### 2.2. Mechanistic Model

The identified relationships suggest a mechanistic model where upstream regulators like RELB, SMAD4, and ATF3 influence the uveitis phenotype through their downstream targets.  RELB's regulation of GBP5 and CD274 suggests a modulation of interferon signaling and T cell activity, potentially contributing to the inflammatory response.  SMAD4's influence on FN1 suggests a role in regulating cell adhesion and tissue remodeling, impacting the inflammatory environment.  ATF3's interactions with both FN1 and CD274 suggest a role in integrating these processes.  The complement components (C1QA, C1QB) and FCGR1A further amplify the inflammatory response and shape the adaptive immune response.  The interactions between these components suggest a complex interplay between innate and adaptive immunity in the pathogenesis of uveitis.


### 2.3. Hypothesis

The observed changes in gene expression in peripheral blood from uveitis patients reflect a systemic dysregulation of immune responses and cell adhesion processes. We hypothesize that dysregulation of RELB, SMAD4, and ATF3 activity, potentially triggered by yet unidentified upstream factors, leads to altered expression of their target genes (GBP5, CD274, FN1), resulting in an amplified inflammatory response, impaired immune regulation, and altered tissue remodeling, contributing to the development and progression of uveitis.  The complement system (C1QA, C1QB) and the Fc receptor (FCGR1A) play crucial roles in amplifying the inflammatory response and shaping the adaptive immune response.  The involvement of ANK2 suggests a role for cell migration in the pathogenesis of the disease. The specific etiology of uveitis (e.g., genetic predisposition, infectious agents, autoimmune triggers) may influence the specific pattern of DEG expression and the relative contribution of these pathways.  Further investigation is needed to elucidate the precise upstream triggers and the specific molecular mechanisms driving this dysregulation.

### 2.4. Download System Model Report

Download the Full System Model Report Here:

[Open full system_model.txt text in new tab](system_model.txt)

## 3. KEGG Enrichment
IAN runs enrichment analysis, filters the significant terms, prepares metadata and generates the LLM based agent response, analyzing the data like a human expert.

### 3.1. Kegg Enrichment Results
KEGG pathway enrichment analysis results, filtered


Table: Top 20 KEGG Enrichment Results

|ID       |Description                                          |    pvalue|Gene                          | neglog10p|
|:--------|:----------------------------------------------------|---------:|:-----------------------------|---------:|
|hsa05133 |Pertussis                                            | 0.0000512|C4BPA,C1QC,SERPING1,C1QB,C1QA |  4.290337|
|hsa04610 |Complement and coagulation cascades                  | 0.0000915|C4BPA,C1QC,SERPING1,C1QB,C1QA |  4.038801|
|hsa05150 |Staphylococcus aureus infection                      | 0.0019621|C1QC,FCGR1A,C1QB,C1QA         |  2.707286|
|hsa05322 |Systemic lupus erythematosus                         | 0.0062773|C1QC,FCGR1A,C1QB,C1QA         |  2.202229|
|hsa04820 |Cytoskeleton in muscle cells                         | 0.0071412|MYOM2,FN1,ANK2,COL4A3,COL4A4  |  2.146228|
|hsa04514 |Cell adhesion molecules                              | 0.0093206|PDCD1LG2,CD274,SLITRK5,NRCAM  |  2.030556|
|hsa04512 |ECM-receptor interaction                             | 0.0113214|FN1,COL4A3,COL4A4             |  1.946099|
|hsa05222 |Small cell lung cancer                               | 0.0127495|FN1,COL4A3,COL4A4             |  1.894506|
|hsa04933 |AGE-RAGE signaling pathway in diabetic complications | 0.0159037|FN1,COL4A3,COL4A4             |  1.798502|
|hsa05142 |Chagas disease                                       | 0.0167549|C1QC,C1QB,C1QA                |  1.775857|
|hsa05146 |Amoebiasis                                           | 0.0167549|FN1,COL4A3,COL4A4             |  1.775857|
|hsa04621 |NOD-like receptor signaling pathway                  | 0.0170720|GBP5,GBP1,CASP5,NAIP          |  1.767715|
|hsa04510 |Focal adhesion                                       | 0.0215949|FN1,COL4A3,COL4A4,PARVA       |  1.665648|
|hsa05171 |Coronavirus disease - COVID-19                       | 0.0359050|RPS4Y1,C1QC,C1QB,C1QA         |  1.444845|
|hsa04936 |Alcoholic liver disease                              | 0.0398029|C1QC,C1QB,C1QA                |  1.400085|
|hsa04148 |Efferocytosis                                        | 0.0493125|C1QC,C1QB,C1QA                |  1.307043|

### 3.2. Kegg Enrichment Analysis Plot
KEGG pathway enrichment analysis results, filtered - plot

![](/Users/nagarajanv/Downloads/IAN_results/report_template_archive_files/figure-gfm/kegg_filtered_plot-1.png)<!-- -->[Download Plot as PNG](kegg_enrichment_plot.png)

### 3.3. KEGG LLM Agent Response

Agent 2:
**1. Summary and Categorization:**

The significantly enriched KEGG pathways primarily highlight the involvement of the complement system, cell adhesion, and extracellular matrix (ECM) interactions in the uveitis patient group compared to healthy controls.  These pathways are strongly interconnected, suggesting a coordinated dysregulation in immune response and tissue remodeling processes.  Several pathways related to infectious diseases are also significantly enriched, hinting at a potential role of infection or microbial dysbiosis in uveitis pathogenesis.

**Categorization:**

- **Immune Response:**  Complement and coagulation cascades, Staphylococcus aureus infection, Systemic lupus erythematosus, Pertussis, Coronavirus disease - COVID-19, Chagas disease (6 pathways)
- **Cell Adhesion and ECM:** Focal adhesion, ECM-receptor interaction, Cell adhesion molecules, Cytoskeleton in muscle cells, AGE-RAGE signaling pathway in diabetic complications, Amoebiasis, Small cell lung cancer (7 pathways)
- **Inflammatory Response:**  Efferocytosis, Alcoholic liver disease (2 pathways)
- **Other:** NOD-like receptor signaling pathway (1 pathway)

## 4. WikiPathway Enrichment
IAN runs enrichment analysis, filters the significant terms, prepares metadata and generates the LLM based agent response, analyzing the data like a human expert.

### 4.1. WikiPathway Enrichment Results
WikiPathway enrichment analysis results, filtered


Table: Top 20 WikiPathway Enrichment Results

|ID     |Description                                                    |    pvalue|Gene                                                  | neglog10p|
|:------|:--------------------------------------------------------------|---------:|:-----------------------------------------------------|---------:|
|WP5090 |Complement system in neuronal development and plasticity       | 0.0000251|C4BPA,C1QC,SERPING1,C1QB,C1QA,CSMD1                   |  4.600374|
|WP3937 |Microglia pathogen phagocytosis pathway                        | 0.0000659|C1QC,FCGR1A,C1QB,C1QA                                 |  4.181306|
|WP4258 |lncRNA in canonical Wnt signaling and colorectal cancer        | 0.0001963|KREMEN1,ATF3,MIR34AHG,WNT16,ROR1                      |  3.707184|
|WP545  |Complement activation                                          | 0.0002625|C1QC,C1QB,C1QA                                        |  3.580802|
|WP558  |Complement and coagulation cascades                            | 0.0002842|C1QC,SERPING1,C1QB,C1QA                               |  3.546376|
|WP3896 |Dengue 2 interactions with complement and coagulation cascades | 0.0003036|C1QC,SERPING1,C1QB,C1QA                               |  3.517653|
|WP5087 |Pleural mesothelioma                                           | 0.0005915|FN1,CD274,KREMEN1,ATF3,FGF13,COL4A3,WNT16,ROR1,COL4A4 |  3.228009|
|WP3941 |Oxidative damage response                                      | 0.0013708|C1QC,C1QB,C1QA                                        |  2.863014|
|WP4585 |Cancer immunotherapy by PD 1 blockade                          | 0.0070763|PDCD1LG2,CD274                                        |  2.150192|
|WP2572 |Primary focal segmental glomerulosclerosis FSGS                | 0.0073096|COL4A3,COL4A4,PARVA                                   |  2.136106|
|WP4239 |Epithelial to mesenchymal transition in colorectal cancer      | 0.0121586|FN1,COL4A3,WNT16,COL4A4                               |  1.915118|
|WP4336 |ncRNAs in Wnt signaling in hepatocellular carcinoma            | 0.0130351|KREMEN1,WNT16,ROR1                                    |  1.884887|
|WP2328 |Allograft rejection                                            | 0.0134327|C1QC,C1QB,C1QA                                        |  1.871836|
|WP4658 |Small cell lung cancer                                         | 0.0159641|FN1,COL4A3,COL4A4                                     |  1.796856|
|WP1433 |Nucleotide binding oligomerization domain NOD pathway          | 0.0215291|CASP5,NAIP                                            |  1.666974|
|WP428  |Wnt signaling                                                  | 0.0250735|KREMEN1,WNT16,ROR1                                    |  1.600785|
|WP4758 |Nephrotic syndrome                                             | 0.0256311|COL4A3,COL4A4                                         |  1.591233|
|WP5078 |T cell modulation in pancreatic cancer                         | 0.0267026|PDCD1LG2,CD274                                        |  1.573446|
|WP5053 |Development of ureteric derived collecting system              | 0.0288993|ANOS1,GRIP1                                           |  1.539113|
|WP2267 |Synaptic vesicle pathway                                       | 0.0323251|SYN2,SLC1A3                                           |  1.490460|

### 4.2. WikiPathway Enrichment Analysis Plot
WikiPathway enrichment analysis results, filtered - plot

![](/Users/nagarajanv/Downloads/IAN_results/report_template_archive_files/figure-gfm/wp_filtered_plot}-1.png)<!-- -->[Download Plot as PNG](wp_enrichment_plot.png)

### 4.3. WikiPathway LLM Agent Response

Agent 1:
**1. Summary and Categorization:**

The significantly enriched WikiPathways point towards a strong involvement of the complement system and Wnt signaling in the pathogenesis of uveitis in the studied patient population.  Additionally, pathways related to immune response, particularly T cell modulation and cancer immunotherapy, are highlighted.  These findings suggest a complex interplay between inflammation, immune dysregulation, and potentially, tissue remodeling processes.

**Categorization:**

- **Immune Response:** Nucleotide binding oligomerization domain NOD pathway, Allograft rejection, Microglia pathogen phagocytosis pathway, Cancer immunotherapy by PD-1 blockade, Complement system in neuronal development and plasticity, Complement activation, Complement and coagulation cascades (7 pathways)
- **Wnt Signaling:** Wnt signaling, lncRNA in canonical Wnt signaling and colorectal cancer, ncRNAs in Wnt signaling in hepatocellular carcinoma (3 pathways)
- **Tissue Remodeling/Cell Adhesion:** Epithelial to mesenchymal transition in colorectal cancer, Small cell lung cancer, Pleural mesothelioma (3 pathways)
- **Other:** Synaptic vesicle pathway, Oxidative damage response, Nephrotic syndrome, Development of ureteric derived collecting system, T cell modulation in pancreatic cancer (5 pathways)

## 5. Reactome Enrichment

### 5.1. Reactome Pathways Enrichment Results
Reactome Pathways enrichment analysis results, filtered


Table: Top 20 Reactome Enrichment Results

|ID            |Description                                 |    pvalue|Gene                                            | neglog10p|
|:-------------|:-------------------------------------------|---------:|:-----------------------------------------------|---------:|
|R-HSA-977606  |Regulation of Complement cascade            | 0.0000036|C4BPA,C1QC,SERPING1,C1QB,C1QA                   |  5.447443|
|R-HSA-166658  |Complement cascade                          | 0.0000102|C4BPA,C1QC,SERPING1,C1QB,C1QA                   |  4.990503|
|R-HSA-166786  |Creation of C4 and C2 activators            | 0.0000427|C1QC,C1QB,C1QA                                  |  4.369891|
|R-HSA-166663  |Initial triggering of complement            | 0.0002010|C1QC,C1QB,C1QA                                  |  3.696776|
|R-HSA-877300  |Interferon gamma signaling                  | 0.0013720|FCGR1A,GBP6,GBP5,GBP1                           |  2.862635|
|R-HSA-2214320 |Anchoring fibril formation                  | 0.0025207|COL4A3,COL4A4                                   |  2.598483|
|R-HSA-3000171 |Non-integrin membrane-ECM interactions      | 0.0032451|FN1,COL4A3,COL4A4                               |  2.488776|
|R-HSA-2243919 |Crosslinking of collagen fibrils            | 0.0036375|COL4A3,COL4A4                                   |  2.439198|
|R-HSA-1442490 |Collagen degradation                        | 0.0040857|MMP19,COL4A3,COL4A4                             |  2.388737|
|R-HSA-112316  |Neuronal System                             | 0.0043528|CACNA1E,SYN2,SLC1A3,GRIN3A,KCNK17,GRIP1,SLITRK5 |  2.361234|
|R-HSA-1474228 |Degradation of the extracellular matrix     | 0.0053755|FN1,MMP19,COL4A3,COL4A4                         |  2.269580|
|R-HSA-389948  |PD-1 signaling                              | 0.0059185|PDCD1LG2,CD274                                  |  2.227786|
|R-HSA-3000178 |ECM proteoglycans                           | 0.0066063|FN1,COL4A3,COL4A4                               |  2.180039|
|R-HSA-216083  |Integrin cell surface interactions          | 0.0089905|FN1,COL4A3,COL4A4                               |  2.046215|
|R-HSA-3000157 |Laminin interactions                        | 0.0099490|COL4A3,COL4A4                                   |  2.002221|
|R-HSA-445095  |Interaction between L1 and Ankyrins         | 0.0106009|ANK2,NRCAM                                      |  1.974656|
|R-HSA-913531  |Interferon Signaling                        | 0.0112785|IFI27,FCGR1A,GBP6,GBP5,GBP1                     |  1.947748|
|R-HSA-112315  |Transmission across Chemical Synapses       | 0.0114478|CACNA1E,SYN2,SLC1A3,GRIN3A,GRIP1                |  1.941277|
|R-HSA-140877  |Formation of Fibrin Clot (Clotting Cascade) | 0.0164641|SERPING1,CD177                                  |  1.783461|
|R-HSA-419037  |NCAM1 interactions                          | 0.0189471|COL4A3,COL4A4                                   |  1.722457|

### 5.2. Reactome Pathways Enrichment Analysis Plot
Reactome Pathways enrichment analysis results, filtered - plot

![](/Users/nagarajanv/Downloads/IAN_results/report_template_archive_files/figure-gfm/reactome_filtered_plot}-1.png)<!-- -->

### 5.3. Reactome Pathways LLM Agent Response

Agent 3:
**1. Summary and Categorization:**

The significantly enriched Reactome pathways in this Uveitis vs. control whole blood transcriptomics study point towards dysregulation in several interconnected biological processes.  The top pathways highlight alterations in neuronal signaling (neurotransmitter release, synaptic transmission, and neuronal system), extracellular matrix (ECM) remodeling (collagen degradation, ECM degradation, collagen biosynthesis, and fibril assembly), complement activation, and histone demethylation.  These findings suggest a complex interplay between immune response, neuronal function, and tissue structure in uveitis pathogenesis.

**Categorization of Enriched Pathways:**

- **Immune System:** Complement cascade (4 pathways), Regulation of Complement cascade, Initial triggering of complement, Creation of C4 and C2 activators.
- **Extracellular Matrix (ECM) Remodeling:** Formation of Fibrin Clot (Clotting Cascade), Collagen degradation, Degradation of the extracellular matrix, Collagen biosynthesis and modifying enzymes, Assembly of collagen fibrils and other multimeric structures, Integrin cell surface interactions, Anchoring fibril formation, Crosslinking of collagen fibrils, Laminin interactions, Non-integrin membrane-ECM interactions, ECM proteoglycans.
- **Neuronal System:** Neurotransmitter release cycle, Transmission across Chemical Synapses, Neuronal System, NCAM signaling for neurite out-growth, NCAM1 interactions.
- **Epigenetic Regulation:** HDMs demethylate histones

## 6. Gene Ontology Enrichment

### 6.1. Gene Ontology Enrichment Results

Gene Ontology enrichment analysis results, filtered


Table: Top 20 Gene Ontology Enrichment Results

|Description                                                                                                               |    pvalue|Gene                                                                            | neglog10p|
|:-------------------------------------------------------------------------------------------------------------------------|---------:|:-------------------------------------------------------------------------------|---------:|
|complement activation, classical pathway                                                                                  | 0.0000001|C4BPA, C1QC, SERPING1, C1QB, C1QA, IGHG4                                        |  7.176487|
|humoral immune response mediated by circulating immunoglobulin                                                            | 0.0000004|C4BPA, C1QC, SERPING1, C1QB, C1QA, IGHG4                                        |  6.409684|
|complement activation                                                                                                     | 0.0000011|C4BPA, C1QC, SERPING1, C1QB, C1QA, IGHG4                                        |  5.941547|
|adaptive immune response based on somatic recombination of immune receptors built from immunoglobulin superfamily domains | 0.0000041|KDM5D, C4BPA, C1QC, SERPING1, FCGR1A, C1QB, C1QA, IL27, CD274, IGHV3-35, IGHG4  |  5.387909|
|defense response to bacterium                                                                                             | 0.0000069|FCGR1A, GBP6, HP, GBP5, GBP1, ANXA3, SLAMF8, SIGLEC16, NAIP, IGHG4              |  5.160943|
|immunoglobulin mediated immune response                                                                                   | 0.0000109|C4BPA, C1QC, SERPING1, FCGR1A, C1QB, C1QA, IGHV3-35, IGHG4                      |  4.961319|
|B cell mediated immunity                                                                                                  | 0.0000126|C4BPA, C1QC, SERPING1, FCGR1A, C1QB, C1QA, IGHV3-35, IGHG4                      |  4.901207|
|leukocyte mediated immunity                                                                                               | 0.0000260|KDM5D, C4BPA, C1QC, SERPING1, FCGR1A, CD177, C1QB, C1QA, ANXA3, IGHV3-35, IGHG4 |  4.585632|
|pyroptosis                                                                                                                | 0.0000364|IFI27, GBP5, GBP1, NAIP                                                         |  4.439019|
|synapse pruning                                                                                                           | 0.0000445|C1QC, C1QB, C1QA                                                                |  4.351924|
|lymphocyte mediated immunity                                                                                              | 0.0001162|KDM5D, C4BPA, C1QC, SERPING1, FCGR1A, C1QB, C1QA, IGHV3-35, IGHG4               |  3.934938|
|cell junction disassembly                                                                                                 | 0.0003406|C1QC, C1QB, C1QA                                                                |  3.467716|
|defense response to protozoan                                                                                             | 0.0003406|BATF2, GBP6, GBP1                                                               |  3.467716|
|regulation of cardiac muscle cell action potential                                                                        | 0.0004224|NOS1AP, FGF13, ANK2                                                             |  3.374271|
|response to protozoan                                                                                                     | 0.0004676|BATF2, GBP6, GBP1                                                               |  3.330112|
|glomerular basement membrane development                                                                                  | 0.0013647|COL4A3, COL4A4                                                                  |  2.864963|
|sensory perception of sound                                                                                               | 0.0013848|HPN, SLC1A3, COL4A3, COCH, ROR1                                                 |  2.858607|
|neutrophil degranulation                                                                                                  | 0.0016322|CD177, ANXA3                                                                    |  2.787220|
|forebrain morphogenesis                                                                                                   | 0.0019226|OTX1, GDF7                                                                      |  2.716108|
|negative regulation of complement activation                                                                              | 0.0019226|C4BPA, SERPING1                                                                 |  2.716108|

### 6.2. Gene Ontology Enrichment Analysis Plot
Gene Ontology enrichment analysis results, filtered - plot  - Top 20 Terms

![](/Users/nagarajanv/Downloads/IAN_results/report_template_archive_files/figure-gfm/go_filtered_plot}-1.png)<!-- -->

### 6.3. GO LLM Agent Response

Agent 5:
**1. Summary and Categorization:**

The significantly enriched GO terms in this RNA-Seq analysis of uveitis patients versus healthy controls strongly implicate immune system dysregulation.  Multiple GO terms related to B cell and T cell mediated immunity, complement activation, and acute inflammatory responses are highly enriched. This suggests a complex interplay of humoral and cellular immune responses, along with innate immune activation, contributing to uveitis pathogenesis.

**Categorization of Enriched GO Terms:**

- **Immune Response:** 20 terms (B cell mediated immunity, T cell costimulation, adaptive immune response, humoral immune response, immunoglobulin mediated immune response, leukocyte mediated immunity, lymphocyte mediated immunity, defense response to bacterium, defense response to protozoan, negative regulation of complement activation, negative regulation of humoral immune response, negative regulation of immune effector process, negative regulation of interleukin-10 production, positive regulation of inflammatory response, regulation of adaptive immune response, regulation of immune effector process, regulation of humoral immune response)
- **Cell Movement and Contraction (actin-based):** 7 terms (actin filament-based movement, actin-mediated cell contraction, action potential, regulation of actin filament-based movement, regulation of action potential, positive regulation of cation channel activity, positive regulation of ion transmembrane transporter activity)
- **Complement Activation:** 3 terms (complement activation, complement activation, classical pathway, negative regulation of complement activation)
- **Cardiac Muscle Function:** 6 terms (cardiac muscle cell action potential, cardiac muscle cell contraction, cardiac muscle cell membrane repolarization, regulation of cardiac muscle cell action potential, regulation of cardiac muscle cell contraction, regulation of cardiac muscle cell membrane repolarization)

## 7. Transcription Factor Enrichment

### 7.1. Transcription Factor (ChEA) enrichment results
Transcription Factor (ChEA) enrichment analysis results, filtered


Table: Top 20 ChEA Enrichment Results

|Term                                                    |   P.value|Genes                                                                                                                                             | neglog10p|
|:-------------------------------------------------------|---------:|:-------------------------------------------------------------------------------------------------------------------------------------------------|---------:|
|RELB 30642670 ChIP-Seq CTB1 Human Placenta Inflammation | 0.0157915|GBP5;CD274;MMP19;GPR84                                                                                                                            | 1.8015768|
|TFAP2C 20629094 ChIP-Seq MCF-7 Human                    | 0.0266249|KREMEN1;IL27;KCNK17;GPR84;LRP1B;VSIG10;ETV7;PKIB;LYPD6B;NOS1AP;NRCAM;SRGAP1;MOCS1                                                                 | 1.5747112|
|POU5F1 16153702 ChIP-ChIP HESCs Human                   | 0.0307580|C1QA;NRN1;EIF1AY;ROR1;OTX1;CYYR1;SOX5                                                                                                             | 1.5120419|
|SMAD4 21741376 ChIP-Seq HESCs Human                     | 0.0309139|GBP5;PLLP;RFPL2;FAM118A;FN1;ANK2;PARVA;CACNA1E;ETV7;GRIP1;PKIB;LYPD6B;EPSTI1;PRR16;SLAMF8;NRCAM;ROR1;FGF13;ATF3;SOX5                              | 1.5098467|
|IRF1 21803131 ChIP-Seq MONOCYTES Human                  | 0.0426667|CD274;PKIB;APOL4;EPSTI1;GBP1                                                                                                                      | 1.3699113|
|PCGF4 22325352 ChIP-Seq 293T-Rex Human                  | 0.0478220|GBP6;C1QB;GBP5;C1QA;C4BPA;CACNA1E;LRP1B;GDF7;FHAD1;COL4A4;LYPD6B;ROR1;OTX1;FCGR1A;GBP1;ATF3;C1QC                                                  | 1.3203727|
|TBX4 33478486 ChIP-Seq IMR90 Human Lung                 | 0.0715628|HPN;FBXO39;CACNA1E;SYBU                                                                                                                           | 1.1453127|
|RXR 22108803 ChIP-Seq LS180 Human                       | 0.0764158|FHAD1;GRIP1;OLAH;EPSTI1;PRR16;XKR3                                                                                                                | 1.1168167|
|ESR1 30970003 ChIP-Seq MCF-7 Human BreastCancer         | 0.0779044|FHAD1;PKIB;ANXA3;LYPD6B;HPN;FN1;ANK2;WNT16;SYBU;VSIG10                                                                                            | 1.1084377|
|ETV1 20927104 ChIP-Seq GIST48 Human                     | 0.0808701|GBP6;C1QB;GBP5;C1QA;C4BPA;CACNA1E;GDF7;FHAD1;LYPD6B;COL4A3;ROR1;OTX1;FCGR1A;GBP1;ATF3;C1QC                                                        | 1.0922123|
|SMAD4 21741376 ChIP-Seq EPCs Human                      | 0.0861922|C1QA;KCNK17;WNT16;CACNA1E;VSIG10;DDO;ARL17B;FHAD1;ETV7;EPSTI1;PRR16;FFAR3;MMP19;SRGAP1;GBP1;ATF3                                                  | 1.0645318|
|STAT3 23295773 ChIP-Seq U87 Human                       | 0.0935024|CD274;MOXD1;WDR17;FN1;SLC1A3;C4BPA;ANK2;PARVA;PDCD1LG2;SYN2;LRP1B;MYOM2;GRIP1;PKIB;GRIN3A;PRR16;TMEM119;ROR1;CYYR1;FGF13;SRGAP1;CSMD1;CORIN;SOX5  | 1.0291775|
|TP53 16413492 ChIP-PET HCT116 Human                     | 0.1159241|WDR17;KCNK17;CACNA1E;ATF3                                                                                                                         | 0.9358264|
|CTNNB1 20460455 ChIP-Seq HCT116 Human                   | 0.1168058|FHAD1;LYPD6B;COL4A3;FN1;NRCAM;ANK2;WNT16;SYN2;C1QC                                                                                                | 0.9325355|
|POU3F2 20337985 ChIP-ChIP 501MEL Human                  | 0.1234462|MOXD1;FN1;SLC1A3;WNT16;LRP1B;PKIB;GRIN3A;CASP5;PRR16;SLITRK5;XKR3;CORIN;SOX5                                                                      | 0.9085221|
|P300 19829295 ChIP-Seq ESCs Human                       | 0.1359181|PLEKHG7;ANXA3;RFPL2;ANK2;ZFY;CACNA1E;ARL17B;FHAD1;LYPD6B;EPSTI1;PRR16;SLITRK5;FGF13;CSMD1;SOX5                                                    | 0.8667229|
|CBX2 22325352 ChIP-Seq 293T-Rex Human                   | 0.1364173|GBP6;C1QB;GBP5;C1QA;C4BPA;CACNA1E;LRP1B;GDF7;FHAD1;COL4A4;LYPD6B;ROR1;OTX1;ATF3;C1QC                                                              | 0.8651304|
|SMAD3 21741376 ChIP-Seq HESCs Human                     | 0.1427270|GRIP1;LYPD6B;EPSTI1;FN1;NRCAM;ANK2;ROR1;PARVA;FGF13;ATF3                                                                                          | 0.8454939|
|AR 19668381 ChIP-Seq PC3 Human                          | 0.1530380|GBP6;EIF1AY;ANXA3;USP9Y;FAM118A;KREMEN1;SLC1A3;ANK2;PARVA;IL27;SYN2;LRP1B;MYOM2;DDO;APOL4;GRIN3A;NOS1AP;EPSTI1;SLITRK5;NRCAM;ROR1;CSMD1;ATF3;SOX5 | 0.8152007|
|BACH1 22875853 ChIP-PCR HELA AND SCP4 Human             | 0.1557047|USP9Y;SLC1A3;SLITRK5;ROR1;UTY;PDCD1LG2;FGF13;SYN2;ATF3;MYOM2;SOX5                                                                                 | 0.8076983|

### 7.2. Transcription Factor (ChEA) Enrichment Analysis Plot
Transcription Factor (ChEA) enrichment analysis results, filtered - plot

![](/Users/nagarajanv/Downloads/IAN_results/report_template_archive_files/figure-gfm/chea_filtered_plot}-1.png)<!-- -->

### 7.3. ChEA LLM Agent Response

Agent 4:
**1. Summary of Enriched Transcription Factors:**

The ChEA analysis identified several significantly enriched transcription factors (TFs) among the differentially expressed genes (DEGs) in uveitis patients compared to healthy controls.  RELB, TFAP2C, and SMAD4 showed the most significant enrichment (p-values < 0.04).  These TFs are known to be involved in immune regulation, cell differentiation, and extracellular matrix (ECM) remodeling, aligning with the inflammatory nature of uveitis and the use of whole blood RNA-Seq. The enrichment of these TFs suggests a complex regulatory network underlying the observed gene expression changes in uveitis.


**2. Regulatory Network Analysis:**

Several TFs emerge as potential master regulators. RELB, a key component of the NF-κB pathway, is strongly implicated due to its association with genes like *GBP5* and *CD274*, both involved in immune responses.  These genes are enriched in pathways related to interferon signaling (Reactome, GO), complement activation (Reactome, WikiPathways, GO), and cell adhesion molecules (KEGG). SMAD4, a central player in the TGF-β signaling pathway, also shows significant enrichment and regulates genes involved in focal adhesion, ECM-receptor interaction, and cytoskeletal organization (KEGG, WikiPathways, Reactome).  The overlap of RELB and SMAD4 target genes in pathways like ECM-receptor interaction and cell adhesion molecules suggests a coordinated regulatory mechanism. TFAP2C, involved in cell differentiation and development, might play a more subtle role, influencing the cellular context of the immune response.

## 8. Protein-Protein Interaction



### 8.1. Protein-Protein Interaction Network Analysis
The genes with high interactions scores are scored for network properties and a combined score is calculated to identify important genes. Top 10 genes are shown below.


```
## ## Important Genes based on Network Properties
```

### 8.2. Protein-Protein Interaction Network Analysis Plot
Protein-Protein Interaction Network Analysis (STRING) results plot, filtered

![](/Users/nagarajanv/Downloads/IAN_results/report_template_archive_files/figure-gfm/string_filtered_analysis_plot}-1.png)<!-- -->

### 8.3. STRING LLM Agent Response

Agent 6:
**1. Summary of Interactions:**

The STRING analysis reveals a highly interconnected network of proteins, with several exhibiting high combined scores and prominent network properties.  Fibronectin (FN1), a key component of the extracellular matrix (ECM), emerges as a central hub, interacting extensively with proteins involved in cytoskeletal organization (MYOM2, ANK2), immune response (CD274, FCGR1A), and complement activation (C1QA, C1QB, C1QC).  ANKRD22, another highly connected node, shows strong interactions with multiple immune-related proteins, suggesting a role in immune regulation.  The high scores for interactions within the Y-chromosome gene cluster (UTY, KDM5D, USP9Y, DDX3Y, RPS4Y1, EIF1AY, ZFY) suggest a potential sex-specific component to the observed gene expression changes in uveitis patients compared to healthy controls.


**2. Key Interactions and Network Topology:**

Based on the combined network scores, FN1, ANKRD22, CD274, and the Y-chromosome gene cluster (UTY, KDM5D, USP9Y, DDX3Y, RPS4Y1, EIF1AY, ZFY) stand out as key proteins.  FN1's numerous interactions highlight its role as a central hub, connecting diverse functional modules.  Its interactions with MYOM2 suggest involvement in cytoskeletal remodeling within muscle cells, a finding supported by the "Cytoskeleton in muscle cells" KEGG pathway enrichment. ANKRD22's interactions with immune-related proteins (CD274, GBP5, IFI27, APOL4) suggest a role in modulating immune responses, consistent with its high network score. The strong interactions within the Y-chromosome gene cluster indicate a potential sex-specific influence on the observed gene expression changes.  The network displays a scale-free topology, characteristic of biological systems, with a few highly connected hub proteins (FN1, ANKRD22, CD274) and many proteins with fewer connections. This modular organization suggests that distinct functional modules interact to contribute to the overall phenotype of uveitis.


**4. Cross-Analysis:**

Several connections exist between the high-scoring proteins and the enriched pathways. FN1, COL4A3, and COL4A4 are present in multiple pathways related to ECM-receptor interaction, focal adhesion, and collagen biosynthesis. C1QA, C1QB, and C1QC are central to complement activation pathways. CD274 and PDCD1LG2 are key players in immune checkpoint pathways.  The Y-chromosome genes are not directly represented in the pathways, but their high connectivity suggests they may indirectly influence these processes.

Several ChEA transcription factors regulate genes involved in these interactions. RELB regulates GBP5 and CD274, both involved in immune responses. SMAD4 regulates FN1, ANK2, and ETV7, all involved in ECM remodeling and immune regulation. TFAP2C regulates several genes involved in immune regulation and cell signaling. POU5F1 regulates genes involved in development and cell differentiation. These transcription factors could be acting as upstream regulators of the observed interactions.


## 9. Full Integrated Network
The system representation from each of the 6 agents enrichment analysis responses are integrated to build the below network. This is the network that was used for deciphering the system model.

The nodes in blue are "Genes" found in our list of DEGs. The Nodes in yellow are either "Term/Concept" nodes or "Genes" not in our list of DEGs (coming from ChEA instead).




## 10. Download
Here is the list of all original results, along with filtered results, computed results, integrated results and LLM responses:

<a href='system_model.txt'>Click to open system_model.txt in new tab</a> <br><a href='final_response.txt'>Click to open final_response.txt in new tab</a> <br><a href='agent_responses.txt'>Click to open agent_responses.txt in new tab</a> <br><a href='kegg_enrichment_original.txt'>Click to open kegg_enrichment_original.txt in new tab</a> <br><a href='kegg_enrichment_filtered.txt'>Click to open kegg_enrichment_filtered.txt in new tab</a> <br><a href='wp_enrichment_original.txt'>Click to open wp_enrichment_original.txt in new tab</a> <br><a href='wp_enrichment_filtered.txt'>Click to open wp_enrichment_filtered.txt in new tab</a> <br><a href='reactome_enrichment_original.txt'>Click to open reactome_enrichment_original.txt in new tab</a> <br><a href='reactome_enrichment_filtered.txt'>Click to open reactome_enrichment_filtered.txt in new tab</a> <br><a href='chea_enrichment_original.txt'>Click to open chea_enrichment_original.txt in new tab</a> <br><a href='chea_enrichment_filtered.txt'>Click to open chea_enrichment_filtered.txt in new tab</a> <br><a href='string_interactions_original.txt'>Click to open string_interactions_original.txt in new tab</a> <br><a href='string_interactions_filtered.txt'>Click to open string_interactions_filtered.txt in new tab</a> <br><a href='string_network_properties.txt'>Click to open string_network_properties.txt in new tab</a> <br><a href='pathway_comparison.txt'>Click to open pathway_comparison.txt in new tab</a> <br><a href='integrated_network.txt'>Click to open integrated_network.txt in new tab</a> <br>

## 11. Analysis Parameters
The following parameters were used for this analysis:


```
## [1] "Experimental Design:"
```

```
## RNA-Seq data generated from peripheral, whole blood was used to identify differentially expressed genes between Uveitis patients and healthy controls.
```

```
## Parameters file not found. Please ensure 'analysis_parameters.txt' exists in the working directory.
```


## 12. Session Info


```
## R version 4.4.3 (2025-02-28)
## Platform: aarch64-apple-darwin20
## Running under: macOS Ventura 13.7.4
## 
## Matrix products: default
## BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
## LAPACK: /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.0
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## time zone: America/New_York
## tzcode source: internal
## 
## attached base packages:
## [1] stats4    stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] org.Hs.eg.db_3.20.0  AnnotationDbi_1.68.0 IRanges_2.40.1       S4Vectors_0.44.0     Biobase_2.66.0      
##  [6] BiocGenerics_0.52.0  igraph_2.1.4         ggh4x_0.3.0          kableExtra_1.4.0     knitr_1.50          
## [11] lubridate_1.9.4      forcats_1.0.0        stringr_1.5.1        dplyr_1.1.4          purrr_1.0.4         
## [16] tidyr_1.3.1          tibble_3.2.1         ggplot2_3.5.1        tidyverse_2.0.0      openxlsx_4.2.8      
## [21] rmarkdown_2.29       IAN_0.1.0            readr_2.1.5         
## 
## loaded via a namespace (and not attached):
##   [1] later_1.4.1             splines_4.4.3           bitops_1.0-9            ggplotify_0.1.2        
##   [5] R.oo_1.27.0             polyclip_1.10-7         graph_1.84.1            lifecycle_1.0.4        
##   [9] globals_0.16.3          lattice_0.22-6          vroom_1.6.5             MASS_7.3-65            
##  [13] magrittr_2.0.3          sass_0.4.9              remotes_2.5.0           jquerylib_0.1.4        
##  [17] yaml_2.3.10             plotrix_3.8-4           httpuv_1.6.15           ggtangle_0.0.6         
##  [21] zip_2.3.2               sessioninfo_1.2.3       pkgbuild_1.4.6          cowplot_1.1.3          
##  [25] DBI_1.2.3               RColorBrewer_1.1-3      pkgload_1.4.0           zlibbioc_1.52.0        
##  [29] R.utils_2.13.0          ggraph_2.2.1            hash_2.2.6.3            yulab.utils_0.2.0      
##  [33] WriteXLS_6.7.0          tweenr_2.0.3            rappdirs_0.3.3          GenomeInfoDbData_1.2.13
##  [37] enrichplot_1.26.6       ggrepel_0.9.6           listenv_0.9.1           tidytree_0.4.6         
##  [41] reactome.db_1.89.0      proto_1.0.0             parallelly_1.42.0       svglite_2.1.3          
##  [45] codetools_0.2-20        DOSE_4.0.0              xml2_1.3.8              ggforce_0.4.2          
##  [49] tidyselect_1.2.1        aplot_0.2.5             UCSC.utils_1.2.0        farver_2.1.2           
##  [53] viridis_0.6.5           webshot_0.5.5           roxygen2_7.3.2          jsonlite_1.9.1         
##  [57] ellipsis_0.3.2          tidygraph_1.3.1         progressr_0.15.1        systemfonts_1.2.1      
##  [61] tools_4.4.3             chron_2.3-62            ragg_1.3.3              treeio_1.30.0          
##  [65] Rcpp_1.0.14             glue_1.8.0              gridExtra_2.3           xfun_0.51              
##  [69] qvalue_2.38.0           usethis_3.1.0           GenomeInfoDb_1.42.3     withr_3.0.2            
##  [73] BiocManager_1.30.25     fastmap_1.2.0           caTools_1.18.3          digest_0.6.37          
##  [77] mime_0.13               timechange_0.3.0        R6_2.6.1                gridGraphics_0.5-1     
##  [81] textshaping_1.0.0       colorspace_2.1-1        GO.db_3.20.0            gtools_3.9.5           
##  [85] RSQLite_2.3.9           R.methodsS3_1.8.2       generics_0.1.3          data.table_1.17.0      
##  [89] graphlayouts_1.2.2      httr_1.4.7              htmlwidgets_1.6.4       sqldf_0.4-11           
##  [93] graphite_1.52.0         pkgconfig_2.0.3         gtable_0.3.6            blob_1.2.4             
##  [97] XVector_0.46.0          furrr_0.3.1             clusterProfiler_4.14.6  htmltools_0.5.8.1      
## [101] profvis_0.4.0           fgsea_1.32.2            scales_1.3.0            png_0.1-8              
## [105] enrichR_3.4             ggfun_0.1.8             rstudioapi_0.17.1       tzdb_0.5.0             
## [109] reshape2_1.4.4          rjson_0.2.23            visNetwork_2.1.2        nlme_3.1-167           
## [113] curl_6.2.1              cachem_1.1.0            KernSmooth_2.23-26      parallel_4.4.3         
## [117] miniUI_0.1.1.1          ReactomePA_1.50.0       pillar_1.10.1           grid_4.4.3             
## [121] vctrs_0.6.5             gplots_3.2.0            urlchecker_1.0.1        promises_1.3.2         
## [125] STRINGdb_2.18.0         xtable_1.8-4            evaluate_1.0.3          gsubfn_0.7             
## [129] cli_3.6.4               compiler_4.4.3          rlang_1.1.5             crayon_1.5.3           
## [133] labeling_0.4.3          plyr_1.8.9              fs_1.6.5                stringi_1.8.4          
## [137] viridisLite_0.4.2       BiocParallel_1.40.0     munsell_0.5.1           Biostrings_2.74.1      
## [141] lazyeval_0.2.2          devtools_2.4.5          GOSemSim_2.32.0         Matrix_1.7-3           
## [145] hms_1.1.3               patchwork_1.3.0         bit64_4.6.0-1           future_1.34.0          
## [149] shiny_1.10.0            KEGGREST_1.46.0         memoise_2.0.1           bslib_0.9.0            
## [153] ggtree_3.14.0           fastmatch_1.1-6         bit_4.6.0               ape_5.8-1              
## [157] gson_0.1.0
```
