#ground.R

################ chea genes extraction

# Read the data from the b.txt file
data <- read.delim("IAN_results_for_evaluation_uv/chea_enrichment_filtered.txt", sep="\t", header=TRUE, stringsAsFactors = FALSE)

# Extract genes from the "Genes" column
genes_list <- strsplit(data$Genes, ";")

# Extract genes from the "Term" column (extract the first word)
term_genes <- sapply(data$Term, function(x) strsplit(x, " ")[[1]][1])

# Combine all genes into a single vector
all_genes <- c(term_genes, unlist(genes_list))

# Remove any leading/trailing whitespace and convert to uppercase
all_genes <- trimws(toupper(all_genes))

# Remove duplicates
unique_genes <- unique(all_genes)

# Print the unique genes
print(unique_genes)

# Print the number of unique genes
cat("Number of unique genes:", length(unique_genes), "\n")


write.table(unique_genes, file = "uv-chea-symbols.txt", sep = "\t", row.names = FALSE, quote = FALSE)

################# WP/reactome terms extractions

# Read the data from the hi.txt file
text <- readLines("IAN_results_for_evaluation_uv/agent_responses.txt")

# Use regular expression to find WikiPathways entries (WP followed by digits)
wikipathways <- grep("WP[0-9]+", text, value = TRUE)

# Extract the WikiPathways IDs using regular expression
wikipathway_ids <- unique(unlist(regmatches(wikipathways, gregexpr("WP[0-9]+", wikipathways))))

# Use regular expression to find Reactome pathways entries (R-HSA followed by digits)
reactome_pathways <- grep("R-HSA-[0-9]+", text, value = TRUE)

# Extract the Reactome pathways IDs using regular expression
reactome_pathway_ids <- unique(unlist(regmatches(reactome_pathways, gregexpr("R-HSA-[0-9]+", reactome_pathways))))

# Combine WikiPathways and Reactome pathways IDs
all_pathway_ids <- c(wikipathway_ids, reactome_pathway_ids)

# Remove duplicates from the combined list
unique_pathway_ids <- unique(all_pathway_ids)

# Print the unique pathway IDs
print(unique_pathway_ids)

# Print the number of unique pathway IDs
cat("Number of unique pathway IDs:", length(unique_pathway_ids), "\n")

write.table(unique_pathway_ids, file = "uv-pathway-terms.txt", sep = "\t", row.names = FALSE, quote = FALSE)

######################



