#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(leaflet)
library(sf)
library(config)
library(aws.s3)
library(shinyjs)
library(shinyWidgets)

source("read-data.R")

shinyUI(

    navbarPage(
    title = "Surf Journal",
    
    tabPanel("Input",
             shinyjs::useShinyjs(),
             div(
                 id = "form",
                 h2("Welcome to my surfing journal"),
                 p("My name is David, I live in Galveston, TX, and I started surfing in 2020.
                   This is a record of everywhere I've surfed, who I've surfed with, and what it was like. 
                   Data analytics to be added soon!"),
                 uiOutput("last_updated"),
                 fluidRow(style="padding-bottom: 10px;"),
                 leafletOutput("inputMap"), #Drop a pin to record lon/lat
                 
                 fluidRow(style = "padding-top: 20px;",
                     column(4,
                            dateInput(
                                inputId = "date_surfed", 
                                label = "Date surfed"
                            )
                     ),
                     column(4,
                            selectizeInput(
                                inputId = "surfed_with",
                                label = "Who I surfed with",
                                choices = c('Start typing...' = '', unique(old_data$surfed_with)),
                                selected = NULL,
                                options = list(create = T, placeholder = 'Start typing...')
                            )
                     ),
                     column(4,
                            selectizeInput(
                                inputId = "surfed_where_text",
                                label = "Where I surfed",
                                choices = c('Start typing...' = '', unique(old_data$surfed_where_text)),
                                options = list(create = T, placeholder = 'Start typing...')
                            )
                     )
                 ),
                 
                 fluidRow(
                     style = "padding-top: 20px;",
                     column(4,
                            selectInput(
                                inputId = "surf_conditions",
                                label = "Surf conditions",
                                choices = c("Clean", "Fair", "Choppy")
                            )
                     ),
                     column(4,
                            sliderInput(
                                inputId = "wave_height",
                                label = "Wave height (in feet)",
                                value = 0, min = 0, max = 10
                            )
                     ),
                     column(4,
                            textAreaInput(
                                inputId = "notes",
                                label = "Notes",
                                height = "100px", width = "100%"
                            )
                     )
                 ),
                 actionButton("submit", "Submit", class = "btn-primary"),
                 fluidRow(style = "padding-bottom:30px;")
                 
             ),
             shinyjs::hidden(
                 div(
                     id = "thankyou_msg",
                     h3("Thanks, your response was submitted successfully!"),
                     actionLink("submit_another", "Submit another response")
                 )
             )  
    )

    
))
