<div class="container-fluid main-container">

<div class="row">

<div class="col-xs-12 col-sm-4 col-md-3">

<div id="TOC" class="tocify">

</div>

</div>

<div class="toc-content col-xs-12 col-sm-8 col-md-9">

<div id="header">

# FN1-centered immune dysregulation in uveitis pathogenesis

</div>

<div id="integrated-analysis-results" class="section level2">

## 1. Integrated Analysis Results

This report summarizes the results of a multi-agent-AI-system (IAN)
based analysis performed using the provided list of differentially
expressed genes. Results after IAN integrated all the individual agents
responses is provided below:

<div id="high-level-summary" class="section level3">

### 1.1. High-Level Summary

Uveitis pathogenesis involves a complex interplay between dysregulated
immune responses (complement activation, T cell co-stimulation,
interferon signaling), ECM remodeling, and potentially neuronal
dysfunction and infectious triggers. FN1, a central ECM component, acts
as a key hub, connecting immune, complement, and cytoskeletal processes.
RELB and SMAD4, as key transcription factors, orchestrate these
processes, regulating genes involved in inflammation and ECM remodeling.
The high connectivity of Y-chromosome genes suggests a potential
sex-specific component. Infectious triggers and neuronal dysfunction may
contribute to disease initiation or severity.

</div>

<div id="affected-biological-processes" class="section level3">

### 1.2. Affected Biological Processes

The integrated analysis reveals a complex interplay of immune
dysregulation, ECM remodeling, and potentially neuronal dysfunction and
infectious triggers in uveitis. The complement system (C1QA, C1QB, C1QC,
SERPING1, C4BPA) is consistently implicated across all analyses,
indicating a central role in initiating and amplifying inflammation. ECM
remodeling (FN1, COL4A3, COL4A4) is highlighted, suggesting alterations
in tissue structure contribute to the disease. Immune responses,
particularly T cell modulation (CD274, PDCD1LG2) and interferon
signaling (GBP1, GBP5, GBP6), are consistently enriched. Agent 2 and
Agent 3 highlight the involvement of infectious disease pathways and
neuronal signaling pathways, respectively, suggesting potential
contributing factors. Agent 4’s transcription factor analysis points to
RELB and SMAD4 as key regulators, influencing both immune response and
ECM remodeling. Agent 5’s GO term analysis reinforces the importance of
B and T cell mediated immunity and complement activation. Agent 6’s
STRING analysis identifies FN1 and ANKRD22 as central hubs, connecting
various functional modules. The high connectivity of Y-chromosome genes
suggests a potential sex-specific component.

</div>

<div id="potential-regulatory-networks" class="section level3">

### 1.3. Potential Regulatory Networks

ChEA analysis reveals RELB, SMAD4, and TFAP2C as significantly enriched
transcription factors. RELB, a key NF-κB component, regulates genes
involved in interferon signaling and complement activation (GBP5,
CD274). SMAD4, a central TGF-β effector, regulates genes involved in
ECM-receptor interaction and cell adhesion (FN1, COL4A3, COL4A4).
TFAP2C’s role appears more subtle, potentially influencing the cellular
context of the immune response. The overlap of RELB and SMAD4 target
genes in pathways like ECM-receptor interaction suggests a coordinated
regulatory mechanism. Novel interactions, such as TFAP2C’s association
with KCNK17 and NOS1AP, and POU5F1’s regulation of ROR1, warrant further
investigation. \* **NF-κB (RELB):** Master regulator of inflammation,
consistently implicated across analyses. \* **SMAD family (SMAD4):**
Crucial for TGF-β signaling, involved in ECM remodeling and immune
regulation. \* **STAT family:** Mediates cytokine signaling and immune
cell differentiation. \* **IRF family:** Essential for interferon
responses, relevant to the enriched immune and infectious disease
pathways. \* **AP-1:** Regulates cell proliferation, differentiation,
and inflammation.

</div>

<div id="potential-hub-genes" class="section level3">

### 1.4. Potential Hub Genes

Based on consistent appearance across multiple analyses (pathway
enrichments, GO terms, STRING network scores, ChEA results), the
following emerge as strong hub gene candidates:

- **FN1:** High STRING network score, multiple pathway enrichments (ECM,
  cell adhesion, inflammation).
