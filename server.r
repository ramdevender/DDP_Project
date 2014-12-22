library(shiny)

shinyServer(function(input, output) {
  
  getsample <- reactive({
    
    mean1 <- input$effectsize
    sd1 <- 1
    randomsample <- rnorm(input$totalsims * input$samplesize, mean1, sd1)
    sample <- matrix(randomsample, nrow=input$totalsims)
    
    samplemeans <- apply(sample, 1, mean)
    samplesems <- apply(sample, 1, sd) / sqrt(input$samplesize)
    
    df <- input$samplesize - 1
    t.stats <- samplemeans / samplesems   
    p.values <- pt(t.stats, df, lower.tail=FALSE)
    
    sig.rate <- sum(p.values < 0.05) / input$totalsims
    power <- power.t.test(input$samplesize, mean1, sd1, 0.05,
                          type="one.sample", alternative="one.sided")$power
    
    list(df=df, t.stats=t.stats, p.values=p.values, sig.rate=sig.rate, power=power)
    
  })
  
  output$t.stats <- renderPlot({
    
    sample <- getsample()
    plot.title <- sprintf("Power: %.2f; Proportion rejected nulls: %.2f", sample$power, sample$sig.rate)
    hist(sample$t.stats, 25, col="dodgerblue", main=plot.title, xlab="t statistics")
    abline(v=qt(0.05, sample$df, lower.tail=FALSE), lwd=5)
    
  })
  
  output$p.values <- renderPlot({
    
    sample <- getsample()  
    bins <- seq(0, 1, length.out=40)
    hist(sample$p.values, bins, col="tomato", main=NULL, xlab="p values")
    abline(v=0.05, lwd=5)
    
  })
  
})