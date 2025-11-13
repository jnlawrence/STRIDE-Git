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

# This new observer clears pickers when switching to "Simple Search"
observeEvent(input$search_mode, {
  
  # Wait for the input to exist
  req(!is.null(input$search_mode)) 
  
  if (input$search_mode == FALSE) {
    # --- Switched TO "Simple" ---
    # Clear all advanced inputs
    updateTextInput(session, "text_advanced", value = "")
    updatePickerInput(session, "qss_region", selected = character(0))
    updatePickerInput(session, "qss_division", selected = character(0))
    updatePickerInput(session, "qss_legdist", selected = character(0))
    updatePickerInput(session, "qss_municipality", selected = character(0))
    
  } else {
    # --- Switched TO "Advanced" ---
    # Clear the simple input
    updateTextInput(session, "text_simple", value = "")
  }
}, ignoreNULL = TRUE, ignoreInit = TRUE) # ignoreInit is important!

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
  
  req(!is.null(input$search_mode)) 
  is_advanced_mode <- isTRUE(input$search_mode)
  
  # Check if any advanced search *pickers* are filled
  adv_pickers_filled <- !is.null(input$qss_region) || 
    !is.null(input$qss_division) || 
    !is.null(input$qss_legdist) || 
    !is.null(input$qss_municipality)
  
  can_run <- FALSE
  warning_msg <- ""
  
  if (is_advanced_mode) {
    # --- Advanced Mode Logic ---
    txt <- trimws(input$text_advanced) # Read from advanced input
    can_run <- (txt != "" || adv_pickers_filled)
    if (!can_run) {
      warning_msg <- "⚠ Please enter a school name or use advanced search filters."
    }
    
  } else {
    # --- Simple Mode Logic ---
    txt <- trimws(input$text_simple) # Read from simple input
    can_run <- (txt != "")
    if (!can_run) {
      warning_msg <- "⚠ Please enter a school name."
    }
  }
  
  # Enable/disable button
  shinyjs::toggleState("TextRun", condition = can_run)
  
  # Show or hide warning message
  output$text_warning_ui <- renderUI({
    if (!can_run) {
      tags$small(
        style = "color: red; font-style: italic;",
        warning_msg
      )
    } else {
      "" # Clear warning
    }
  })
})


# --- 4. Main Data Filtering (When "Show Selection" is clicked) ---
# --- MODIFIED: Changed from eventReactive to the "Snapshot" pattern ---

# 4a. Create a reactiveVal to store our data "snapshot"
# This val will ONLY be updated when input$TextRun is clicked.
data_snapshot <- reactiveVal(NULL)

# 4b. This observeEvent now does the filtering and PUSHES
#    the result into our data_snapshot()
observeEvent(input$TextRun, {
  
  is_advanced <- isTRUE(input$search_mode)
  
  # --- START: Robust Check ---
  Text_pattern <- "" 
  
  if (is_advanced) {
    if (!is.null(input$text_advanced) && !is.na(input$text_advanced) && input$text_advanced != "") {
      Text_pattern <- trimws(input$text_advanced)
    }
  } else {
    if (!is.null(input$text_simple) && !is.na(input$text_simple) && input$text_simple != "") {
      Text_pattern <- trimws(input$text_simple)
    }
  }
  # --- END: Robust Check ---
  
  filtered_data <- uni
  
  if (Text_pattern != "") {
    filtered_data <- filtered_data %>%
      filter(grepl(Text_pattern, as.character(School.Name), ignore.case = TRUE))
  }
  
  if (is_advanced) {
    
    sel_region <- input$qss_region
    sel_division <- input$qss_division
    sel_legdist <- input$qss_legdist
    sel_municipality <- input$qss_municipality
    
    if (!is.null(sel_region)) {
      filtered_data <- filtered_data %>% filter(Region %in% sel_region)
    }
    if (!is.null(sel_division)) {
      filtered_data <- filtered_data %>% filter(Division %in% sel_division)
    }
    if (!is.null(sel_legdist)) {
      filtered_data <- filtered_data %>% filter(Legislative.District %in% sel_legdist)
    }
    if (!is.null(sel_municipality)) {
      filtered_data <- filtered_data %>% filter(Municipality %in% sel_municipality)
    }
  } 
  
  # Arrange for a clean final table
  final_data <- filtered_data %>% arrange(Region, Division, Municipality, School.Name)
  
  # --- THIS IS THE KEY ---
  # Save the final data to our "snapshot"
  data_snapshot(final_data)
  
}, ignoreNULL = TRUE, ignoreInit = TRUE) # This should listen to the button click


# --- 5. Update Outputs after "Show Selection" is clicked ---
# --- MODIFIED: Now observes data_snapshot() AND removed DT render ---

