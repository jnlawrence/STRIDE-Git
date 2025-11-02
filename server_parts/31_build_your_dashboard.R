# Build your Dashboard

# --- Drilldown State Management ---
# --- Drilldown State Management ---
global_drill_state <- reactiveVal(list(
  level = "Region", 
  region = NULL,    
  division = NULL,
  coc_filter = NULL,      # <-- NEW: To store the COC filter
  typology_filter = NULL  # <-- NEW: To store the Typology filter
))
global_trigger <- reactiveVal(0) 

# --- Observer Lifecycle Manager ---
drilldown_observers <- reactiveVal(list())

# --- NEW: Selection Order Tracker ---
# This reactiveVal tracks the *click order* of metrics,
# because input$selected_metrics (from a standard selectInput) does not.
selection_order <- reactiveVal(character(0))

observeEvent(input$selected_metrics, {
  current_selection <- input$selected_metrics
  # Use isolate() to compare the new value to the old value
  old_selection <- isolate(selection_order())
  
  # 1. Find items that were *added*
  # (items in the new list that weren't in the old one)
  newly_added <- setdiff(current_selection, old_selection)
  
  # 2. Find items that were *kept*
  # We filter the *old* list to preserve its order
  kept_items <- old_selection[old_selection %in% current_selection]
  
  # 3. The new order is the kept items, plus the new items at the end
  new_order <- c(kept_items, newly_added)
  
  # 4. Save the new, correctly-ordered list
  selection_order(new_order)
  
}, ignoreNULL = FALSE) # ignoreNULL=FALSE ensures it runs even when cleared


# --- *** UPDATED: OBSERVER TO SYNC PICKER -> TOGGLES *** ---
# This observes the pickerInput. If the user manually removes
# metrics, this will uncheck the corresponding toggle.
observeEvent(input$selected_metrics, {
  
  current_selection <- input$selected_metrics
  # Handle empty selection
  if (is.null(current_selection)) {
    current_selection <- character(0)
  }
  
  # --- *** FIXED: Use the SAME metric lists as the toggle observers *** ---
  teacher_metrics <- c("TotalTeachers", "Total.Shortage","Total.Excess")
  classroom_metrics <- c("Instructional.Rooms.2023.2024","Classroom.Requirement","Buildings","Shifting") 
  school_metrics <- c("School.Size.Typology","Modified.COC") 
  
  
  # Check if ALL metrics for a group are selected
  all_teacher_selected <- all(teacher_metrics %in% current_selection)
  all_school_selected <- all(school_metrics %in% current_selection)
  all_classroom_selected <- all(classroom_metrics %in% current_selection)
  
  # --- *** START OF FIX *** ---
  # Only send an update if the toggle's current value is
  # DIFFERENT from the value we want to set. This breaks the loop.
  
  if (isolate(input$preset_teacher) != all_teacher_selected) {
    
    # We still use freezeReactiveValue for safety
    freezeReactiveValue(input, "preset_teacher") 
    shinyWidgets::updateAwesomeCheckbox(
      session,
      "preset_teacher",
      value = all_teacher_selected
    )
  }
  
  if (isolate(input$preset_school) != all_school_selected) {
    
    freezeReactiveValue(input, "preset_school")
    shinyWidgets::updateAwesomeCheckbox(
      session,
      "preset_school",
      value = all_school_selected
    )
  }
  
  if (isolate(input$preset_classroom) != all_classroom_selected) {
    
    freezeReactiveValue(input, "preset_classroom")
    shinyWidgets::updateAwesomeCheckbox(
      session,
      "preset_classroom",
      value = all_classroom_selected
    )
  }
  # --- *** END OF FIX *** ---
  
}, ignoreNULL = FALSE, ignoreInit = TRUE) # <-- Added ignoreInit = TRUE


# --- *** UPDATED: PRESET TOGGLE OBSERVERS *** ---
# These observers now ADD or REMOVE metrics based on the toggle state.

