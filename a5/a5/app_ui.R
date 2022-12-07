library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(readr)
library(plotly)

#a5
co2_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")


cleaned_data <- co2_data %>%
  select(country, year, population, gdp, co2, co2_growth_abs, co2_per_gdp, co2_growth_prct)

select_x_values <- colnames(cleaned_data)[-1]

select_y_values <- colnames(cleaned_data)[c(-1,-2)]

select_country <- unique(cleaned_data$country)

x_input <- selectInput(
  "x_var",
  label = "X Variable",
  choices = select_x_values,
  selected = "gdp"
)


y_input <- selectInput(
  "y_var",
  label = "Y Variable",
  choices = select_y_values,
  selected = "co2"
)

country_input <-selectInput(
  "country",
  label = "Country",
  choices = select_country
)

color_input <- selectInput(
  "color",
  label = "Color",
  choices = list("Red" = "red", "Blue" = "blue", "Purple" = "purple", "Black" = "b")
)


size_input <- sliderInput(
  "size",
  label = "Size of point", min = 1, max = 10, value = 5
)



intro_page <- tabPanel(
  "Introduction", 
  h1("A5: CO2 Exploration"), 
  p("In this assignment, I want to focus on the change in CO2 and GDP in each country and the world as a whole.
    In my three revelvant values of interest where I first focus on the change of CO2 from 1800s to 2021 for the world itself. Secondly, I filtered the dataset to the top 20 countries that have the most growth based on total production-based emissions of carbon dioxide (CO₂) in the year of 2021.
    Lastly, in my third value of interst, I would like to compare the difference of CO2 in the United States and the world itself throughout the years."),
  titlePanel("First Value"),
  p("In this chart, we can see the change in CO2 in the world from 1800s to the present year. We can see that the CO2 has been increasing throughout the year. 
    However, in the year of 2020, there is a reducement in CO2, but it rises again in 2021."),
  plotlyOutput("chart1"),
  titlePanel("Second Value"),
  p("In this chart, I want to focus on the value of growth of CO2 in the year of 2021 where I filtered down the top 20 countries that has the most growth in CO2 in the world.
    Surprisingly, I found out these countries are mostly devloping countries and this can also show why they have the most CO2 growth in 2021."),
  plotlyOutput("chart2"),
  titlePanel("Third Value"),
  p("In this chart, I want to focus on top 10 countries that has the most GDP the years in the world in 2021. And I filtered them to see their 
  CO2 per GDP in the dataset. I found quite interesting that China has the highest CO2 per GDP in 2017 compared to all other countries that are the top 10 countries for great GDP among the world.
    In the bottom of the page, there is a reference from investopedia that shows the top 10 countries for GDP."),
  plotlyOutput("chart3"),
  uiOutput("tab")
)



chart_panel <- tabPanel(
  "CO2 Chart",
  
  # A `titlePanel()` with the text "Income growth 1980-2014"
  titlePanel("CO2 growth 1980-2021"),
  
  
  # A `sidebarLayout()` to create two columns.
  # The sidebar layout will contain elements:
  sidebarLayout(
    sidebarPanel(
      uiOutput("selectCountry")
    ),
    
    
    mainPanel(
      plotlyOutput("countryPlot"),
      p( "This chart shows the change of CO2 from 1850 to 2021 where you select a country from the
         widget to see the change throughout the year."),
      textOutput("sampleText")
    )
  ),
  
  
  x_input, 
  
  y_input,
  
  country_input,
  
  color_input,
  
  size_input, 
  
  # Plot the output with the name "scatter" (defined in `app_server.R`)
  plotlyOutput("scatter"),
  p("In this chart, you can select the x and y variable that you want to compare with and you can choose a country
    where you want to focus on.")
)



ui <- navbarPage(
  "CO2",
  intro_page,
  chart_panel
)
