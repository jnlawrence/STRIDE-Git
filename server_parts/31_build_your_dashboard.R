# Build your Dashboard

# --- Drilldown State Management (UPDATED) ---
global_drill_state <- reactiveVal(list(
  level = "Region", 
  region = NULL,    
  division = NULL,
  municipality = NULL,         
  legislative_district = NULL, 
  
  # --- NEW FILTERS ADDED ---
  ownership_filter = NULL,
  electricity_filter = NULL,
  water_filter = NULL,
  # --- END NEW FILTERS ---
  
  coc_filter = NULL,      
  typology_filter = NULL, 
  shifting_filter = NULL,
  outlier_filter = NULL,
  clustering_filter = NULL
))
global_trigger <- reactiveVal(0) 

# --- Observer Lifecycle Manager ---
drilldown_observers <- reactiveVal(list())

# --- *** NEW: Reactive to store SchoolID from map or table click *** ---
reactive_selected_school_id <- reactiveVal(NULL)


# --- *** NEW: Define Metric Choices for Plot Titles *** ---
# This must match the 'choices' in your 10_stride2_UI.R pickers
hr_metric_choices <- list(
  `School Information` = c("Number of Schools" = "Total.Schools",
                           "School Size Typology" = "School.Size.Typology", 
                           "Curricular Offering" = "Modified.COC"),
  `Teaching Data` = c("Number of Teachers" = "TotalTeachers", 
                      "Teacher Excess" = "Total.Excess", 
                      "Teacher Shortage" = "Total.Shortage"),
  `Non-teaching Data` = c("COS" = "Outlier.Status", 
                          "AOII Clustering Status" = "Clustering.Status"),
  `Enrolment Data` = c("Total Enrolment" = "TotalEnrolment", "Kinder" = "Kinder", 
                       "Grade 1" = "G1", "Grade 2" = "G2", "Grade 3" = "G3", 
                       "Grade 4" = "G4", "Grade 5" = "G5", "Grade 6" = "G6", 
                       "Grade 7" = "G7", "Grade 8" = "G8", 
                       "Grade 9" = "G9", "Grade 10" = "G10", 
                       "Grade 11" = "G11", "Grade 12" = "G12"),
  `Specialization Data` = c("English" = "English", "Mathematics" = "Mathematics", 
                            "Science" = "Science", 
                            "Biological Sciences" = "Biological.Sciences", 
                            "Physical Sciences" = "Physical.Sciences")
)

infra_metric_choices <- list(
  `Classroom` = c("Number of Classrooms" = "Instructional.Rooms.2023.2024",
                  "Classroom Requirement" =  "Classroom.Requirement",
                  "Classroom Shortage" = "Est.CS",
                  "Shifting" = "Shifting",
                  "Number of Buildings" = "Buildings",
                  "Buildable Space" = "Buidable_space",
                  "Major Repairs Needed" = "Major.Repair.2023.2024"),
  `Facilities` = c("Seats Inventory" = "Total.Total.Seat",
                   "Seats Shortage" = "Total.Seats.Shortage"),
  # --- MOVED Resources to categorical ---
  `Resources` = c("Ownership Type" = "OwnershipType",
                  "Electricity Source" = "ElectricitySource",
                  "Water Source" = "WaterSource"
  ))

condition_metric_choices <- list(
  `Building Status` = c("Condemned (Building)" = "Building.Count_Condemned...For.Demolition",
                        "For Condemnation (Building)" = "Building.Count_For.Condemnation",
                        "For Completion (Building)" = "Building.Count_For.Completion",
                        "On-going Construction (Building)" = "Building.Count_On.going.Construction",
                        "Good Condition (Building)" = "Building.Count_Good.Condition",
                        "For Major Repairs (Building)" = "Building.Count_Needs.Major.Repair",
                        "For Minor Repairs (Building)" = "Building.Count_Needs.Minor.Repair"),
  `Classroom Status` = c("Condemned (Classroom)" = "Number.of.Rooms_Condemned...For.Demolition",
                         "For Condemnation (Classroom)" = "Number.of.Rooms_For.Condemnation",
                         "For Completion (Classroom)" = "Number.of.Rooms_For.Completion",
                         "On-going Construction (Classroom)" = "Number.of.Rooms_On.going.Construction",
                         "Good Condition (Classroom)" = "Number.of.Rooms_Good.Condition",
                         "For Major Repairs (Classroom)" = "Number.of.Rooms_Needs.Major.Repair",
                         "For Minor Repairs (Classroom)" = "Number.of.Rooms_Needs.Minor.Repair")
  
)

program_metric_choices <- list(
  "ALS/CLC" = c(
    "ALS/CLC (2024)" = "ALS.CLC_2024_Allocation"
  ),
  "Electrification" = c(
    "Electrification (2017)" = "ELECTRIFICATION.2017",
    "Electrification (2018)" = "ELECTRIFICATION.2018",
    "Electrification (2019)" = "ELECTRIFICATION.2019",
    "Electrification (2023)" = "ELECTRIFICATION.2023",
    "Electrification (2024)" = "ELECTRIFICATION.2024"
  ),
  "Gabaldon" = c(
    "Gabaldon (2020)" = "GABALDON.2020",
    "Gabaldon (2021)" = "GABALDON.2021",
    "Gabaldon (2022)" = "GABALDON.2022",
    "Gabaldon (2023)" = "GABALDON.2023",
    "Gabaldon (2024)" = "GABALDON.2024"
  ),
  "LibHub" = c(
    "LibHub (2024)" = "LibHub.2024"
  ),
  "LMS" = c(
    "LMS (2020)" = "LMS.2020",
    "LMS (2021)" = "LMS.2021",
    "LMS (2022)" = "LMS.2022",
    "LMS (2023)" = "LMS.2023",
    "LMS (2024)" = "LMS.2024"
  ),
  "NC" = c(
    "NC (2014)" = "NC.2014",
    "NC (2015)" = "NC.2015",
    "NC (2016)" = "NC.2016",
    "NC (2017)" = "NC.2017",
    "NC (2018)" = "NC.2018",
    "NC (2019)" = "NC.2019",
    "NC (2020)" = "NC.2020",
    "NC (2021)" = "NC.2021",
    "NC (2023)" = "NC.2023",
    "NC (2024)" = "NC.2024"
  ),
  "QRF" = c(
    "QRF (2019)" = "QRF.2019",
    "QRF (2020)" = "QRF.2020",
    "QRF (2021)" = "QRF.2021",
    "QRF (2022)" = "QRF.2022.REPLENISHMENT",
    "QRF (2023)" = "QRF.2023",
    "QRF (2024)" = "QRF.2024"
  ),
  "Repair" = c(
    "Repair (2020)" = "REPAIR.2020",
    "Repair (2021)" = "REPAIR.2021",
    "Repair (2022)" = "REPAIR.2022",
    "Repair (2023)" = "REPAIR.2023",
    "Repair (2024)" = "REPAIR.2024"
  ),
  "School Health Facilities" = c(
    "Health (2022)" = "SCHOOL.HEALTH.FACILITIES.2022",
    "Health (2024)" = "SCHOOL.HEALTH.FACILITIES.2024"
  ),
  "SPED/ILRC" = c(
    "SPED (2024)" = "SPED.ILRC.2024"
  )
)