# Preset 1: Teacher Focus Toggle
observeEvent(input$preset_teacher, {
  # 1. Get the metrics that are *already* selected
  current_selection <- isolate(input$selected_metrics)
  
  # 2. Define the metrics for *this* preset
  teacher_metrics <- c("TotalTeachers", "Total.Shortage","Total.Excess")
  
  # 3. Add or Remove based on the checkbox value
  if (input$preset_teacher == TRUE) {
    # Add metrics: union() merges and removes duplicates
    new_selection <- union(current_selection, teacher_metrics)
  } else {
    # Remove metrics: setdiff() keeps items in 'current_selection'
    # that are NOT in 'teacher_metrics'
    new_selection <- setdiff(current_selection, teacher_metrics)
  }
  
  # 4. Update the picker input
  shinyWidgets::updatePickerInput(
    session, 
    "selected_metrics", 
    selected = new_selection
  )
})

# Preset 2: Categorical/Demographic Focus Toggle
observeEvent(input$preset_classroom, {
  
  # 1. Get the metrics that are *already* selected
  current_selection <- isolate(input$selected_metrics)
  
  # 2. Define the metrics for *this* preset
  classroom_metrics <- c("Instructional.Rooms.2023.2024","Classroom.Requirement","Buildings","Shifting") 
  
  # 3. Add or Remove based on the checkbox value
  if (input$preset_classroom == TRUE) {
    # Add metrics
    new_selection <- union(current_selection, classroom_metrics)
  } else {
    # Remove metrics
    new_selection <- setdiff(current_selection, classroom_metrics)
  }
  
  # 4. Update the picker input
  shinyWidgets::updatePickerInput(
    session, 
    "selected_metrics", 
    selected = new_selection
  )
})

observeEvent(input$preset_school, {
  
  # 1. Get the metrics that are *already* selected
  current_selection <- isolate(input$selected_metrics)
  
  # 2. Define the metrics for *this* preset
  school_metrics <- c("School.Size.Typology","Modified.COC") 
  
  # 3. Add or Remove based on the checkbox value
  if (input$preset_school == TRUE) {
    # Add metrics
    new_selection <- union(current_selection, school_metrics)
  } else {
    # Remove metrics
    new_selection <- setdiff(current_selection, school_metrics)
  }
  
  # 4. Update the picker input
  shinyWidgets::updatePickerInput(
    session, 
    "selected_metrics", 
    selected = new_selection
  )
})


# --- *** DELETED THE DUPLICATE SYNC OBSERVER *** ---
# The old, buggy 'observeEvent(input$selected_metrics, ...)'
# that was here has been REMOVED to prevent the loop.
# --- *** DELETED THE DUPLICATE SYNC OBSERVER *** ---


# --- Back Button Logic (Unchanged) ---
# --- Back Button Logic (Updated) ---
# --- Back Button Logic (Updated for Dynamic Label) ---
output$back_button_ui <- renderUI({
  state <- global_drill_state() 
  button_label <- ""  # Initialize
  show_button <- FALSE # Flag to control visibility
  
  # --- Determine button label based on the state, in reverse priority order ---
  
  # 1. Check for Typology Filter (Highest priority undo)
  if (!is.null(state$typology_filter)) {
    
    # Use str_trunc to prevent a very long button label
    label_text <- stringr::str_trunc(state$typology_filter, 20) 
    button_label <- paste("Undo Filter:", label_text)
    show_button <- TRUE
    
    # 2. Check for COC Filter
  } else if (!is.null(state$coc_filter)) {
    
    label_text <- stringr::str_trunc(state$coc_filter, 20)
    button_label <- paste("Undo Filter:", label_text)
    show_button <- TRUE
    # 3. Check for Legislative District Level
  } else if (state$level == "Legislative.District") {
    
    button_label <- "Undo Drilldown" # Or "Go Back to Division"
    show_button <- TRUE
    
    # 4. Check for Division Level
  } else if (state$level == "Division") {
    
    button_label <- "Undo Drilldown" # Or "Go Back to Region"
    show_button <- TRUE
  }
  
  # --- Render the button only if one of the conditions was met ---
  if (show_button) { 
    
    # --- UPDATED: Added class = "btn-danger" to make the button red ---
    actionButton("back_button", 
                 button_label, 
                 icon = icon("undo"), 
                 class = "btn-danger") # <-- THIS IS THE CHANGE
  }
})

