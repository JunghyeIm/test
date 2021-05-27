# Load package
library(shiny)
library(ggmap)
library(data.table)
library(readr)


# Load files
load("data/station_latlon.RData")
register_google(key = mykey)


#User interface
ui <- fluidPage(
  titlePanel("서울시 지하철 정보"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("서울시 지하철 노선도"),
      
      selectInput("station",
                  label = "지하철호선 선택",
                  choices = c("01호선","02호선",
                              "03호선","04호선",
                              "05호선","06호선",
                              "07호선","08호선",
                              "09호선"),
                  selected = "02호선"),
      
      checkboxInput("district",
                    label = "행정구역 표시", value = FALSE),
      
      img(src = "seoul_metro.gif", height = 200, width = 200)
      
      ),
    mainPanel(plotOutput("map"))
  ),
  
  hr(),
  
  fluidRow(
    column(3),
    column(4),
    column(4)
  )
)


# Server logic
server <- function(input, output){
  
  stationInput <- reactive({
    station_latlon[호선 == input$station]
    
  })
  
  colorInput <- reactive({
  color_list[parse_number(input$station)]
  })
  
  distInput <- reactive({
    if(input$district){ #district 체크박스 표시되어 있을 때
      return(p + geom_polygon(data = seoul_map, 
                              aes(x=long, y=lat, group=group),
                              fill = "black", 
                              alpha = 0.2, 
                              color = "white"))
    }else{
      return(p)
    }
  })
  
  output$map <- renderPlot({
    distInput() + geom_point(data = stationInput(), aes(lon, lat), size = 2.5, color=colorInput())
      
  })
  
  
}


# Run app
shinyApp(ui, server)