library(twitteR)
library(tidyverse)
library(skimr)
library(tidytext)
library(lubridate)
library(stringr)
library(scales)

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
                        n = 100000, 
                        lang = "pt", 
                        since = "2018-10-07",
                        retryOnRateLimit = 500)

haddad <- twListToDF(haddad)

write_csv(haddad, "data/haddad.csv", append = TRUE)

terms <- c("#bolsonaro17", "#elesim")
terms_search <- paste(terms, collapse = " OR ")

bolsonaro <- searchTwitter(terms_search, 
                           n = 100000, 
                           lang = "pt", 
                           since = "2018-10-07",
                           retryOnRateLimit = 500)
bolsonaro <- twListToDF(bolsonaro)

write_csv(bolsonaro, "data/bolsonaro.csv", append = TRUE)


haddad %>%
  as.tibble() %>% skim

bolsonaro %>%
  as.tibble() %>% skim

tweets <- bind_rows(haddad %>%
                      mutate(person = "Haddad"),
                    bolsonaro %>%
                      mutate(person = "Bolsonaro"))

stop_words <- read_lines("data/final_stopwords.txt")
stop_words_total <- unique(c(tm::stopwords('en'),
                             tm::stopwords('SMART'),
                             tm::stopwords('pt'),
                             stop_words))

remove_reg <- "&amp;|&lt;|&gt;"

tidy_tweets <- tweets %>% 
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_remove_all(text, remove_reg)) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words_total,
         !word %in% str_remove_all(stop_words_total, "'"),
         str_detect(word, "[a-z]"))

frequency <- tidy_tweets %>% 
  group_by(person) %>% 
  count(word, sort = TRUE) %>% 
  left_join(tidy_tweets %>% 
              group_by(person) %>% 
              summarise(total = n())) %>%
  mutate(freq = n/total)
