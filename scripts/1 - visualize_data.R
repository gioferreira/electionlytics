

haddad <- read_csv("data/haddad.csv")
bolsonaro <- read_csv("data/bolsonaro.csv")

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

frequency <- frequency %>% 
  select(person, word, freq) %>% 
  spread(person, freq) %>%
  arrange(Bolsonaro, Haddad)

ggplot(frequency, aes(Bolsonaro, Haddad)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red")


word_ratios <- tidy_tweets %>%
  filter(!str_detect(word, "^@")) %>%
  count(word, person) %>%
  group_by(word) %>%
  filter(sum(n) >= 10) %>%
  ungroup() %>%
  spread(person, n, fill = 0) %>%
  mutate_if(is.numeric, funs((. + 1) / (sum(.) + 1))) %>%
  mutate(logratio = log(Bolsonaro / Haddad)) %>%
  arrange(desc(logratio))


word_ratios %>% 
  arrange(abs(logratio))


word_ratios %>%
  group_by(logratio < 0) %>%
  top_n(20, abs(logratio)) %>%
  ungroup() %>%
  mutate(word = reorder(word, logratio)) %>%
  ggplot(aes(word, logratio, fill = logratio < 0)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  ylab("log odds ratio (Bolsonaro/Haddad)") +
  scale_fill_discrete(name = "", labels = c("Bolsonaro", "Haddad"))
