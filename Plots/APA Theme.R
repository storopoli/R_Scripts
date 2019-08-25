# APA Theme ggplot
library(ggplot2)
apatheme = theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        text = element_text(family='Arial'),
        legend.title = element_blank(),
        legend.position = c(.7, .8),
        axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'))
