# --- SERVER LOGIC FOR PLANTILLA POSITIONS ---

# --- Shared global drilldown state (applies to ALL cards) ---
# MOVED: These MUST be outside the observe block to persist.
plantilla_drill_state <- reactiveVal(list(region = NULL))
plantilla_trigger <- reactiveVal(0)

# --- NEW: Create a master list of all locations ---
all_locations <- distinct(dfGMIS, Old.Region, Division)

observe({
  req(input$selected_positions)
  
  # --- Render Dynamic Cards Layout ---
  # --- Render Dynamic Cards Layout ---
  output$dynamic_positions_ui <- renderUI({
    req(input$selected_positions)
    
    cards <- lapply(input$selected_positions, function(pos) {
      plot_id <- paste0("plot_", gsub(" ", "_", pos))
      vbox_id <- paste0("vbox_", gsub(" ", "_", pos))
      
      card(
        full_screen = TRUE,
        class = "shadow-sm p-2",
        card_header(
          h4(pos, class = "m-0 pt-1")
        ),
        card_body(
          # --- THIS IS THE CHANGE ---
          # We replace layout_column_wrap with layout_columns
          # to gain more control over positioning.
          layout_columns(
            # Use a 12-unit grid:
            # col_width = 4 (which is 1/3)
            # offset = 4 (which pushes it 1/3 from the left)
            # This centers the 1/3-width card.
            col_widths = list(4, offset = 4), 
            uiOutput(vbox_id)
          ),
          # --- END OF CHANGE ---
          
          plotlyOutput(plot_id, height = "450px")
        )
      )
    })
    
    # --- FIX 1: Replaced layout_column_wrap with do.call ---
    # This is the robust, base-R way to "splice" a list of arguments (your cards)
    # into a function call (layout_column_wrap).
    do.call(
      layout_column_wrap,
      c(
        list(width = 1/3, heights_equal = "row"), # First args
        cards                                    # The list of cards to splice
      )
    )
    # --- End of Fix 1 ---
    
  })
  
  # --- Generate Each Card’s Logic ---
  lapply(input$selected_positions, function(pos) {
    plot_id <- paste0("plot_", gsub(" ", "_", pos))
    vbox_id <- paste0("vbox_", gsub(" ", "_", pos))
    source_id <- paste0("drilldown_source_", gsub(" ", "_", pos))
    
    df_sub <- reactive({
      
      # 1. Create a scaffold for *this* position against *all* locations
      pos_scaffold <- all_locations %>% mutate(Position = pos)
      
      # 2. Get the *actual* data for this position
      actual_data <- dfGMIS %>% 
        filter(Position == pos) %>%
        select(Position, Old.Region, Division, Total.Filled, Total.Unfilled)
      
      # 3. Join them. The scaffold ensures all locations are present.
      pos_scaffold %>%
        left_join(actual_data, by = c("Position", "Old.Region", "Division")) %>%
        # 4. Replace NAs with 0s for counts
        mutate(
          Total.Filled = replace_na(Total.Filled, 0),
          Total.Unfilled = replace_na(Total.Unfilled, 0)
        )
    })
    
    # --- Value Box ---
    # --- Value Box ---
    output[[vbox_id]] <- renderUI({
      
      # 1. Read the global drill state to make this reactive update when the state changes.
      trigger <- plantilla_trigger() # Read the trigger to force re-render
      state <- plantilla_drill_state()
      if (is.null(state)) state <- list(region = NULL)
      
      # 2. Get the base data for the current position
      data_to_summarize <- df_sub()
      
      title_context <- "Total Positions"
      
      # 3. Filter the data if a Region has been selected (i.e., drilled down)
      if (!is.null(state$region)) {
        data_to_summarize <- data_to_summarize %>%
          filter(Old.Region == state$region)
        
        # Update the title to reflect the current view
        title_context <- paste("Total Positions in", state$region)
      } else {
        title_context <- paste("Total Positions")
      }
      
      # 4. Calculate the total from the (now possibly filtered) data
      total <- data_to_summarize %>%
        summarise(total = sum(Total.Filled + Total.Unfilled, na.rm = TRUE)) %>%
        pull(total)
      
      card(
        class = "border-2 border-primary-subtle", # A simple, light border
        card_body(
          class = "text-center p-2", # Center text, add padding
          # 5. Update the displayed title
          h5(paste(title_context, "-", pos), class = "card-title mb-1"),
          h3(formatC(total, format = "d", big.mark = ","), class = "card-text")
        )
      )
    })
    
    # --- Plot with Global Drilldown ---
    # --- Plot with Global Drilldown ---
    # --- Plot with Global Drilldown ---
    output[[plot_id]] <- renderPlotly({
      trigger <- plantilla_trigger()  # re-render when drilldown changes
      state <- plantilla_drill_state()
      if (is.null(state)) state <- list(region = NULL)
      
      df <- df_sub()
      
      # --- LEVEL 1: Region View ---
      if (is.null(state$region)) {
        plot_data <- df %>%
          group_by(Old.Region) %>%
          summarise(
            Filled = sum(Total.Filled, na.rm = TRUE),
            Unfilled = sum(Total.Unfilled, na.rm = TRUE),
            .groups = "drop"
          ) %>%
          tidyr::pivot_longer(cols = c(Filled, Unfilled),
                              names_to = "Type", values_to = "Count")
        y_formula <- ~Old.Region
        
        # --- LEVEL 2: Division View ---
      } else {
        plot_data <- df %>%
          filter(Old.Region == state$region) %>%
          group_by(Division) %>%
          summarise(
            Filled = sum(Total.Filled, na.rm = TRUE),
            Unfilled = sum(Total.Unfilled, na.rm = TRUE),
            .groups = "drop"
          ) %>%
          tidyr::pivot_longer(cols = c(Filled, Unfilled),
                              names_to = "Type", values_to = "Count")
        y_formula <- ~Division
      }
      
      # Handle empty data
      if (nrow(plot_data) == 0) {
        return(plot_ly() %>% layout(title = title_txt))
      }
      
      # --- FIX 2: Correct max_val calculation for STACKED bars ---
      # We must now sum the counts for each bar (Region/Division) 
      # to find the true maximum for the x-axis.
      
      # Get the name of the y-axis variable (e.g., "Old.Region" or "Division")
      # --- Get the name of the y-axis variable (e.g., "Old.Region" or "Division") ---
      y_var_name <- all.vars(y_formula)  
      
      # --- FIX: Define the data used for totals based on the drill state ---
      data_for_totals <- if (is.null(state$region)) {
        df # Level 1: Use all data (already filtered by Position)
      } else {
        df %>% filter(Old.Region == state$region) # Level 2: Filter by clicked Region
      }
      
      # Now summarize the correctly filtered data_for_totals
      total_counts <- data_for_totals %>%
        group_by(!!sym(y_var_name)) %>%
        summarise(
          TotalFilled = sum(Total.Filled, na.rm = TRUE),
          TotalUnfilled = sum(Total.Unfilled, na.rm = TRUE),
          TotalCount = TotalFilled + TotalUnfilled,
          # Guard against division by zero
          FillingRate = ifelse(TotalCount == 0, 0, TotalFilled / TotalCount), 
          .groups = "drop"
        )
      # --- End of Change 1 ---
      
      max_val <- max(total_counts$TotalCount, na.rm = TRUE)
      final_max <- if (max_val <= 0) 10 else (max_val * 1.3) 
      
      color_map <- c("Filled" = "#007BFF", "Unfilled" = "#FF0000")
      
      plot_ly(
        data = plot_data,
        y = y_formula,
        x = ~Count,
        color = ~Type,
        colors = color_map,
        type = 'bar',
        orientation = 'h',
        source = source_id,
        text = ~Count,
        texttemplate = '%{x:,.0f}',
        textposition = 'inside'
      ) %>%
        layout(
          barmode = 'stack',
          xaxis = list(
            title = "Number of Positions", 
            range = c(0, final_max),
            tickformat = ',.0f'
          ),
          yaxis = list(
            title = "", 
            categoryorder = "total descending", 
            autorange = "reversed"
          ),
          legend = list(
            orientation = 'h',
            xanchor = 'center',
            x = 0.5,
            yanchor = 'bottom',
            y = 1.02
          )
        ) %>%
        
        # --- CHANGE 2: Update add_text to include the Filling Rate ---
        add_text(
          data = total_counts,
          y = as.formula(paste0("~`", y_var_name, "`")),
          x = ~TotalCount,
          # --- UPDATED: Use HTML <i> and <span style> tags for formatting ---
          text = ~paste0(
            # Total Count (Bold black)
            formatC(TotalCount, format = "d", big.mark = ","),
            
            # Start parenthesis and bold/black space
            " (",
            
            # Percentage: Italicized and Blue
            '<span style="color: #007BFF;"><i>', # Start blue color and italics
            scales::percent(FillingRate, accuracy = 1),
            '</i></span>', # End italics and blue color
            
            ")"
          ),
          textposition = "middle right",
          showlegend = FALSE,
          inherit = FALSE,
          hoverinfo = 'none',
          
          # We need to remove the "weight = 'bold'" from textfont so the HTML color applies correctly.
          # We will put the bold tag around the TotalCount number for clarity.
          textfont = list(color = '#000000', size = 11) 
          # Note: The 'weight = bold' is complex to mix with HTML, 
          # so we'll adjust the text string slightly instead:
        )
    })
    
    # --- Drilldown Handler (Global Sync) ---
    observeEvent(event_data("plotly_click", source = source_id), {
      click_data <- event_data("plotly_click", source = source_id)
      if (is.null(click_data)) return()
      
      cat_clicked <- click_data$y
      if (is.null(cat_clicked)) return()
      
      current_state <- isolate(plantilla_drill_state())
      if (is.null(current_state)) current_state <- list(region = NULL)
      
      # Only allow 1 drilldown level: Region -> Division
      if (is.null(current_state$region)) {
        plantilla_drill_state(list(region = as.character(cat_clicked)))
        plantilla_trigger(plantilla_trigger() + 1)
      }
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
  })
  
  # --- ONE BACK BUTTON (GLOBAL) ---
  # This observer can also be moved outside the main observe block.
  # It doesn't need to be recreated every time.
  observeEvent(input$btn_back_drilldown, {
    state <- isolate(plantilla_drill_state())
    if (!is.null(state$region)) {
      plantilla_drill_state(list(region = NULL))
      plantilla_trigger(plantilla_trigger() + 1)
    }
  })
})