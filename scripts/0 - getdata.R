source("scripts/functions/custom_functions.R")

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

params_list <- make_params_list(terms = terms,
                                since = since,
                                until = until,
                                save_to = save_to)

map(params_list, extract_tweets)

terms <- c("#bolsonaro17", "#elesim")
since <- "2018-10-08"
until <- "2018-10-24"
save_to <- "data/bolsonaro.csv"

params_list <- make_params_list(terms = terms,
                                since = since,
                                until = until,
                                save_to = save_to)

map(params_list, extract_tweets)