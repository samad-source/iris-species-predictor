# Install Shiny package that allows you to build
# interactive web applications directly in R
library(shiny)

# Load kknn for k-Nearest Neighbours
library(kknn)

# Load ggplot2 for visual representation
library(ggplot2)


# ==================================================
# USER INTERFACE
# ==================================================

ui <- fluidPage(
  
  titlePanel("IRIS SPECIES PREDICTOR"),
  
  # Distance metric
  selectInput(
    inputId = "distance_metric",
    label = "Distance Metric",
    choices = c(
      "Euclidean" = 2,
      "Manhattan" = 1
    ),
    selected = 2
  ),
  
  # Number of neighbours
  sliderInput(
    inputId = "k_value",
    label = "Number of Neighbours (K)",
    min = 1,
    max = 15,
    value = 5,
    step = 2
  ),
  
  # Neighbour weighting
  selectInput(
    inputId = "weighting_method",
    label = "Neighbour Weighting",
    choices = c(
      "Uniform" = "rectangular",
      "Distance Weighted" = "inv"
    ),
    selected = "rectangular"
  ),
  
  # Flower measurements
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
  
  # Prediction button
  actionButton(
    inputId = "predict",
    label = "Predict Species"
  ),
  
  br(),
  br(),
  
  # Prediction result
  textOutput("prediction"),
  
  br(),
  
  # Nearest neighbour table
  tableOutput("nearest_neighbors"),
  
  br(),
  
  # Neighbour visualization
  plotOutput(
    "neighbor_plot",
    height = "500px"
  ),
  
  br(),
  
  # Model accuracy
  textOutput("model_accuracy"),
  
  br(),
  
  # Dataset preview
  tableOutput("data_preview")
)


# ==================================================
# SERVER
# ==================================================

server <- function(input, output) {
  
  # ------------------------------------------------
  # LOAD IRIS DATA
  # ------------------------------------------------
  
  iris_data <- iris
  
  
  # ------------------------------------------------
  # TRAIN / TEST SPLIT
  # ------------------------------------------------
  
  set.seed(123)
  
  train_index <- sample(
    1:nrow(iris_data),
    0.7 * nrow(iris_data)
  )
  
  train_data <- iris_data[train_index, ]
  test_data <- iris_data[-train_index, ]
  
  
  # ------------------------------------------------
  # MODEL FOR EVALUATION
  # ------------------------------------------------
  
  model <- reactive({
    
    kknn(
      Species ~ .,
      train = train_data,
      test = test_data,
      k = input$k_value,
      distance = as.numeric(input$distance_metric),
      kernel = input$weighting_method,
      scale = TRUE
    )
    
  })
  
  
  # ------------------------------------------------
  # MODEL ACCURACY
  # ------------------------------------------------
  
  accuracy <- reactive({
    
    predictions <- fitted(model())
    
    mean(predictions == test_data$Species)
    
  })
  
  
  # ------------------------------------------------
  # DISPLAY MODEL ACCURACY
  # ------------------------------------------------
  
  output$model_accuracy <- renderText({
    
    paste(
      "Model Accuracy:",
      round(accuracy() * 100, 2),
      "%"
    )
    
  })
  
  
  # ------------------------------------------------
  # PREDICT NEW FLOWER
  # ------------------------------------------------
  
  observeEvent(input$predict, {
    
    # Create a new flower from user input
    new_flower <- data.frame(
      Sepal.Length = input$sepal_length,
      Sepal.Width = input$sepal_width,
      Petal.Length = input$petal_length,
      Petal.Width = input$petal_width
    )
    
    
    # Run k-NN on the new flower
    prediction_model <- kknn(
      Species ~ .,
      train = train_data,
      test = new_flower,
      k = input$k_value,
      distance = as.numeric(input$distance_metric),
      kernel = input$weighting_method,
      scale = TRUE
    )
    
    
    # ------------------------------------------------
    # GET PREDICTION
    # ------------------------------------------------
    
    prediction <- fitted(prediction_model)
    
    
    # Display prediction
    output$prediction <- renderText({
      
      paste(
        "Prediction:",
        as.character(prediction)
      )
      
    })
    
    
    # ------------------------------------------------
    # GET NEAREST NEIGHBOUR INFORMATION
    # ------------------------------------------------
    
    neighbor_indices <- as.vector(
      prediction_model$C
    )
    
    neighbor_species <- as.vector(
      prediction_model$CL
    )
    
    neighbor_distance <- as.vector(
      prediction_model$D
    )
    
    neighbor_weights <- as.vector(
      prediction_model$W
    )
    
    
    # ------------------------------------------------
    # GET ACTUAL NEIGHBOUR ROWS
    # ------------------------------------------------
    
    neighbor_points <- train_data[
      neighbor_indices,
      ,
      drop = FALSE
    ]
    
    
    # Add neighbour information
    neighbor_points$Neighbour <- seq_along(
      neighbor_indices
    )
    
    neighbor_points$Distance <- neighbor_distance
    
    neighbor_points$Weight <- neighbor_weights
    
    
    # ------------------------------------------------
    # CREATE NEIGHBOUR TABLE
    # ------------------------------------------------
    
    neighbor_data <- data.frame(
      Neighbour = seq_along(neighbor_distance),
      Species = neighbor_species,
      Distance = neighbor_distance,
      Weight = neighbor_weights
    )
    
    
    # Display neighbour table
    output$nearest_neighbors <- renderTable({
      
      neighbor_data
      
    })
    
    
    # ------------------------------------------------
    # CREATE NEIGHBOUR PLOT
    # ------------------------------------------------
    
    output$neighbor_plot <- renderPlot({
      
      ggplot() +
        
        # All training flowers
        geom_point(
          data = train_data,
          aes(
            x = Petal.Length,
            y = Petal.Width,
            color = Species
          ),
          alpha = 0.45,
          size = 2
        ) +
        
        # K nearest neighbours
        geom_point(
          data = neighbor_points,
          aes(
            x = Petal.Length,
            y = Petal.Width,
            color = Species
          ),
          size = 5
        ) +
        
        # Number each neighbour
        geom_text(
          data = neighbor_points,
          aes(
            x = Petal.Length,
            y = Petal.Width,
            label = Neighbour
          ),
          nudge_y = 0.05,
          size = 4
        ) +
        
        # User's flower
        geom_point(
          data = new_flower,
          aes(
            x = Petal.Length,
            y = Petal.Width
          ),
          shape = 8,
          size = 6,
          color = "black"
        ) +
        
        labs(
          title = "Your Flower and Its Nearest Neighbours",
          x = "Petal Length",
          y = "Petal Width",
          color = "Species"
        ) +
        
        theme_minimal()
      
    })
    
  })
  
  
  # ------------------------------------------------
  # DATA PREVIEW
  # ------------------------------------------------
  
  output$data_preview <- renderTable({
    
    head(iris_data)
    
  })
  
}


# ==================================================
# RUN SHINY APP
# ==================================================

shinyApp(
  ui = ui,
  server = server
)