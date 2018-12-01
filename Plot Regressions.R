########## GRAPH LINEAR MODEL ############
## https://ggplot2.tidyverse.org/reference/fortify.lm.html ##

#use +theme_void() to generate a complete empty frame
#fonts serif is Times New Roman
#sans is Arial
#mono is Courrier
#symbol is Symbol

library(ggplot2)
library(extrafont)
loadfonts()
attach(Base_195)

#Histogram of DV
h <- ggplot(Base_195, aes(NOTA_RUF))+ 
  geom_histogram(bins = 40, fill = "grey", color = "black",  boundary = 0.5)
h + labs(x = "Nota RUF", y = "Frequência") +theme_classic(base_size = 12, base_family = "serif")
ggsave("Histograma DV.png", dpi = 300)

# Model Function
#adjust the abs(.sdresid)>2
attach(Base_195)
plotmodel <- ggplot(lm.fit, aes(seq_along(lm.fit$fitted.values), lm.fit$fitted.values)) +
  geom_point() +
  geom_smooth(se = T, color = "red", level = 0.95)
plotmodel + labs(x = "Observações", y = "Nota RUF") + 
  theme_classic(base_size = 12, base_family = "serif")+
  geom_text(aes(label=ifelse(abs(.stdresid)>3,seq_along(.fitted),"")), hjust=1.28)
ggsave("Model.png", dpi = 300)

# Resid vs Fitted
#adjust the abs(.sdresid)>3
res1 <- ggplot(lm.fit, aes(.fitted, .resid)) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = T, color = "red", level = 0.95)
res1 + labs(x = "Valores Ajustados da Nota RUF", y = "Resíduos") + 
  theme_classic(base_size = 12, base_family = "serif")+
  geom_text(aes(label=ifelse(abs(.stdresid)>3,seq_along(.fitted),"")), hjust=1.28)
ggsave("Resid vs Fitted.png", dpi = 300)


#StudentResid vs Fitted
#adjust the abs(.stdresid)>3
res2 <- ggplot(lm.fit, aes(.fitted, .stdresid)) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = T, color = "red", level = 0.95)
res2 + labs(x = "Valores Ajustados da Nota RUF", y = "Resíduos Studentizados")+ 
  theme_classic(base_size = 12, base_family = "serif")+
  geom_text(aes(label=ifelse(abs(.stdresid)>3,seq_along(.fitted),"")), hjust=1.28)
ggsave("StudentResid vs Fitted.png", dpi = 300)

#SQRT StudentResid vs Fitted
#adjust the sqrt(abs(.stdresid))>1.732 (sqrt of 3 in student resid)
res3 <- ggplot(lm.fit, aes(.fitted, sqrt(abs(.stdresid)))) +
  geom_point() +
  geom_smooth(se = T, color = "red", level = 0.95)
res3 + labs(x = "Valores Ajustados da Nota RUF", y = "Raíz Quadrada dos Resíduos Studentizados")+
  theme_classic(base_size = 12, base_family = "serif")+
  geom_text(aes(label=ifelse(sqrt(abs(.stdresid))>1.732, seq_along(.fitted),"")), hjust=1.28)
ggsave("SQRT StudentResid vs Fitted.png", dpi = 300)

#Normal QQ-PLOT
qq <- ggplot(lm.fit) +
  stat_qq(aes(sample = .stdresid), color = "grey35") +
  geom_abline(color = "black", size = 0.5)
qq + labs(x = "Quantis Teóricos", y = "Resíduos Studentizados")+
  theme_classic(base_size = 12, base_family = "serif")
ggsave("Normal QQ-PLOT.png", dpi = 300)

#Cooks D
#use hjust to labels not overlap
#adjust .cooksd>0.1 to flag observations with cooks D
cook <- ggplot(lm.fit, aes(seq_along(.cooksd), .cooksd)) +
  geom_col(fill = "gray25")
cook + labs(x = "Observações", y = "Distância de Cook")+
  theme_classic(base_size = 12, base_family = "serif") +
  geom_text(aes(label=ifelse(.cooksd>0.1,seq_along(.cooksd),"")), hjust=1.28)
ggsave("Cooks D.png", dpi = 300)

#Residuals vs Leverage
#use hjust to labels not overlap
residlev <- ggplot(lm.fit, aes(.hat, .stdresid)) +
  geom_point(aes(size = .cooksd), color ="gray25") +
  geom_smooth(se = T, size = 1, color = "red", level = 0.95)
residlev + labs(x= "Influência", y= "Resíduos Studentizados",
                size="Dist Cook") + theme_classic(base_size = 12, base_family = "serif")+
  geom_text(aes(label=ifelse(.cooksd>0.1,seq_along(.cooksd),"")), hjust=2)
ggsave("Residuals vs Leverage vs Cook D.png", dpi = 300)


#Cook's dist vs Leverage hii/(1-hii)
cookleveage<-ggplot(lm.fit, aes(.hat, .cooksd))+geom_point(na.rm=TRUE)+
  stat_smooth(method="loess", na.rm=TRUE, color = "red", level = 0.95)
cookleveage+xlab("Influência hii")+ylab("Distância de Cook")+
  geom_abline(slope=seq(0,3,0.5), color="gray35", linetype="dashed") +
  theme_classic(base_size = 12, base_family = "serif")+
  geom_text(aes(label=ifelse(.cooksd>0.1,seq_along(.cooksd),"")), hjust=1.28)
ggsave("Cook vs Leverage.png", dpi = 300)
