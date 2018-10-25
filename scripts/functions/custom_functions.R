library(twitteR)
library(tidyverse)

make_params_list <- function(terms,
                             since,
                             until,
                             save_to){
  library(lubridate)
  interv <- interval(ymd(since),ymd(until))
  n_params <- as.period(interv) %>% day()
  params_list <- rep(list(list()), n_params)
  for (i in 1:n_params) {
    params_list[[i]] <- list("terms" = terms, 
                             "since" = since, 
                             "until" = as.character(ymd(since) + days(i)), 
                             "save_to" = save_to)
  }
  return(params_list)
}

extract_tweets <- function(params) {
  terms <- params$terms
  since <- params$since
  until <- params$until
  save_to <- params$save_to
  terms_search <- paste(terms, collapse = " OR ")
  
  search_result <- searchTwitter(terms_search, 
                                 n = 3000, 
                                 lang = "pt", 
                                 since = since,
                                 until = until,
                                 retryOnRateLimit = 500)
  
  if (length(search_result) != 0){
    search_result <- twListToDF(search_result)
    write_csv(search_result, save_to, append = TRUE)
  }
}