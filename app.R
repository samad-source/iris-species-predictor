# install (shiny) package that allows you to build interactive web applications directly in R
library(shiny) #load shiny
library(class) #load class
library(kknn) # load kknn
# Creating UI(user interface)
ui <- fluidPage(
  titlePanel("IRIS SPECIES PREDICTOR"),
  
  selectInput(
    inputId = "distance_metric",
    label = "Distance Metric",
    choices = c("Euclidean" =2,"Manhattan" =1),
    selected = 2
  ),
  
  sliderInput(
    inputId = "k_value",
    label = "Number of Neighbours (K)",
    min = 1,
    max = 15,
    value = 5,
    step = 2
  ),
  
  textOutput("model_accuracy"),
  tableOutput("data_preview")
)

server <- function(input,output){
  iris_data <- iris
  
  set.seed(123)
  train_index <- sample(
    1:nrow(iris_data),
    0.7 * nrow(iris_data)
  )
  
  train_data <- iris_data[train_index,]
  test_data <- iris_data[- train_index,]
  
  train_x <- train_data[,1:4]
  train_y <- train_data$Species
  
  test_x <- test_data[,1:4]
  test_y <- test_data$Species
  
  
  model <- reactive({
  kknn(
    Species ~ .,
    train = train_data,
    test = test_data,
    k = input$k_value,
    distance = as.numeric(input$distance_metric),
    kernel = "rectangular",
    scale = TRUE
  )
  })
  
  
  accuracy <- reactive({
    predictions <- fitted(model())
    mean(predictions == test_y)
  })
  
  output$model_accuracy <- renderText({
    paste(
      "Model Accuracy",
      round(accuracy() * 100,2),
      "%"
    )
  })
  output$data_preview <- renderTable({head(iris_data)})
}

shinyApp(ui=ui,server=server)

