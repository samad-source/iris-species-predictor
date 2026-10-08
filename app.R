# install (shiny) package that allows you to build interactive web applications directly in R
install.packages("shiny")
library(shiny) #load shiny

# Creating UI(user interface)
ui <- fluidPage(
  titlePanel("IRIS SPECIES PREDICTOR")
)

server <- function(input,output){
  
}

shinyApp(ui=ui,server=server)

