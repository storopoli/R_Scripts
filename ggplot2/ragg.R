#install.packages("ragg")
library(ggplot2)
library(ragg)
arabic_text <- "هذا مكتوب باللغة العربية"
hebrew_text <- "זה כתוב בעברית"
sindhi_text <- "هي سنڌيءَ ۾ لکيو ويو آهي"

ggplot() +
  geom_text(
    aes(x = 0, y = 3:1, label = c(arabic_text, hebrew_text, sindhi_text)),
    family = "Arial"
  ) +
  expand_limits(y = c(0, 4))

code <- "x <- y != z"
logo <- "twitter"
ggplot() +
  geom_text(
    aes(x = 0, y = 2, label = code),
    family = "Cascadia Code PL"
  ) +
  geom_text(
    aes(x = 0, y = 1, label = logo),
    family = "Font Awesome 5 brands"
  ) +
  expand_limits(y = c(0, 3))

emojis <- "👩🏾‍💻🔥📊"

ggplot() +
  geom_label(
    aes(x = 0, y = 0, label = emojis),
    family = "Apple Color Emoji"
  )
