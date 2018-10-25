library(twitteR)
library(tidyverse)

consumer_key <- read_rds("private_data/consumer_key.rds")
consumer_secret <- read_rds("private_data/consumer_secret.rds")
access_token <- read_rds("private_data/access_token.rds")
access_secret <- read_rds("private_data/access_secret.rds")

setup_twitter_oauth(consumer_key = consumer_key, 
                    consumer_secret = consumer_secret, 
                    access_token = access_token, 
                    access_secret = access_secret)
terms <- c("#elenao", "#haddad13")
since <- "2018-10-08"
until <- "2018-10-24"
save_to <- "data/haddad.csv"

parameters <- list("terms" = terms, 
                   "since" = since, 
                   "until" = until, 
                   "save_to" = save_to)

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
                           "until" = ymd(since) + days(i), 
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
  
  search_result <- twListToDF(search_result)
  write_csv(search_result, save_to, append = TRUE)
}

terms <- c("#bolsonaro17", "#elesim")
terms_search <- paste(terms, collapse = " OR ")

bolsonaro <- searchTwitter(terms_search, 
                           n = 3000, 
                           lang = "pt", 
                           since = "2018-10-08",
                           until = "2018-10-09",
                           retryOnRateLimit = 500)
bolsonaro <- twListToDF(bolsonaro)

write_csv(bolsonaro, "data/bolsonaro.csv", append = TRUE)