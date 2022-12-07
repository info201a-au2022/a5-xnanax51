library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(readr)
library(plotly)

#a5
co2_data <- read.csv("~/Documents/info201/data/owid-co2-data.csv")

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
  plotlyOutput("chart1"),
  plotlyOutput("chart2"),
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
      textOutput("sampleText")
    )
  ),
  
  
  x_input, 
  
  y_input,
  
  country_input,
  
  color_input,
  
  size_input, 
  
  # Plot the output with the name "scatter" (defined in `app_server.R`)
  plotlyOutput("scatter")
)



ui <- navbarPage(
  "CO2",
  intro_page,
  chart_panel
)
