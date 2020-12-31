#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    #Last updated ######################################
    output$last_updated <- renderUI(
        HTML(paste0("<em>Last updated: ", unique(max(old_data$date_entered)), "</em>"))
    )
    
    #Input map #########################################
    output$inputMap <- renderLeaflet(
        leaflet() %>%
            addProviderTiles("CartoDB.Positron", group="Greyscale") %>%
            setView(zoom=12, lat=29.3013, lng=-94.7977) %>% 
            addCircleMarkers(
                data = old_data_sf,
                radius = 6,
                stroke = F, fillOpacity = 0.5
            )
    )
    
    
    #Click map, store lng/lat, drop pin #################
    #Store lng/lat
    click_values <- reactiveValues(lat = NA, lng = NA)
    
    #Click map & drop pin
    observeEvent(input$inputMap_click,{
        click_values$lat <- input$inputMap_click$lat
        click_values$lng <- input$inputMap_click$lng
        
        leafletProxy('inputMap') %>% 
            clearGroup("drop_pin") %>% 
            addMarkers(
                lng = click_values$lng, lat = click_values$lat,
                group = "drop_pin",
                popup = paste0(round(click_values$lng, 1), ", ", round(click_values$lat, 1))
            )
    })

    
    #Export data ###########################################
    input_data <- reactive({
        new_data <- tibble(
            date_entered = Sys.Date(),
            date_surfed = c(input$date_surfed),
            surfed_with = c(input$surfed_with),
            surfed_where_text = c(input$surfed_where_text),
            surfed_where_lng = c(click_values$lng),
            surfed_where_lat = c(click_values$lat),
            surf_conditions = c(input$surf_conditions),
            wave_height = c(input$wave_height),
            notes = c(input$notes)
        )
        data <- rbind(old_data, new_data)
        return(data)
    })
    
    #Submit password
    observeEvent(input$submit, {
        showModal(
            modalDialog(
                title = "Enter password to submit data",
                textInput(inputId = "password_input", "Type password"),
                actionButton("submit_pw", "Submit password"),
                easyClose = T
            )
        )
        
    })
    
    #Submit data
    observeEvent(input$submit_pw, {
        #password protection
        if (input$password_input == app_password) {
            #Save data
            s3saveRDS(input_data(),
                      bucket = "surf-journal",
                      object = "surf-journal-data.rds")
            
            removeModal()
            shinyjs::reset("form")
            shinyjs::hide("form")
            shinyjs::show("thankyou_msg")

            #Refresh the data
            old_data <- loadData()
            old_data_sf <- loadData() %>% st_as_sf(., coords = c("surfed_where_lng", "surfed_where_lat"), crs=wgs84)
        } 

    })
    
    #Submit another and reset form #############################
    observeEvent(input$submit_another, {
        shinyjs::show("form")
        shinyjs::hide("thankyou_msg")
        
        #reset map
        leafletProxy('inputMap') %>% 
            clearGroup("drop_pin")
    })  


})
