library(twitteR)
library(tidyverse)
library(skimr)

consumer_key <- read_rds("private_data/consumer_key.rds")
consumer_secret <- read_rds("private_data/consumer_secret.rds")
access_secret <- read_rds("private_data/access_secret.rds")
access_secret <- read_rds("private_data/access_secret.rds")

setup_twitter_oauth(consumer_key = consumer_key, 
                    consumer_secret = consumer_secret, 
                    access_token = access_token, 
                    access_secret = access_secret)

terms <- c("#elenao", "#haddad13")
terms_search <- paste(terms, collapse = " OR ")

haddad <- searchTwitter(terms_search, n=1000, lang="pt", since = "2018-10-07")
haddad <- twListToDF(haddad)

haddad %>%
  as.tibble() %>% skim