- **CD274:** High STRING network score, multiple pathway enrichments (T
  cell co-stimulation, immune checkpoint).
- **C1QA, C1QB, C1QC:** High STRING network scores, multiple pathway
  enrichments (complement activation).
- **ANK2:** Multiple pathway enrichments (actin cytoskeleton, cardiac
  muscle), high STRING network score.

**Drug Target/Marker/Kinase/Ligand Analysis:**

- **FN1:** Not a direct drug target, but its role in ECM remodeling
  makes it a potential indirect target.
- **CD274:** Established drug target in cancer immunotherapy (anti-PD-L1
  antibodies).
- **C1QA, C1QB, C1QC:** Potential biomarkers for inflammation.
- **ANK2:** Not a known drug target. None of these are kinases or
  ligands.

</div>

<div id="similar-systems" class="section level3">

### 1.5. Similar Systems

Other inflammatory eye diseases (age-related macular degeneration,
diabetic retinopathy), systemic lupus erythematosus (SLE), and other
autoimmune diseases with complement dysregulation and ECM remodeling
show similarities.

</div>

<div id="novelty-exploration" class="section level3">

### 1.6. Novelty Exploration

The strong enrichment of infectious disease pathways (Agent 2) and
neuronal signaling pathways (Agent 3) in the context of uveitis, along
with the specific transcription factor-gene interactions identified by
ChEA (e.g., TFAP2C-KCNK17, POU5F1-ROR1), warrant further investigation
to determine their novelty.

</div>

<div id="download-full-analysis-report" class="section level3">

### 1.7. Download Full Analysis Report

Download the Full Integrated IAN Analysis Report Here:

[Open full final_response.txt text in new tab](final_response.txt)

</div>

</div>

<div id="system-model" class="section level2">

## 2. System Model

IAN takes the integrated full analysis report and the integrated system
network data from each of the agents response and puts forward a system
model, which includes the system overview, mechanistic model and an
hypothesis.

<div id="system-model-and-overview" class="section level3">

### 2.1. System Model and Overview

<div id="htmlwidget-7c7f74f2b10116d0b19d"
class="visNetwork html-widget html-fill-item"
style="width:672px;height:480px;">

</div>

The provided network depicts a complex interplay of genes and pathways
primarily involved in immune response, inflammation, and cell adhesion.
The differentially expressed genes (DEGs) identified via RNA-Seq in
peripheral blood from uveitis patients provide crucial context for
interpreting this network. The system appears to center around the
regulation of immune cell activity and extracellular matrix remodeling,
both key processes in inflammatory conditions like uveitis. Several
transcription factors and signaling molecules emerge as potential
upstream regulators influencing these processes.

</div>

<div id="mechanistic-model" class="section level3">

### 2.2. Mechanistic Model

The identified relationships suggest a mechanistic model where upstream
regulators like RELB, SMAD4, and ATF3 influence the uveitis phenotype
through their downstream targets. RELB’s regulation of GBP5 and CD274
suggests a modulation of interferon signaling and T cell activity,
potentially contributing to the inflammatory response. SMAD4’s influence
on FN1 suggests a role in regulating cell adhesion and tissue
remodeling, impacting the inflammatory environment. ATF3’s interactions
with both FN1 and CD274 suggest a role in integrating these processes.
The complement components (C1QA, C1QB) and FCGR1A further amplify the
inflammatory response and shape the adaptive immune response. The
interactions between these components suggest a complex interplay
between innate and adaptive immunity in the pathogenesis of uveitis.

</div>

<div id="hypothesis" class="section level3">

### 2.3. Hypothesis

The observed changes in gene expression in peripheral blood from uveitis
patients reflect a systemic dysregulation of immune responses and cell
adhesion processes. We hypothesize that dysregulation of RELB, SMAD4,
and ATF3 activity, potentially triggered by yet unidentified upstream
factors, leads to altered expression of their target genes (GBP5, CD274,
FN1), resulting in an amplified inflammatory response, impaired immune
regulation, and altered tissue remodeling, contributing to the
development and progression of uveitis. The complement system (C1QA,
C1QB) and the Fc receptor (FCGR1A) play crucial roles in amplifying the
inflammatory response and shaping the adaptive immune response. The
involvement of ANK2 suggests a role for cell migration in the
pathogenesis of the disease. The specific etiology of uveitis (e.g.,
genetic predisposition, infectious agents, autoimmune triggers) may
influence the specific pattern of DEG expression and the relative
contribution of these pathways. Further investigation is needed to
elucidate the precise upstream triggers and the specific molecular
mechanisms driving this dysregulation.

</div>

<div id="download-system-model-report" class="section level3">

### 2.4. Download System Model Report

Download the Full System Model Report Here:

[Open full system_model.txt text in new tab](system_model.txt)

</div>

</div>

<div id="kegg-enrichment" class="section level2">

## 3. KEGG Enrichment

IAN runs enrichment analysis, filters the significant terms, prepares
metadata and generates the LLM based agent response, analyzing the data
like a human expert.

<div id="kegg-enrichment-results" class="section level3">

### 3.1. Kegg Enrichment Results

KEGG pathway enrichment analysis results, filtered

<div pagedtable="false">

</div>

</div>

<div id="kegg-enrichment-analysis-plot" class="section level3">

### 3.2. Kegg Enrichment Analysis Plot

KEGG pathway enrichment analysis results, filtered - plot

<img src="report_template_files/figure-html/kegg_filtered_plot-1.png"
width="768" /><a href="kegg_enrichment_plot.png" download="">Download Plot as PNG</a>

</div>

<div id="kegg-llm-agent-response" class="section level3">

### 3.3. KEGG LLM Agent Response

Agent 2: **1. Summary and Categorization:**

The significantly enriched KEGG pathways primarily highlight the
involvement of the complement system, cell adhesion, and extracellular
matrix (ECM) interactions in the uveitis patient group compared to
healthy controls. These pathways are strongly interconnected, suggesting
a coordinated dysregulation in immune response and tissue remodeling
processes. Several pathways related to infectious diseases are also
significantly enriched, hinting at a potential role of infection or
microbial dysbiosis in uveitis pathogenesis.

**Categorization:**

- **Immune Response:** Complement and coagulation cascades,
  Staphylococcus aureus infection, Systemic lupus erythematosus,
  Pertussis, Coronavirus disease - COVID-19, Chagas disease (6 pathways)
- **Cell Adhesion and ECM:** Focal adhesion, ECM-receptor interaction,
  Cell adhesion molecules, Cytoskeleton in muscle cells, AGE-RAGE
  signaling pathway in diabetic complications, Amoebiasis, Small cell
  lung cancer (7 pathways)
- **Inflammatory Response:** Efferocytosis, Alcoholic liver disease (2
  pathways)
- **Other:** NOD-like receptor signaling pathway (1 pathway)

</div>

</div>

<div id="wikipathway-enrichment" class="section level2">

## 4. WikiPathway Enrichment

IAN runs enrichment analysis, filters the significant terms, prepares
metadata and generates the LLM based agent response, analyzing the data
like a human expert.

<div id="wikipathway-enrichment-results" class="section level3">

### 4.1. WikiPathway Enrichment Results

WikiPathway enrichment analysis results, filtered

<div pagedtable="false">

</div>

</div>

<div id="wikipathway-enrichment-analysis-plot" class="section level3">

### 4.2. WikiPathway Enrichment Analysis Plot

WikiPathway enrichment analysis results, filtered - plot

<img src="report_template_files/figure-html/wp_filtered_plot%7D-1.png"
width="768" /><a href="wp_enrichment_plot.png" download="">Download Plot as PNG</a>

</div>

<div id="wikipathway-llm-agent-response" class="section level3">

### 4.3. WikiPathway LLM Agent Response

Agent 1: **1. Summary and Categorization:**

The significantly enriched WikiPathways point towards a strong
involvement of the complement system and Wnt signaling in the
pathogenesis of uveitis in the studied patient population. Additionally,
pathways related to immune response, particularly T cell modulation and
cancer immunotherapy, are highlighted. These findings suggest a complex
interplay between inflammation, immune dysregulation, and potentially,
tissue remodeling processes.

**Categorization:**

