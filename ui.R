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
library(leaflet.extras)
library(sf)
library(config)
library(aws.s3)
library(shinyjs)
library(shinyWidgets)
library(DT)

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
                            uiOutput("surfed_with")
                     ),
                     column(4,
                            uiOutput("surfed_where_text")
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
                 actionButton("refresh_data", "Refresh data", class = "btn-primary"),
                 fluidRow(style = "padding-bottom:30px;")
                 
             ),
             shinyjs::hidden(
                 div(
                     id = "thankyou_msg",
                     h3("Thanks, your response was submitted successfully!"),
                     actionLink("submit_another", "Submit another response")
                 )
             )  
    ),
    
    tabPanel("Data",
             DT::dataTableOutput("data_table")
        
    )

    
))
