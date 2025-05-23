% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/IAN_network_prompt_generator.R
\name{generate_network_revision_prompt}
\alias{generate_network_revision_prompt}
\title{IAN_network_prompt_generator.R}
\usage{
generate_network_revision_prompt(
  file_path,
  gene_symbols,
  experimental_design = NULL,
  string_results = NULL
)
}
\arguments{
\item{file_path}{Character string specifying the path to the text file.}

\item{gene_symbols}{A vector of gene symbols used in the analysis.}

\item{experimental_design}{A character string describing the experimental design (optional).}

\item{string_results}{A list containing STRING protein-protein interaction data (optional).}
}
\value{
A character string containing the LLM prompt, or NULL if the network data is invalid or the file cannot be processed.

A data frame containing the combined TSV data, or NULL if no valid TSV blocks are found or the file cannot be processed.
}
\description{
Generates a prompt for a Large Language Model (LLM) to revise a system representation network,
integrating information from STRING protein-protein interaction data and experimental design.
}