- **Immune Response:** Nucleotide binding oligomerization domain NOD
  pathway, Allograft rejection, Microglia pathogen phagocytosis pathway,
  Cancer immunotherapy by PD-1 blockade, Complement system in neuronal
  development and plasticity, Complement activation, Complement and
  coagulation cascades (7 pathways)
- **Wnt Signaling:** Wnt signaling, lncRNA in canonical Wnt signaling
  and colorectal cancer, ncRNAs in Wnt signaling in hepatocellular
  carcinoma (3 pathways)
- **Tissue Remodeling/Cell Adhesion:** Epithelial to mesenchymal
  transition in colorectal cancer, Small cell lung cancer, Pleural
  mesothelioma (3 pathways)
- **Other:** Synaptic vesicle pathway, Oxidative damage response,
  Nephrotic syndrome, Development of ureteric derived collecting system,
  T cell modulation in pancreatic cancer (5 pathways)

</div>

</div>

<div id="reactome-enrichment" class="section level2">

## 5. Reactome Enrichment

<div id="reactome-pathways-enrichment-results" class="section level3">

### 5.1. Reactome Pathways Enrichment Results

Reactome Pathways enrichment analysis results, filtered

<div pagedtable="false">

</div>

</div>

<div id="reactome-pathways-enrichment-analysis-plot"
class="section level3">

### 5.2. Reactome Pathways Enrichment Analysis Plot

Reactome Pathways enrichment analysis results, filtered - plot

<img
src="report_template_files/figure-html/reactome_filtered_plot%7D-1.png"
width="672" />

</div>

<div id="reactome-pathways-llm-agent-response" class="section level3">

### 5.3. Reactome Pathways LLM Agent Response

Agent 3: **1. Summary and Categorization:**

The significantly enriched Reactome pathways in this Uveitis vs. control
whole blood transcriptomics study point towards dysregulation in several
interconnected biological processes. The top pathways highlight
alterations in neuronal signaling (neurotransmitter release, synaptic
transmission, and neuronal system), extracellular matrix (ECM)
remodeling (collagen degradation, ECM degradation, collagen
biosynthesis, and fibril assembly), complement activation, and histone
demethylation. These findings suggest a complex interplay between immune
response, neuronal function, and tissue structure in uveitis
pathogenesis.

**Categorization of Enriched Pathways:**

- **Immune System:** Complement cascade (4 pathways), Regulation of
  Complement cascade, Initial triggering of complement, Creation of C4
  and C2 activators.
- **Extracellular Matrix (ECM) Remodeling:** Formation of Fibrin Clot
  (Clotting Cascade), Collagen degradation, Degradation of the
  extracellular matrix, Collagen biosynthesis and modifying enzymes,
  Assembly of collagen fibrils and other multimeric structures, Integrin
  cell surface interactions, Anchoring fibril formation, Crosslinking of
  collagen fibrils, Laminin interactions, Non-integrin membrane-ECM
  interactions, ECM proteoglycans.
- **Neuronal System:** Neurotransmitter release cycle, Transmission
  across Chemical Synapses, Neuronal System, NCAM signaling for neurite
  out-growth, NCAM1 interactions.
- **Epigenetic Regulation:** HDMs demethylate histones

</div>

</div>

<div id="gene-ontology-enrichment" class="section level2">

## 6. Gene Ontology Enrichment

<div id="gene-ontology-enrichment-results" class="section level3">

### 6.1. Gene Ontology Enrichment Results

Gene Ontology enrichment analysis results, filtered

<div pagedtable="false">

</div>

</div>

<div id="gene-ontology-enrichment-analysis-plot" class="section level3">

### 6.2. Gene Ontology Enrichment Analysis Plot

Gene Ontology enrichment analysis results, filtered - plot - Top 20
Terms

<img src="report_template_files/figure-html/go_filtered_plot%7D-1.png"
width="672" />

</div>

<div id="go-llm-agent-response" class="section level3">

### 6.3. GO LLM Agent Response

Agent 5: **1. Summary and Categorization:**

The significantly enriched GO terms in this RNA-Seq analysis of uveitis
patients versus healthy controls strongly implicate immune system
dysregulation. Multiple GO terms related to B cell and T cell mediated
immunity, complement activation, and acute inflammatory responses are
highly enriched. This suggests a complex interplay of humoral and
cellular immune responses, along with innate immune activation,
contributing to uveitis pathogenesis.

