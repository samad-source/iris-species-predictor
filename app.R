# install (shiny) package that allows you to build interactive web applications directly in R
library(shiny) #load shiny

# Creating UI(user interface)
ui <- fluidPage(
  titlePanel("IRIS SPECIES PREDICTOR"),
  tableOutput("data_preview")
)

server <- function(input,output){
  iris_data <- iris
  
  output$data_preview <- renderTable({head(iris_data)})
}

shinyApp(ui=ui,server=server)

