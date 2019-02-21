rm(list = ls())
source("lib/01_helpers.R")
cargar_paquetes("pander") # Para formatear salidas en tablas

base_marginacion <- read_csv("data/Base_Indice_de_marginacion_municipal_90-15.csv",
                             col_types = cols(`AÑO` = col_character()), locale = locale(encoding = "UTF-8"))

#Limpieza de la base de datos. 
#============================

#Generamos una función que limpia los datos, NO unos datos nuevos limpios!! De este modo podemos limpiar la base ad hoc, cuando nos hace falta y sin efectos colaterales. 
#Agregamos cada línea necesaria para la limpieza. Al interior de la función asignamos con =, de modo de no asignar de objetos al entorno global. 

limpiar <- function(datos) {
  datos=select(datos, -`<U+FEFF>CVE_MUN`, -CVE_ENT, -CVEE_MUN, -IND0A100,  -LUGAR_NAC, -LUGAR_EST)
  datos=mutate(datos, POB_TOT=as.numeric(
    gsub(" ", "", POB_TOT)
  )
  )
  datos=mutate_if(datos, is.character, as.factor)
  datos [datos=="-"] <- NA
  return(datos)            #Para que pase el resultado a la función siguiente. 
}

#Recodificación. 
#==============

recodificar <- function(datos){
  datos=mutate(datos, ENT=recode(ENT, `Distrito Federal`="Ciudad de México")) 
  return(datos)
}

#Summary de datos. 
#==================

#En tabla.

base_marginacion %>% 
  limpiar() %>% 
  recodificar() %>% 
  filter (AÑO=="2015" & ENT!="Nacional") %>% 
  summary() %>% 
  pander

#Gráfico condensado para variables numéricas. 

base_marginacion %>% 
  limpiar() %>% 
  recodificar() %>% 
  filter (AÑO=="2015" & ENT!="Nacional") %>% 
  keep (is.numeric) %>% 
  gather(Variable, valor) %>% 
  ggplot(aes(valor)) +
  geom_density() + 
  facet_wrap(~Variable,scales="free")

#Gráfico condensado para variables categóricas. (factores). 

base_marginacion %>% 
  limpiar() %>% 
  recodificar() %>% 
  filter (AÑO=="2015" & ENT!="Nacional") %>% 
  keep (is.factor) %>% 
  gather(Variable, valor) %>% 
  ggplot(aes(valor)) +
  geom_bar() + 
  facet_wrap(~Variable,scales="free") + 
  theme(axis.text = element_text(angle=90))