**Categorization of Enriched GO Terms:**

- **Immune Response:** 20 terms (B cell mediated immunity, T cell
  costimulation, adaptive immune response, humoral immune response,
  immunoglobulin mediated immune response, leukocyte mediated immunity,
  lymphocyte mediated immunity, defense response to bacterium, defense
  response to protozoan, negative regulation of complement activation,
  negative regulation of humoral immune response, negative regulation of
  immune effector process, negative regulation of interleukin-10
  production, positive regulation of inflammatory response, regulation
  of adaptive immune response, regulation of immune effector process,
  regulation of humoral immune response)
- **Cell Movement and Contraction (actin-based):** 7 terms (actin
  filament-based movement, actin-mediated cell contraction, action
  potential, regulation of actin filament-based movement, regulation of
  action potential, positive regulation of cation channel activity,
  positive regulation of ion transmembrane transporter activity)
- **Complement Activation:** 3 terms (complement activation, complement
  activation, classical pathway, negative regulation of complement
  activation)
- **Cardiac Muscle Function:** 6 terms (cardiac muscle cell action
  potential, cardiac muscle cell contraction, cardiac muscle cell
  membrane repolarization, regulation of cardiac muscle cell action
  potential, regulation of cardiac muscle cell contraction, regulation
  of cardiac muscle cell membrane repolarization)

</div>

</div>

<div id="transcription-factor-enrichment" class="section level2">

## 7. Transcription Factor Enrichment

<div id="transcription-factor-chea-enrichment-results"
class="section level3">

### 7.1. Transcription Factor (ChEA) enrichment results

Transcription Factor (ChEA) enrichment analysis results, filtered

<div pagedtable="false">

</div>

</div>

<div id="transcription-factor-chea-enrichment-analysis-plot"
class="section level3">

### 7.2. Transcription Factor (ChEA) Enrichment Analysis Plot

Transcription Factor (ChEA) enrichment analysis results, filtered - plot

<img src="report_template_files/figure-html/chea_filtered_plot%7D-1.png"
width="672" />

</div>

<div id="chea-llm-agent-response" class="section level3">

### 7.3. ChEA LLM Agent Response

Agent 4: **1. Summary of Enriched Transcription Factors:**

The ChEA analysis identified several significantly enriched
transcription factors (TFs) among the differentially expressed genes
(DEGs) in uveitis patients compared to healthy controls. RELB, TFAP2C,
and SMAD4 showed the most significant enrichment (p-values \< 0.04).
These TFs are known to be involved in immune regulation, cell
differentiation, and extracellular matrix (ECM) remodeling, aligning
with the inflammatory nature of uveitis and the use of whole blood
RNA-Seq. The enrichment of these TFs suggests a complex regulatory
network underlying the observed gene expression changes in uveitis.

**2. Regulatory Network Analysis:**

Several TFs emerge as potential master regulators. RELB, a key component
of the NF-κB pathway, is strongly implicated due to its association with
genes like *GBP5* and *CD274*, both involved in immune responses. These
genes are enriched in pathways related to interferon signaling
(Reactome, GO), complement activation (Reactome, WikiPathways, GO), and
cell adhesion molecules (KEGG). SMAD4, a central player in the TGF-β
signaling pathway, also shows significant enrichment and regulates genes
involved in focal adhesion, ECM-receptor interaction, and cytoskeletal
organization (KEGG, WikiPathways, Reactome). The overlap of RELB and
SMAD4 target genes in pathways like ECM-receptor interaction and cell
adhesion molecules suggests a coordinated regulatory mechanism. TFAP2C,
involved in cell differentiation and development, might play a more
subtle role, influencing the cellular context of the immune response.

</div>

</div>

<div id="protein-protein-interaction" class="section level2">

## 8. Protein-Protein Interaction

<div id="protein-protein-interaction-network-analysis"
class="section level3">

### 8.1. Protein-Protein Interaction Network Analysis

The genes with high interactions scores are scored for network
properties and a combined score is calculated to identify important
genes. Top 10 genes are shown below.

    ## ## Important Genes based on Network Properties

<div pagedtable="false">

</div>

</div>

<div id="protein-protein-interaction-network-analysis-plot"
class="section level3">