# Combine and unlist to create a flat, named vector for lookups
metric_choices <- unlist(c(hr_metric_choices, infra_metric_choices, condition_metric_choices, program_metric_choices))

# --- *** MODIFIED (Change 1 of 3): Added "clean name" lookup vector *** ---
# This list combines all inner vectors, preserving their original, clean names
clean_metric_choices <- c(
  hr_metric_choices$`School Information`,
  hr_metric_choices$`Teaching Data`,
  hr_metric_choices$`Non-teaching Data`,
  hr_metric_choices$`Enrolment Data`,
  hr_metric_choices$`Specialization Data`,
  infra_metric_choices$Classroom,
  infra_metric_choices$Facilities,
  infra_metric_choices$Resources,
  condition_metric_choices$`Building Status`,
  condition_metric_choices$`Classroom Status`,
  program_metric_choices$`ALS/CLC`,
  program_metric_choices$Electrification,
  program_metric_choices$Gabaldon,
  program_metric_choices$LibHub,
  program_metric_choices$LMS,
  program_metric_choices$NC,
  program_metric_choices$QRF,
  program_metric_choices$Repair,
  program_metric_choices$`School Health Facilities`,
  program_metric_choices$`SPED/ILRC`
)


# --- *** NEW: COMBINED METRIC REACTIVE *** ---
all_selected_metrics <- reactive({
  hr_metrics <- input$Combined_HR_Toggles_Build
  infra_metrics <- input$Combined_Infra_Toggles_Build
  condition_metrics <- input$Combined_Conditions_Toggles_Build
  program_metrics <- input$Infra_Programs_Picker_Build # <-- RE-ADDED
  c(hr_metrics, infra_metrics, condition_metrics, program_metrics) # <-- RE-ADDED
})


# --- *** START: PRESET & PICKER SYNC LOGIC *** ---

# --- Define Metric Groups ---
teacher_metrics <- c("TotalTeachers", "Total.Shortage", "Total.Excess")
school_metrics <- c("Total.Schools","School.Size.Typology", "Modified.COC") 
classroom_metrics <- c("Instructional.Rooms.2023.2024", "Classroom.Requirement", "Shifting")
enrolment_metrics <- c("G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12")
buildingcondition_metrics <- c("Building.Count_Condemned...For.Demolition","Building.Count_For.Completion",             
                               "Building.Count_For.Condemnation","Building.Count_Good.Condition",             
                               "Building.Count_Needs.Major.Repair","Building.Count_Needs.Minor.Repair",         
                               "Building.Count_On.going.Construction")
roomcondition_metrics <- c("Number.of.Rooms_Condemned...For.Demolition","Number.of.Rooms_For.Completion","Number.of.Rooms_For.Condemnation","Number.of.Rooms_Good.Condition","Number.of.Rooms_Needs.Major.Repair","Number.of.Rooms_Needs.Minor.Repair","Number.of.Rooms_On.going.Construction")

# --- Observer 1: Sync Pickers -> Toggles ---


# --- Observers 2-4: Sync Toggles -> Pickers (Add-only logic) ---

# --- Observers 2-5: Sync Toggles -> Pickers (UPDATED) ---

