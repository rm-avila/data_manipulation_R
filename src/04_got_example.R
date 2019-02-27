GoT_actors %>% 
  gather(season, time, -actor) %>% 
  group_by(actor, season) %>% 
  summarise(tot_time = sum(time)) %>%
  group_by(season) %>%
  arrange(desc(tot_time)) %>% 
  slice(1:5) %>% 
  ggplot(aes(x = actor, y = tot_time, label = actor, las = 2, fill = actor)) +
  geom_bar(stat = "identity") +
  facet_wrap(~season) +
  geom_text()

