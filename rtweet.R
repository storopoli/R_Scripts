library(rtweet)


# Authorization -----------------------------------------------------------

# api_key <- Sys.getenv("TWITTER_KEY")
# api_secret_key <- Sys.getenv("TWITTER_KEY_SECRET")
# access_token <- Sys.getenv("TWITTER_ACCESS_TOKEN")
# access_token_secret <- Sys.getenv("TWITTER_ACCESS_SECRET_TOKEN")

# token <- create_token(
#   app = "LabCidades",
#   consumer_key = api_key,
#   consumer_secret = api_secret_key,
#   access_token = access_token,
#   access_secret = access_token_secret)

get_token()


# Search Tweets -----------------------------------------------------------

rt <- search_tweets(
  "#paraisopolis", n = 250000, retryonratelimit = T, include_rts = T
)

rt <- search_fullarchive(
  "#paraisópolis", n = 250000, env_name = "dev",
  fromDate = "202001010000",
  toDate = "202008210000"
)

rt %>%
  ts_plot("days") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of #rstats Twitter statuses from past 9 days",
    subtitle = "Twitter status (tweet) counts aggregated using three-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )
