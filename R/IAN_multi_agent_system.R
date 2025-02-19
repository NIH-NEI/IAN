#' IAN_multi_agent_system.R
#'
#' This script defines a multi-agent system where agents interact with the Gemini API to generate responses based on predefined prompts.
#' It includes functions for making API requests, defining agent behavior, and managing the environment in which agents operate.
#'
#' @section Functions:
#' \describe{
#'   \item{\code{\link{make_gemini_request}}}{: Sends a request to the Gemini API with a given prompt and configuration.}
#' }

#' @section Classes:
#' \describe{
#'   \item{\code{\link{Agent}}}{: Represents an agent in the multi-agent system.}
#'   \item{\code{\link{Environment}}}{: Represents the environment in which the agents operate.}
#' }
#'
#' @importFrom future plan
#' @importFrom furrr future_map
#' @importFrom progressr with_progress progressor
#' @name multi_agent_system
#' @docType package
#' 
#' Make Gemini API Request
#'
#' Sends a request to the Gemini API with a given prompt and configuration.
#'
#' @param prompt Character string containing the prompt to send to the Gemini API.
#' @param temperature Numeric value controlling the randomness of the response.
#' @param max_output_tokens Integer specifying the maximum number of tokens in the response.
#' @param api_key Character string containing the Gemini API key.
#' @param model_query Character string specifying the model to query.
#' @param delay_seconds Numeric value specifying the delay in seconds after sending the request.
#'
#' @return Character string containing the response from the Gemini API, or a list with an "error" element if the request fails.
#'
#' @importFrom httr POST content_type_json encode content status_code
#' @importFrom stringr paste0
#' @export
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

#' Agent Class
#'
#' Represents an agent in the multi-agent system.
#'
#' @export
Agent <- R6::R6Class(
  "Agent",
  public = list(
    id = NULL,
    prompt = NULL,
    prompt_type = NULL,  # Added prompt_type
    response = NULL,
    #' @param id The ID of the agent.
    #' @param prompt The prompt for the agent.
    #' @param prompt_type The type of prompt for the agent.
    initialize = function(id, prompt, prompt_type) {  # Added prompt_type parameter
      self$id <- id
      self$prompt <- prompt
      self$prompt_type <- prompt_type # Initialize the prompt type here
    },
    #' @description
    #' Gets the response from the Gemini API.
    #' @param make_gemini_request_func The function to make the Gemini API request.
    #' @param temperature Numeric value controlling the randomness of the response.
    #' @param max_output_tokens Integer specifying the maximum number of tokens in the response.
    #' @param api_key Character string containing the Gemini API key.
    #' @param model_query Character string specifying the model to query.
    #' @param delay_seconds Numeric value specifying the delay in seconds after sending the request.
    #' @return The response from the Gemini API.
    get_response = function(make_gemini_request_func, temperature, max_output_tokens, api_key, model_query, delay_seconds) {
      self$response <- make_gemini_request_func(self$prompt, temperature, max_output_tokens, api_key, model_query, delay_seconds)
      return(self$response)
    }
  )
)

#' Environment Class
#'
#' Represents the environment in which the agents operate.
#'
#' @export
Environment <- R6::R6Class(
  "Environment",
  public = list(
    agents = list(),
    #' @param prompts A list of prompts for the agents.
    #' @param prompt_types A list of prompt types for the agents.
    initialize = function(prompts, prompt_types) { # Accepts prompt types
      num_agents <- length(prompts)
      for (i in 1:num_agents) {
        self$agents[[i]] <- Agent$new(i, prompts[[i]], prompt_types[[i]])  # Pass prompt type here
      }
    },
    #' @description
    #' Runs the agents in the environment.
    #' @param make_gemini_request_func The function to make the Gemini API request.
    #' @param temperature Numeric value controlling the randomness of the response.
    #' @param max_output_tokens Integer specifying the maximum number of tokens in the response.
    #' @param api_key Character string containing the Gemini API key.
    #' @param model_query Character string specifying the model to query.
    #' @param delay_seconds Numeric value specifying the delay in seconds after sending the request.
    #' @param num_workers Integer specifying the number of workers to use for parallel execution.
    #' @param max_retries Integer specifying the maximum number of retries for each agent.
    #' @return A list of results from the agents.
    #'
    #' @importFrom future plan
    #' @importFrom furrr future_map
    #' @importFrom progressr with_progress progressor
run_agents = function(make_gemini_request_func, temperature, max_output_tokens, api_key, model_query, delay_seconds, num_workers, max_retries = 3) {
  library(future)
  future::plan(multisession, workers = num_workers)
  
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
  
  future::plan(sequential) # Use future::plan
  return(results)
}
    
  )
)