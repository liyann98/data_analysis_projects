library(shiny)
library(plotly)
library(ggplot2)
library(dplyr)
library(reshape)
library(dslabs)
library(tidyverse)
library(pheatmap)
library(ggcorrplot)
home<- read.csv("homeChourly.csv")
Usage<-read.csv("HourlyUsage.csv")
appliance_yearly <-read.csv("appliance_yearly.csv")
appliance_monthly<-read.csv("appliance_monthly.csv")
kitchen_appliances<-read.csv("kitchen_appliances.csv")

function(input, output, session){
  
  output$home <- renderTable({
    home
  })
  
  output$plot1 <- renderPlotly({
    
    
    Usage%>%
      group_by(Hour) %>%
      summarise(HouseUsage = mean(HouseUsage)) %>%
      ggplot(aes(x = Hour, y = 1, fill = HouseUsage)) +
      geom_tile() +
      scale_fill_gradient(low = "blue", high = "red") +
      scale_y_continuous(expand = c(0, 0), name = "") +
      labs(x = "Hour of Day", fill = "Energy Usage") +
      theme_minimal() +
      theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) -> my_plot
    
    ggplotly(my_plot)
    
  })
  
  output$plot2 <- renderPlotly({
    
    
    plot2<-plot_ly(home, x = ~Month, y = ~houseUsage, color = ~temperature, type = "bar") %>%
      layout(xaxis = list(title = "Month"), yaxis = list(title = "Consumption"), barmode = "stack")
    
    
  })
  
  output$hist<- renderPlotly({
    #histogram Liyan
    ggplot(home, aes(x = houseUsage)) +
      geom_histogram(aes(y = ..density.., fill = ..count..), binwidth = 5) +
      geom_density(alpha = .2, fill = "#a30351") +
      scale_x_continuous(name = "Amount of energy used by house", breaks = seq(0, 200, 20), limits = c(0, 200)) +
      scale_y_continuous(name = "Density", expand = c(0, 0)) +
      labs(subtitle = "Hover over the bars to see actual values") +
      theme_minimal()
    
    # Convert the ggplot object to an interactive plot with plotly
    ggplotly(tooltip = c("x", "count"), dynamicTicks = T)
    
  })
  output$scatter <- renderPlot({
    
    #ScatterPlot
    home<- home[ , c(input$varT, input$varW)]
    plot(home[,1],home[,2],
         xlab=colnames(home)[1],
         ylab=colnames(home)[2],
         main=paste("Scatter plot of", input$varT, "vs", input$varW),
         col="rosybrown", pch=15)
    
    
  })
  
  output$histogram <- renderPlotly({
    #histogram Dashboard
    
    ggplot(home, aes(x=solarGen)) + geom_histogram(aes(fill = ..count..),binwidth = 5) +
      scale_x_continuous(breaks=seq(2.5,40,5), limits=c(2.5,40)) +
      scale_y_continuous(name= "Count")+ scale_fill_gradient(low="rosybrown1", high="rosybrown4")
    ggplotly()
    
  })
  output$monthScatter <- renderPlotly({
    #scatter plot month 
    ggplot(home, aes(x=solarGen, y=cloudCover)) + geom_point(aes(colour= windSpeed))+
      facet_grid(Month~.,scales='free')+scale_color_gradient(low="rosybrown1",high="rosybrown4")
    ggplotly()
    
  })
  
  output$density <- renderPlot({
    #Density chart
    ggplot(home, aes(x = solarGen))+
      geom_density(aes(colour="rosybrown4"))
    
  })
  
  output$SolarM<- renderPlotly({
    #Bar Chart
    plot_ly(
      x = ~home$Month,  
      y = ~home$solarGen,
      name = "Solar power per Month",
      type = "bar",
      col="skyblue"
    ) %>% 
      layout(xaxis = list(title = "Month"), 
             yaxis = list(title = "Solar power generated"))
  })
  
  output$temp<- renderPlot({
    #Box plot
    boxplot(temperature~Month, data=home, col="salmon") 
  })
  
  output$donut<- renderPlotly({
    #Donut chart
    appliance_yearly_donut<-appliance_yearly%>%plot_ly(labels=~Appliance,values=~Usage)
    appliance_yearly_donut<-appliance_yearly_donut%>%add_pie(hole=0.6)
    appliance_yarly_donut<-appliance_yearly_donut%>%layout(showlegend=T,
                                                           xaxis=list(showgrid=FALSE, zeroline=FALSE, showticklabels=FALSE),
                                                           yaxis=list(showgrid=FALSE, zeroline=FALSE, showticklabels=FALSE))
  })
  output$interactiveAppliance <- renderPlot({
    
    data<- appliance_monthly[ , c(input$varX, input$varAppliance)]
    plot(data[,1],data[,2],
         xlab=colnames(data)[1],
         ylab=colnames(data)[2],
         main=paste("Line plot of", input$varX, "vs", input$Appliance),
         col="coral", pch=15, type= "o")
  })
  
  output$Furnace <-renderPlotly({
    # furnace_temp_line_chart ----
    ggplot(data=home, aes(x=Month)) +
      geom_point(aes(y=temperature, color=Furnace))+ scale_color_gradient(low="gold",high='coral')
    
    ggplotly()
  })
  
  output$Kitchen <-renderPlotly({
    kitchen_appliances$EntityColor<-c("#FFD700","#FFA500","#FFAC00","#FFA07A","#FF7F50")
    kitchen_yearly_donut<-kitchen_appliances%>%plot_ly(labels=~Appliance,values=~Usage, marker=list(colors=~EntityColor))
    kitchen_yearly_donut<-kitchen_yearly_donut%>%add_pie(hole=0.6)
    kitchen_yearly_donut<-kitchen_yearly_donut%>%layout(showlegend=T,
                                                        xaxis=list(showgrid=FALSE, zeroline=FALSE, showticklabels=FALSE),
                                                        yaxis=list(showgrid=FALSE, zeroline=FALSE, showticklabels=FALSE))
  })
  output$dewPoint<-renderPlotly({
    ggplot(home, aes(x = dewPoint, y=temperature, colour=cloudCover))+
      geom_point()+ scale_color_gradient(low="blue",high='red')
    ggplotly()
    
    
  })
  
  output$weatherScat <- renderPlot({
    
    home<- home[ , c(input$varA, input$varB)]
    
    plot(home[,1],home[,2],
         xlab=colnames(home)[1],
         ylab=colnames(home)[2],
         main=paste("Scatter plot of", input$varA, "vs", input$varB),
         col="blue", pch=15)
    
  })
  
  
  
  
  
  output$Correlation <- renderPlotly({
    Weather <- c("temperature","humidity","visibility", "pressure","windSpeed", "cloudCover", "windBearing","dewPoint","Month")
    weather <- home[, Weather, drop = FALSE]
    Weather1 <- data.matrix(weather)
    #correlation table
    Wcor <- cor(Weather1)
    ggcorrplot(Wcor)
    
  })
  
}