### 8.2. Protein-Protein Interaction Network Analysis Plot

Protein-Protein Interaction Network Analysis (STRING) results plot,
filtered

<img
src="report_template_files/figure-html/string_filtered_analysis_plot%7D-1.png"
width="672" />

</div>

<div id="string-llm-agent-response" class="section level3">

### 8.3. STRING LLM Agent Response

Agent 6: **1. Summary of Interactions:**

The STRING analysis reveals a highly interconnected network of proteins,
with several exhibiting high combined scores and prominent network
properties. Fibronectin (FN1), a key component of the extracellular
matrix (ECM), emerges as a central hub, interacting extensively with
proteins involved in cytoskeletal organization (MYOM2, ANK2), immune
response (CD274, FCGR1A), and complement activation (C1QA, C1QB, C1QC).
ANKRD22, another highly connected node, shows strong interactions with
multiple immune-related proteins, suggesting a role in immune
regulation. The high scores for interactions within the Y-chromosome
gene cluster (UTY, KDM5D, USP9Y, DDX3Y, RPS4Y1, EIF1AY, ZFY) suggest a
potential sex-specific component to the observed gene expression changes
in uveitis patients compared to healthy controls.

**2. Key Interactions and Network Topology:**

Based on the combined network scores, FN1, ANKRD22, CD274, and the
Y-chromosome gene cluster (UTY, KDM5D, USP9Y, DDX3Y, RPS4Y1, EIF1AY,
ZFY) stand out as key proteins. FN1’s numerous interactions highlight
its role as a central hub, connecting diverse functional modules. Its
interactions with MYOM2 suggest involvement in cytoskeletal remodeling
within muscle cells, a finding supported by the “Cytoskeleton in muscle
cells” KEGG pathway enrichment. ANKRD22’s interactions with
immune-related proteins (CD274, GBP5, IFI27, APOL4) suggest a role in
modulating immune responses, consistent with its high network score. The
strong interactions within the Y-chromosome gene cluster indicate a
potential sex-specific influence on the observed gene expression
changes. The network displays a scale-free topology, characteristic of
biological systems, with a few highly connected hub proteins (FN1,
ANKRD22, CD274) and many proteins with fewer connections. This modular
organization suggests that distinct functional modules interact to
contribute to the overall phenotype of uveitis.

**4. Cross-Analysis:**

Several connections exist between the high-scoring proteins and the
enriched pathways. FN1, COL4A3, and COL4A4 are present in multiple
pathways related to ECM-receptor interaction, focal adhesion, and
collagen biosynthesis. C1QA, C1QB, and C1QC are central to complement
activation pathways. CD274 and PDCD1LG2 are key players in immune
checkpoint pathways. The Y-chromosome genes are not directly represented
in the pathways, but their high connectivity suggests they may
indirectly influence these processes.

Several ChEA transcription factors regulate genes involved in these
interactions. RELB regulates GBP5 and CD274, both involved in immune
responses. SMAD4 regulates FN1, ANK2, and ETV7, all involved in ECM
remodeling and immune regulation. TFAP2C regulates several genes
involved in immune regulation and cell signaling. POU5F1 regulates genes
involved in development and cell differentiation. These transcription
factors could be acting as upstream regulators of the observed
interactions.

</div>

</div>

<div id="full-integrated-network" class="section level2">

## 9. Full Integrated Network

The system representation from each of the 6 agents enrichment analysis
responses are integrated to build the below network. This is the network
that was used for deciphering the system model.

<div id="htmlwidget-81c91d68108c9545742f"
class="visNetwork html-widget html-fill-item"
style="width:768px;height:576px;">

</div>

</div>

<div id="download" class="section level2">

## 10. Download

Here is the list of all original results, along with filtered results,
computed results, integrated results and LLM responses:

