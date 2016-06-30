shinyServer(function(input, output) {
  
  install = function(pkg){
    #Si ya está instalado, no lo instala.
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg)
      if (!require(pkg, character.only = TRUE)) stop(paste("load failure:", pkg))
    }
  }
  install("foreach")
  #Seleccionamos los archivos que queremos instalar
  archive = c("shiny", "rmarkdown", "recommenderlab", "caret")
  foreach(i = archive) %do% install(i)
  
  library(recommenderlab)
  
  set.seed(1)
  #setwd("C:/Users/nadi_/Dropbox/App-1")
  train <- read.csv("train.csv")
  
  train$Artist <- NULL
  train$Time <- NULL
  
  #Realizando la Real Rating MAtrix para el análisis exploratorio
  
  track.id <- as.factor(train$Track)
  user.id <- as.factor(train$User)
  music.sparse = sparseMatrix(i = as.numeric(user.id), j = as.numeric(track.id), 
                              x = as.numeric(train$Rating))
  colnames(music.sparse) <- levels(track.id)
  rownames(music.sparse) <- levels(user.id)
  
  train.matrix <- new("realRatingMatrix", data = music.sparse)
  
  #Análsis Exploratorio
  
  dim(train.matrix)
  image(train.matrix[1:100,1:184], main = "Data de Ratings", col.regions = heat.colors(100))
  
  #Explorando los valores de los ratings
  
  sort(unique(train$Rating))
  
  #Histograma de Ratings
  
  hist(train$Rating, col = "skyblue", 
       main = "Histograma de Rating", 
       xlab = "Rating", 
       ylab = "Frecuencia")
  
  # Dibujando la Data con un Subset de 0.01% de la poblacion
  
  #Tama?o de la muestra
  t_size <- floor(0.001 * length(train$User))
  
  #Patici?n
  t_indx <- sample(seq_len(length(train$User)), size = t_size)
  train2 <- train[t_indx, ]
  
  #Matriz sparce con sampling de 0.001%
  track.id2 <- as.factor(train2$Track)
  user.id2 <- as.factor(train2$User)
  music.sparse2 = sparseMatrix(i = as.numeric(user.id2), j = as.numeric(track.id2), 
                               x = as.numeric(train2$Rating))
  colnames(music.sparse2) <- levels(track.id2)
  rownames(music.sparse2) <- levels(user.id2)
  dim(music.sparse2)
  
  image(music.sparse2[1:dim(music.sparse2)[1],1:dim(music.sparse2)[2]], 
        main = "Sample de la Poblacion", col.regions = rainbow(100))
  
  #Similaridad entre usuarios
  
  similarity_users <- similarity(train.matrix[1:5, ], 
                                 method = "cosine", 
                                 which = "users")
  
  as.matrix(similarity_users)
  image(as.matrix(similarity_users), main = "Similaridad entre usuarios")
  
  #Mostramos los diferentes modelos disponibles para utilizar y su descripción
  
  recommender_models <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")
  names(recommender_models)
  
  lapply(recommender_models, "[[", "description")
  
  #Normalizamos la data
  
  
  #genero el modelo
  #recc_model <- Recommender(data = train.matrix, 
  #                          method = "IBCF")
  
  #predigo con unas recomendaciones
  
  n_recommended <- 6
  #recc_predicted <- predict(object = recc_model, 
  #                          newdata = train.matrix, #deberia ser test
  #                          n = n_recommended)
  load("recc_model.rdata")
  load("recc_predicted.rdata")
  output$recom <- renderText(
    recc_predicted@items[[input$user]]
  )
  
  
  
})