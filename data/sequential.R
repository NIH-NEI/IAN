# --- New Section: Sequential LLM Prompting ---
cat("\n--- Sequential LLM Prompting Results ---\n")

# Initialize string_interactions_seq outside the loop
string_interactions_seq <- NULL

# --- Generate Prompts ---
initial_tasks_seq <- lapply(names(enrichment_results), function(func_name) {
  func <- enrichment_results[[func_name]]
  
  if (func_name == "perform_chea_enrichment") {
    gene_input <- gene_mapping$SYMBOL
    res <- func(gene_input, organism = organism)
  } else if (func_name == "perform_string_interactions") {
    res <- func(gene_mapping, organism = organism)
    string_interactions_seq <<- res # Store string interactions
  } else {
    gene_input <- gene_mapping$ENTREZID
    res <- func(gene_input, gene_mapping, organism = organism)
  }
  
  # Get the appropriate prompt generation function
  prompt_func <- prompt_functions[[func_name]]
  
  # Call the prompt function with the correct arguments
  if (func_name == "perform_string_interactions") {
    prompt <- prompt_func(res, func_name)
    return(prompt)
  } else {
    return(prompt_func(res, func_name))
  }
})

# --- Get Sequential LLM Responses ---
responses_seq <- get_sequential_llm_responses(initial_tasks_seq, make_gemini_request, temperature, max_output_tokens, api_key, model_query, delay_seconds)

# Create combined prompt
combined_prompt_seq <- create_combined_prompt(responses_seq, gene_symbols, string_interactions_seq)

# Make final request to LLM
final_response_seq <- make_gemini_request(combined_prompt_seq, temperature, max_output_tokens, api_key, model_query, delay_seconds)

# Save agent responses to a file
agent_response_file_seq <- file.path(output_dir_path, "agent_responses_seq.txt")

tryCatch({
  # Open the file connection
  file_conn_seq <- file(agent_response_file_seq, "w")
  
  # Write agent responses
  for (i in seq_along(responses_seq)) {
    cat(paste0("Agent ", responses_seq[[i]]$prompt_id, ":\n"), file = file_conn_seq)
    if (is.null(responses_seq[[i]]$response)) {
      cat("Task failed.\n\n", file = file_conn_seq)
    } else if (is.list(responses_seq[[i]]$response) && "error" %in% names(responses_seq[[i]]$response)) {
      cat(paste("Error:", responses_seq[[i]]$response$message), "\n\n", file = file_conn_seq)
    } else if (is.null(responses_seq[[i]]$response) || responses_seq[[i]]$response == "No response from Gemini") {
      cat("No response from Gemini.\n\n", file = file_conn_seq)
    } else {
      cat(responses_seq[[i]]$response, "\n\n", file = file_conn_seq)
    }
  }
  
  # Close the file connection
  close(file_conn_seq)
  
  message(paste("Sequential agent responses saved to:", agent_response_file_seq))
}, error = function(e) {
  message(paste("Error saving sequential agent responses:", e$message))
})

# Save final response to a separate file
final_response_file_seq <- file.path(output_dir_path, "final_response_seq.txt")
tryCatch({
  file_conn_final_seq <- file(final_response_file_seq, "w")
  on.exit(close(file_conn_final_seq), add = TRUE)
  
  if (is.list(final_response_seq)) {
    if ("error" %in% names(final_response_seq)) {
      cat(paste("Error:", final_response_seq$error), "\n", file = file_conn_final_seq)
    } else {
      cat("Final response is a list, but no error message found.\n", file = file_conn_final_seq)
    }
  } else {
    cat(final_response_seq, file = file_conn_final_seq)
  }
  message(paste("Sequential final response saved to:", final_response_file_seq))
}, error = function(e) {
  message(paste("Error saving sequential final response:", e$message))
})

# Print results
for (i in seq_along(responses_seq)) {
  cat(paste0("Agent ", responses_seq[[i]]$prompt_id, ":\n"))
  if (is.null(responses_seq[[i]]$response)) {
    cat("Task failed.\n\n")
  } else if (is.list(responses_seq[[i]]$response) && "error" %in% names(responses_seq[[i]]$response)) {
    cat(paste("Error:", responses_seq[[i]]$response$message), "\n\n")
  } else if (is.null(responses_seq[[i]]$response) || responses_seq[[i]]$response == "No response from Gemini") {
    cat("No response from Gemini.\n\n")
  } else {
    cat(responses_seq[[i]]$response, "\n\n")
  }
}
cat(paste0("Sequential Final Response:\n"))
if (is.list(final_response_seq)) {
  if ("error" %in% names(final_response_seq)) {
    cat(paste("Error:", final_response_seq$error), "\n")
  } else {
    cat("Final response is a list, but no error message found.\n")
  }
} else {
  cat(final_response_seq, "\n\n")
}