# Preset 1: Teacher Focus Toggle
observeEvent(input$preset_teacher, {
  current_selection <- isolate(input$Combined_HR_Toggles_Build)
  if (input$preset_teacher == TRUE) {
    new_selection <- union(current_selection, teacher_metrics)
  } else {
    # --- ADDED: This will remove the metrics ---
    new_selection <- setdiff(current_selection, teacher_metrics)
  }
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_HR_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)

# Preset 2: School Focus Toggle
observeEvent(input$preset_school, {
  current_selection <- isolate(input$Combined_HR_Toggles_Build)
  if (input$preset_school == TRUE) {
    new_selection <- union(current_selection, school_metrics)
  } else {
    # --- ADDED: This will remove the metrics ---
    new_selection <- setdiff(current_selection, school_metrics)
  }
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_HR_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)


# Preset 3: Infrastructure Focus Toggle
observeEvent(input$preset_classroom, {
  current_selection <- isolate(input$Combined_Infra_Toggles_Build)
  if (input$preset_classroom == TRUE) {
    new_selection <- union(current_selection, classroom_metrics)
  } else {
    # --- ADDED: This will remove the metrics ---
    new_selection <- setdiff(current_selection, classroom_metrics)
  }
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_Infra_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)

# Preset 4: Enrolment Focus Toggle
observeEvent(input$preset_enrolment, {
  current_selection <- isolate(input$Combined_HR_Toggles_Build)
  if (input$preset_enrolment == TRUE) {
    new_selection <- union(current_selection, enrolment_metrics)
  } else {
    # --- ADDED: This will remove the metrics ---
    new_selection <- setdiff(current_selection, enrolment_metrics)
  }
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_HR_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)

# Preset 5: Building Condition Focus Toggle
observeEvent(input$preset_buildingcondition, {
  # Isolate the selection from the NEW conditions picker
  current_selection <- isolate(input$Combined_Conditions_Toggles_Build) 
  
  if (input$preset_buildingcondition == TRUE) {
    # Add the building condition metrics
    new_selection <- union(current_selection, buildingcondition_metrics) 
  } else {
    # Remove the building condition metrics
    new_selection <- setdiff(current_selection, buildingcondition_metrics)
  }
  
  # Update the NEW conditions picker
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_Conditions_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)

# Preset 6: Room Condition Focus Toggle
observeEvent(input$preset_roomcondition, {
  # Isolate the selection from the NEW conditions picker
  current_selection <- isolate(input$Combined_Conditions_Toggles_Build) 
  
  if (input$preset_roomcondition == TRUE) {
    # Add the room condition metrics
    new_selection <- union(current_selection, roomcondition_metrics) 
  } else {
    # Remove the room condition metrics
    new_selection <- setdiff(current_selection, roomcondition_metrics)
  }
  
  # Update the NEW conditions picker
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_Conditions_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)

# --- *** END: PRESET & PICKER SYNC LOGIC *** ---

# --- *** END: PRESET & PICKER SYNC LOGIC *** ---


# --- *** UPDATED: Conditional UI for Data Explorer Tab *** ---
output$data_explorer_content <- renderUI({
  
  state <- global_drill_state()
  
  # Condition: No region is selected (user is at the top level)
  if (state$level == "Region") {
    
    # Render the instruction message
    tags$div(
      class = "d-flex align-items-center justify-content-center",
      style = "height: 60vh; padding: 20px;", 
      bslib::card(
        style = "max-width: 600px;", 
        bslib::card_body(
          h4("Data Explorer", class = "card-title"),
          p("Please go to the ", tags$b("Dashboard Visuals"), " tab and click on a bar in any graph to select a region."),
          p("The map and data table will appear here once you have drilled down into a specific area.")
        )
      )
    )
    
  } else {
    
    # Render the map/table/details UI
    tagList(
      
      # --- SECTION 1: Map and Table (SWAPPED) ---
      bslib::layout_columns(
        col_widths = c(6, 6), 
        
        # --- Column 1: Datatable (MOVED) ---
        bslib::card(
          full_screen = TRUE,
          bslib::card_header("Filtered Data (Click a row)"),
          bslib::card_body(
            DT::dataTableOutput("school_table")
          )
        ),
        
        # --- Column 2: Leaflet Map (MOVED) ---
        bslib::card(
          full_screen = TRUE,
          bslib::card_header("School Map (Click a school)"),
          bslib::card_body(
            leaflet::leafletOutput("school_map", height = "500px") 
          )
        )
      ), # End layout_columns
      
      # --- SECTION 2: School Details ---
      bslib::card(
        full_screen = TRUE,
        card_header(div(strong("School Details"),
                        tags$span(em("(Select a school from the table or map above)"),
                                  style = "font-size: 0.7em; color: grey;"
                        ))),
        card_body(
          uiOutput("build_dashboard_school_details_ui") 
        )
      )
    ) # End tagList
  } # End else
})


# --- Map & Table Server Logic ---
output$school_map <- leaflet::renderLeaflet({
  req(global_trigger() > 0)
  data_to_map_raw <- filtered_data() 
  req(nrow(data_to_map_raw) > 0)
  req("Latitude" %in% names(data_to_map_raw), "Longitude" %in% names(data_to_map_raw))
  
  data_to_map <- data_to_map_raw %>%
    mutate(
      TotalEnrolment = as.numeric(as.character(TotalEnrolment)),
      Instructional.Rooms.2023.2024 = as.numeric(as.character(Instructional.Rooms.2023.2024)),
      TotalTeachers = as.numeric(as.character(TotalTeachers))
    )
  
  leaflet(data_to_map) %>%
    addProviderTiles(providers$Esri.WorldImagery) %>%
    fitBounds(
      lng1 = min(data_to_map$Longitude, na.rm = TRUE),
      lat1 = min(data_to_map$Latitude, na.rm = TRUE),
      lng2 = max(data_to_map$Longitude, na.rm = TRUE),
      lat2 = max(data_to_map$Latitude, na.rm = TRUE)
    ) %>%
    addMarkers(
      lng = ~Longitude,
      lat = ~Latitude,
      label = ~lapply(paste(
        "<strong>School:</strong>", htmltools::htmlEscape(School.Name),
        "<br/><strong>School ID:</strong>", htmltools::htmlEscape(SchoolID),
        "<br/><strong>Typology:</strong>", htmltools::htmlEscape(School.Size.Typology),
        "<br/><strong>Total Enrolment:</strong>", 
        ifelse(is.na(TotalEnrolment), "N/A", scales::comma(TotalEnrolment, accuracy = 1))
      ), htmltools::HTML),
      labelOptions = labelOptions(noHide = FALSE, direction = 'auto'),
      layerId = ~SchoolID, # --- IMPORTANT: This is the ID we use for clicks ---
      clusterOptions = markerClusterOptions() 
    )
})

# --- data_in_bounds (Unchanged) ---
data_in_bounds <- reactive({
  data_to_filter <- filtered_data()
  req(nrow(data_to_filter) > 0)
  req("Latitude" %in% names(data_to_filter), "Longitude" %in% names(data_to_filter))
  
  bounds <- input$school_map_bounds
  if (is.null(bounds)) {
    return(data_to_filter)
  }
  
  data_to_filter %>%
    filter(
      Latitude >= bounds$south & Latitude <= bounds$north &
        Longitude >= bounds$west & Longitude <= bounds$east
    )
})

# --- school_table (Unchanged) ---
output$school_table <- DT::renderDataTable({
  req(global_trigger() > 0)
  data_for_table <- data_in_bounds()
  cols_to_show <- c("SchoolID", "School.Name", "Division", "Region", "TotalTeachers", "Modified.COC")
  cols_to_show <- intersect(cols_to_show, names(data_for_table))
  req(length(cols_to_show) > 0)
  
  DT::datatable(
    data_for_table[, cols_to_show],
    selection = 'single', 
    rownames = FALSE,
    options = list(
      pageLength = 10,
      scrollY = "400px", 
      scrollCollapse = TRUE,
      paging = FALSE 
    )
  )
})

# --- *** NEW: Observers for Map/Table Clicks *** ---

# --- Observer for Table Clicks (UPDATED) ---
observeEvent(input$school_table_rows_selected, {
  selected_row_index <- input$school_table_rows_selected
  req(selected_row_index)
  
  table_data <- data_in_bounds()
  selected_row_data <- table_data[selected_row_index, ]
  
  # Set the reactive ID for school details
  reactive_selected_school_id(selected_row_data$SchoolID)
  
  req("Latitude" %in% names(selected_row_data), "Longitude" %in% names(selected_row_data))
  
  # Zoom the map
  leafletProxy("school_map", session) %>%
    setView(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15 
    )
}, ignoreNULL = TRUE, ignoreInit = TRUE)

# --- Observer for Map Marker Clicks ---
observeEvent(input$school_map_marker_click, {
  clicked_marker <- input$school_map_marker_click
  req(clicked_marker$id) 
  reactive_selected_school_id(clicked_marker$id)
}, ignoreNULL = TRUE, ignoreInit = TRUE)

# --- Observer to clear selection on any data change ---
observeEvent(global_trigger(), {
  reactive_selected_school_id(NULL)
}, ignoreInit = TRUE)


# --- Back Button Logic (UPDATED) ---
# In 31_build_your_dashboard.R

# --- Back Button Logic (UPDATED to support two buttons) ---
output$back_button_ui <- renderUI({
  state <- global_drill_state() 
  
  # --- Logic for Button 1: Undo ---
  undo_button <- NULL # Start as NULL
  undo_button_label <- ""  
  show_undo_button <- FALSE 
  
  # (This is your existing logic, unchanged)
  if (!is.null(state$clustering_filter)) {
    label_text <- stringr::str_trunc(state$clustering_filter, 20) 
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$outlier_filter)) {
    label_text <- stringr::str_trunc(state$outlier_filter, 20) 
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$shifting_filter)) {
    label_text <- stringr::str_trunc(state$shifting_filter, 20) 
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$typology_filter)) {
    label_text <- stringr::str_trunc(state$typology_filter, 20) 
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$coc_filter)) {
    label_text <- stringr::str_trunc(state$coc_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$water_filter)) { 
    label_text <- stringr::str_trunc(state$water_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$electricity_filter)) { 
    label_text <- stringr::str_trunc(state$electricity_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$ownership_filter)) { 
    label_text <- stringr::str_trunc(state$ownership_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (state$level == "District") {
    undo_button_label <- "Undo Drilldown"; show_undo_button <- TRUE
  } else if (state$level == "Legislative.District") {
    undo_button_label <- "Undo Drilldown"; show_undo_button <- TRUE
  } else if (state$level == "Municipality") {
    undo_button_label <- "Undo Drilldown"; show_undo_button <- TRUE
  } else if (state$level == "Division") {
    undo_button_label <- "Undo Drilldown"; show_undo_button <- TRUE
  }
  
  if (show_undo_button) { 
    undo_button <- actionButton("back_button", undo_button_label, icon = icon("undo"), class = "btn-danger") 
  }
  
  # --- Logic for Button 2: Reset to Region (NEW) ---
  reset_button <- NULL # Start as NULL
  
  # Condition: Show only if level is "beyond Division"
  if (state$level %in% c("Municipality", "Legislative.District", "District")) {
    reset_button <- actionButton(
      "reset_to_region_button", 
      "Go back to Regional View", 
      icon = icon("home"), 
      class = "btn-warning" # Using warning to stand out
    )
  }
  
  # --- Return a tagList of both buttons ---
  # NULL buttons will not be rendered
  tagList(
    undo_button,
    reset_button
  )
})

# --- Back Button Observer (UPDATED) ---
observeEvent(input$back_button, {
  state <- isolate(global_drill_state()) 
  new_state <- state 
  
  # --- UPDATED: Added new filters to precedence list ---
  if (!is.null(state$clustering_filter)) {
    new_state$clustering_filter <- NULL
  } else if (!is.null(state$outlier_filter)) {
    new_state$outlier_filter <- NULL
  } else if (!is.null(state$shifting_filter)) {
    new_state$shifting_filter <- NULL
  } else if (!is.null(state$typology_filter)) {
    new_state$typology_filter <- NULL 
  } else if (!is.null(state$coc_filter)) {
    new_state$coc_filter <- NULL      
  } else if (!is.null(state$water_filter)) { # --- NEW ---
    new_state$water_filter <- NULL
  } else if (!is.null(state$electricity_filter)) { # --- NEW ---
    new_state$electricity_filter <- NULL
  } else if (!is.null(state$ownership_filter)) { # --- NEW ---
    new_state$ownership_filter <- NULL
  } else if (state$level == "District") {
    new_state$level <- "Legislative.District"; new_state$legislative_district <- NULL 
  } else if (state$level == "Legislative.District") {
    new_state$level <- "Municipality"; new_state$municipality <- NULL
  } else if (state$level == "Municipality") {
    new_state$level <- "Division"; new_state$division <- NULL
  } else if (state$level == "Division") {
    new_state$level <- "Region"; new_state$region <- NULL
  }
  
  global_drill_state(new_state)
  global_trigger(global_trigger() + 1) 
})

# In 31_build_your_dashboard.R

# --- *** NEW: Reset to Region Button Observer *** ---
observeEvent(input$reset_to_region_button, {
  
  # Define the default (top-level) state
  # This is the same list you use to initialize global_drill_state
  default_state <- list(
    level = "Region", 
    region = NULL,    
    division = NULL,
    municipality = NULL,         
    legislative_district = NULL, 
    ownership_filter = NULL,
    electricity_filter = NULL,
    water_filter = NULL,
    coc_filter = NULL,      
    typology_filter = NULL, 
    shifting_filter = NULL,
    outlier_filter = NULL,
    clustering_filter = NULL
  )
  
  # Set the state back to default
  global_drill_state(default_state)
  
  # Increment the trigger to force all elements to update
  global_trigger(global_trigger() + 1) 
  
}, ignoreNULL = TRUE, ignoreInit = TRUE)
# --- *** END NEW OBSERVER *** ---


# --- *** UPDATED: DYNAMIC OBSERVER MANAGER (REVERTED) *** ---
observe({
  
  # <-- BUG FIX (Change 1): React to trigger to force re-creation
  global_trigger() 
  
  selected_metrics <- all_selected_metrics() 
  
  old_handles <- isolate(drilldown_observers())
  walk(old_handles, ~ .x$destroy()) 
  
  new_handles <- map(selected_metrics, ~{
    current_metric <- .x
    
    # <-- BUG FIX (Change 2): Create dynamic source names tied to the trigger
    current_trigger_val <- isolate(global_trigger())
    
    # --- DYNAMIC CATEGORICAL SOURCES ---
    coc_source <- paste0("coc_pie_click_", current_trigger_val)
    typology_source <- paste0("typology_bar_click_", current_trigger_val)
    shifting_source <- paste0("shifting_bar_click_", current_trigger_val)
    outlier_source <- paste0("outlier_click_", current_trigger_val) 
    clustering_source <- paste0("clustering_click_", current_trigger_val)
    ownership_source <- paste0("ownership_click_", current_trigger_val)
    electricity_source <- paste0("electricity_click_", current_trigger_val)
    water_source <- paste0("water_click_", current_trigger_val)
    
    # --- DYNAMIC GEOGRAPHIC SOURCE ---
    current_metric_source <- paste0("plot_source_", current_metric, "_", current_trigger_val)
    
    
    # --- Categorical Filter Observers (UPDATED) ---
    observeEvent(event_data("plotly_click", source = coc_source), { # <-- MODIFIED
      d <- event_data("plotly_click", source = coc_source); if (is.null(d$y)) return() # <-- MODIFIED
      state <- isolate(global_drill_state()); state$coc_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = typology_source), { # <-- MODIFIED
      d <- event_data("plotly_click", source = typology_source); if (is.null(d$y)) return() # <-- MODIFIED
      state <- isolate(global_drill_state()); state$typology_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = shifting_source), { # <-- MODIFIED
      d <- event_data("plotly_click", source = shifting_source); if (is.null(d$y)) return() # <-- MODIFIED
      state <- isolate(global_drill_state()); state$shifting_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = outlier_source), { # <-- MODIFIED
      d <- event_data("plotly_click", source = outlier_source); if (is.null(d$y)) return() # <-- MODIFIED
      state <- isolate(global_drill_state()); state$outlier_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = clustering_source), { # <-- MODIFIED
      d <- event_data("plotly_click", source = clustering_source); if (is.null(d$y)) return() # <-- MODIFIED
      state <- isolate(global_drill_state()); state$clustering_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    # --- *** NEW OBSERVERS ADDED *** ---
    observeEvent(event_data("plotly_click", source = ownership_source), { # <-- MODIFIED
      d <- event_data("plotly_click", source = ownership_source); if (is.null(d$y)) return() # <-- MODIFIED
      state <- isolate(global_drill_state()); state$ownership_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = electricity_source), { # <-- MODIFIED
      d <- event_data("plotly_click", source = electricity_source); if (is.null(d$y)) return() # <-- MODIFIED
      state <- isolate(global_drill_state()); state$electricity_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = water_source), { # <-- MODIFIED
      d <- event_data("plotly_click", source = water_source); if (is.null(d$y)) return() # <-- MODIFIED
      state <- isolate(global_drill_state()); state$water_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    # --- *** END NEW OBSERVERS *** ---
    
    
    # --- Geographic Drilldown Observer (Unchanged) ---
    # This now applies to ALL metrics, including programs
    observeEvent(event_data("plotly_click", source = current_metric_source), { # <-- MODIFIED
      state <- isolate(global_drill_state()); if (state$level == "District") return() 
      d <- event_data("plotly_click", source = current_metric_source); if (is.null(d$y)) return() # <-- MODIFIED
      
      new_state <- state 
      if (state$level == "Region") {
        new_state$level <- "Division"; new_state$region <- d$y
      } else if (state$level == "Division") {
        new_state$level <- "Municipality"; new_state$division <- d$y
      } else if (state$level == "Municipality") { 
        new_state$level <- "Legislative.District"; new_state$municipality <- d$y
      } else if (state$level == "Legislative.District") { 
        new_state$level <- "District"; new_state$legislative_district <- d$y
      }
      global_drill_state(new_state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
  })
  
  drilldown_observers(new_handles)
})


# --- Reactive Data (filtered_data) (UPDATED) ---
filtered_data <- reactive({
  trigger <- global_trigger() 
  state <- global_drill_state()
  temp_data <- uni
  
  if (state$level == "Division") {
    req(state$region); temp_data <- temp_data %>% filter(Region == state$region)
  } else if (state$level == "Municipality") { 
    req(state$region, state$division); temp_data <- temp_data %>% filter(Region == state$region, Division == state$division)
  } else if (state$level == "Legislative.District") { 
    req(state$region, state$division, state$municipality); temp_data <- temp_data %>% filter(Region == state$region, Division == state$division, Municipality == state$municipality)
  } else if (state$level == "District") { 
    req(state$region, state$division, state$municipality, state$legislative_district); temp_data <- temp_data %>% filter(Region == state$region, Division == state$division, Municipality == state$municipality, Legislative.District == state$legislative_district)
  }
  
  # --- UPDATED: Added new filters ---
  if (!is.null(state$coc_filter)) { temp_data <- temp_data %>% filter(Modified.COC == state$coc_filter) }
  if (!is.null(state$typology_filter)) { temp_data <- temp_data %>% filter(School.Size.Typology == state$typology_filter) }
  if (!is.null(state$shifting_filter)) { temp_data <- temp_data %>% filter(Shifting == state$shifting_filter) }
  if (!is.null(state$outlier_filter)) { temp_data <- temp_data %>% filter(Outlier.Status == state$outlier_filter) }
  if (!is.null(state$clustering_filter)) { temp_data <- temp_data %>% filter(Clustering.Status == state$clustering_filter) }
  if (!is.null(state$ownership_filter)) { temp_data <- temp_data %>% filter(OwnershipType == state$ownership_filter) } # --- NEW ---
  if (!is.null(state$electricity_filter)) { temp_data <- temp_data %>% filter(ElectricitySource == state$electricity_filter) } # --- NEW ---
  if (!is.null(state$water_filter)) { temp_data <- temp_data %>% filter(WaterSource == state$water_filter) } # --- NEW ---
  
  temp_data
})

# In 31_build_your_dashboard.R

# ... (put this after your filtered_data reactive) ...

# --- *** NEW: Current Filter Text Display *** ---
# In 31_build_your_dashboard.R

# --- *** NEW: Current Filter Text Display (Corrected) *** ---
output$current_filter_text <- renderText({
  
  # Re-run whenever the state or trigger changes
  global_trigger()
  state <- global_drill_state()
  
  # Start with an empty vector
  filter_parts <- c()
  
  # Add geographic drilldown filters (only if not at the top "Region" level)
  if (state$level != "Region") {
    if (!is.null(state$region)) {
      filter_parts <- c(filter_parts, state$region) # No "Region:" prefix
    }
    if (!is.null(state$division)) {
      filter_parts <- c(filter_parts, state$division) # No "Division:" prefix
    }
    if (!is.null(state$municipality)) {
      filter_parts <- c(filter_parts, state$municipality) # No "Municipality:" prefix
    }
    if (!is.null(state$legislative_district)) {
      filter_parts <- c(filter_parts, state$legislative_district) # No "Leg. District:" prefix
    }
  }
  
  # Add all other categorical filters
  if (!is.null(state$coc_filter)) {
    filter_parts <- c(filter_parts, paste("Offering:", state$coc_filter))
  }
  if (!is.null(state$typology_filter)) {
    filter_parts <- c(filter_parts, paste("Typology:", state$typology_filter))
  }
  if (!is.null(state$shifting_filter)) {
    filter_parts <- c(filter_parts, paste("Shifting:", state$shifting_filter))
  }
  if (!is.null(state$ownership_filter)) {
    filter_parts <- c(filter_parts, paste("Ownership:", state$ownership_filter))
  }
  if (!is.null(state$electricity_filter)) {
    filter_parts <- c(filter_parts, paste("Electricity:", state$electricity_filter))
  }
  if (!is.null(state$water_filter)) {
    filter_parts <- c(filter_parts, paste("Water:", state$water_filter))
  }
  if (!is.null(state$outlier_filter)) {
    filter_parts <- c(filter_parts, paste("Outlier:", state$outlier_filter))
  }
  if (!is.null(state$clustering_filter)) {
    filter_parts <- c(filter_parts, paste("Clustering:", state$clustering_filter))
  }
  
  # --- *** THIS IS THE FIX *** ---
  # Check if length is 0 (not 1)
  if (length(filter_parts) == 0 && state$level == "Region") {
    # If no filters and at top level
    final_text <- "Viewing All Regions"
  } else {
    # Otherwise, show all active filters separated by " -> "
    final_text <- paste(filter_parts, collapse = " -> ")
  }
  
  # Add the "Current Filter:" prefix
  paste("Current Filter:", final_text)
  
})
# --- *** END CORRECTED SECTION *** ---
# --- *** END NEW SECTION *** ---

# --- Reactive Data (summarized_data_long) (UPDATED) ---
summarized_data_long <- reactive({
  
  selected_metrics_list <- all_selected_metrics()
  # --- MODIFICATION: Check for empty selection ---
  if (length(selected_metrics_list) == 0) {
    # Return an empty tibble with the correct structure
    return(tibble(Category = character(), Metric = character(), Value = numeric()))
  }
  # --- END MODIFICATION ---
  
  state <- global_drill_state() 
  group_by_col <- state$level  
  metrics_to_process <- selected_metrics_list 
  data_in <- filtered_data()
  summaries_list <- list()
  
  if ("Total.Schools" %in% metrics_to_process) {
    school_count_summary <- data_in %>%
      group_by(!!sym(group_by_col)) %>%
      summarise(Value = n(), .groups = "drop") %>% 
      rename(Category = !!sym(group_by_col)) %>%
      mutate(Metric = "Total.Schools") 
    summaries_list[["school_count"]] <- school_count_summary
  }
  
  # --- UPDATED: Added new metrics to categorical list ---
  categorical_metrics <- c("Modified.COC", "School.Size.Typology", "Total.Schools","Shifting", "Completion",
                           "Outlier.Status", "Clustering.Status", "OwnershipType", "ElectricitySource", "WaterSource")
  
  numeric_metrics_to_process <- setdiff(metrics_to_process, categorical_metrics)
  existing_metrics <- intersect(numeric_metrics_to_process, names(data_in))
  
  if (length(existing_metrics) > 0) {
    data_in <- data_in %>%
      mutate(across(all_of(existing_metrics), ~ as.numeric(as.character(.))))
    
    valid_metrics <- existing_metrics[sapply(data_in[existing_metrics], is.numeric)]
    
    if (length(valid_metrics) > 0) {
      numeric_summary <- data_in %>%
        select(!!sym(group_by_col), all_of(valid_metrics)) %>%
        pivot_longer(cols = all_of(valid_metrics), names_to = "Metric", values_to = "Value") %>%
        group_by(!!sym(group_by_col), Metric) %>%
        summarise(Value = sum(Value, na.rm = TRUE), .groups = "drop") %>%
        rename(Category = !!sym(group_by_col))
      summaries_list[["numeric_metrics"]] <- numeric_summary
    }
  }
  
  if (length(summaries_list) == 0) {
    return(tibble(Category = character(), Metric = character(), Value = numeric()))
  }
  
  bind_rows(summaries_list)
})


# --- Dynamic UI Dashboard Grid (REVERTED) ---
output$dashboard_grid <- renderUI({
  
  selected_metrics <- all_selected_metrics() 
  
  if (length(selected_metrics) == 0) {
    return(
      tags$div(
        class = "d-flex align-items-center justify-content-center", style = "height: 60vh; padding: 20px;", 
        bslib::card(
          style = "max-width: 600px;", 
          bslib::card_body(
            h4("Welcome to your Dashboard!", class = "card-title"),
            p("Welcome to this Interactive Education Resource Dashboard."),
            p("Start by selecting any of the presets or choosing from the advanced filters available on the sidebar to build your view.")
          )
        )
      )
    )
  }
  
  # --- *** Pre-filter data for plots *** ---
  metric_plot_data <- summarized_data_long()
  
  # --- 1. Create Plotly Renders ---
  walk(selected_metrics, ~{
    current_metric <- .x
    
    # <-- BUG FIX (Change 3): Get current trigger value
    current_trigger_val <- isolate(global_trigger())
    
    # --- *** MODIFIED (Change 2 of 3): Use clean_metric_choices *** ---
    current_metric_name <- names(clean_metric_choices)[clean_metric_choices == current_metric]
    
    state <- global_drill_state()
    level_name <- stringr::str_to_title(state$level) 
    plot_title <- current_metric_name 
    
    if (state$level == "Region") {
      plot_title <- paste(plot_title, "by", level_name)
    } else if (state$level == "Division") {
      plot_title <- paste(plot_title, "by", level_name, "in", state$region)
    } else if (state$level == "Municipality") { 
      plot_title <- paste(plot_title, "by", level_name, "in", state$division)
    } else if (state$level == "Legislative.District") { 
      plot_title <- paste(plot_title, "by", level_name, "in", state$municipality)
    } else if (state$level == "District") { 
      plot_title <- paste(plot_title, "by", level_name, "in", state$legislative_district)
    }
    
    filter_parts <- c()
    if (!is.null(state$coc_filter)) { filter_parts <- c(filter_parts, state$coc_filter) }
    if (!is.null(state$typology_filter)) { filter_parts <- c(filter_parts, state$typology_filter) }
    if (!is.null(state$shifting_filter)) { filter_parts <- c(filter_parts, state$shifting_filter) }
    if (!is.null(state$outlier_filter)) { filter_parts <- c(filter_parts, state$outlier_filter) }
    if (!is.null(state$clustering_filter)) { filter_parts <- c(filter_parts, state$clustering_filter) }
    if (!is.null(state$ownership_filter)) { filter_parts <- c(filter_parts, state$ownership_filter) } # --- NEW ---
    if (!is.null(state$electricity_filter)) { filter_parts <- c(filter_parts, state$electricity_filter) } # --- NEW ---
    if (!is.null(state$water_filter)) { filter_parts <- c(filter_parts, state$water_filter) } # --- NEW ---
    
    if (length(filter_parts) > 0) {
      plot_title <- paste0(plot_title, " (Filtered by: ", paste(filter_parts, collapse = ", "), ")")
    }
    
    # --- UPDATED IF CONDITION ---
    if (current_metric %in% c("Modified.COC", "School.Size.Typology", "Shifting", "Total.Schools", "Completion", 
                              "Outlier.Status", "Clustering.Status", "OwnershipType", "ElectricitySource", "WaterSource")) {
      
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          bar_data <- tibble() 
          if (current_metric == "Total.Schools") {
            bar_data <- metric_plot_data %>%
              filter(Metric == "Total.Schools", !is.na(Category)) %>%
              rename(Count = Value) 
          } else {
            plot_data_bar <- filtered_data()
            if (nrow(plot_data_bar) > 0) {
              bar_data <- plot_data_bar %>%
                count(!!sym(current_metric), name = "Count") %>%
                filter(!is.na(!!sym(current_metric))) %>%
                rename(Category = !!sym(current_metric)) 
            }
          }
          
          if (nrow(bar_data) == 0) {
            return(plot_ly() %>% layout(title = list(text = plot_title, x = 0.05), annotations = list(x = 0.5, y = 0.5, text = "No data available", showarrow = FALSE)))
          }
          
          # --- UPDATED CASE_WHEN ---
          # <-- BUG FIX (Change 3): Make plot source names dynamic
          plot_source <- dplyr::case_when(
            current_metric == "Modified.COC" ~ paste0("coc_pie_click_", current_trigger_val),
            current_metric == "School.Size.Typology" ~ paste0("typology_bar_click_", current_trigger_val),
            current_metric == "Shifting" ~ paste0("shifting_bar_click_", current_trigger_val),
            current_metric == "Outlier.Status" ~ paste0("outlier_click_", current_trigger_val), 
            current_metric == "Clustering.Status" ~ paste0("clustering_click_", current_trigger_val),
            current_metric == "OwnershipType" ~ paste0("ownership_click_", current_trigger_val),
            current_metric == "ElectricitySource" ~ paste0("electricity_click_", current_trigger_val),
            current_metric == "WaterSource" ~ paste0("water_click_", current_trigger_val),
            TRUE ~ paste0("plot_source_", current_metric, "_", current_trigger_val) 
          )
          
          # This logic is no longer needed
          # click_source_name <- if (plot_source %in% c("coc_pie_click", ...))
          
          plot_ly(
            data = bar_data, y = ~Category, x = ~Count,
            type = "bar", orientation = 'h', name = current_metric_name,
            texttemplate = '%{x:,.0f}', textposition = "outside",
            cliponaxis = FALSE, textfont = list(color = '#000000', size = 10),
            source = plot_source # <-- MODIFIED
          ) %>%
            layout(
              title = list(text = plot_title, x = 0.05), 
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
              xaxis = list(title = "Total Count", tickformat = ',.0f'),
              legend = list(orientation = 'h', xanchor = 'center', x = 0.5, y = 1.02),
              margin = list(l = 150) 
            )
        }, error = function(e) {
          # ... (Error handling) ...
        })
      })
      
    } else {
      # --- RENDER DEFAULT DRILLDOWN BAR CHART (Unchanged) ---
      # --- *** PROGRAM COLUMNS WILL NOW BE RENDERED HERE *** ---
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          plot_data <- metric_plot_data %>%
            filter(Metric == current_metric, !is.na(Category))
          
          if (nrow(plot_data) == 0 || all(is.na(plot_data$Value))) {
            return(plot_ly() %>% layout(title = list(text = plot_title, x = 0.05), annotations = list(x = 0.5, y = 0.5, text = "No data available", showarrow = FALSE)))
          }
          
          xaxis_range <- c(0, max(plot_data$Value, na.rm = TRUE) * 1.3)
          
          plot_ly(
            data = plot_data, y = ~Category, x = ~Value, type = "bar",
            orientation = 'h', name = current_metric_name,
            
            # <-- BUG FIX (Change 3): Make plot source name dynamic
            source = paste0("plot_source_", current_metric, "_", current_trigger_val), 
            
            texttemplate = '%{x:,.0f}', textposition = "outside",
            cliponaxis = FALSE, textfont = list(color = '#000000', size = 10)
          ) %>%
            layout(
              title = list(text = plot_title, x = 0.05), 
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
              xaxis = list(title = "Total Value", tickformat = ',.0f', range = xaxis_range),
              legend = list(orientation = 'h', xanchor = 'center', x = 0.5, y = 1.02),
              margin = list(l = 150)
            )
        }, error = function(e) {
          # ... (Error handling) ...
        })
      })
    }
  })
  
  # --- 2. Create the UI Card Elements ---
  plot_cards <- map(selected_metrics, ~{
    current_metric <- .x
    # --- *** MODIFIED (Change 3 of 3): Use clean_metric_choices *** ---
    current_metric_name <- names(clean_metric_choices)[clean_metric_choices == current_metric]
    summary_card_content <- NULL
    
    # --- UPDATED IF CONDITION ---
    if (current_metric %in% c("Modified.COC", "School.Size.Typology", "Shifting", "Total.Schools", "Completion", 
                              "Outlier.Status", "Clustering.Status", "OwnershipType", "ElectricitySource", "WaterSource")) {
      
      total_count <- tryCatch({
        if (current_metric == "Total.Schools") {
          metric_plot_data %>% filter(Metric == "Total.Schools") %>% pull(Value) %>% sum(na.rm = TRUE)
        } else {
          nrow(filtered_data()) 
        }
      }, error = function(e) { 0 }) 
      
      summary_title <- if (current_metric == "Total.Schools") paste("Total", current_metric_name) else "Total Records in View"
      
      summary_card_content <- card(
        style = "background-color: #1f77b445; padding: 0px;", # Light yellow, tight padding
        tags$h5(
          summary_title, 
          style = "font-weight: 600; color: #555; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        ),
        tags$h2(
          scales::comma(total_count), 
          style = "font-weight: 700; color: #000; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        )
      )
      
    } else {
      # --- *** PROGRAM COLUMNS WILL NOW BE HANDLED HERE *** ---
      total_val <- tryCatch({
        metric_plot_data %>% filter(Metric == current_metric) %>% pull(Value) %>% sum(na.rm = TRUE)
      }, error = function(e) { 0 }) 
      
      summary_card_content <- card(
        style = "background-color: #1f77b445; padding: 0px;", # Light yellow, tight padding
        tags$h5(
          paste("Total", current_metric_name), 
          style = "font-weight: 600; color: #555; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        ),
        tags$h2(
          scales::comma(total_val), 
          style = "font-weight: 700; color: #000; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        )
      )
    }
    
    bslib::card(
      full_screen = TRUE,
      card_header(current_metric_name),
      card_body(
        tags$div(style = "text-align: center; padding-bottom: 10px;", summary_card_content),
        plotlyOutput(paste0("plot_", .x))
      )
    )
  })
  
  # --- 3. Arrange the cards into the layout (Logic Unchanged) ---
  plot_grid <- do.call(bslib::layout_columns, c(list(col_widths = 4), plot_cards))
  tagList(
    tags$h3("Interactive Education Resource Dashboard", style = "text-align: center; font-weight: bold; margin-bottom: 20px;"),
    tags$div(
      style = "text-align: center; font-size: 1.1em; font-weight: 500; color: #333; background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 5px; padding: 10px; margin-bottom: 20px;",
      textOutput("current_filter_text")
    ),
    plot_grid 
  )
})


# --- *** NEW: School Details Logic for Build Your Dashboard *** ---

# --- 1. Reactive to get the full data for the selected school (UPDATED) ---
selected_school_data <- reactive({
  # Require the new reactiveVal to have a value
  req(reactive_selected_school_id())
  selected_id <- reactive_selected_school_id()
  
  # Filter the main 'uni' dataframe for this one school.
  uni %>% filter(SchoolID == selected_id)
})


# --- 2. Dynamic UI to show prompt or detail tables (UPDATED) ---
output$build_dashboard_school_details_ui <- renderUI({
  
  # Check the new reactiveVal
  if (is.null(reactive_selected_school_id())) {
    return(
      tags$div(
        style = "padding: 20px; text-align: center; color: #6c757d;",
        bs_icon("info-circle", size = "2em"),
        h5("Click a school in the 'Filtered Data' table or on the map to load its details here.")
      )
    )
  }
  
  # If a school IS selected, show the 4-column layout
  layout_columns(
    col_widths = c(6,6,6,6),
    
    card(full_screen = TRUE,
         card_header(strong("Basic Information")),
         tableOutput("schooldetails_build")),
    
    card(full_screen = TRUE,
         card_header(strong("HR Data")),
         tableOutput("schooldetails_build2")),
    
    card(full_screen = TRUE,
         card_header(strong("Classroom Data")),
         tableOutput("schooldCSS_build3")),
    
    card(full_screen = TRUE,
         card_header(div(strong("Specialization Data"),
                         tags$span(em("(based on eSF7 for SY 2023-2024)"),
                                   style = "font-size: 0.7em; color: grey;"
                         ))),
         tableOutput("schooldetails_build5"))
  )
})

# --- 3. Render the four detail tables (FIXED with correct column names) ---

# --- School Details Table 1: Basic Info ---
output$schooldetails_build <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  data.frame(
    Metric = c("Region", "Province", "Municipality", "Division", "District", 
               "Barangay", "Street Address", "School ID", "School Name", "School Head", 
               "School Head Position", "Implementing Unit", "Modified Curricular Offering", 
               "Latitude", "Longitude"),
    Value = as.character(c(
      data$Region, data$Province, data$Municipality, data$Division, data$District,
      data$Barangay, data$Street.Address, data$SchoolID, data$School.Name, data$School.Head.Name,
      data$SH.Position, data$Implementing.Unit, data$Modified.COC,
      data$Latitude, data$Longitude
    ))
  )
}, striped = TRUE, hover = TRUE, bordered = TRUE)

# --- School Details Table 2: HR Data ---
output$schooldetails_build2 <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  data.frame(
    Metric = c("ES Excess", "ES Shortage", "JHS Excess", "JHS Shortage", 
               "SHS Excess", "SHS Shortage", "ES Teachers", "JHS Teachers", 
               "SHS Teachers", "ES Enrolment", "JHS Enrolment", "SHS Enrolment", 
               "School Size Typology", "AO II Deployment", "COS Deployment"),
    Value = as.character(c(
      data$ES.Excess, data$ES.Shortage, data$JHS.Excess, data$JHS.Shortage,
      data$SHS.Excess, data$SHS.Shortage, data$ES.Teachers, data$JHS.Teachers,
      data$SHS.Teachers, data$ES.Enrolment, data$JHS.Enrolment, data$SHS.Enrolment,
      data$School.Size.Typology, data$PDOI_Deployment, data$Outlier.Status
    ))
  )
}, striped = TRUE, hover = TRUE, bordered = TRUE)

# --- School Details Table 3: Classroom Data ---
output$schooldetails_build3 <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  data.frame(
    Metric = c("Number of Buildings", "Number of Instructional Rooms", 
               "Classroom Requirement", "Estimated Classroom Shortage", 
               "With Buildable Space", "For Major Repairs", 
               "School Building Priority Index", "Shifting", "Ownership Type", 
               "Source of Electricity", "Source of Water", "Total Seats", 
               "Total Seats Shortage"),
    Value = as.character(c(
      data$Buildings, data$Instructional.Rooms.2023.2024,
      data$Classroom.Requirement, data$Est.CS,
      data$Buidable_space, data$Major.Repair.2023.2024,
      data$SBPI, data$Shifting, data$OwnershipType,
      data$ElectricitySource, data$WaterSource, data$Total.Seats.2True23.2024,
      data$Total.Seats.Shortage.2023.2024
    ))
  )
}, striped = TRUE, hover = TRUE, bordered = TRUE)

# --- School Details Table 4: Specialization (was build5) ---
# --- School Details Table 4: Specialization (UPDATED) ---
output$schooldetails_build5 <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  
  # --- Define the metric list ---
  metric_labels <- c("English", "Mathematics", "Science", "Biological Sciences", 
                     "Physical Sciences", "General Education", "Araling Panlipunan", 
                     "TLE", "MAPEH", "Filipino", "ESP", "Agriculture", 
                     "Early Childhood Education", "SPED")
  
  # --- Check if the school is "Purely ES" ---
  # We add !is.na() as a safety check
  if (!is.na(data$Modified.COC) && data$Modified.COC == "Purely ES") {
    
    # --- If YES, show dashes ("-") for all values ---
    data.frame(
      Metric = metric_labels,
      Value = rep("-", length(metric_labels))
    )
    
  } else {
    
    # --- If NO, show the actual specialization data ---
    data.frame(
      Metric = metric_labels,
      Value = as.character(c(
        data$English, data$Mathematics, data$Science, data$Biological.Sciences,
        data$Physical.Sciences, data$General.Ed, data$Araling.Panlipunan,
        data$TLE, data$MAPEH, data$Filipino, data$ESP, data$Agriculture,
        data$ECE, data$SPED
      ))
    )
  }
  
}, striped = TRUE, hover = TRUE, bordered = TRUE)