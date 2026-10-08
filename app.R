# PACKAGES
library(shiny)
library(kknn)
library(ggplot2)

# SPECIES INFORMATION

species_info <- list(
  
  setosa = list(
    name = "Iris-setosa",
    image = "Iris_setosa.png",
    description = paste(
      "Iris setosa is one of the three species in the Iris dataset.",
      "It is generally characterized by relatively small petals",
      "compared with the other two species."
    )
  ),
  
  versicolor = list(
    name = "Iris-versicolor",
    image = "Iris_versicolor.png",
    description = paste(
      "Iris versicolor is one of the three species represented",
      "in the Iris dataset. Its measurements are generally",
      "between those of Iris setosa and Iris virginica."
    )
  ),
  
  virginica = list(
    name = "Iris-virginica",
    image = "Iris_virginica.jpg",
    description = paste(
      "Iris virginica is one of the three species represented",
      "in the Iris dataset. It generally has larger petal",
      "measurements than the other two species."
    )
  )
)

# USER INTERFACE

ui <- fluidPage(

  # BASIC STYLING
  
  tags$head(
    
    tags$style(HTML("
      
      body {
        background-color: #f4f6f8;
        font-family: Arial, sans-serif;
      }
      
      .main-title {
        text-align: center;
        font-weight: bold;
        margin-bottom: 5px;
      }
      
      .subtitle {
        text-align: center;
        color: #666666;
        margin-bottom: 30px;
      }
      
      .section-box {
        background-color: white;
        padding: 20px;
        margin-bottom: 25px;
        border-radius: 8px;
        border: 1px solid #dddddd;
      }
      
      .section-title {
        font-weight: bold;
        margin-top: 0;
        margin-bottom: 20px;
      }
      
      .measurement-box {
        background-color: #fafafa;
        border: 1px solid #dddddd;
        border-radius: 6px;
        padding: 15px;
      }
      
      .measurement-title {
        font-weight: bold;
        margin-bottom: 15px;
      }
      
      .predict-container {
        text-align: center;
        margin-top: 20px;
      }
      
      .predict-button {
        padding: 10px 25px;
        font-size: 16px;
      }
      
      .prediction-box {
        background-color: #eef6ff;
        border: 1px solid #b8d8f5;
        border-radius: 8px;
        padding: 20px;
        text-align: center;
        margin-bottom: 20px;
      }
      
      .prediction-name {
        font-size: 25px;
        font-weight: bold;
        margin-bottom: 15px;
      }
      
      .prediction-image {
        width: 300px;
        max-width: 100%;
        border-radius: 8px;
        margin-bottom: 15px;
      }
      
      .description {
        font-size: 16px;
        line-height: 1.6;
        max-width: 700px;
        margin: auto;
      }
      
      .accuracy-box {
        background-color: #f5f5f5;
        border-radius: 8px;
        padding: 12px;
        text-align: center;
        margin-bottom: 20px;
        font-size: 16px;
      }
      
    "))
  ),

  # HEADER
  
  h1(
    "IRIS SPECIES PREDICTOR",
    class = "main-title"
  ),
  
  p(
    "Interactive k-Nearest Neighbours Classification",
    class = "subtitle"
  ),

  # 1. MODEL SETTINGS
  
  div(
    
    class = "section-box",
    
    h3(
      "1. Model Settings",
      class = "section-title"
    ),
    
    fluidRow(
      
      column(
        
        width = 4,
        
        selectInput(
          inputId = "distance_metric",
          label = "Distance Metric",
          choices = c(
            "Euclidean" = 2,
            "Manhattan" = 1
          ),
          selected = 2
        )
        
      ),
      
      column(
        
        width = 4,
        
        sliderInput(
          inputId = "k_value",
          label = "Number of Neighbours (K)",
          min = 1,
          max = 15,
          value = 5,
          step = 2
        )
        
      ),
      
      column(
        
        width = 4,
        
        selectInput(
          inputId = "weighting_method",
          label = "Neighbour Weighting",
          choices = c(
            "Uniform" = "rectangular",
            "Distance Weighted" = "inv"
          ),
          selected = "rectangular"
        )
        
      )
      
    )
    
  ),

  # 2. FLOWER MEASUREMENTS
  
  div(
    
    class = "section-box",
    
    h3(
      "2. Flower Measurements",
      class = "section-title"
    ),
    
    fluidRow(

      # SEPAL
      
      column(
        
        width = 6,
        
        div(
          
          class = "measurement-box",
          
          h4(
            "Sepal Measurements",
            class = "measurement-title"
          ),
          
          numericInput(
            inputId = "sepal_length",
            label = "Sepal Length",
            value = 5.8,
            min = 0,
            width = "100%"
          ),
          
          numericInput(
            inputId = "sepal_width",
            label = "Sepal Width",
            value = 3.0,
            min = 0,
            width = "100%"
          )
          
        )
        
      ),
      
      # PETAL
      
      column(
        
        width = 6,
        
        div(
          
          class = "measurement-box",
          
          h4(
            "Petal Measurements",
            class = "measurement-title"
          ),
          
          numericInput(
            inputId = "petal_length",
            label = "Petal Length",
            value = 4.3,
            min = 0,
            width = "100%"
          ),
          
          numericInput(
            inputId = "petal_width",
            label = "Petal Width",
            value = 1.3,
            min = 0,
            width = "100%"
          )
          
        )
        
      )
      
    ),
# PREDICT BUTTON-
    
    div(
      
      class = "predict-container",
      
      actionButton(
        inputId = "predict",
        label = "Predict Species",
        class = "btn-primary predict-button"
      )
      
    )
    
  ),
  
  # 3. PREDICTION RESULTS
  
  div(
    
    class = "section-box",
    
    h3(
      "3. Prediction Results",
      class = "section-title"
    ),

    # SPECIES RESULT
   
    div(
      
      class = "prediction-box",
      
      uiOutput("species_result")
      
    ),

    # MODEL SETTINGS USED
    
    textOutput("prediction_settings"),
    
    br(),

    # ACCURACY
    
    div(
      
      class = "accuracy-box",
      
      textOutput("model_accuracy")
      
    ),
    
    
    hr(),
    # NEAREST NEIGHBOURS
    
    h4("Nearest Neighbours"),
    
    tableOutput("nearest_neighbors"),
    
    
    br(),

    # VISUALIZATION

    h4("Neighbour Visualization"),
    
    plotOutput(
      "neighbor_plot",
      height = "500px"
    ),
    
    
    hr(),

    # DATA PREVIEW
    
    h4("Iris Dataset Preview"),
    
    tableOutput("data_preview")
    
  )
  
)

# SERVER

server <- function(input, output) {

  # LOAD DATA
  
  iris_data <- iris

  # TRAIN / TEST SPLIT
  
  set.seed(123)
  
  train_index <- sample(
    1:nrow(iris_data),
    0.7 * nrow(iris_data)
  )
  
  train_data <- iris_data[
    train_index,
  ]
  
  test_data <- iris_data[
    -train_index,
  ]

  # MODEL FOR EVALUATION
  
  model <- reactive({
    
    kknn(
      Species ~ .,
      train = train_data,
      test = test_data,
      k = input$k_value,
      distance = as.numeric(
        input$distance_metric
      ),
      kernel = input$weighting_method,
      scale = TRUE
    )
    
  })

  # MODEL ACCURACY
  
  accuracy <- reactive({
    
    predictions <- fitted(
      model()
    )
    
    mean(
      predictions == test_data$Species
    )
    
  })

  # DISPLAY MODEL ACCURACY
  
  output$model_accuracy <- renderText({
    
    paste(
      "Model Accuracy:",
      round(
        accuracy() * 100,
        2
      ),
      "%"
    )
    
  })

  # PREDICT NEW FLOWER
  
  observeEvent(
    
    input$predict,
    
    {
      # CREATE NEW FLOWER
      
      new_flower <- data.frame(
        
        Sepal.Length = input$sepal_length,
        
        Sepal.Width = input$sepal_width,
        
        Petal.Length = input$petal_length,
        
        Petal.Width = input$petal_width
        
      )

      # RUN K-NN
      
      prediction_model <- kknn(
        
        Species ~ .,
        
        train = train_data,
        
        test = new_flower,
        
        k = input$k_value,
        
        distance = as.numeric(
          input$distance_metric
        ),
        
        kernel = input$weighting_method,
        
        scale = TRUE
        
      )

      # GET PREDICTION
      
      prediction <- fitted(
        prediction_model
      )
      
      predicted_species <- as.character(
        prediction
      )

      # GET SPECIES INFORMATION
      
      info <- species_info[[predicted_species]]

      # DISPLAY IMAGE + NAME + DESCRIPTION
      
      output$species_result <- renderUI({
        
        tagList(
          
          div(
            
            class = "prediction-name",
            
            info$name
            
          ),
          
          tags$img(
            
            src = info$image,
            
            class = "prediction-image"
            
          ),
          
          p(
            
            info$description,
            
            class = "description"
            
          )
          
        )
        
      })

      # DISPLAY SETTINGS USED FOR PREDICTION
      
      distance_name <- ifelse(
        
        input$distance_metric == 2,
        
        "Euclidean",
        
        "Manhattan"
        
      )
      
      weighting_name <- ifelse(
        
        input$weighting_method == "rectangular",
        
        "Uniform",
        
        "Distance Weighted"
        
      )
      
      
      output$prediction_settings <- renderText({
        
        paste(
          
          "K =", input$k_value,
          
          "| Distance =", distance_name,
          
          "| Weighting =", weighting_name
          
        )
        
      })

      # GET NEAREST NEIGHBOURS
      
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

      # GET ACTUAL NEIGHBOUR ROWS
      
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

      # CREATE NEIGHBOUR TABLE
      
      neighbor_data <- data.frame(
        
        Neighbour = seq_along(
          neighbor_distance
        ),
        
        Species = paste0(
          "Iris-",
          neighbor_species
        ),
        
        Distance = round(
          neighbor_distance,
          3
        ),
        
        Weight = round(
          neighbor_weights,
          3
        )
        
      )

      # DISPLAY NEIGHBOUR TABLE
      
      output$nearest_neighbors <- renderTable({
        
        neighbor_data
        
      })

      # CREATE VISUALIZATION
      
      output$neighbor_plot <- renderPlot({
        
        ggplot() +

        # ALL TRAINING FLOWERS
        
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

        # NEAREST NEIGHBOURS
        
        geom_point(
          
          data = neighbor_points,
          
          aes(
            x = Petal.Length,
            y = Petal.Width,
            color = Species
          ),
          
          size = 5
          
        ) +

        # NEIGHBOUR NUMBERS
          
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
          

        # USER'S FLOWER

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

        # GRAPH LABELS
        
        labs(
          
          title = "Your Flower and Its Nearest Neighbours",
          
          x = "Petal Length",
          
          y = "Petal Width",
          
          color = "Species"
          
        ) +
          
          
          theme_minimal()
        
      })
      
    }
    
  )
  
  # DATA PREVIEW
  
  output$data_preview <- renderTable({
    
    head(iris_data)
    
  })
  
}

# RUN SHINY APPLICATION

shinyApp(
  ui = ui,
  server = server
)