library(tidyverse)
library(furrr)
library(rvest)

get_data <- function(link) {
  link <- read_html(link)
  name <- link %>% 
    html_node("h2") %>% 
    html_text()
  country <- link %>% 
    html_node(".flag") %>% 
    html_attr("alt") %>% 
    str_extract(., "[\\w-]+")
  description <- link %>% 
    html_node("p:nth-child(1)") %>% 
    html_text()
  langs <- link %>% 
    html_node("p:nth-child(2)") %>% 
    html_text() %>% 
    str_trim() %>% 
    str_remove("^.*:") %>% 
    str_trim() %>% 
    str_split(", ")
  return(tibble(
    name,
    country,
    description,
    langs
  ))
}

links <- read_html("https://education.rstudio.com/trainers/") %>% 
  html_nodes("#people a") %>% 
  html_attr("href") %>% 
  str_c("https://education.rstudio.com", .) %>%
  unique()

df <- future_map_dfr(links, get_data)

df %>% count(country) %>% arrange(-n)

df %>% filter(country == "brazil")
