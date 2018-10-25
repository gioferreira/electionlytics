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
terms_search <- paste(terms, collapse = " OR ")

haddad <- searchTwitter(terms_search, 
                        n = 3000, 
                        lang = "pt", 
                        since = "2018-10-08",
                        until = "2018-10-09",
                        retryOnRateLimit = 500)

haddad <- twListToDF(haddad)

write_csv(haddad, "data/haddad.csv", append = TRUE)

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