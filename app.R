# PACKAGES
library(shiny)
library(kknn)
library(ggplot2)
library(fontawesome)

# SPECIES INFORMATION

species_info <- list(
  
  setosa = list(
    name = "Iris-setosa",
    image = "Iris_setosa.png",
    description = paste(
      "Iris setosa is a flowering perennial plant in the iris family,",
      "Iridaceae. It is native to northern regions of North America",
      "and parts of northeastern Asia. It is often found in moist",
      "meadows, coastal areas and other cool, damp habitats.",
      "The species is recognized by its distinctive flowers,",
      "with three prominent petal-like sepals and three smaller",
      "upright petals. Its leaves are narrow and sword-shaped."
    ),
    fun_fact = paste(
      "Iris setosa has three large, spreading sepals that are often",
      "more visually prominent than its three smaller upright petals.",
      "It is adapted to cool climates and can grow in moist coastal",
      "environments where many garden plants struggle."
    ),
    advantages = c(
      "Can grow well in cool climates and moist garden locations.",
      "Its attractive flowers can add colour to suitable naturalistic gardens.",
      "Can contribute to plant diversity in appropriate wetland-style landscapes.",
      "Its perennial growth habit means it can return in suitable conditions."
    ),
    disadvantages = c(
      "May struggle in hot climates without suitable growing conditions.",
      "Requires appropriate moisture and soil conditions for healthy growth.",
      "May not tolerate prolonged drought or excessively dry soil well.",
      "Its growing requirements may make it unsuitable for some indoor gardens."
    )
  ),
  
  versicolor = list(
    name = "Iris-versicolor",
    image = "Iris_versicolor.png",
    description = paste(
      "Iris versicolor, commonly known as the blue flag iris,",
      "is a perennial flowering plant native to eastern North America.",
      "It commonly grows in wetlands, marshes, pond margins and",
      "other moist habitats. Its flowers are usually blue-violet",
      "with distinctive markings on the sepals. Its sword-shaped",
      "leaves and spreading rhizomes help it form clumps over time."
    ),
    fun_fact = paste(
      "The species name versicolor refers to its variable flower",
      "colouration. Individual flowers can display different shades",
      "of blue and violet, often with contrasting yellow or white",
      "markings that help distinguish the flower's pattern."
    ),
    advantages = c(
      "Well suited to suitable rain gardens and pond margins.",
      "Its colourful flowers can provide seasonal garden interest.",
      "Can contribute to native wetland planting in its natural range.",
      "Its spreading rhizomes can help establish a dense planting."
    ),
    disadvantages = c(
      "Needs consistently moist conditions for best growth.",
      "May perform poorly in dry sites without adequate moisture.",
      "Its rhizomes can spread and may need management in small gardens.",
      "The plant is toxic if eaten, so keep it away from pets and children."
    )
  ),
  
  virginica = list(
    name = "Iris-virginica",
    image = "Iris_virginica.jpg",
    description = paste(
      "Iris virginica, commonly called the Virginia iris or southern",
      "blue flag, is a perennial flowering plant native to eastern",
      "North America. It is commonly associated with marshes,",
      "wet meadows, stream margins and other moist habitats.",
      "Its flowers are generally blue to violet, and its long,",
      "upright leaves grow from underground rhizomes. Flower size",
      "and colour can vary with the variety and growing conditions."
    ),
    fun_fact = paste(
      "Iris virginica is adapted to wet environments and can be",
      "used in suitable rain gardens and pond-edge plantings.",
      "Its flowers provide a seasonal display, while its foliage",
      "can add structure to a garden even when the plant is not flowering."
    ),
    advantages = c(
      "Can thrive in moist soils and suitable wetland-style gardens.",
      "Its flowers can add colour and visual interest to landscapes.",
      "Can be useful in appropriate native-plant and rain-garden designs.",
      "Its perennial growth habit can provide recurring seasonal interest."
    ),
    disadvantages = c(
      "May struggle in dry soil or during prolonged drought.",
      "Needs sufficient space as its clumps develop over time.",
      "Excessively dry conditions can reduce plant health and flowering.",
      "The plant is toxic if eaten, so keep it away from pets and children."
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
      
      .flower-details {
        text-align: left;
        max-width: 850px;
        margin: 20px auto 0 auto;
      }

      .flower-detail-card {
        background-color: #ffffff;
        border: 1px solid #dddddd;
        border-radius: 8px;
        padding: 18px;
        margin-top: 15px;
      }

      .flower-detail-card h4 {
        margin-top: 0;
        margin-bottom: 12px;
        color: #234e52;
        font-weight: bold;
      }

      .flower-detail-card p,
      .flower-detail-card li {
        font-size: 15px;
        line-height: 1.7;
      }

      .flower-detail-card ul {
        padding-left: 22px;
        margin-bottom: 0;
      }

      .flower-scientific-name {
        color: #666666;
        font-style: italic;
        margin-bottom: 12px;
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
      
      # DISPLAY IMAGE, NAME, DESCRIPTION AND ADDITIONAL DETAILS
      
      output$species_result <- renderUI({
        tagList(
          # FLOWER NAME
          div(
            class = "prediction-name",
            info$name
          ),
          
          # FLOWER IMAGE
          tags$img(
            src = info$image,
            class = "prediction-image",
            alt = info$name
          ),
          
          # FLOWER INFORMATION
          div(
            class = "flower-details",
            
            # DESCRIPTION
            div(
              class = "flower-detail-card",
              h4(
                fontawesome::fa("leaf"),
                "About This Flower"
                ),
              p(
                info$description,
                class = "description"
              )
            ),
            
            # FUN FACT
            div(
              class = "flower-detail-card",
              h4(
                fontawesome::fa("lightbulb"),
                "Fun Fact"
                ),
              p(info$fun_fact)
            ),
            
            # ADVANTAGES
            div(
              class = "flower-detail-card",
              h4(
                fontawesome::fa("circle-check"),
                "Advantages"
                ),
              tags$ul(
                lapply(info$advantages, function(item) tags$li(item))
              )
            ),
            
            # DISADVANTAGES
            div(
              class = "flower-detail-card",
              h4(
                fontawesome::fa("triangle-exclamation"),
                "Disadvantages and Growing Considerations"
                ),
              tags$ul(
                lapply(info$disadvantages, function(item) tags$li(item))
              )
            )
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