[Click to open system_model.txt in new tab](system_model.txt)  
[Click to open final_response.txt in new tab](final_response.txt)  
[Click to open agent_responses.txt in new tab](agent_responses.txt)  
[Click to open kegg_enrichment_original.txt in new
tab](kegg_enrichment_original.txt)  
[Click to open kegg_enrichment_filtered.txt in new
tab](kegg_enrichment_filtered.txt)  
[Click to open wp_enrichment_original.txt in new
tab](wp_enrichment_original.txt)  
[Click to open wp_enrichment_filtered.txt in new
tab](wp_enrichment_filtered.txt)  
[Click to open reactome_enrichment_original.txt in new
tab](reactome_enrichment_original.txt)  
[Click to open reactome_enrichment_filtered.txt in new
tab](reactome_enrichment_filtered.txt)  
[Click to open chea_enrichment_original.txt in new
tab](chea_enrichment_original.txt)  
[Click to open chea_enrichment_filtered.txt in new
tab](chea_enrichment_filtered.txt)  
[Click to open string_interactions_original.txt in new
tab](string_interactions_original.txt)  
[Click to open string_interactions_filtered.txt in new
tab](string_interactions_filtered.txt)  
[Click to open string_network_properties.txt in new
tab](string_network_properties.txt)  
[Click to open pathway_comparison.txt in new
tab](pathway_comparison.txt)  
[Click to open integrated_network.txt in new
tab](integrated_network.txt)  

</div>

<div id="analysis-parameters" class="section level2">

## 11. Analysis Parameters

The following parameters were used for this analysis:

    ## [1] "Experimental Design:"

    ## RNA-Seq data generated from peripheral, whole blood was used to identify differentially expressed genes between Uveitis patients and healthy controls.

| Parameter | Value |
|:---|:---|
| experimental_design | RNA-Seq data generated from peripheral, whole blood was used to identify differentially expressed genes between Uveitis patients and healthy controls. |
| gene_type | ENSEMBL |
| organism | human |
| input_type | custom |
| deg_file | /Users/nagarajanv/OneDrive - National Institutes of Health/Research/smart-enrichment/Ian/Ianoriginal/data/uveitis-PIIS0002939421000271-deg.txt |
| pvalue | 0.05 |
| ont | BP |
| score_threshold | 0 |
| model | gemini-1.5-flash-latest |
| temperature | 0 |
| output_dir | IAN_results |

Analysis Parameters

</div>

<div id="session-info" class="section level2">

