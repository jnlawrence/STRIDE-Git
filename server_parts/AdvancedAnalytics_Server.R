# --- Load Required Libraries ---
library(shiny)
library(dplyr)
library(tibble)
library(ggplot2)
library(scales)

# --- 1. VALIDATE METADATA ---
if (!exists("col_info_adv_static")) {
  stop("FATAL ERROR: 'col_info_adv_static' object not found. 
       Please add the pre-analysis code to your main server.R or global.R file
       AFTER you load the 'uni' database.")
} else {
  print("--- ADVANCED ANALYTICS: Server logic is loading. Metadata found. ---")
}


# --- 2. Dynamic Filter Management ---

active_filter_ids <- reactiveVal(c()) 
adv_filter_counter <- reactiveVal(0) 

# --- 2a. OBSERVER: "Add Filter" Button ---
observeEvent(input$add_adv_filter_btn, {
  
  new_id <- isolate(adv_filter_counter()) + 1
  adv_filter_counter(new_id)
  ui_id <- paste0("adv_filter_row_", new_id)
  
  insertUI(
    selector = "#adv_filter_container",
    where = "beforeEnd",
    ui = div(
      id = ui_id,
      class = "adv-filter-group",
      style = "border: 1px solid #ddd; border-radius: 5px; padding: 10px; margin-bottom: 10px;",
      
      actionButton(paste0("adv_remove_", new_id), "Remove", 
                   icon = icon("times"), class = "btn-danger btn-sm float-end"),
      
      selectInput(paste0("adv_col_", new_id), 
                  label = paste("Filter", new_id, ": Select Column"),
                  choices = adv_analytics_choices),
      
      uiOutput(paste0("adv_filter_val_ui_", new_id))
    )
  )
  
  active_filter_ids(c(isolate(active_filter_ids()), new_id))
  
  # --- 2b. DYNAMIC OBSERVERS ---
  local({
    
    current_filter_id <- new_id
    
    # --- DYNAMIC RENDER: Create the filter's value input (WITH FIX) ---
    output[[paste0("adv_filter_val_ui_", current_filter_id)]] <- renderUI({
      
      col_name <- input[[paste0("adv_col_", current_filter_id)]]
      req(col_name) 
      
      # --- FIX HERE: Changed 'column_name' to 'Raw_Name' ---
      col_type <- col_info_adv_static$type[col_info_adv_static$Raw_Name == col_name]
      col_data <- uni[[col_name]] 
      
      if (col_type == "Numeric") {
        min_val <- min(col_data, na.rm = TRUE)
        max_val <- max(col_data, na.rm = TRUE)
        
        if (is.infinite(min_val) || is.infinite(max_val)) {
          tags$p("This column has no valid numeric data to filter.", 
                 style = "color: #dc3545; font-style: italic;")
        } else {
          tagList(
            numericInput(paste0("adv_num_min_", current_filter_id), "Min Value:", value = min_val),
            numericInput(paste0("adv_num_max_", current_filter_id), "Max Value:", value = max_val)
          )
        }
        
      } else if (col_type %in% c("Categorical", "Binary")) {
        choices <- unique(col_data)
        choices <- choices[!is.na(choices)]
        
        if (length(choices) == 0) {
          tags$p("This column has no valid categories to filter.", 
                 style = "color: #dc3545; font-style: italic;")
        } else {
          choices <- sort(choices)
          selectInput(paste0("adv_select_", current_filter_id), "Select Value(s):",
                      choices = choices, selected = choices, multiple = TRUE)
        }
      }
    })
    
    # --- DYNAMIC OBSERVER: "Remove" Button ---
    observeEvent(input[[paste0("adv_remove_", current_filter_id)]], {
      print(paste("Removing filter:", current_filter_id))
      removeUI(selector = paste0("#adv_filter_row_", current_filter_id))
      active_filter_ids(setdiff(isolate(active_filter_ids()), current_filter_id))
    })
    
  }) # End local()
  
}) # End observeEvent(add_adv_filter_btn)


# --- 3. Filter Data when "Apply" button is clicked ---
filtered_data_adv <- eventReactive(input$adv_analytics_run, {
  
  req(global_drill_state())
  print("--- ADVANCED ANALYTICS: 'Apply' button clicked, filtering data... ---")
  
  data_filtered <- uni 
  drill_state <- global_drill_state()
  
  # --- 1. Apply all filters from the main dashboard ---
  if (!is.null(drill_state$ownership_filter)) {
    data_filtered <- data_filtered %>% filter(OwnershipType %in% drill_state$ownership_filter)
  }
  if (!is.null(drill_state$electricity_filter)) {
    data_filtered <- data_filtered %>% filter(ElectricitySource %in% drill_state$electricity_filter)
  }
  if (!is.null(drill_state$water_filter)) {
    data_filtered <- data_filtered %>% filter(WaterSource %in% drill_state$water_filter)
  }
  if (!is.null(drill_state$coc_filter)) {
    data_filtered <- data_filtered %>% filter(Modified.COC %in% drill_state$coc_filter)
  }
  if (!is.null(drill_state$typology_filter)) {
    data_filtered <- data_filtered %>% filter(School.Size.Typology %in% drill_state$typology_filter)
  }
  if (!is.null(drill_state$shifting_filter)) {
    data_filtered <- data_filtered %>% filter(Shifting %in% drill_state$shifting_filter)
  }
  
  # --- 2. Apply ALL dynamic filters from this panel ---
  filter_ids_to_apply <- isolate(active_filter_ids())
  
  if (length(filter_ids_to_apply) > 0) {
    for (id in filter_ids_to_apply) {
      col_name <- isolate(input[[paste0("adv_col_", id)]])
      if (is.null(col_name)) next 
      
      # --- FIX HERE: Changed 'column_name' to 'Raw_Name' ---
      col_type <- col_info_adv_static$type[col_info_adv_static$Raw_Name == col_name]
      
      if (col_type == "Numeric") {
        min_val <- isolate(input[[paste0("adv_num_min_", id)]])
        max_val <- isolate(input[[paste0("adv_num_max_", id)]])
        
        if (is.null(min_val) || is.null(max_val)) next 
        
        data_filtered <- data_filtered %>%
          filter(!is.na(!!sym(col_name))) %>% 
          filter(!!sym(col_name) >= min_val, !!sym(col_name) <= max_val)
        
      } else if (col_type %in% c("Categorical", "Binary")) {
        selected_choices <- isolate(input[[paste0("adv_select_", id)]])
        
        if (is.null(selected_choices)) next 
        
        data_filtered <- data_filtered %>%
          filter(!!sym(col_name) %in% selected_choices)
      }
    }
  }
  
  # --- 3. Apply geographic drilldown filters ---
  if (drill_state$level %in% c("Division", "Legislative", "District", "School")) {
    req(drill_state$region)
    data_filtered <- data_filtered %>% filter(Region == drill_state$region)
  }
  if (drill_state$level %in% c("Legislative", "District", "School")) {
    req(drill_state$division)
    data_filtered <- data_filtered %>% filter(Division == drill_state$division)
  }
  if (drill_state$level %in% c("District", "School")) {
    req(drill_state$legislative_district)
    data_filtered <- data_filtered %>% filter(Legislative.District == drill_state$legislative_district)
  }
  
  print("--- ADVANCED ANALYTICS: Filtering complete. ---")
  return(data_filtered)
})


# --- 4. Render the Drilldown Plot ---
output$advanced_drilldown_plot <- renderPlot({
  
  req(filtered_data_adv())
  print("--- ADVANCED ANALYTICS: Rendering plot. ---")
  
  data_to_plot <- filtered_data_adv()
  drill_level <- global_drill_state()$level 
  
  group_col_sym <- switch(drill_level,
                          "Region" = sym("Region"),
                          "Division" = sym("Division"),
                          "Legislative" = sym("Legislative.District"),
                          "District" = sym("District"),
                          "School" = sym("School.Name"),
                          sym("Region") 
  )
  
  if (nrow(data_to_plot) == 0) {
    print("--- ADVANCED ANALYTICS: No data to plot after filtering. ---")
    return(
      ggplot() + 
        labs(title = "No Data",
             subtitle = "No schools match all selected filters.") +
        theme_minimal()
    )
  }
  
  plot_data <- data_to_plot %>%
    group_by(!!sym(group_col_sym)) %>%
    summarise(School_Count = n(), .groups = 'drop') %>%
    rename(Group = !!sym(group_col_sym)) %>%
    filter(!is.na(Group)) %>% 
    arrange(desc(School_Count)) %>% 
    head(25) 
  
  ggplot(plot_data, aes(x = reorder(Group, -School_Count), y = School_Count)) +
    geom_bar(stat = "identity", fill = "#007bff") +
    geom_text(aes(label = School_Count), vjust = -0.5, size = 3) +
    labs(
      title = paste("School Count by", drill_level, "(Top 25)"),
      x = drill_level,
      y = "Number of Schools"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 60, hjust = 1, size = 10))
  
}, res = 96)


# --- 5. Render the Data Description Text ---
# --- 5. Render the Filtered Data Table (REPLACED DESCRIPTION) ---
output$advanced_data_table <- DT::renderDataTable({
  
  # Wait for the button press
  req(filtered_data_adv())
  print("--- ADVANCED ANALYTICS: Rendering data table. ---")
  
  data_to_show <- filtered_data_adv()
  
  # --- Select key columns to display ---
  # We show identifiers and the columns the user can filter on
  
  # First, get the raw column names of the active filters
  filter_cols <- col_info_adv_static$Raw_Name
  
  # Select key columns + the filterable columns
  data_to_show <- data_to_show %>%
    select(
      School.Name, 
      Region, 
      Division, 
      Municipality,
      all_of(filter_cols) # Selects all 12 of your filterable columns
    )
  
  # --- Render the interactive table ---
  datatable(
    data_to_show,
    options = list(
      scrollX = TRUE,  # Allows horizontal scrolling
      pageLength = 10, # Show 10 rows per page
      autoWidth = TRUE
    ),
    rownames = FALSE,
    filter = 'top' # Adds column filters to the table
  )
  
})