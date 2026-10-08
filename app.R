# Install Shiny package that allows you to build interactive web applications
# directly in R
library(shiny)

# Load kknn for k-Nearest Neighbours
library(kknn)

# USER INTERFACE
ui <- fluidPage(
  
  titlePanel("IRIS SPECIES PREDICTOR"),
  
  selectInput(
    inputId = "distance_metric",
    label = "Distance Metric",
    choices = c(
      "Euclidean" = 2,
      "Manhattan" = 1
    ),
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
  
  numericInput(
    inputId = "sepal_length",
    label = "Sepal Length",
    value = 5.8,
    min = 0
  ),
  
  numericInput(
    inputId = "sepal_width",
    label = "Sepal Width",
    value = 3.0,
    min = 0
  ),
  
  numericInput(
    inputId = "petal_length",
    label = "Petal Length",
    value = 4.3,
    min = 0
  ),
  
  numericInput(
    inputId = "petal_width",
    label = "Petal Width",
    value = 1.3,
    min = 0
  ),
  
  actionButton(
    inputId = "predict",
    label = "Predict Species"
  ),
  
  br(),
  br(),
  
  textOutput("prediction"),
  
  tableOutput("nearest_neighbors"),
  
  textOutput("model_accuracy"),
  
  tableOutput("data_preview")
)

# SERVER
server <- function(input, output) {
  
# Load Iris dataset
  iris_data <- iris

# TRAIN / TEST SPLIT
  set.seed(123)
  
  train_index <- sample(
    1:nrow(iris_data),
    0.7 * nrow(iris_data)
  )
  
  train_data <- iris_data[train_index, ]
  test_data <- iris_data[-train_index, ]
  
# MODEL USED FOR EVALUATION

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

# MODEL ACCURACY
  accuracy <- reactive({
    
    predictions <- fitted(model())
    
    mean(predictions == test_data$Species)
    
  })
# DISPLAY ACCURACY
  output$model_accuracy <- renderText({
    
    paste(
      "Model Accuracy:",
      round(accuracy() * 100, 2),
      "%"
    )
    
  })
 
# PREDICT NEW FLOWER
  
  observeEvent(input$predict, {
    
    new_flower <- data.frame(
      Sepal.Length = input$sepal_length,
      Sepal.Width = input$sepal_width,
      Petal.Length = input$petal_length,
      Petal.Width = input$petal_width
    )
    
    
    prediction_model <- kknn(
      Species ~ .,
      train = train_data,
      test = new_flower,
      k = input$k_value,
      distance = as.numeric(input$distance_metric),
      kernel = "rectangular",
      scale = TRUE
    )
    
    
    prediction <- fitted(prediction_model)
    
    neighbor_data <- data.frame(
      Species = as.vector(prediction_model$CL),
      Distance = as.vector(prediction_model$D)
    )
    
    output$nearest_neighbors <- renderTable({
      neighbor_data
    })
    
    output$prediction <- renderText({
      
      paste(
        "Prediction:",
        as.character(prediction)
      )
      
    })
 
  })
# SHOW DATA PREVIEW
  output$data_preview <- renderTable({
    
    head(iris_data)
    
  })
  
}
# RUN SHINY APP
shinyApp(
  ui = ui,
  server = server
)