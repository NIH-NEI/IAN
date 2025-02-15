# llmresponses.R

# --- Function to send prompts sequentially to Gemini ---
get_sequential_llm_responses <- function(prompts, make_gemini_request_func, temperature, max_output_tokens, api_key, model_query, delay_seconds) {
  responses <- list()
  for (i in seq_along(prompts)) {
    prompt <- prompts[[i]]
    response <- make_gemini_request_func(prompt, temperature, max_output_tokens, api_key, model_query, delay_seconds)
    responses[[i]] <- list(prompt_id = i, response = response)
  }
  return(responses)
}