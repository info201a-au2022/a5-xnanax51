library(shiny)
library(ggplot2)
library(tidyverse)
library(plotly)
library(zipcodeR)
library(terra)
co2_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")


cleaned_data <- co2_data %>%
  select(country, year, population, gdp, co2, co2_growth_abs, co2_per_gdp, co2_growth_prct)


#world and co2

world_co2 <- cleaned_data %>%
  group_by(country) %>%
  filter(country == "World")



#see the top 20 countries that have the most co2_growth_prct in 2021

top_countries_co2_growth <- cleaned_data %>%
  group_by(country) %>%
  filter(year == "2021")%>%
  arrange(desc(co2_growth_prct))%>%
  head(20)


#3rd value
top_countries_gdp <- cleaned_data %>%
  group_by(country) %>%
  filter(country == "United States" | country == "China" | country == "Japan" | country == "Germany"| country == "United Kingdom"
         | country == "India" | country == "France"| country == "Italy"| country == "Canada"| country == "South Korea")
 




server <- function(input, output) {
  
  
  #intro value 1
  output$chart1 <- renderPlotly({
    
    
    # Create ggplot scatter
    first_chart <- ggplot(world_co2, aes(year, co2)) +
      geom_col()+
      ggtitle("The Change in CO2 in the World")
    first_chart
  })
  
  
  #intro value 2
  
  output$chart2 <- renderPlotly({
    
    
    # Create ggplot scatter
    second_chart <- ggplot(top_countries_co2_growth, aes(country,co2_growth_prct)) +
      geom_bar(aes(fill = country), position = "dodge", stat="identity") + 
      theme(axis.text.x = element_text(angle = 90,
                                       vjust = 0.5,
                                       hjust = 0.5)) +
      ggtitle("Comparing the Countries on Growth of CO2 in 2021")
    second_chart
  })
  
  
  #intro value 3
  output$chart3 <- renderPlotly({
    
    
    # Create ggplot scatter
    third_chart <-  ggplot(top_countries_gdp)+
      geom_line(aes(x = year, y = co2_per_gdp, color = country))+
      ggtitle("The Top 10 Countries by Nominal GDP in 2021 and their changes in CO2 per GDP") +
      scale_y_continuous(name="CO2 per GDP", labels = scales::comma) 
    
    third_chart
    
  })
  
  
  url <- a("Resource", href="https://www.investopedia.com/insights/worlds-top-economies/")
  output$tab <- renderUI({
    tagList("URL link:", url)
  })
  
  
  #2nd page chart 1
  output$selectCountry <-renderUI({
    selectInput("Country", "Choose a country:", choices = unique(cleaned_data$country))
  })
  
  scatterPlot <- reactive({
    plotData <- cleaned_data%>%
      filter(country %in% input$Country)
  
  ggplot(plotData, aes(x= year, y= co2)) +
    geom_point(aes(color = country)) +
    labs(x = "Year",
         y= "CO2",
         title = "Change in CO2 from 1850 to 2021",
         caption = "This chart shows the change of CO2 from 1850 to 2021 where you select a country from the
         widget to see the change throughout the year.")
  })
  
  
  output$countryPlot <- renderPlotly({
    scatterPlot()
  })
  
  #2nd page chart 2
  
  

  output$scatter <- renderPlotly({
    
    # Store the title of the graph in a variable indicating the x/y variables
    title <- paste0("CO2 Dataset: ", input$x_var, " v.s.", input$y_var)
    
    p <- ggplot(filter(cleaned_data, country == input$country))  +
      geom_point(mapping = aes_string(x = input$x_var, y = input$y_var), 
                 size = input$size, 
                 color = input$color) +
      labs(x = input$x_var, y = input$y_var, title = title,
           caption = "In this chart, you can select the x and y variable that you want to compare with and you can choose a country
           where you want to focus on.")
    p
  })
  
  }

  
  
  
  


  
  