observeEvent(input$back_button, {
  state <- isolate(global_drill_state()) 
  new_state <- state # Start with the current state
  
  # --- CHANGED: Clear categorical filters first (in reverse order) ---
  if (!is.null(state$typology_filter)) {
    new_state$typology_filter <- NULL # Clear typology filter
  } else if (!is.null(state$coc_filter)) {
    new_state$coc_filter <- NULL      # Clear COC filter
  } 
  # --- Original logic for geographic drill-up ---
  else if (state$level == "Legislative.District") {
    new_state$level <- "Division"
    new_state$division <- NULL
  } else if (state$level == "Division") {
    new_state$level <- "Region"
    new_state$region <- NULL
  }
  
  global_drill_state(new_state)
  global_trigger(global_trigger() + 1) 
})


# --- DYNAMIC OBSERVER MANAGER ---
observe({
  # --- CHANGED: Use our new ordered list ---
  selected_metrics <- selection_order() 
  
  # (Rest of this observer is unchanged)
  old_handles <- isolate(drilldown_observers())
  walk(old_handles, ~ .x$destroy()) 
  
  new_handles <- map(selected_metrics, ~{
    current_metric <- .x
    current_metric_source <- paste0("plot_source_", current_metric)
    
    # --- NEW: Categorical Filter Observers ---
    # This observer handles clicks on the Modified.COC chart
    observeEvent(event_data("plotly_click", source = "coc_pie_click"), {
      d <- event_data("plotly_click", source = "coc_pie_click")
      
      if (is.null(d$y)) return() # Horizontal bar charts use 'y'
      clicked_coc <- d$y        
      
      state <- isolate(global_drill_state())
      # Only update if the filter is new
      if (is.null(state$coc_filter) || state$coc_filter != clicked_coc) {
        state$coc_filter <- clicked_coc
        global_drill_state(state)
        global_trigger(global_trigger() + 1)
      }
      
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    # This observer handles clicks on the School.Size.Typology bar chart
    observeEvent(event_data("plotly_click", source = "typology_bar_click"), {
      d <- event_data("plotly_click", source = "typology_bar_click")
      if (is.null(d$y)) return() # Horizontal bar charts use 'y'
      
      clicked_typology <- d$y
      
      state <- isolate(global_drill_state())
      # Only update if the filter is new
      if (is.null(state$typology_filter) || state$typology_filter != clicked_typology) {
        state$typology_filter <- clicked_typology
        global_drill_state(state)
        global_trigger(global_trigger() + 1)
      }
      
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = current_metric_source), {
      state <- isolate(global_drill_state()) 
      if (state$level == "Legislative.District") return()
      d <- event_data("plotly_click", source = current_metric_source)
      if (is.null(d$y)) return()
      clicked_category <- d$y 
      new_state <- list()
      if (state$level == "Region") {
        new_state <- list(level = "Division", region = clicked_category, division = NULL)
      } else if (state$level == "Division") {
        new_state <- list(level = "Legislative.District", region = state$region, division = clicked_category)
      }
      global_drill_state(new_state)
      global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
  })
  
  drilldown_observers(new_handles)
})


# --- Reactive Data (Unchanged) ---
# (The reactive data functions do not need to be changed)
# --- Reactive Data (Updated) ---
filtered_data <- reactive({
  trigger <- global_trigger() 
  state <- global_drill_state()
  temp_data <- uni
  
  # --- 1. Geographic filters (Unchanged) ---
  if (state$level == "Division") {
    req(state$region)
    temp_data <- temp_data %>% filter(Region == state$region)
  } else if (state$level == "Legislative.District") {
    req(state$region, state$division)
    temp_data <- temp_data %>% 
      filter(Region == astate$region, Division == state$division)
  }
  
  # --- 2. NEW: Categorical filters ---
  # Apply COC filter if it exists
  if (!is.null(state$coc_filter)) {
    temp_data <- temp_data %>% filter(Modified.COC == state$coc_filter)
  }
  
  # Apply Typology filter if it exists
  if (!is.null(state$typology_filter)) {
    temp_data <- temp_data %>% filter(School.Size.Typology == state$typology_filter)
  }
  
  temp_data
})

summarized_data_long <- reactive({
  # This reactive doesn't care about UI order, so it can
  # still use input$selected_metrics directly.
  req(input$selected_metrics) 
  state <- global_drill_state() 
  group_by_col <- state$level  
  
  metrics_to_process <- input$selected_metrics 
  data_in <- filtered_data()
  
  existing_metrics <- intersect(metrics_to_process, names(data_in))
  if (length(existing_metrics) == 0) {
    return(tibble(Category = character(), Metric = character(), Value = numeric()))
  }
  valid_metrics <- existing_metrics[sapply(data_in[existing_metrics], is.numeric)]
  
  if (length(valid_metrics) == 0) {
    return(tibble(Category = character(), Metric = character(), Value = numeric()))
  }
  
  data_in %>%
    select(!!sym(group_by_col), all_of(valid_metrics)) %>%
    pivot_longer(
      cols = all_of(valid_metrics),
      names_to = "Metric",
      values_to = "Value"
    ) %>%
    group_by(!!sym(group_by_col), Metric) %>%
    summarise(Value = sum(Value, na.rm = TRUE), .groups = "drop") %>%
    rename(Category = !!sym(group_by_col))
})


# --- Dynamic UI: Combined Dashboard Grid ---
# --- Dynamic UI: Combined Dashboard Grid ---
# --- Dynamic UI: Combined Dashboard Grid ---
# --- Dynamic UI: Combined Dashboard Grid (Updated) ---
output$dashboard_grid <- renderUI({
  
  selected_metrics <- selection_order() 
  
  if (length(selected_metrics) == 0) {
    return(tags$h4("Please select at least one metric to display graphs."))
  }
  
  # --- 1. Create Plotly Renders ---
  walk(selected_metrics, ~{
    current_metric <- .x
    current_metric_name <- names(metric_choices)[metric_choices == current_metric]
    
    # --- NEW: Unified Title Logic ---
    # Get the state ONCE for all plots
    state <- global_drill_state()
    level_name <- stringr::str_to_title(state$level) 
    plot_title <- current_metric_name # Start with the metric name
    
    # A. Add geographic context
    if (state$level == "Region") {
      plot_title <- paste(plot_title, "by", level_name)
    } else if (state$level == "Division") {
      plot_title <- paste(plot_title, "by", level_name, "in", state$region)
    } else if (state$level == "Legislative.District") {
      plot_title <- paste(plot_title, "by", level_name, "in", state$division)
    }
    
    # B. Add filter context
    filter_parts <- c()
    if (!is.null(state$coc_filter)) {
      filter_parts <- c(filter_parts, state$coc_filter)
    }
    if (!is.null(state$typology_filter)) {
      filter_parts <- c(filter_parts, state$typology_filter)
    }
    
    # Append filters to the title if any exist
    if (length(filter_parts) > 0) {
      plot_title <- paste0(plot_title, " (Filtered by: ", paste(filter_parts, collapse = ", "), ")")
    }
    # --- END of Unified Title Logic ---
    
    
    # --- Conditional Plot Rendering ---
    
    # --- This block now handles *both* categorical charts ---
    if (current_metric == "Modified.COC" || current_metric == "School.Size.Typology") {
      # --- RENDER CATEGORICAL BAR CHART ---
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          plot_data_bar <- filtered_data()
          
          if (nrow(plot_data_bar) == 0) {
            return(
              plot_ly() %>% 
                layout(
                  title = list(text = plot_title, x = 0.05), # Use unified title
                  annotations = list(x = 0.5, y = 0.5, text = "No data available for this view", showarrow = FALSE, font = list(size = 14))
                )
            )
          }
          
          # <-- ***** SECTION 1: CODE FIX ***** -->
          bar_data <- plot_data_bar %>%
            count(!!sym(current_metric), name = "Count") %>%
            filter(!is.na(!!sym(current_metric))) %>%
            rename(Category = !!sym(current_metric)) # <-- FIXED: Rename dynamic col to "Category"
          
          if (nrow(bar_data) == 0) {
            return(
              plot_ly() %>% 
                layout(
                  title = list(text = plot_title, x = 0.05), # Use unified title
                  annotations = list(x = 0.5, y = 0.5, text = "No data available for this view", showarrow = FALSE, font = list(size = 14))
                )
            )
          }
          
          plot_source <- ifelse(current_metric == "Modified.COC", 
                                "coc_pie_click", 
                                "typology_bar_click")
          
          p_bar <- plot_ly(
            data = bar_data,
            y = ~Category,  # <-- FIXED: Always use the "Category" column
            x = ~Count,
            type = "bar",
            orientation = 'h',
            name = current_metric_name,
            texttemplate = '%{x:,.0f}', textposition = "outside",
            cliponaxis = FALSE, textfont = list(color = '#000000', size = 10),
            source = plot_source  
          ) %>%
            layout(
              title = list(text = plot_title, x = 0.05), # Use unified title
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
              xaxis = list(title = "Total Count", tickformat = ',.0f'),
              legend = list(orientation = 'h', xanchor = 'center', x = 0.5, yanchor = 'bottom', y = 1.02),
              margin = list(l = 150) 
            )
          
          p_bar
          
        }, error = function(e) {
          # ... (Error handling unchanged) ...
        })
      })
      
    } else {
      # --- RENDER DEFAULT DRILLDOWN BAR CHART ---
      # (This block is unchanged)
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          trigger <- global_trigger()
          plot_data <- summarized_data_long() %>%
            filter(Metric == current_metric) %>%
            filter(!is.na(Category))
          
          if (nrow(plot_data) == 0 || all(is.na(plot_data$Value))) {
            return(
              plot_ly() %>% 
                layout(
                  title = list(text = plot_title, x = 0.05), # Use unified title
                  annotations = list(x = 0.5, y = 0.5, text = "No data available for this view", showarrow = FALSE, font = list(size = 14))
                )
            )
          }
          
          max_val <- max(plot_data$Value, na.rm = TRUE)
          xaxis_range <- c(0, max_val * 1.3)
          
          p <- plot_ly(
            data = plot_data, y = ~Category, x = ~Value, type = "bar",
            orientation = 'h', name = current_metric_name,
            source = paste0("plot_source_", current_metric), # (Original drilldown source)
            texttemplate = '%{x:,.0f}', textposition = "outside",
            cliponaxis = FALSE, textfont = list(color = '#000000', size = 10)
          ) %>%
            layout(
              title = list(text = plot_title, x = 0.05), # Use unified title
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
              xaxis = list(title = "Total Value", tickformat = ',.0f', range = xaxis_range),
              legend = list(orientation = 'h', xanchor = 'center', x = 0.5, yanchor = 'bottom', y = 1.02),
              margin = list(l = 150)
            )
          
          p
          
        }, error = function(e) {
          # ... (Error handling unchanged) ...
        })
      })
    }
    # --- END of Conditional Plot Rendering ---
  })
  
  # --- 2. Create the UI Card Elements ---
  # (This loop is unchanged)
  plot_cards <- map(selected_metrics, ~{
    current_metric <- .x
    current_metric_name <- names(metric_choices)[metric_choices == current_metric]
    
    # --- Conditional Summary Card ---
    summary_card_content <- NULL
    
    if (current_metric == "Modified.COC" || current_metric == "School.Size.Typology") {
      # ... (Logic unchanged) ...
      total_count <- tryCatch({
        nrow(filtered_data()) 
      }, error = function(e) { 0 }) 
      
      summary_card_content <- card(
        tags$h5(paste("Total Records in View"), style = "font-weight: 600; color: #555; margin-top: 5px; margin-bottom: 5px;"),
        tags$h2(scales::comma(total_count), style = "font-weight: 700; color: #000; margin-top: 0; margin-bottom: 10px;")
      )
      
    } else {
      # ... (Logic unchanged) ...
      total_val <- tryCatch({
        summarized_data_long() %>%
          filter(Metric == current_metric) %>%
          pull(Value) %>%
          sum(na.rm = TRUE)
      }, error = function(e) { 0 }) 
      
      summary_card_content <- card(
        tags$h5(paste("Total", current_metric_name), style = "font-weight: 600; color: #555; margin-top: 5px; margin-bottom: 5px;"),
        tags$h2(scales::comma(total_val), style = "font-weight: 700; color: #000; margin-top: 0; margin-bottom: 10px;")
      )
    }
    # --- END of Conditional Summary Card ---
    
    # --- Build the final card for this metric ---
    bslib::card(
      full_screen = TRUE,
      card_header(current_metric_name),
      card_body(
        tags$div(
          style = "text-align: center; padding-bottom: 10px;",
          summary_card_content 
        ),
        plotlyOutput(paste0("plot_", .x))
      )
    )
  })
  
  # --- 3. Arrange the cards into the layout ---
  # (Unchanged)
  do.call(
    bslib::layout_columns,
    c(list(col_widths = 4), plot_cards)
  )
  
})