# This observer will trigger when data_snapshot() (our data) is updated
observe({
  data <- data_snapshot() # <-- CHANGED
  
  # Add a check for the initial NULL state (before any search)
  if (is.null(data)) {
    # This clears the map when the app first loads
    output$text_warning_ui <- renderUI("")
    leafletProxy("TextMapping") %>%
      clearMarkers() %>%
      clearMarkerClusters()
    return()
  }
  
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
# --- MODIFIED: A much more robust way to handle the initial NULL state ---
output$TextTable <- DT::renderDT(server = TRUE, {
  
  # Get the data from our snapshot
  data_from_snapshot <- data_snapshot()
  
  # 1. Check if the snapshot is NULL (on app startup)
  if (is.null(data_from_snapshot)) {
    
    # Create a blank data.frame with the *final* column names
    data_for_table <- data.frame(
      Region = character(0),
      Division = character(0),
      `Legislative.District` = character(0), # Use backticks for safety
      Municipality = character(0),
      School = character(0), # Final column name is "School"
      check.names = FALSE # Prevents R from changing the '.' in "Legislative.District"
    )
    
  } else {
    
    # 2. If we have data, process it
    data_for_table <- data_from_snapshot %>% 
      select(
        "Region", 
        "Division", 
        "Legislative.District", 
        "Municipality", 
        "School.Name" # Select the original column
      ) %>%
      rename("School" = "School.Name") # Rename it
  }
  
  # 3. Pass the prepared data (either blank or full) to datatable()
  datatable(
    data_for_table, 
    extension = 'Buttons',
    rownames = FALSE,
    selection = 'single', 
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
# --- MODIFIED: Changed mainreact1() to data_snapshot() ---

observeEvent(input$TextTable_rows_selected, {
  # Get the index of the selected row
  idx <- input$TextTable_rows_selected
  if (is.null(idx)) return()
  
  # --- THIS IS THE FIX ---
  # We get the data from our STABLE snapshot.
  # This does NOT re-run any filtering logic. It just reads the data.
  current_data <- data_snapshot() 
  
  # Safety check in case the snapshot is somehow NULL (e.g., race condition)
  if (is.null(current_data)) return()
  
  selected_school <- current_data[idx, ] # <-- CHANGED
  
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
      select(Region,Province,Municipality,Division,District,Barangay,Street.Address,SchoolID,School.Name,School.Head.Name,SH.Position,Implementing.Unit,Modified.COC,Latitude,Longitude) %>% rename("Modified Curricular Offering" = Modified.COC, "School ID" = SchoolID, "School Name" = School.Name, "Street Address" = Street.Address, "Implementing Unit" = Implementing.Unit, "School Head" = School.Head.Name,"School Head Position" = SH.Position) %>%
      # You can add more fields here
      t() # Transpose for a cleaner look
  }, rownames = TRUE, colnames = FALSE)
  
  output$schooldetails2 <- renderTable({
    details %>% 
      select(ES.Excess,ES.Shortage,JHS.Excess,JHS.Shortage,SHS.Excess,SHS.Shortage,ES.Teachers,JHS.Teachers,SHS.Teachers,ES.Enrolment,JHS.Enrolment,SHS.Enrolment,School.Size.Typology,Clustering.Status,Outlier.Status) %>% rename("ES Teachers"=ES.Teachers,"JHS Teachers"=JHS.Teachers,"SHS Teachers"=SHS.Teachers, "ES Enrolment" = ES.Enrolment, "JHS Enrolment" = JHS.Enrolment, "SHS Enrolment" = SHS.Enrolment, "School Size Typology" = School.Size.Typology, "AO II Deployment" = Clustering.Status,"COS Deployment" = Outlier.Status, "ES Shortage" = ES.Shortage,"ES Excess" = ES.Excess,"JHS Shortage" = JHS.Shortage,"JHS Excess" = JHS.Excess,"SHS Shortage" = SHS.Shortage,"SHS Excess" = SHS.Excess) %>%
      # Add more HR fields
      t()
  }, rownames = TRUE, colnames = FALSE)
  
  output$schooldetails3 <- renderTable({
    details %>% 
      select(Buildings,Instructional.Rooms.2023.2024,Classroom.Requirement,Est.CS,Buidable_space,Major.Repair.2023.2024,SBPI,Shifting,OwnershipType,ElectricitySource,WaterSource,Total.Seats.2023.2024,Total.Seats.Shortage.2023.2024) %>% rename("With Buildable Space" = Buidable_space,"Number of Instructional Rooms" = Instructional.Rooms.2023.2024,"Classroom Requirement" = Classroom.Requirement,"Ownership Type" = OwnershipType,"Source of Electricity" = ElectricitySource,"Source of Water" = WaterSource,"Estimated Classroom Shortage"= Est.CS,"School Building Priority Index" = SBPI,"For Major Repairs"= Major.Repair.2023.2024,"Total Seats"=Total.Seats.2023.2024,"Total Seats Shortage"=Total.Seats.Shortage.2023.2024, "Number of Buildings"=Buildings) %>%
      # Add more Classroom fields
      t()
  }, rownames = TRUE, colnames = FALSE)
  
  output$schooldetails5 <- renderTable({
    details %>% 
      select(English,Mathematics,Science,Biological.Sciences,Physical.Sciences,General.Ed,Araling.Panlipunan,TLE,MAPEH,Filipino,ESP,Agriculture,ECE,SPED) %>% rename("Biological Sciences" = Biological.Sciences,"Physical Sciences" = Physical.Sciences,"General Education" = General.Ed,"Araling Panlipunan" = Araling.Panlipunan,"Early Chilhood Education" = ECE) %>%
      # Add more Specialization fields
      t()
  }, rownames = TRUE, colnames = FALSE)
})