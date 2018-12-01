library(ggplot2)

##http://r4ds.had.co.nz/data-visualisation.html
##http://r4ds.had.co.nz/graphics-for-communication.html

#Definir cores dos dados color="blue"
ggplot(data = dataset) + 
  geom_point(mapping = aes(x = AGE_SS, y = RUF), color="blue")

##você pode usar color/size/alpha/shape no ggplot
ggplot(data = dataset) + 
  geom_point(mapping = aes(x = AGE_SS, y = RUF, color=PUBLICA))

#usando facets e o nrow e o numero de colunas
ggplot(data = dataset) + 
  geom_point(mapping = aes(x = AGE_SS, y = RUF)) + 
  facet_wrap(~ PUBLICA, nrow = 1)

#facet_grid
ggplot(data = dataset) + 
  geom_point(mapping = aes(x = AGE_SS, y = RUF)) + 
  facet_grid(PUBLICA ~ MEDICINA)

#gplot geometric objets
ggplot(data = dataset) + 
  geom_smooth(mapping = aes(x = AGE_SS, y = RUF))

#gometric linedrive
ggplot(data = dataset) + 
  geom_smooth(mapping = aes(x = AGE_SS, y = RUF, linetype = VAR_CAT))

#geometric group
ggplot(data = dataset) + 
  geom_smooth(mapping = aes(x = AGE_SS, y = RUF, group = PUBLICA))

#geometric color
ggplot(data = dataset) + 
  geom_smooth(
    mapping = aes(x = AGE_SS, y = RUF, color = PUBLICA),
    show.legend = FALSE
    )
#SALVAR O ULTIMO GGPLOT EM PDF!
ggsave("my-plot.pdf")