## 12. Session Info

    ## R version 4.4.1 (2024-06-14)
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
    ##  [1] IAN_0.1.0            igraph_2.0.3         ggh4x_0.3.0          kableExtra_1.4.0    
    ##  [5] knitr_1.48           lubridate_1.9.3      forcats_1.0.0        stringr_1.5.1       
    ##  [9] dplyr_1.1.4          purrr_1.0.2          readr_2.1.5          tidyr_1.3.1         
    ## [13] tibble_3.2.1         ggplot2_3.5.1        tidyverse_2.0.0      openxlsx_4.2.7.1    
    ## [17] rmarkdown_2.27       roxygen2_7.3.2       devtools_2.4.5       usethis_3.0.0       
    ## [21] future_1.34.0        enrichR_3.2          org.Hs.eg.db_3.19.1  AnnotationDbi_1.66.0
    ## [25] IRanges_2.38.1       S4Vectors_0.42.1     Biobase_2.64.0       BiocGenerics_0.50.0 
    ## 
    ## loaded via a namespace (and not attached):
    ##   [1] STRINGdb_2.16.4         fs_1.6.4                bitops_1.0-7            xopen_1.0.1            
    ##   [5] enrichplot_1.24.4       httr_1.4.7              RColorBrewer_1.1-3      profvis_0.3.8          
    ##   [9] tools_4.4.1             utf8_1.2.4              R6_2.5.1                lazyeval_0.2.2         
    ##  [13] urlchecker_1.0.1        withr_3.0.0             graphite_1.50.0         prettyunits_1.2.0      
    ##  [17] gridExtra_2.3           progressr_0.14.0        textshaping_0.4.0       cli_3.6.3              
    ##  [21] scatterpie_0.2.4        labeling_0.4.3          sass_0.4.9              systemfonts_1.1.0      
    ##  [25] yulab.utils_0.1.7       gson_0.1.0              svglite_2.1.3           DOSE_3.30.5            
    ##  [29] R.utils_2.12.3          parallelly_1.38.0       WriteXLS_6.6.0          sessioninfo_1.2.2      
    ##  [33] plotrix_3.8-4           rstudioapi_0.16.0       RSQLite_2.3.7           visNetwork_2.1.2       
    ##  [37] generics_0.1.3          gridGraphics_0.5-1      vroom_1.6.5             gtools_3.9.5           
    ##  [41] zip_2.3.1               GO.db_3.19.1            Matrix_1.7-0            fansi_1.0.6            
    ##  [45] R.methodsS3_1.8.2       lifecycle_1.0.4         yaml_2.3.9              gplots_3.1.3.1         
    ##  [49] qvalue_2.36.0           grid_4.4.1              blob_1.2.4              promises_1.3.0         
    ##  [53] crayon_1.5.3            miniUI_0.1.1.1          lattice_0.22-6          cowplot_1.1.3          
    ##  [57] KEGGREST_1.44.1         pillar_1.9.0            fgsea_1.30.0            rjson_0.2.21           
    ##  [61] codetools_0.2-20        fastmatch_1.1-4         glue_1.7.0              ggfun_0.1.5            
    ##  [65] data.table_1.15.4       remotes_2.5.0           vctrs_0.6.5             png_0.1-8              
    ##  [69] treeio_1.28.0           testthat_3.2.1.1        gtable_0.3.5            rcmdcheck_1.4.0        
    ##  [73] gsubfn_0.7              cachem_1.1.0            xfun_0.45               mime_0.12              
    ##  [77] tidygraph_1.3.1         ellipsis_0.3.2          nlme_3.1-164            ggtree_3.12.0          
    ##  [81] bit64_4.0.5             GenomeInfoDb_1.40.1     rprojroot_2.0.4         bslib_0.7.0            
    ##  [85] KernSmooth_2.23-24      colorspace_2.1-0        DBI_1.2.3               tidyselect_1.2.1       
    ##  [89] processx_3.8.4          bit_4.0.5               compiler_4.4.1          curl_6.0.1             
    ##  [93] chron_2.3-61            httr2_1.0.1             graph_1.82.0            xml2_1.3.6             
    ##  [97] desc_1.4.3              shadowtext_0.1.4        scales_1.3.0            caTools_1.18.2         
    ## [101] callr_3.7.6             rappdirs_0.3.3          digest_0.6.36           XVector_0.44.0         
    ## [105] htmltools_0.5.8.1       pkgconfig_2.0.3         highr_0.11              fastmap_1.2.0          
    ## [109] rlang_1.1.4             htmlwidgets_1.6.4       UCSC.utils_1.0.0        shiny_1.8.1.1          
    ## [113] farver_2.1.2            jquerylib_0.1.4         jsonlite_1.8.8          BiocParallel_1.38.0    
    ## [117] GOSemSim_2.30.2         R.oo_1.26.0             magrittr_2.0.3          GenomeInfoDbData_1.2.12
    ## [121] ggplotify_0.1.2         patchwork_1.2.0         munsell_0.5.1           Rcpp_1.0.12            
    ## [125] ape_5.8                 viridis_0.6.5           proto_1.0.0             furrr_0.3.1            
    ## [129] sqldf_0.4-11            stringi_1.8.4           ggraph_2.2.1            brio_1.1.5             
    ## [133] zlibbioc_1.50.0         MASS_7.3-60.2           plyr_1.8.9              pkgbuild_1.4.4         
    ## [137] parallel_4.4.1          listenv_0.9.1           ggrepel_0.9.5           Biostrings_2.72.1      
    ## [141] graphlayouts_1.2.0      splines_4.4.1           hash_2.2.6.3            hms_1.1.3              
    ## [145] ps_1.7.7                reshape2_1.4.4          pkgload_1.4.0           evaluate_0.24.0        
    ## [149] BiocManager_1.30.23     tzdb_0.4.0              tweenr_2.0.3            httpuv_1.6.15          
    ## [153] polyclip_1.10-6         ReactomePA_1.48.0       ggforce_0.4.2           xtable_1.8-4           
    ## [157] reactome.db_1.88.0      tidytree_0.4.6          later_1.3.2             ragg_1.3.2             
    ## [161] viridisLite_0.4.2       clusterProfiler_4.12.6  aplot_0.2.3             memoise_2.0.1          
    ## [165] timechange_0.3.0        globals_0.16.3

</div>

</div>

</div>

</div>
