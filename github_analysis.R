#https://tbradley1013.github.io/2020/01/02/analyzing-my-2019-github-usage-in-r/
library(tidyverse)
library(gh)
library(lubridate)
library(glue)
library(furrr)
plan(multisession)

# Getting Repos
repos <- gh("/user/repos", .limit = Inf)
repo_info <- tibble(
  owner = map_chr(repos, c("owner", "login")),
  name = map_chr(repos, "name"),
  full_name = map_chr(repos, "full_name"),
  private = map_lgl(repos, "private")
)

repo_info %>% 
  filter(!private)

# Get and Parse Commits
null_list <- function(x){
  future_map_chr(x, ~{ifelse(is.null(.x), NA, .x)})
}

parse_commit <- function(commits, repo){
  # browser()
  commit_by <- future_map(commits, c("commit", "author", "name"))
  username <- future_map(commits, c("committer", "login"))
  commit_time <- future_map(commits, c("commit", "author", "date"))
  message <- future_map(commits, c("commit", "message"))
  
  out <- tibble(
    repo = repo,
    commit_by = null_list(commit_by),
    username = null_list(username),
    commit_time = null_list(commit_time),
    message = null_list(message)
  )
  
  out <- mutate(out, commit_time = as.POSIXct(commit_time, format = "%Y-%m-%dT%H:%M:%SZ"))
  return(out)
}

gh_safe <- purrr::possibly(gh, otherwise = NULL)

all_commits <- future_map_dfr(repo_info$full_name, function(z){
  name_split <- str_split(z, "/")
  owner <- name_split[[1]][1]
  repo <- name_split[[1]][2]
  
  repo_commits <- gh_safe("/repos/:owner/:repo/commits", owner = owner, 
                          repo = repo, author = "storopoli",
                          since = "2017-01-01T00:00:00Z",
                          until = "2021-01-01T00:00:00Z",  ## Change this
                          .limit = Inf)
  
  out <- parse_commit(repo_commits, repo = z)
  
  return(out)
})


my_commits <- all_commits %>% 
  filter(commit_by %in% c("Jose Storopoli", "storopoli", "Storopoli"))

my_commits

# Analyzing the Results
my_commits <- my_commits %>% 
  mutate(
    date = date(commit_time),
    wday = wday(date, label = TRUE),
    year = year(date),
    week = week(date)
  ) %>% 
  left_join(
    repo_info, 
    by = c("repo" = "full_name")
  )

my_commits %>% 
  count(year) %>% 
  ggplot(aes(as.character(year), n)) + 
  geom_col() + 
  geom_text(aes(y = (n-3), label = paste(n, "commits")), color = "white", fontface = "bold") + 
  theme_bw() + 
  scale_y_continuous() + 
  scale_x_discrete() + 
  labs(
    title = "Commits by Jose Storopoli (storopoli) since joining GitHub by Year",
    y = "Number of Commits",
    x = NULL)

my_commits  %>% 
  count(year, private) %>% 
  mutate(private = ifelse(private, "Private", "Public"),
         year = factor(year, levels = unique(year))) %>% 
  ggplot(aes(year, n, fill = private)) + 
  geom_col(position = "dodge") + 
  #geom_text(aes(n-3, label = paste(n, "commits")), color = "white", fontface = "bold") +
  theme_bw() + 
  # ggsci::scale_f
  scale_y_continuous() + 
  scale_x_discrete() +
  labs(
    title = "Number of GitHub Commits by Jose Storopoli (storopoli) to Public and Private Repos by Year",
    y = "Number of Commits",
    x = NULL) 

my_commits %>% 
  count(date, wday, year, week) %>% 
  mutate(
    week = factor(week),
    wday = fct_rev(wday)
  ) %>% 
  group_by(year, week) %>% 
  mutate(
    min_date = floor_date(date, "week"), 
    min_date = if_else(
      year(min_date) < year, 
      as.Date(str_replace(min_date, as.character(year-1), "1999")),
      as.Date(str_replace(min_date, as.character(year), "2000"))
    )
    
  ) %>% 
  ungroup() %>% 
  ggplot(aes(min_date, wday, fill = n)) + 
  facet_wrap(~year, ncol = 1) +
  geom_tile(width = 5, height = 0.9, color = "black") + 
  theme_bw() + 
  scale_y_discrete(expand = c(0,0)) + 
  scale_x_date(date_breaks = "1 month", date_labels = "%b", expand = c(0, 0)) +
  labs(
    title = "Jose Storopoli (storopoli) GitHub contributions heat map by year"
  ) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_blank(),
    legend.title = element_blank()
  ) + 
  scale_fill_gradient(low = "#dcffe4", high = "#28a745")


my_commits %>% 
  filter(year == 2020) %>% 
  mutate(
    hour = hour(commit_time)
  ) %>% 
  count(hour) %>% 
  #mutate(
    #text_y = ifelse(n < 50, n+5, n-5),
    #text_color = ifelse(n < 50, "black", "white")
  #) %>% 
  ggplot(aes(hour, n)) + 
  geom_col() + 
  #geom_text(aes(y = text_y, color = text_color, label = paste("n =", n)), show.legend = FALSE, size = 3) + 
  theme_bw() + 
  scale_x_continuous(breaks = seq(0, 23, 2), labels = seq(0, 23, 2)) +
  scale_y_continuous() +
  scale_color_manual(values = c("black", "white")) + 
  labs(
    title = "Commits by Jose Storopoli (storopoli) in 2020 by time of day",
    y = "Number of Commits",
    x = "Time of Day (Hour)"
  )

my_commits %>% 
  filter(year == 2019) %>% 
  count(wday) %>% 
  ggplot(aes(wday, n)) + 
  geom_col() + 
  #geom_text(aes(y = n-10, label = paste("n =", n)), color = "white", show.legend = FALSE) + 
  theme_bw() +
  scale_y_continuous() +
  scale_color_manual(values = c("black", "white")) + 
  labs(
    title = "Commits by Jose Storopoli (storopoli) in 2020 by day of the week",
    y = "Number of Commits",
    x = "Day of the week"
  )
