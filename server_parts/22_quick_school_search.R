# --- 1. Initialize Map ---
output$TextMapping <- renderLeaflet({
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom = 5) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
    addProviderTiles(providers$CartoDB.Positron, group = "Road Map") %>%
    addMeasure(position = "topright",
               primaryLengthUnit = "kilometers",
               primaryAreaUnit = "sqmeters") %>%
    addLayersControl(baseGroups = c("Satellite", "Road Map"))
})

# --- 2. Update Picker Choices Dynamically ---

# This creates a 'filtered_data' reactive that changes based on selections
filtered_data_react <- reactive({
  
  data <- uni # Start with the full dataset
  
  if (!is.null(input$qss_region)) {
    data <- data %>% filter(Region %in% input$qss_region)
  }
  if (!is.null(input$qss_division)) {
    data <- data %>% filter(Division %in% input$qss_division)
  }
  if (!is.null(input$qss_legdist)) {
    data <- data %>% filter(Legislative.District %in% input$qss_legdist)
  }
  
  return(data)
})

# Observe Region input
observeEvent(input$qss_region, {
  data <- uni # Start from full data
  
  # Filter choices for Division
  if (!is.null(input$qss_region)) {
    data <- data %>% filter(Region %in% input$qss_region)
  }
  
  # Update Division, LegDist, and Municipality choices
  updatePickerInput(
    session, "qss_division",
    choices = sort(unique(data$Division)),
    selected = input$qss_division # Keep existing selection if still valid
  )
  
  updatePickerInput(
    session, "qss_legdist",
    choices = sort(unique(data$Legislative.District)),
    selected = input$qss_legdist 
  )
  
  updatePickerInput(
    session, "qss_municipality",
    choices = sort(unique(data$Municipality)),
    selected = input$qss_municipality
  )
}, ignoreNULL = FALSE, ignoreInit = TRUE) # `ignoreNULL = FALSE` is key!

# Observe Division input
observeEvent(input$qss_division, {
  data <- uni # Start from full data
  
  # Apply upstream filters
  if (!is.null(input$qss_region)) {
    data <- data %>% filter(Region %in% input$qss_region)
  }
  
  # Filter choices for LegDist
  if (!is.null(input$qss_division)) {
    data <- data %>% filter(Division %in% input$qss_division)
  }
  
  # Update LegDist and Municipality choices
  updatePickerInput(
    session, "qss_legdist",
    choices = sort(unique(data$Legislative.District)),
    selected = input$qss_legdist 
  )
  
  updatePickerInput(
    session, "qss_municipality",
    choices = sort(unique(data$Municipality)),
    selected = input$qss_municipality
  )
}, ignoreNULL = FALSE, ignoreInit = TRUE)

# Observe Legislative District input
observeEvent(input$qss_legdist, {
  data <- uni # Start from full data
  
  # Apply all upstream filters
  if (!is.null(input$qss_region)) {
    data <- data %>% filter(Region %in% input$qss_region)
  }
  if (!is.null(input$qss_division)) {
    data <- data %>% filter(Division %in% input$qss_division)
  }
  
  # Filter choices for Municipality
  if (!is.null(input$qss_legdist)) {
    data <- data %>% filter(Legislative.District %in% input$qss_legdist)
  }
  
  # Update Municipality choices
  updatePickerInput(
    session, "qss_municipality",
    choices = sort(unique(data$Municipality)),
    selected = input$qss_municipality
  )
}, ignoreNULL = FALSE, ignoreInit = TRUE)


# --- 3. Update Button State & Warning Message ---
observe({
  txt <- trimws(input$text)
  
  # Check if any advanced search filters are filled
  adv_search_filled <- !is.null(input$qss_region) || 
    !is.null(input$qss_division) || 
    !is.null(input$qss_legdist) || 
    !is.null(input$qss_municipality)
  
  # Enable button if EITHER text search OR advanced search is used
  can_run <- (txt != "" || adv_search_filled)
  shinyjs::toggleState("TextRun", condition = can_run)
  
  # Show or hide warning message
  output$text_warning_ui <- renderUI({
    if (!can_run) {
      tags$small(
        style = "color: red; font-style: italic;",
        "⚠ Please enter a school name or use advanced search."
      )
    } else {
      "" # Clear warning
    }
  })
})


# --- 4. Main Data Filtering (When "Show Selection" is clicked) ---

# We use eventReactive to create a "snapshot" of the filtered data
# This reactive only runs when input$TextRun is clicked
mainreact1 <- eventReactive(input$TextRun, {
  
  Text <- trimws(input$text)
  sel_region <- input$qss_region
  sel_division <- input$qss_division
  sel_legdist <- input$qss_legdist
  sel_municipality <- input$qss_municipality
  
  # Start with the full dataset
  filtered_data <- uni
  
  # 1. Conditionally filter by School Name
  if (Text != "") {
    filtered_data <- filtered_data %>%
      filter(grepl(Text, as.character(School.Name), ignore.case = TRUE))
  }
  
  # 2. Conditionally filter by Region
  if (!is.null(sel_region)) {
    filtered_data <- filtered_data %>%
      filter(Region %in% sel_region)
  }
  
  # 3. Conditionally filter by Division
  if (!is.null(sel_division)) {
    filtered_data <- filtered_data %>%
      filter(Division %in% sel_division)
  }
  
  # 4. Conditionally filter by Legislative District
  if (!is.null(sel_legdist)) {
    filtered_data <- filtered_data %>%
      filter(Legislative.District %in% sel_legdist)
  }
  
  # 5. Conditionally filter by Municipality
  if (!is.null(sel_municipality)) {
    filtered_data <- filtered_data %>%
      filter(Municipality %in% sel_municipality)
  }
  
  # Arrange for a clean final table
  filtered_data %>% arrange(Region, Division, Municipality, School.Name)
})

