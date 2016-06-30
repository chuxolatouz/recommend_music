#install.packages("shiny")
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("EMI Music Data Science Hackathon"),
  
  fluidRow(
    column(4,
           numericInput("user", label = h3("Usuario a recomendar"), value = 2)
           ),
    column(8,
           h3("canciones recomendadas"),
           verbatimTextOutput("recom")
           )
  )
  
 
  # Sidebar with numeric input 

  
))


