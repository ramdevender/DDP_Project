library(shiny)

fig.width <- 600
fig.height <- 450

shinyUI(pageWithSidebar(
  
  headerPanel("Simulate T-Tests"),
  
  sidebarPanel(
    
    div(p("Simulate T-test using Effect Size, Sample Size and Total Simulations as input")),
    
    div(
      
      sliderInput("effectsize", 
                  strong("Effect size"), 
                  min=0, max=1, value=0, step=.1, ticks=FALSE),
      sliderInput("samplesize",
                  strong("Number of observations in a sample"),
                  min=1, max=50, value=20, step=1, ticks=FALSE),
      sliderInput("totalsims",
                  strong("Total Simulations"),
                  min=100, max=5000, value=500, step=100, ticks=TRUE)
      
    )
  ),
  
  mainPanel(
    plotOutput("t.stats", width=fig.width, height=fig.height),
    plotOutput("p.values", width=fig.width, height=fig.height)
  )
  
))