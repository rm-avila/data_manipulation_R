rm(list = ls())
source("lib/01_helpers.R")

# Por default, en helpers cargamos el 'tidyverse' completo, pero podríamos sólo
# instalar y cargar tidyr (por el momento)
cargar_paquetes("tidyr")


# Observar la forma de presentar los mismos datos:

(preg <- read.csv("tidyr/vignettes/preg.csv", stringsAsFactors = FALSE))

read.csv("tidyr/vignettes/preg2.csv", stringsAsFactors = FALSE)



# Desorden #1 -------------------------------------------------------------

# Relación entre ingreso y religión en EU
# 'Fuente: Pew Research Center

cargar_paquetes("tibble")
pew <- as_tibble(read.csv("tidyr/vignettes/pew.csv", stringsAsFactors = FALSE, check.names = FALSE))
pew

# Cuáles son las variables? Cuáles son las unidades?

# Desorden por qué?
# Los encabezados de columna son valores, no nombres de variables
# Ventaja: Almacenamiento más eficiente, manejo más eficiente si se desean realizar
# operaciones matriciales

# Ordenar
pew %>%
  gather(income, frequency, -religion)

# Desorden #2 -------------------------------------------------------------

# Conteos de casos de tuberculosis confirmados por país, año y grupo demográfico
# Fuente: World Health Organisation

