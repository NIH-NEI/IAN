# multi_agent_system_5.R

library(future)
library(furrr)
library(dplyr)
library(plyr)
library(stringr)
library(httr)
library(R6)
library(progressr)

# --- Gemini API Request Function ---
make_gemini_request <- function(prompt, temperature, max_output_tokens, api_key, model_query, delay_seconds) {
  req_body <- list(
    contents = list(
      parts = list(list(text = prompt))
    ),
    generationConfig = list(
      temperature = temperature,
      seed = 123456,
      maxOutputTokens = max_output_tokens
    )
  )
  
  response <- httr::POST(
    url = paste0("https://generativelanguage.googleapis.com/v1beta/models/", model_query),
    query = list(key = api_key),
    content_type_json(),
    encode = "json",
    body = req_body
  )
  
  Sys.sleep(delay_seconds)
  
  status_code <- status_code(response)
  if (status_code == 200) {
    candidates <- httr::content(response)$candidates
    if (length(candidates) > 0 && !is.null(candidates[[1]]$content$parts[[1]]$text)) {
      return(candidates[[1]]$content$parts[[1]]$text)
    } else {
      return("No response from Gemini")
    }
  } else {
    error_message <- paste0("Request failed with status code: ", status_code, ", message: ", httr::content(response)$error$message)
    message(error_message)
    return(list(error = error_message))
  }
}

Agent <- R6::R6Class(
  "Agent",
  public = list(
    id = NULL,
    prompt = NULL,
    prompt_type = NULL,  # Added prompt_type
    response = NULL,
    initialize = function(id, prompt, prompt_type) {  # Added prompt_type parameter
      self$id <- id
      self$prompt <- prompt
      self$prompt_type <- prompt_type # Initialize the prompt type here
    },
    get_response = function(make_gemini_request_func, temperature, max_output_tokens, api_key, model_query, delay_seconds) {
      self$response <- make_gemini_request_func(self$prompt, temperature, max_output_tokens, api_key, model_query, delay_seconds)
      return(self$response)
    }
  )
)

# --- Environment Class ---
Environment <- R6::R6Class(
  "Environment",
  public = list(
    agents = list(),
    initialize = function(prompts, prompt_types) { # Accepts prompt types
      num_agents <- length(prompts)
      for (i in 1:num_agents) {
        self$agents[[i]] <- Agent$new(i, prompts[[i]], prompt_types[[i]])  # Pass prompt type here
      }
    },
    run_agents = function(make_gemini_request_func, temperature, max_output_tokens, api_key, model_query, delay_seconds, num_workers, max_retries = 3) {
      plan(multisession, workers = num_workers)
      
      with_progress({
        p <- progressor(along = self$agents) # Create progressor
        results <- future_map(self$agents, function(agent) {
          
          cat(paste("Agent", agent$id, "is starting execution of", agent$prompt_type, "\n"))
          p(sprintf("Agent %d is starting execution of %s", agent$id, agent$prompt_type))
          
          retries <- 0
          response <- NULL
          while (retries <= max_retries) {
            response <- tryCatch({
              agent$get_response(make_gemini_request_func, temperature, max_output_tokens, api_key, model_query, delay_seconds)
            }, error = function(e) {
              cat(paste("Error during agent", agent$id, "execution:", e$message, "\n"))
              return(list(error = e$message))
            })
            
            if (is.list(response) && !is.null(response$error) && grepl("Request failed with status code: 503", response$error, fixed = TRUE)) {
              retries <- retries + 1
              cat(paste("Agent", agent$id, "returned 503 error. Retrying (attempt", retries, "of", max_retries, ")", "\n"))
              Sys.sleep(delay_seconds * 2) # Wait longer before retrying
            } else {
              break # Exit the loop if no 503 error or if successful
            }
          }
          
          if (retries > max_retries) {
            cat(paste("Agent", agent$id, "failed after", max_retries, "retries.", "\n"))
            return(list(agent_id = agent$id, response = list(error = "Failed after multiple retries")))
          } else {
            cat(paste("Agent", agent$id, "completed execution of", agent$prompt_type, "\n"))
            p(sprintf("Agent %d completed execution of %s", agent$id, agent$prompt_type))
            return(list(agent_id = agent$id, response = response))
          }
        }, .progress = FALSE) # Disable future_map's progress
      })
      
      plan(sequential)
      return(results)
    }
    )
)