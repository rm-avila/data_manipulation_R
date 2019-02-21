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

tb <- as_tibble(read.csv("tidyr/vignettes/tb.csv", stringsAsFactors = FALSE))
tb


# Cuáles son las variables? Cuáles son las unidades?

# Desorden por qué?
# Una columna contiene datos de más de una variable
# Ventaja: Almacenamiento más eficiente, captura más sencilla

# Ordenar
tb2 <- tb %>% 
  gather(demo, n, -iso2, -year, na.rm = TRUE)
tb2

tb3 <- tb2 %>% 
  separate(demo, c("sex", "age"), 1)
tb3
 # Ventaja porque nos gustaría comparar tasas en vez de frecuencias


# Desorden # 3 ------------------------------------------------------------

# Clima diario en una estación (MX17004) en México durante 5 meses de 2010
# Fuente:  Global Historical Climatology Network

weather <- as_tibble(read.csv("tidyr/vignettes/weather.csv", stringsAsFactors = FALSE))
weather

# Cuáles son las variables? Cuáles son las unidades?

# Desorden por qué?
# Variables tanto en filas como en columnas

weather2 <- weather %>%
  gather(day, value, d1:d31, na.rm = TRUE)
weather2

weather3 <- weather2 %>% 
  mutate(day = parse_number(day)) %>%
  select(id, year, month, day, element, value) %>%
  arrange(id, year, month, day)

weather3

weather3 %>% spread(element, value)
