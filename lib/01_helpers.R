# Función para cargar paquetes e instalar los que hagan falta -------------

na_to_zero <- Vectorize(function(x){
  x <- ifelse(is.na(x), 0, x)
})

cargar_paquetes <- function(paquetes_extra = NULL){
  paquetes <- c("tidyverse", "stringr", "lubridate", "foreign", "readxl",
                "RColorBrewer", "ggrepel", paquetes_extra)
  if (length(setdiff(paquetes, rownames(installed.packages()))) > 0) {
    install.packages(setdiff(paquetes, rownames(installed.packages())))  
  }
  lapply(paquetes, require, character.only = TRUE)
  return(search())
}

cargar_paquetes()

# Función para calcular significancia de parámetros -----------------------

prob <- function(x){
  out <- min(length(x[x>0])/length(x), length(x[x<0])/length(x))
  out
}


# Función para reemplazar NA's por ceros en un vector ---------------------

na.zero <- function (x) {
  x[is.na(x)] <- 0
  return(x)
}

# Función para copiar tablas a portapapeles -------------------------------

# Notar que por default se escriben con separador por columna '|' (pipe)

copiar_tabla <- function(base, sep = ";" , row.names = F, ...){
  if(row.names == T){
    if(!is.data.frame(base)) base <- as.data.frame(base)
    base <- base %>% rownames_to_column()
    names(base)[1] <- "" 
    write.table(base, "clipboard", sep = sep, row.names = F, ...)
  } else{
    write.table(base, "clipboard", sep = sep, row.names = row.names, ...) 
  }
}

# Colores cbb -------------------------------------------------------------

# Paleta (52 colores) con gris

colores <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#FFFF33", 
             "#A65628", "#F0027F", "#BEAED4", "#00927F", "#FDC086", "#7FC97F", 
             "#D90A2D", "#1AEFC7", "#E75927", "#025a19")

# Para color de lìnea y/o puntos

col.ptos <- scale_color_manual(values = colores)

# Para usar como color de relleno

col.fill <- scale_fill_manual(values = colores)


# Theme de ggplot ---------------------------------------------------------

theme_set(theme_bw())

# Multiplot ---------------------------------------------------------------

# Función para mostrar múltiples gráficos en un layout
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  #############################################################################
  # Input:
  #   Pueden pasarse las gráficas de ggplot2 en ..., 
  #          o hacer una plotlist (lista de objetos de ggplot2)
  #   cols - Número de columnas en el layout
  #   layout - Una matriz especificando el layout. Si no es NULL, se ignora cols
  #
  # Output: Layout de gráficas con la configuración deseada
  #
  #############################################################################
  cargar_paquetes('grid')
  
  # Hacer una lista con los argumentos ... y plotlists
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # Si layout is NULL, usar 'cols' para determinar el layout
  if (is.null(layout)) {
    # Hacer el panel
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Configurar la página
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Mostrar cada gráfica en la configuración correcta
    for (i in 1:numPlots) {
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