# This reactive filters the main results based on the map's current view
df1 <- reactive({
  # Get the data from our eventReactive
  data <- mainreact1()
  
  if (is.null(input$TextMapping_bounds)) {
    data
  } else {
    bounds <- input$TextMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(data,
           Latitude >= latRng[1] & Latitude <= latRng[2] & 
             Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})


# --- 5. Update Outputs after "Show Selection" is clicked ---

# This observer will trigger when mainreact1() (our data) is updated
observe({
  data <- mainreact1()
  
  # Handle no matching results
  if (nrow(data) == 0) {
    output$text_warning_ui <- renderUI({
      tags$small(
        style = "color: red; font-style: italic;",
        "⚠ No results found for the selected criteria."
      )
    })
    leafletProxy("TextMapping") %>%
      clearMarkers() %>%
      clearMarkerClusters()
    output$TextTable <- DT::renderDT(NULL)
    return()
  } else {
    # Clear any old warning
    output$text_warning_ui <- renderUI("") 
  }
  
  # --- Create leaflet labels ---
  values.comp <- paste(
    strong("SCHOOL INFORMATION"),
    "<br>School Name:", data$School.Name,
    "<br>School ID:", data$SchoolID
  ) %>% lapply(htmltools::HTML)
  
 # --- Update leaflet map ---
  leafletProxy("TextMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    # Fit the map to all the resulting points
    flyToBounds(
      lng1 = min(data$Longitude), lat1 = min(data$Latitude),
      lng2 = max(data$Longitude), lat2 = max(data$Latitude)
    ) %>%
    addAwesomeMarkers(
      lng = data$Longitude,
      lat = data$Latitude,
      icon = makeAwesomeIcon(
        icon = "education",
        library = "glyphicon",
        markerColor = "blue"
      ),
      label = values.comp,
      labelOptions = labelOptions(
        noHide = FALSE,
        textsize = "12px",
        direction = "top",
        fill = TRUE,
        style = list("border-color" = "rgba(0,0,0,0.5)")
      )
    )
})

# --- Render DataTable ---
output$TextTable <- DT::renderDT(server = TRUE, {
  datatable(
    df1() %>% # Use the map-filtered data
      select("Region", "Division", "Legislative.District", "Municipality", "School.Name") %>%
      rename("School" = "School.Name"),
    extension = 'Buttons',
    rownames = FALSE,
    selection = 'single', # Important: Allow only one row to be selected
    options = list(
      scrollX = TRUE,
      pageLength = 10,
      columnDefs = list(list(className = 'dt-center', targets = "_all")),
      dom = 'lrtip'
    ),
    filter = "top"
  )
})


# --- 6. BONUS: Logic for Table Row Click (Your missing piece) ---

observeEvent(input$TextTable_rows_selected, {
  # Get the index of the selected row
  idx <- input$TextTable_rows_selected
  if (is.null(idx)) return()
  
  # Get the data for that specific row from the reactive data table
  # Note: We must use df1() here to make sure the row index matches
  selected_school <- df1()[idx, ]
  
  # 1. Zoom map to the selected school
  leafletProxy("TextMapping") %>%
    flyTo(
      lng = selected_school$Longitude,
      lat = selected_school$Latitude,
      zoom = 15 # Zoom in close
    )
  
  # 2. Render the detailed info tables
  # We use the SchoolID to filter the original 'uni' dataset
  # This ensures we get all data, even if it wasn't in the table columns
  school_id <- selected_school$SchoolID
  details <- uni %>% filter(SchoolID == school_id)
  
  output$schooldetails <- renderTable({
    details %>% 
      select(SchoolID, School.Name, Region, Division, Municipality) %>%
      # You can add more fields here
      t() # Transpose for a cleaner look
  }, rownames = TRUE, colnames = FALSE)
  
  output$schooldetails2 <- renderTable({
    details %>% 
      select(TotalTeachers, Total.Excess, Total.Shortage) %>%
      # Add more HR fields
      t()
  }, rownames = TRUE, colnames = FALSE)
  
  output$schooldetails3 <- renderTable({
    details %>% 
      select(Instructional.Rooms.2023.2024, Classroom.Requirement, Est.CS) %>%
      # Add more Classroom fields
      t()
  }, rownames = TRUE, colnames = FALSE)
  
  output$schooldetails5 <- renderTable({
    details %>% 
      select(English, Mathematics, Science, Biological.Sciences, Physical.Sciences) %>%
      # Add more Specialization fields
      t()
  }, rownames = TRUE, colnames = FALSE)
})