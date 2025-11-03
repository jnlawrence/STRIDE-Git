# stride2 UI

output$STRIDE2 <- renderUI({
  
  # --- Define the Title/Brand UI Element ---
  navbar_title_ui <- tags$a(
    class = "navbar-brand d-flex align-items-center me-auto",
    href = "#",
    tags$img(src = "logo3.png", height = "87px", style = "margin-right: 9px;
    margin-left: 20px;
    margin-top: 20px;"),
    tags$div(
      tags$img(src = "Stridelogo1.png", height = "74px", style = "margin-right: -3px; padding-top: 11px; margin-top: -35px;"),
      tags$small("Strategic Inventory for Deployment Efficiency", style = "font-size: 17px; color: #3d3232; display: block; line-height: 1; margin-block: -21px")
    )
  ) # End of navbar_title_ui tags$a
  
  # --- Build the page_navbar ---
  page_navbar(
    id = "STRIDE2_navbar",
    title = navbar_title_ui,
    
    theme = bs_theme(
      version = 5,
      bootswatch = "sandstone",
      font_scale = 0.9,
      base_font = font_google("Poppins")
    ), 
    
    # |> bs_add_rules(
    #   "
    # /* --- Make Navbar Sticky at the Top --- */
    # .bslib-navbar,
    # .navbar {
    #   position: sticky !important;
    #   position: -webkit-sticky !important; /* Safari */
    #   top: 0px !important;                 /* Stick to the very top */
    #   z-index: 4 !important;
    #   background-color: #ffffff !important; /* White background */
    #   box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15) !important; /* Shadow */
    #   padding-top: 0.5rem !important;
    #   padding-bottom: 0.5rem !important;
    #   border-bottom: 2px solid #dee2e6 !important; /* Add a subtle gray line */
    # }
    # 
    # /* --- Style the Brand/Title Area --- */
    # .navbar-brand { padding-top: 0; padding-bottom: 0; }
    # .navbar-brand span { color: #003366 !important; text-shadow: 1px 1px 1px rgba(0,0,0,0.1); }
    # .navbar-brand small { color: #495057 !important; }
    # 
    # /* --- Style Navigation Links --- */
    # .navbar-nav .nav-link {
    #   color: #003366 !important; font-weight: 500;
    #   padding-left: 1rem !important; padding-right: 1rem !important;
    #   transition: color 0.2s ease, background-color 0.2s ease;
    # }
    # .navbar-nav .nav-link:hover,
    # .navbar-nav .nav-link:focus {
    #   color: #0056b3 !important; background-color: rgba(0, 51, 102, 0.05); border-radius: 4px;
    # }
    # 
    # /* --- Style Active Navigation Link --- */
    # .navbar-nav .nav-link.active {
    #   color: #D62828 !important; font-weight: 700;
    #   border-bottom: 3px solid #D62828; background-color: transparent !important;
    # }
    # 
    # /* --- Style Dropdown Menus --- */
    # .dropdown-menu { border: none !important; box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important; border-radius: 0 0 8px 8px !important; }
    # .dropdown-item { color: #003366 !important; font-weight: 500; }
    # .dropdown-item:hover, .dropdown-item:focus { background-color: rgba(0, 51, 102, 0.08) !important; color: #0056b3 !important; }
    # 
    # /* --- Ensure Right Alignment of Nav Items --- */
    # .navbar-collapse { justify-content: flex-end !important; }
    # .navbar-nav { margin-left: auto; }
    # 
    # /* Include other specific rules if needed */
    # .nav-tabs .nav-link, .nav-pills .nav-link, .accordion-button { font-weight: bold; }
    # .sidebar-title { color: #002D62; font-weight: bold; }
    # .sidebar h4 { color: #002D62; font-weight: bold; }
    # 
    # " # End of CSS string
    # ), # End of bs_add_rules
    nav_spacer(),
    
  #   # --- Navigation Panels and Menus ---
  #   nav_panel(
  #     title = tags$b("Home"),
  #     icon = bs_icon("house-door-fill"),
  #     value = "home_tab",
  #     # <<<--- PASTE YOUR HOME PAGE UI CODE (tagList) HERE --->>>
  #     tagList(
  #       useShinyjs(),  # Still needed here for this panel's interactivity
  #       tags$head(
  #         tags$style(HTML("
  #   /* =====================================================
  #      DEPED COLOR THEME
  #      ===================================================== */
  #   :root {
  #     --deped-blue: #003366;
  #     --deped-gold: #FFB81C;
  #     --deped-light: #f4f6fa;
  #     --deped-white: #ffffff;
  #   }
  # 
  # 
  # 
  #   /* =====================================================
  #      SIDEBAR
  #      ===================================================== */
  #   .sidebar_erdb {
  #     width: 260px;
  #     background: var(--deped-blue);
  #     color: var(--deped-white);
  #     padding: 20px;
  #     border-radius: 0 12px 12px 0;
  #     box-shadow: 2px 0 8px rgba(0,0,0,0.15);
  #     position: sticky;
  #     top: 60px; /* Adjust top based on navbar height */
  #     height: calc(100vh - 60px); /* Adjust height based on navbar height */
  #     flex-shrink: 0;
  #     overflow-y: auto;
  #   }
  # 
  #   .sidebar_erdb h4 {
  #     color: var(--deped-gold);
  #     font-weight: 700;
  #     text-align: center;
  #     margin-bottom: 20px;
  #   }
  # 
  #   /* =====================================================
  #      SIDEBAR BUTTONS
  #      ===================================================== */
  #   .btn-card {
  #     background: rgba(255,255,255,0.1);
  #     border: 1px solid rgba(255,255,255,0.15);
  #     color: var(--deped-white);
  #     border-radius: 10px;
  #     text-align: left;
  #     padding: 12px 16px;
  #     display: flex;
  #     align-items: center;
  #     width: 100%;
  #     transition: all 0.2s ease-in-out;
  #   }
  # 
  #   .btn-card:hover,
  #   .btn-card:focus {
  #     background: var(--deped-gold) !important;
  #     color: var(--deped-blue) !important;
  #     transform: scale(1.02);
  #     box-shadow: 0 4px 10px rgba(0,0,0,0.2);
  #   }
  # 
  #   .btn-card h5 {
  #     display: inline-block;
  #     margin-left: 8px;
  #     font-size: 1.05rem;
  #     font-weight: 600;
  #   }
  # 
  # 
  # 
  #   /* =====================================================
  #      GLOBAL SCROLLBAR
  #      ===================================================== */
  #   ::-webkit-scrollbar {
  #     width: 10px;
  #   }
  # 
  #   ::-webkit-scrollbar-thumb {
  #     background:  #003366;
  #     border-radius: 10px;
  #   }
  # 
  # 
  # "))
  #       ),
  #       # --- MAIN LAYOUT Div ---
  #       div(
  #         class = "layout_erdb",
  #         # --- SIDEBAR Div ---
  #         div(
  #           class = "sidebar_erdb",
  #           h4("Select Category"),
  #           actionButton(
  #             "erdb_overview",
  #             label = tagList(bs_icon("house", size = 24), tags$h5("Overview")),
  #             class = "w-100 btn-card"
  #           ),
  #           actionButton("erdb_hr", label = tagList(bs_icon("people-fill", size = 24), tags$h5("Human Resource")), class = "btn-card mb-2"), # source: 187
  #           actionButton("erdb_school", label = tagList(bs_icon("building", size = 24), tags$h5("Basic Info")), class = "btn-card mb-2"), # source: 187
  #           actionButton("erdb_infra", label = tagList(bs_icon("tools", size = 24), tags$h5("Infrastructure")), class = "btn-card mb-2"), # source: 188
  #           actionButton("erdb_financial", label = tagList(bs_icon("currency-dollar", size = 24), tags$h5("Financial")), class = "btn-card mb-2"), # source: 188
  #           actionButton("erdb_monitoring", label = tagList(bs_icon("graph-up", size = 24), tags$h5("Monitoring")), class = "btn-card mb-2"), # source: 188
  #           actionButton("erdb_ppas", label = tagList(bs_icon("clipboard-data", size = 24), tags$h5("PPAs")), class = "btn-card mb-2") # source: 188
  #         ), # End Sidebar Div
  #         # --- MAIN CONTENT Div ---
  #         # div(
  #         #   id = "main_erdb_content",
  #         #   uiOutput("dynamic_erdb_panel"), # This will render the content based on sidebar clicks
  #         #   class = "main-content-erdb"
  #         # ) # End Main Content Div
  #       ) # End Main Layout Div
  #     ) # End tagList for Home content
  #   ), # End of Home nav_panel - COMMA is correct here
    
    nav_menu(
      title = tagList(bs_icon("speedometer"), tags$b("Dashboard")),
      value = "dashboard_menu",
      # Assuming this is inside a larger page_navbar structure
      # nav_panel(
      #   title = "Education Resource Dashboard",
      #   
      #   # --- SIDEBAR + MAIN CONTENT LAYOUT (using bslib::layout_sidebar) ---
      #   layout_sidebar(
      #     
      #     # 1. SIDEBAR CONTENT
      #     # The sidebar argument handles the first column (col_widths = 2)
      #     sidebar = sidebar(
      #       width = 250, # Set a fixed or proportional width for the sidebar
      #       class = "sidebar_erdb", # Retain your custom class if needed
      #       
      #       tags$h4("Select Category", class = "text-center mb-3"),
      #       
      #       # Stacked Buttons/Cards
      #       div(
      #         class = "d-grid gap-3", # Bootstrap class for vertical stacking/spacing
      #         
      #         # Use bslib::card or actionButton; I'll stick to actionButton for your logic
      #         actionButton(
      #           "erdb_overview",
      #           label = tags$div(
      #             bs_icon("house", size = 20), 
      #             tags$h5("Overview", class = "mb-0") # mb-0 helps align text
      #           ),
      #           class = "w-100 btn-card d-flex align-items-center justify-content-start" 
      #         ),
      #         
      #         # NOTE: Repeat this pattern for all other buttons
      #         actionButton(
      #           "erdb_hr",
      #           label = tags$div(
      #             bs_icon("people", size = 20), 
      #             tags$h5("Human Resource", class = "mb-0")
      #           ),
      #           class = "w-100 btn-card d-flex align-items-center justify-content-start"
      #         ),
      #         
      #         actionButton(
      #           "erdb_basic",
      #           label = tags$div(
      #             bs_icon("info-circle", size = 20), 
      #             tags$h5("Basic Information", class = "mb-0")
      #           ),
      #           class = "w-100 btn-card d-flex align-items-center justify-content-start"
      #         ),
      #         
      #         actionButton(
      #           "erdb_infra",
      #           label = tags$div(
      #             bs_icon("building", size = 20), 
      #             tags$h5("Infrastructure", class = "mb-0")
      #           ),
      #           class = "w-100 btn-card d-flex align-items-center justify-content-start"
      #         ),
      #         
      #         actionButton(
      #           "erdb_fin",
      #           label = tags$div(
      #             bs_icon("currency-exchange", size = 20), 
      #             tags$h5("Financial", class = "mb-0")
      #           ),
      #           class = "w-100 btn-card d-flex align-items-center justify-content-start"
      #         ),
      #         
      #         actionButton(
      #           "erdb_monitoring",
      #           label = tags$div(
      #             bs_icon("bar-chart-line", size = 20), 
      #             tags$h5("Monitoring", class = "mb-0")
      #           ),
      #           class = "w-100 btn-card d-flex align-items-center justify-content-start"
      #         ),
      #         
      #         actionButton(
      #           "erdb_ppas",
      #           label = tags$div(
      #             bs_icon("clipboard-check", size = 20), 
      #             tags$h5("PPAs", class = "mb-0")
      #           ),
      #           class = "w-100 btn-card d-flex align-items-center justify-content-start"
      #         )
      #       ) # /div .d-grid
      #     ), # /sidebar
      #     
      #     # 2. MAIN CONTENT AREA
      #     # The main content area handles the second column (col_widths = 10)
      #     div(
      #       class = "main_content_erdb", # Retain your custom class if needed
      #       uiOutput("erdb_content")    # Dynamic area that changes based on button clicks
      #     )
      #   ) # /layout_sidebar
      # ), # /nav_panel
      
      # nav_panel("Plantilla Positions",  #GMIS
      #           layout_sidebar(
      #             sidebar = sidebar(
      #               width = 450,
      #               class = "bg-secondary",
      #               h6("Data Toggles:"),
      #               pickerInput(
      #                 inputId = "RegionGMIS",
      #                 label = "Select one or more Regions:",
      #                 choices = c(
      #                   "Region I" = "Region I - Ilocos",
      #                   "Region II" = "Region II - Cagayan Valley",
      #                   "Region III" = "Region III - Central Luzon",
      #                   "Region IV-A" = "Region IVA - CALABARZON",
      #                   "Region IV-B" = "Region IVB - MIMAROPA",
      #                   "Region V" = "Region V - Bicol",
      #                   "Region VI" = "Region VI - Western Visayas",
      #                   "Region VII" = "Region VII - Central Visayas",
      #                   "Region VIII" = "Region VIII - Eastern Visayas",
      #                   "Region IX" = "Region IX - Zamboanga Peninsula",
      #                   "Region X" = "Region X - Northern Mindanao",
      #                   "Region XI" = "Region XI - Davao",
      #                   "Region XII" = "Region XII - SOCCSKSARGEN",
      #                   "CARAGA" = "Region XIII - CARAGA",
      #                   "CAR" = "Cordillera Administrative Region (CAR)",
      #                   "NCR" = "National Capital Region (NCR)"
      #                 ),
      #                 selected = c(
      #                   "Region I" = "Region I - Ilocos",
      #                   "Region II" = "Region II - Cagayan Valley",
      #                   "Region III" = "Region III - Central Luzon",
      #                   "Region IV-A" = "Region IVA - CALABARZON",
      #                   "Region IV-B" = "Region IVB - MIMAROPA",
      #                   "Region V" = "Region V - Bicol",
      #                   "Region VI" = "Region VI - Western Visayas",
      #                   "Region VII" = "Region VII - Central Visayas",
      #                   "Region VIII" = "Region VIII - Eastern Visayas",
      #                   "Region IX" = "Region IX - Zamboanga Peninsula",
      #                   "Region X" = "Region X - Northern Mindanao",
      #                   "Region XI" = "Region XI - Davao",
      #                   "Region XII" = "Region XII - SOCCSKSARGEN",
      #                   "CARAGA" = "Region XIII - CARAGA",
      #                   "CAR" = "Cordillera Administrative Region (CAR)",
      #                   "NCR" = "National Capital Region (NCR)"
      #                 ), # You can set default selected values here
      #                 multiple = TRUE, # CRITICAL CHANGE: Must be TRUE to enable Select All/Deselect All
      #                 options = pickerOptions(
      #                   actionsBox = TRUE, # Already correct
      #                   liveSearch = TRUE,
      #                   header = "Select Regions",
      #                   title = "No Regions Selected",
      #                   selectedTextFormat = "count > 3",
      #                   dropupAuto = FALSE,
      #                   dropup = FALSE
      #                 ),
      #                 choicesOpt = list()
      #               ),
      #               uiOutput("SDOSelectionGMIS"),
      #               # pickerInput(
      #               #   inputId = "PosCatGMIS",
      #               #   label = "Select a Position Category:",
      #               #   choices = c(
      #               #     "General Civil Servant" = "General Civil Servant",
      #               #     "Teaching Related" = "Teaching Related",
      #               #     "Allied Medical" = "Allied Medical",
      #               #     "Medical" = "Medical",
      #               #     "Teaching" = "Teaching"
      #               #   ),
      #               #   selected = c(
      #               #     "Teaching" = "Teaching"
      #               #   ),
      #               #   multiple = TRUE,
      #               #   options = pickerOptions(
      #               #     liveSearch = TRUE,
      #               #     actionsBox = TRUE, # This adds the "Select All" and "Deselect All" buttons
      #               #     title = "No Category Selected",
      #               #     header = "Select a Category"
      #               #   )
      #               # ),
      #               uiOutput("PosSelectionGMIS")),
      #             # input_task_button("GMISRun", icon_busy = fontawesome::fa_i("refresh", class = "fa-spin", "aria-hidden" = "true"), strong("Show Selection"), class = "btn-danger")),
      #             layout_columns(
      #               card(
      #                 card_header(strong("GMIS Data")),
      #                 plotlyOutput("GMISTable")),
      #               card(
      #                 card_header(strong("GMIS Data")),
      #                 dataTableOutput("GMISTable1")),
      #               col_widths = c(12,12)))), # End of Plantilla nav_panel - COMMA is correct
      # --- PLANTILLA POSITIONS PANEL ---
      # --- PLANTILLA POSITIONS PANEL ---
      # --- PLANTILLA POSITIONS PANEL ---
      nav_panel("Build your Dashboard",
                layout_sidebar(
                  sidebar = sidebar(
                    width = 350,
                    title = "Dashboard Controls",
                    uiOutput("back_button_ui"),
                    
                    # --- Section 1: Presets ---
                    hr(), # Added horizontal rule for separation
                    h4(strong("Dashboard Presets")), # Replaced card_header
                    # We apply a negative margin to pull the checkboxes left.
                    # This offsets the default padding of the input container.
                    tags$div(
                      style = "margin-left: -10px;", # Adjust this value if needed
                      
                      shinyWidgets::awesomeCheckbox(
                        inputId = "preset_teacher",
                        label = tags$div(
                          style = "display: flex; align-items: center;", 
                          tags$span("Teacher Focus", style = "margin-left: 10px; font-size: 1.1rem;") 
                        ),
                        value = FALSE 
                      ),
                      
                      tags$div(style = "margin-top: 5px;"), # Spacer
                      
                      shinyWidgets::awesomeCheckbox(
                        inputId = "preset_school",
                        label = tags$div(
                          style = "display: flex; align-items: center;", 
                          tags$span("School Focus", style = "margin-left: 10px; font-size: 1.1rem;")
                        ),
                        value = FALSE
                      ),
                      
                      tags$div(style = "margin-top: 5px;"), # <-- ADDED SPACER
                      
                      shinyWidgets::awesomeCheckbox(
                        inputId = "preset_classroom",
                        label = tags$div(
                          style = "display: flex; align-items: center;", 
                          tags$span("Infrastructure Focus", style = "margin-left: 10px; font-size: 1.1rem;")
                        ),
                        value = FALSE 
                      ),
                      
                      # --- ADD THIS NEW PRESET ---
                      tags$div(style = "margin-top: 5px;"), # Spacer
                      
                      shinyWidgets::awesomeCheckbox(
                        inputId = "preset_enrolment",
                        label = tags$div(
                          style = "display: flex; align-items: center;", 
                          tags$span("Enrolment Focus", style = "margin-left: 10px; font-size: 1.1rem;")
                        ),
                        value = FALSE 
                      )
                      # --- END OF NEW PRESET ---
                      # --- End of Wrapper Div ---
                    ), # --- End of Wrapper Div ---
                    
                    
                    # --- Section 2: Advanced Filtering ---
                    hr(), # Added horizontal rule for separation
                    h4(strong("Dashboard Filters")), # Replaced card_header

                    
                    # --- Picker 1: Human Resource Metrics ---
                    pickerInput(
                      inputId = "Combined_HR_Toggles_Build", # New combined ID
                      label = strong("Select Human Resource Metrics"),
                      multiple = TRUE,
                      options = pickerOptions(
                        `actions-box` = TRUE,
                        liveSearch = TRUE,
                        dropupAuto = FALSE,
                        dropup = FALSE,
                        header = "Select HR Metrics",
                        title = "No HR Metrics Selected"
                      ),
                      choices = list(
                        `School Information` = c("School Size Typology" = "School.Size.Typology", 
                                                 "Curricular Offering" = "Modified.COC"),
                        `Teaching Data` = c("Total Teachers" = "TotalTeachers", 
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
                    ),
                    
                    # --- Picker 2: Infrastructure Metrics ---
                    pickerInput(
                      inputId = "Combined_Infra_Toggles_Build", # New combined ID
                      label = strong("Select Infrastructure Metrics"),
                      choices = list(
                        `Classroom` = c("Classrooms" = "Instructional.Rooms.2023.2024",
                                        "Classroom Requirement" =  "Classroom.Requirement",
                                        "Classroom Shortage" = "Est.CS",
                                        "Shifting" = "Shifting",
                                        "Buildings" = "Buildings",
                                        "Buildable Space" = "Buidable_space",
                                        "Major Repairs Needed" = "Major.Repair.2023.2024"),
                        `Facilities` = c("Total Seats Available" = "Total.Seats.2023.2024",
                                         "Total Seats Shortage" = "Total.Seats.Shortage.2023.2024"),
                        `Resources` = c("Ownership Type" = "OwnershipType",
                                        "Electricity Source" = "ElectricitySource",
                                        "Water Source" = "WaterSource"
                        )),
                      multiple = TRUE,
                      options = pickerOptions(
                        `actions-box` = TRUE,
                        liveSearch = TRUE,
                        header = "Select Data Columns",
                        title = "No Data Column Selected",
                        dropupAuto = FALSE,
                        dropup = FALSE
                      )
                    )
                    
                  ), # --- End of sidebar ---
                  
                  # --- Main content area (UNCHANGED) ---
                  bslib::navset_card_tab(
                    full_screen = TRUE,
                    
                    # --- Tab 1: Your original dashboard grid ---
                    bslib::nav_panel(
                      title = "Interactive Dashboard",
                      uiOutput("dashboard_grid") # This is your existing chart grid
                    ),
                    
                    # --- Tab 2: The new Map + Table Data Explorer ---
                    bslib::nav_panel(
                      title = "School Locator",
                      # This UI output will now conditionally render 
                      # either the instructions or the map/table layout.
                      uiOutput("data_explorer_content")
                    )
                  )
                )
      ),
      # --- *** END OF NEW LAYLUT *** ---

      nav_panel(
        "Plantilla Positions",
        layout_sidebar(
          sidebar = sidebar(
            width = 500,
            class = "bg-secondary text-white",
            h5("Select Positions"),
            pickerInput(
              inputId = "selected_positions",
              label = NULL,
              choices = sort(unique(dfGMIS$Position)),   # <-- Arranged alphabetically
              selected = head(sort(unique(dfGMIS$Position)), 1), # <-- Match sorted choices
              multiple = TRUE, 
              options = list(
                `actions-box` = TRUE,  # Adds "Select All" and "Deselect All"
                `dropup-auto` = FALSE, # Forces it to always drop down
                `live-search` = TRUE,   # <-- Adds the search bar
                `live-search-style` = 'contains'
              )
            ),
            br(),
            actionButton("btn_back_drilldown", "⬅ Back", class = "btn btn-light w-100 mt-3")
          ),
          
          # --- MAIN CONTENT ---
          layout_columns(
            uiOutput("dynamic_positions_ui")
          )
        )
      ),
      nav_panel(
        title = "Infrastructure and Education Facilities",
        layout_sidebar(
          sidebar = sidebar(
            width = 350,
            div( # This div acts as a container for the right-hand filter cards
              card( # Filter by Category
                card_header("Filter by Category"),
                height = 400,
                card_body(
                  pickerInput(
                    inputId = "selected_category",
                    label = NULL,
                    choices = all_categories,
                    selected = all_categories,
                    multiple = TRUE,
                    options = pickerOptions(
                      actionsBox = TRUE,
                      liveSearch = TRUE,
                      header = "Select Categories",
                      title = "No Category Selected",
                      selectedTextFormat = "count > 3",
                      dropupAuto = FALSE, # This tells it NOT to automatically switch direction
                      dropup = FALSE
                    ),
                    choicesOpt = list()
                  )
                )
              ),
              card( # Filter by Region
                card_header("Filter by Region"),
                height = 400,
                card_body(
                  pickerInput(
                    inputId = "selected_region",
                    label = NULL,
                    choices = all_regions,
                    selected = all_regions,
                    multiple = TRUE,
                    options = pickerOptions(
                      actionsBox = TRUE,
                      liveSearch = TRUE,
                      header = "Select Regions",
                      title = "No Region Selected",
                      selectedTextFormat = "count > 3",
                      dropupAuto = FALSE, # This tells it NOT to automatically switch direction
                      dropup = FALSE
                    ),
                    choicesOpt = list()
                  )
                )
              ),
              card( # Filter by Division
                card_header("Filter by Division"),
                height = 400,
                card_body(
                  pickerInput(
                    inputId = "selected_division",
                    label = NULL,
                    choices = NULL,
                    selected = NULL,
                    multiple = TRUE,
                    options = pickerOptions(
                      actionsBox = TRUE,
                      liveSearch = TRUE,
                      header = "Select Divisions",
                      title = "No Division Selected",
                      selectedTextFormat = "count > 3",
                      dropupAuto = FALSE, # This tells it NOT to automatically switch direction
                      dropup = FALSE
                    ),
                    choicesOpt = list()
                  )
                )
              )
            )
          ),
          tagList( # Start of tagList for EFD
            h3("Allocation and Completion Overview"),
            layout_columns( # Start of layout_columns for main content and filters
              col_widths = c(12,12,12,12), # Main content on left (10), Filters on right (2)
              
              # --- LEFT COLUMN: Main Dashboard Content (Value Boxes + Tabs) ---
              # div(
              #   # Value Boxes Section
              #   card(
              #     card_header("Total Allocation per Funding Year"),
              #     layout_columns(
              #       col_widths = 12 / length(unique_funding_years), # Distribute columns evenly
              #       row_heights = 1, # Forces them into a single row
              #       !!!lapply(unique_funding_years, function(year) {
              #         value_box(
              #           title = paste("Total in", year),
              #           value = tags$span(textOutput(paste0("vb_total_alloc_", year)), style = "font-size: 1.5em;"),
              #           showcase = bsicons::bs_icon("cash-coin"),
              #           theme = "primary",
              #           full_screen = TRUE
              #         )
              #       })
              #     )
              #   )),
              
              # Main Content Area (Tabs) - Below Value Boxes
              navset_card_tab(
                nav_panel("Allocation Overview",
                          layout_columns(
                            card(full_screen = TRUE,
                                 plotlyOutput("allocationStackedBar", height = "100%"),
                                 fill = TRUE, fillable = TRUE, max_height = "auto", height = 500
                            ))),
                nav_panel("Completion Overview",
                          card(full_screen = TRUE,
                               plotlyOutput("completionByCategoryPlot", height = "100%"),
                               fill = TRUE, fillable = TRUE, max_height = "auto", height = 500
                          )))
              , # Added comma to separate navset_card_tab from the next card
              card( # This card contains both the data table and the line graph
                layout_columns(
                  col_widths = 12,
                  card(
                    card_header("Detailed Project Data for Selected Bar Segment"),
                    DT::dataTableOutput("projectDetailTable", height = "100%"),
                    fill = TRUE, fillable = TRUE, max_height = "auto", height = 700)
                ),
                layout_columns(col_widths = 12,
                               row_heights = "fill",
                               card(
                                 card_header("Allocation Trend per Category per Funding Year (Line Graph)"),
                                 plotlyOutput("allocationTrendLine", height = "100%"),
                                 fill = TRUE, fillable = TRUE, max_height = "auto", height = 600, full_screen = TRUE
                               )
                )
              )
            )
          ) # End of layout_columns for main content and filters
        ) # End of tagList for EFD
      )), # End of Dashboard nav_menu - COMMA is correct here
    
    nav_menu(
      title = tags$b("Data Explorer"),  # Dropdown menu
      icon = bs_icon("table"),
      
      # --- Nav Panel 1: Human Resource Database ---
      nav_panel(
        title = tags$b("Human Resource Database"),
        layout_sidebar(
          sidebar = sidebar(
            width = 350,
            h6("Data Toggles:"),
            
            pickerInput(
              inputId = "DataBuilder_HROD_Region",
              label = "Select a Region:",
              choices = sort(unique(uni$Region)),
              selected = sort(unique(uni$Region)),
              multiple = FALSE,
              options = pickerOptions(
                actionsBox = TRUE,
                liveSearch = TRUE,
                header = "Select Categories",
                title = "No Category Selected",
                selectedTextFormat = "count > 3",
                dropupAuto = FALSE,
                dropup = FALSE
              )
            ),
            uiOutput("DataBuilder_HROD_SDO"),
            
            pickerInput("School_Data_Toggles", strong("School Information Data Toggles"), 
                        choices = c("School Size Typology" = "School.Size.Typology", 
                                    "Curricular Offering" = "Modified.COC"),
                        multiple = TRUE,
                        options = pickerOptions(
                          `actions-box` = TRUE,
                          dropupAuto = FALSE,
                          dropup = FALSE
                        )
            ),
            
            pickerInput("Teaching_Data_Toggles", strong("Teaching Data Toggles"), 
                        choices = c("Total Teachers" = "TotalTeachers", 
                                    "Teacher Excess" = "Total.Excess", 
                                    "Teacher Shortage" = "Total.Shortage"),
                        multiple = TRUE,
                        options = pickerOptions(
                          `actions-box` = TRUE,
                          dropupAuto = FALSE,
                          dropup = FALSE
                        )
            ),
            
            pickerInput("NTP_Data_Toggles", strong("Non-teaching Data Toggles"), 
                        choices = c("COS" = "Outlier.Status", 
                                    "AOII Clustering Status" = "Clustering.Status"),
                        multiple = TRUE,
                        options = pickerOptions(
                          `actions-box` = TRUE,
                          dropupAuto = FALSE,
                          dropup = FALSE
                        )
            ),
            
            pickerInput("Enrolment_Data_Toggles", strong("Enrolment Data Toggles"), 
                        choices = c("Total Enrolment" = "TotalEnrolment", "Kinder" = "Kinder", 
                                    "Grade 1" = "G1", "Grade 2" = "G2", "Grade 3" = "G3", 
                                    "Grade 4" = "G4", "Grade 5" = "G5", "Grade 6" = "G6", 
                                    "Grade 7" = "G7", "Grade 8" = "G8", 
                                    "Grade 9" = "G9", "Grade 10" = "G10", 
                                    "Grade 11" = "G11", "Grade 12" = "G12"),
                        multiple = TRUE,
                        options = pickerOptions(
                          `actions-box` = TRUE,
                          dropupAuto = FALSE,
                          dropup = FALSE
                        )
            ),
            
            pickerInput("Specialization_Data_Toggles", strong("Specialization Data Toggles"), 
                        choices = c("English" = "English", "Mathematics" = "Mathematics", 
                                    "Science" = "Science", 
                                    "Biological Sciences" = "Biological.Sciences", 
                                    "Physical Sciences" = "Physical.Sciences"),
                        multiple = TRUE,
                        options = pickerOptions(
                          `actions-box` = TRUE,
                          dropupAuto = FALSE,
                          dropup = FALSE
                        )
            )
          ),
          
          layout_columns(
            card(
              card_header(strong("HROD Data Panel")),
              dataTableOutput("HROD_Table")
            ),
            col_widths = c(12, 12)
          )
        )
      ), # End of Human Resource DB nav_panel
      
      
      # --- Nav Panel 2: Infrastructure Database ---
      nav_panel(
        title = tags$b("Infrastructure Database"),
        layout_sidebar(
          sidebar = sidebar(
            width = 350,
            h6("EFD Database Filters:"),
            
            # Region (single select)
            pickerInput(
              inputId = "EFD_Region",
              label = "Select Region:",
              choices = sort(unique(EFDDB$Region)),
              selected = sort(unique(EFDDB$Region))[1],
              multiple = FALSE,
              options = pickerOptions(
                liveSearch = TRUE,
                header = "Select Region",
                title = "No Region Selected",
                dropupAuto = FALSE,
                dropup = FALSE
              )
            ),
            
            # Division (multi-select)
            pickerInput(
              inputId = "EFD_Division",
              label = "Select Division:",
              choices = sort(unique(EFDDB$Division)),
              multiple = TRUE,
              options = pickerOptions(
                `actions-box` = TRUE,
                liveSearch = TRUE,
                header = "Select Division(s)",
                title = "No Division Selected",
                dropupAuto = FALSE,
                dropup = FALSE
              )
            ),
            
            # Legislative District (multi-select)
            pickerInput(
              inputId = "EFD_LD",
              label = "Select Legislative District:",
              choices = sort(unique(EFDDB$Legislative.District)),
              multiple = TRUE,
              options = pickerOptions(
                `actions-box` = TRUE,
                liveSearch = TRUE,
                header = "Select Legislative District(s)",
                title = "No Legislative District Selected",
                dropupAuto = FALSE,
                dropup = FALSE
              )
            ),
            
            # EFD Toggles
            pickerInput(
              inputId = "EFD_Toggles",
              label = strong("EFD Data Toggles"),
              choices = names(EFDDB)[!names(EFDDB) %in% c(
                "Region", "Old.Region", "Division", "SchoolID", "School.Name",
                "District", "Legislative.District", "Barangay"
              )],
              multiple = TRUE,
              options = pickerOptions(
                `actions-box` = TRUE,
                liveSearch = TRUE,
                header = "Select Data Columns",
                title = "No Data Column Selected",
                dropupAuto = FALSE,
                dropup = FALSE
              )
            )
          ),
          
          layout_columns(
            card(
              full_screen = TRUE,
              style = "
          width: 100%;
          max-height: 85vh;
          overflow-y: auto;
          margin-bottom: 20px;
        ",
              card_header(
                strong("EFD Database Panel"),
                style = "
            font-size: 22px;
            padding: 15px 20px;
            text-align: center;
            background-color: #00234d;
            color: white;
            border-bottom: 2px solid #dee2e6;
          "
              ),
              card_body(
                div(
                  style = "
              padding: 10px;
              overflow-x: auto;
              height: calc(85vh - 80px);
            ",
                  dataTableOutput("EFD_Table")
                )
              )
            ),
            col_widths = c(12)
          )
        )
      ),
      nav_panel(
        title = tags$b("DepEd Officials"),
        layout_sidebar(
          sidebar = sidebar(
            width = 350,
            h6("Strand Filter:"),
            pickerInput(
              inputId = "ThirdLevel_Strands",
              label = "Select Strand(s):",
              choices = c(
                "Administration",
                "Deped Attached Agencies",
                "Finance",
                "Human Resource And Organizational Development",
                "Learning System",
                "Legal And Legislative Affairs",
                "Office Of The Secretary",
                "Operations",
                "Procurement",
                "Strategic Management",
                "Teachers And Education Council Secretariat"
              ),
              selected = c(
                "Administration",
                "Deped Attached Agencies",
                "Finance",
                "Human Resource And Organizational Development",
                "Learning System",
                "Legal And Legislative Affairs",
                "Office Of The Secretary",
                "Operations",
                "Procurement",
                "Strategic Management",
                "Teachers And Education Council Secretariat"
              ),
              multiple = TRUE,
              options = pickerOptions(
                actionsBox = TRUE,
                liveSearch = TRUE,
                header = "Select Strand(s)",
                title = "No Strand Selected",
                selectedTextFormat = "count > 3",
                dropupAuto = FALSE,
                dropup = FALSE
              ),
              choicesOpt = list(
                style = "white-space: normal; word-break: break-word; overflow-wrap: break-word;"
              )
            )
          ),
          
          layout_columns(
            card(
              full_screen = TRUE,
              style = "
          width: 100%;
          max-height: 85vh;
          overflow-y: auto;
          margin-bottom: 20px;
        ",
              card_header(
                strong("HROD Data Panel"),
                style = "
            font-size: 22px;
            padding: 15px 20px;
            text-align: center;
            background-color: #00234d;
            border-bottom: 2px solid #dee2e6;
          "
              ),
              card_body(
                div(
                  style = "
              padding: 10px;
              overflow-x: auto;
              height: calc(85vh - 80px);
            ",
                  dataTableOutput("ThirdLevel_Table")
                )
              )
            ),
            col_widths = c(12)
          )
        )
      )
    ), # End of Data Explorer nav_menu - COMMA is correct here
    
    nav_panel(
      title = tags$b("Quick School Search"),
      icon = bs_icon("search"),
      layout_sidebar(
        sidebar = sidebar(
          textInput("text","Enter School Name"),
          input_task_button("TextRun", icon_busy = fontawesome::fa_i("refresh", class = "fa-spin", "aria-hidden" = "true"), strong("Show Selection"), class = "btn-warning")),
        layout_columns(
          card(
            card_header(strong("Search Output")),
            dataTableOutput("TextTable")),
          card(full_screen = TRUE,
               card_header(strong("School Mapping")),
               leafletOutput("TextMapping", height = 500, width = "100%")),
          card(full_screen = TRUE,
               card_header(div(strong("School Details"),
                               tags$span(em("(Select a school from the table above)"),
                                         style = "font-size: 0.7em; color: grey;"
                               ))),
               layout_columns(
                 card(full_screen = TRUE,
                      card_header(strong("Basic Information")),
                      tableOutput("schooldetails")),
                 card(full_screen = TRUE,
                      card_header(strong("HR Data")),
                      tableOutput("schooldetails2")),
                 card(full_screen = TRUE,
                      card_header(strong("Classroom Data")),
                      tableOutput("schooldetails3")),
                 card(full_screen = TRUE,
                      card_header(div(strong("Specialization Data"),
                                      tags$span(em("(based on eSF7 for SY 2023-2024)"),
                                                style = "font-size: 0.7em; color: grey;"
                                      ))),
                      tableOutput("schooldetails5")),
                 col_widths = c(6,6,6,6))),
          col_widths = c(6,6,12)))), # End of Quick Search nav_panel - COMMA is correct here
    
    nav_panel(
      title = tags$b("Resource Mapping"),
      icon = bs_icon("map"),
      layout_sidebar(
        sidebar = sidebar(
          width = 375,
          title = "Resource Mapping Filters",
          
          # --- Data Filters Card for Resource Mapping ---
          card(
            height = 400,
            card_header(tags$b("Data Filters")),
            
            # Region Picker
            pickerInput(
              inputId = "resource_map_region",
              label = "Region:",
              choices = c(
                "Region I" = "Region I","Region II" = "Region II","Region III" = "Region III",
                "Region IV-A" = "Region IV-A","MIMAROPA" = "MIMAROPA","Region V" = "Region V",
                "Region VI" = "Region VI","NIR" = "NIR","Region VII" = "Region VII",
                "Region VIII" = "Region VIII","Region IX" = "Region IX","Region X" = "Region X",
                "Region XI" = "Region XI","Region XII" = "Region XII","CARAGA" = "CARAGA",
                "CAR" = "CAR","NCR" = "NCR"
              ),
              selected = "Region I",
              multiple = FALSE,
              options = list(
                `actions-box` = FALSE,
                `none-selected-text` = "Select a region",
                dropupAuto = FALSE,
                dropup = FALSE
              )
            ),
            
            # Division Picker
            pickerInput(
              inputId = "Resource_SDO",
              label = "Select a Division:",
              choices = NULL,
              selected = NULL,
              multiple = FALSE,
              options = list(
                `actions-box` = FALSE,
                `none-selected-text` = "Select a division",
                dropupAuto = FALSE,
                dropup = FALSE
              )
            ),
            
            # District Picker
            pickerInput(
              inputId = "Resource_LegDist",
              label = "Select Legislative District(s):",
              choices = NULL,
              selected = NULL,
              multiple = TRUE,
              options = list(
                `actions-box` = TRUE,
                `none-selected-text` = "Select one or more districts",
                dropupAuto = FALSE,
                dropup = FALSE
              )
            ),
            
            input_task_button("Mapping_Run", strong("Show Selection"), class = "btn-warning")
          ),
          
          hr(),
          
          # Resource Types
          card(
            card_header(tags$b("Resource Types")),
            radioButtons(
              inputId = "resource_type_selection",
              label = NULL,
              choices = c(
                "Teaching Deployment",
                "Non-teaching Deployment",
                "Classroom Inventory",
                "Learner Congestion",
                "Industries",
                "Facilities",
                "Last Mile School"
              ),
              selected = "Teaching Deployment"
            )
          )
        ),
        
        # Main Panel
        mainPanel(
          width = 12,
          uiOutput("dynamic_resource_panel")
        )
      )
    ), # End of Mapping nav_panel - COMMA is correct here
    
    nav_menu(
      title = tagList(bs_icon("cloud"),
                      tags$b("CLOUD")),
      
      nav_panel(
        title = "CLOUD (Regional Profile)", # Your existing HROD content
        layout_columns( # Main sidebar title
          # Card for Main Category Picker (combining General Info, Resource Shortage, Other)
          # Assuming this UI code is part of your sidebar or main UI definition
          # Region Filter
          card(height = 300, # Adjusted height
               card_header(tags$b("Region Filter")),
               card_body( # Added card_body
                 pickerInput(
                   inputId = "cloud_region_profile_filter", # Keep the same inputId for server compatibility
                   label = NULL,
                   choices = c("Region II" = "Region II", "MIMAROPA" = "MIMAROPA", "Region XII" = "Region XII", "CAR" = "CAR"),
                   selected = "Region II", # Keep the same default selected value
                   multiple = FALSE,
                   options = pickerOptions(
                     actionsBox = TRUE, # Changed to TRUE
                     liveSearch = TRUE,
                     header = "Select Regions", # Changed header text
                     title = "No Region Selected", # Changed title text
                     selectedTextFormat = "count > 3",
                     dropupAuto = FALSE, # This tells it NOT to automatically switch direction
                     dropup = FALSE # Added this option
                   ),
                   choicesOpt = list() # Added choicesOpt
                 )
               )
          )
          # 
          # # Division Filter
          # card(height = 400, # Adjusted height
          #      card_header(tags$b("Division Filter")),
          #      card_body( # Added card_body
          #        pickerInput(
          #          inputId = "cloud_dashboard_division_filter", # Keep the same inputId for server compatibility
          #          label = NULL,
          #          choices = NULL, # Choices will be updated dynamically by the server
          #          selected = NULL,
          #          multiple = FALSE,
          #          options = pickerOptions(
          #            actionsBox = TRUE, # Changed to TRUE
          #            liveSearch = TRUE,
          #            header = "Select Divisions", # Changed header text
          #            title = "No Division Selected", # Changed title text
          #            selectedTextFormat = "count > 3",
          #            dropupAuto = FALSE, # This tells it NOT to automatically switch direction
          #            dropup = FALSE # Added this option
          #          ),
          #          choicesOpt = list() # Added choicesOpt
          #        )
          #      )
          # )
        ), # End of sidebar
        # Main content for Dashboard tab, controlled by uiOutput
        uiOutput("cloud_profile_main_content_area") # End of layout_sidebar
      ), # End of nav_panel("HROD") # End of CLOUD Regional nav_panel - COMMA is correct
      nav_panel(
        title = "CLOUD (SDO Breakdown)", # Your existing HROD content
        layout_sidebar(
          sidebar = sidebar(
            width = 350, # Keep the sidebar width
            title = "Dashboard Navigation", # Main sidebar title
            
            # Card for Main Category Picker (combining General Info, Resource Shortage, Other)
            # Assuming this UI code is part of your sidebar or main UI definition
            
            card(height = 400, # Adjusted height to 500
                 card_header(tags$b("Select Category")),
                 card_body( # Wrapped pickerInput in card_body
                   pickerInput(
                     inputId = "cloud_main_category_picker",
                     label = NULL,
                     choices = c(
                       "Enrolment Data" = "cloud_enrolment",
                       "SNED Learners" = "cloud_sned",
                       "IP Learners" = "cloud_ip",
                       "Muslim Learners" = "cloud_muslim",
                       "Displaced Learners" = "cloud_displaced",
                       "ALS Learners" = "cloud_als",
                       "Dropout Data" = "cloud_dropout",
                       "Teacher Inventory" = "cloud_teacherinventory",
                       "Years in Service" = "cloud_years",
                       "Classroom Inventory" = "cloud_classroom",
                       "Multigrade" = "cloud_multigrade",
                       "Organized Class" = "cloud_organizedclass",
                       "JHS Teacher Deployment" = "cloud_jhsdeployment",
                       "Shifting" = "cloud_shifting",
                       "Learning Delivery Modality" = "cloud_LDM",
                       "ARAL" = "cloud_ARAL",
                       "CRLA" = "cloud_crla",
                       "PhilIRI" = "cloud_philiri",
                       "Alternative Delivery Modality" = "cloud_adm",
                       "Reading Proficiency" = "cloud_rf",
                       "Electricity Source" = "cloud_elec",
                       "Water Source" = "cloud_water",
                       "Internet Source" = "cloud_internet",
                       "Internet Usage" = "cloud_internet_usage",
                       "Bullying Incidence" = "cloud_bully",
                       # "School Initiatives" = "cloud_initiatives",
                       # "Medium of Instruction" = "cloud_moi",
                       # "School Structure" = "cloud_sosss",
                       # "SHS Implementation" = "cloud_shsimplem",
                       "Overload Pay" = "cloud_overload",
                       "School Resources" = "cloud_resources",
                       "NAT" = "cloud_nat",
                       "NAT Sufficiency" = "cloud_nat_sufficiency",
                       "LAC" = "cloud_lac",
                       "Feeding Program" = "cloud_feeding",
                       "SHA" = "cloud_sha"
                       # "Child Protection" = "cloud_childprotection",
                       # "Extension" = "cloud_extension"
                     ),
                     selected = "general_school_count", # Keep the default selected value
                     multiple = FALSE, # Keep as FALSE for single selection
                     options = pickerOptions(
                       actionsBox = FALSE, # Keep as FALSE as it's single select
                       liveSearch = TRUE,
                       header = "Select a Category", # Keep existing header
                       title = "Select Category",
                       dropupAuto = FALSE, # This tells it NOT to automatically switch direction
                       dropup = FALSE # Keep existing title
                       # selectedTextFormat is not applicable for multiple = FALSE, so it's not added
                     ),
                     choicesOpt = list() # Added choicesOpt = list() for consistency
                   )
                 )
            ),
            
            hr(), # Add a separator
            
            # Card for Region Picker
            # Assuming this UI code is part of your sidebar or main UI definition
            
            # Region Filter
            card(height = 400, # Adjusted height
                 card_header(tags$b("Region Filter")),
                 card_body( # Added card_body
                   pickerInput(
                     inputId = "cloud_region_filter", # Keep the same inputId for server compatibility
                     label = NULL,
                     choices = c("Region II" = "Region II", "MIMAROPA" = "MIMAROPA", "Region XII" = "Region XII", "CAR" = "CAR"),
                     selected = "Region II", # Keep the same default selected value
                     multiple = FALSE,
                     options = pickerOptions(
                       actionsBox = TRUE, # Changed to TRUE
                       liveSearch = TRUE,
                       header = "Select Regions", # Changed header text
                       title = "No Region Selected", # Changed title text
                       selectedTextFormat = "count > 3",
                       dropupAuto = FALSE, # This tells it NOT to automatically switch direction
                       dropup = FALSE # Added this option
                     ),
                     choicesOpt = list() # Added choicesOpt
                   )
                 )
            )
            # 
            # # Division Filter
            # card(height = 400, # Adjusted height
            #      card_header(tags$b("Division Filter")),
            #      card_body( # Added card_body
            #        pickerInput(
            #          inputId = "cloud_dashboard_division_filter", # Keep the same inputId for server compatibility
            #          label = NULL,
            #          choices = NULL, # Choices will be updated dynamically by the server
            #          selected = NULL,
            #          multiple = FALSE,
            #          options = pickerOptions(
            #            actionsBox = TRUE, # Changed to TRUE
            #            liveSearch = TRUE,
            #            header = "Select Divisions", # Changed header text
            #            title = "No Division Selected", # Changed title text
            #            selectedTextFormat = "count > 3",
            #            dropupAuto = FALSE, # This tells it NOT to automatically switch direction
            #            dropup = FALSE # Added this option
            #          ),
            #          choicesOpt = list() # Added choicesOpt
            #        )
            #      )
            # )
          ), # End of sidebar
          # Main content for Dashboard tab, controlled by uiOutput
          uiOutput("cloud_main_content_area")
        ) # End of layout_sidebar
      ), # End of nav_panel("HROD")
      nav_panel(
        title = tagList("CLOUD", em("(Multi-variable)")), # Your existing HROD content
        
        # A fluidRow to contain the three main boxes
        fluidRow(
          # First Box
          column(
            width = 6,
            card(
              card_header(tags$b("Data View 1")),
              card_body(
                pickerInput(
                  inputId = "cloud_category_picker_1",
                  label = NULL,
                  choices = c(
                    "Enrolment Data" = "cloud_enrolment",
                    "SNED Learners" = "cloud_sned",
                    "IP Learners" = "cloud_ip",
                    "Muslim Learners" = "cloud_muslim",
                    "Displaced Learners" = "cloud_displaced",
                    "ALS Learners" = "cloud_als",
                    "Dropout Data" = "cloud_dropout",
                    "Teacher Inventory" = "cloud_teacherinventory",
                    "Years in Service" = "cloud_years",
                    "Classroom Inventory" = "cloud_classroom",
                    "Multigrade" = "cloud_multigrade",
                    "Organized Class" = "cloud_organizedclass",
                    "JHS Teacher Deployment" = "cloud_jhsdeployment",
                    "Shifting" = "cloud_shifting",
                    "Learning Delivery Modality" = "cloud_LDM",
                    "ARAL" = "cloud_ARAL",
                    "CRLA" = "cloud_crla",
                    "PhilIRI" = "cloud_philiri",
                    "Alternative Delivery Modality" = "cloud_adm",
                    "Reading Proficiency" = "cloud_rf",
                    "Electricity Source" = "cloud_elec",
                    "Water Source" = "cloud_water",
                    "Internet Source" = "cloud_internet",
                    "Internet Usage" = "cloud_internet_usage",
                    "Bullying Incidence" = "cloud_bully",
                    # "School Initiatives" = "cloud_initiatives",
                    # "Medium of Instruction" = "cloud_moi",
                    # "School Structure" = "cloud_sosss",
                    # "SHS Implementation" = "cloud_shsimplem",
                    "Overload Pay" = "cloud_overload",
                    "School Resources" = "cloud_resources",
                    "NAT" = "cloud_nat",
                    "NAT Sufficiency" = "cloud_nat_sufficiency",
                    "LAC" = "cloud_lac",
                    "Feeding Program" = "cloud_feeding",
                    "SHA" = "cloud_sha"
                    # "Child Protection" = "cloud_childprotection",
                    # "Extension" = "cloud_extension"
                  ),
                  selected = "cloud_enrolment",
                  multiple = FALSE,
                  options = pickerOptions(
                    liveSearch = TRUE,
                    title = "Select Category"
                  )
                ),
                uiOutput("cloud_graph_1") # Placeholder for the first graph
              )
            )
          ),
          
          # Second Box
          column(
            width = 6,
            card(
              card_header(tags$b("Data View 2")),
              card_body(
                pickerInput(
                  inputId = "cloud_category_picker_2",
                  label = NULL,
                  choices = c(
                    "Enrolment Data" = "cloud_enrolment",
                    "SNED Learners" = "cloud_sned",
                    "IP Learners" = "cloud_ip",
                    "Muslim Learners" = "cloud_muslim",
                    "Displaced Learners" = "cloud_displaced",
                    "ALS Learners" = "cloud_als",
                    "Dropout Data" = "cloud_dropout",
                    "Teacher Inventory" = "cloud_teacherinventory",
                    "Years in Service" = "cloud_years",
                    "Classroom Inventory" = "cloud_classroom",
                    "Multigrade" = "cloud_multigrade",
                    "Organized Class" = "cloud_organizedclass",
                    "JHS Teacher Deployment" = "cloud_jhsdeployment",
                    "Shifting" = "cloud_shifting",
                    "Learning Delivery Modality" = "cloud_LDM",
                    "ARAL" = "cloud_ARAL",
                    "CRLA" = "cloud_crla",
                    "PhilIRI" = "cloud_philiri",
                    "Alternative Delivery Modality" = "cloud_adm",
                    "Reading Proficiency" = "cloud_rf",
                    "Electricity Source" = "cloud_elec",
                    "Water Source" = "cloud_water",
                    "Internet Source" = "cloud_internet",
                    "Internet Usage" = "cloud_internet_usage",
                    "Bullying Incidence" = "cloud_bully",
                    # "School Initiatives" = "cloud_initiatives",
                    # "Medium of Instruction" = "cloud_moi",
                    # "School Structure" = "cloud_sosss",
                    # "SHS Implementation" = "cloud_shsimplem",
                    "Overload Pay" = "cloud_overload",
                    "School Resources" = "cloud_resources",
                    "NAT" = "cloud_nat",
                    "NAT Sufficiency" = "cloud_nat_sufficiency",
                    "LAC" = "cloud_lac",
                    "Feeding Program" = "cloud_feeding",
                    "SHA" = "cloud_sha"
                    # "Child Protection" = "cloud_childprotection",
                    # "Extension" = "cloud_extension"
                  ),
                  selected = "cloud_teacherinventory",
                  multiple = FALSE,
                  options = pickerOptions(
                    liveSearch = TRUE,
                    title = "Select Category"
                  )
                ),
                uiOutput("cloud_graph_2") # Placeholder for the second graph
              )
            )
          ),
          
          # Third Box
          column(
            width = 6,
            card(
              card_header(tags$b("Data View 3")),
              card_body(
                pickerInput(
                  inputId = "cloud_category_picker_3",
                  label = NULL,
                  choices = c(
                    "Enrolment Data" = "cloud_enrolment",
                    "SNED Learners" = "cloud_sned",
                    "IP Learners" = "cloud_ip",
                    "Muslim Learners" = "cloud_muslim",
                    "Displaced Learners" = "cloud_displaced",
                    "ALS Learners" = "cloud_als",
                    "Dropout Data" = "cloud_dropout",
                    "Teacher Inventory" = "cloud_teacherinventory",
                    "Years in Service" = "cloud_years",
                    "Classroom Inventory" = "cloud_classroom",
                    "Multigrade" = "cloud_multigrade",
                    "Organized Class" = "cloud_organizedclass",
                    "JHS Teacher Deployment" = "cloud_jhsdeployment",
                    "Shifting" = "cloud_shifting",
                    "Learning Delivery Modality" = "cloud_LDM",
                    "ARAL" = "cloud_ARAL",
                    "CRLA" = "cloud_crla",
                    "PhilIRI" = "cloud_philiri",
                    "Alternative Delivery Modality" = "cloud_adm",
                    "Reading Proficiency" = "cloud_rf",
                    "Electricity Source" = "cloud_elec",
                    "Water Source" = "cloud_water",
                    "Internet Source" = "cloud_internet",
                    "Internet Usage" = "cloud_internet_usage",
                    "Bullying Incidence" = "cloud_bully",
                    # "School Initiatives" = "cloud_initiatives",
                    # "Medium of Instruction" = "cloud_moi",
                    # "School Structure" = "cloud_sosss",
                    # "SHS Implementation" = "cloud_shsimplem",
                    "Overload Pay" = "cloud_overload",
                    "School Resources" = "cloud_resources",
                    "NAT" = "cloud_nat",
                    "NAT Sufficiency" = "cloud_nat_sufficiency",
                    "LAC" = "cloud_lac",
                    "Feeding Program" = "cloud_feeding",
                    "SHA" = "cloud_sha"
                    # "Child Protection" = "cloud_childprotection",
                    # "Extension" = "cloud_extension"
                  ),
                  selected = "cloud_classroom",
                  multiple = FALSE,
                  options = pickerOptions(
                    liveSearch = TRUE,
                    title = "Select Category"
                  )
                ),
                uiOutput("cloud_graph_3") # Placeholder for the third graph
              )
            )
          ),
          # Fourth Box
          column(
            width = 6,
            card(
              card_header(tags$b("Data View 4")),
              card_body(
                pickerInput(
                  inputId = "cloud_category_picker_4",
                  label = NULL,
                  choices = c(
                    "Enrolment Data" = "cloud_enrolment",
                    "SNED Learners" = "cloud_sned",
                    "IP Learners" = "cloud_ip",
                    "Muslim Learners" = "cloud_muslim",
                    "Displaced Learners" = "cloud_displaced",
                    "ALS Learners" = "cloud_als",
                    "Dropout Data" = "cloud_dropout",
                    "Teacher Inventory" = "cloud_teacherinventory",
                    "Years in Service" = "cloud_years",
                    "Classroom Inventory" = "cloud_classroom",
                    "Multigrade" = "cloud_multigrade",
                    "Organized Class" = "cloud_organizedclass",
                    "JHS Teacher Deployment" = "cloud_jhsdeployment",
                    "Shifting" = "cloud_shifting",
                    "Learning Delivery Modality" = "cloud_LDM",
                    "ARAL" = "cloud_ARAL",
                    "CRLA" = "cloud_crla",
                    "PhilIRI" = "cloud_philiri",
                    "Alternative Delivery Modality" = "cloud_adm",
                    "Reading Proficiency" = "cloud_rf",
                    "Electricity Source" = "cloud_elec",
                    "Water Source" = "cloud_water",
                    "Internet Source" = "cloud_internet",
                    "Internet Usage" = "cloud_internet_usage",
                    "Bullying Incidence" = "cloud_bully",
                    # "School Initiatives" = "cloud_initiatives",
                    # "Medium of Instruction" = "cloud_moi",
                    # "School Structure" = "cloud_sosss",
                    # "SHS Implementation" = "cloud_shsimplem",
                    "Overload Pay" = "cloud_overload",
                    "School Resources" = "cloud_resources",
                    "NAT" = "cloud_nat",
                    "NAT Sufficiency" = "cloud_nat_sufficiency",
                    "LAC" = "cloud_lac",
                    "Feeding Program" = "cloud_feeding",
                    "SHA" = "cloud_sha"
                    # "Child Protection" = "cloud_childprotection",
                    # "Extension" = "cloud_extension"
                  ),
                  selected = "cloud_shifting",
                  multiple = FALSE,
                  options = pickerOptions(
                    liveSearch = TRUE,
                    title = "Select Category"
                  )
                ),
                uiOutput("cloud_graph_4") # Placeholder for the third graph
              )
            )
          ),
          column(
            width = 6,
            card(
              card_header(tags$b("Data View 5")),
              card_body(
                pickerInput(
                  inputId = "cloud_category_picker_5",
                  label = NULL,
                  choices = c(
                    "Enrolment Data" = "cloud_enrolment",
                    "SNED Learners" = "cloud_sned",
                    "IP Learners" = "cloud_ip",
                    "Muslim Learners" = "cloud_muslim",
                    "Displaced Learners" = "cloud_displaced",
                    "ALS Learners" = "cloud_als",
                    "Dropout Data" = "cloud_dropout",
                    "Teacher Inventory" = "cloud_teacherinventory",
                    "Years in Service" = "cloud_years",
                    "Classroom Inventory" = "cloud_classroom",
                    "Multigrade" = "cloud_multigrade",
                    "Organized Class" = "cloud_organizedclass",
                    "JHS Teacher Deployment" = "cloud_jhsdeployment",
                    "Shifting" = "cloud_shifting",
                    "Learning Delivery Modality" = "cloud_LDM",
                    "ARAL" = "cloud_ARAL",
                    "CRLA" = "cloud_crla",
                    "PhilIRI" = "cloud_philiri",
                    "Alternative Delivery Modality" = "cloud_adm",
                    "Reading Proficiency" = "cloud_rf",
                    "Electricity Source" = "cloud_elec",
                    "Water Source" = "cloud_water",
                    "Internet Source" = "cloud_internet",
                    "Internet Usage" = "cloud_internet_usage",
                    "Bullying Incidence" = "cloud_bully",
                    # "School Initiatives" = "cloud_initiatives",
                    # "Medium of Instruction" = "cloud_moi",
                    # "School Structure" = "cloud_sosss",
                    # "SHS Implementation" = "cloud_shsimplem",
                    "Overload Pay" = "cloud_overload",
                    "School Resources" = "cloud_resources",
                    "NAT" = "cloud_nat",
                    "NAT Sufficiency" = "cloud_nat_sufficiency",
                    "LAC" = "cloud_lac",
                    "Feeding Program" = "cloud_feeding",
                    "SHA" = "cloud_sha"
                    # "Child Protection" = "cloud_childprotection",
                    # "Extension" = "cloud_extension"
                  ),
                  selected = "cloud_enrolment",
                  multiple = FALSE,
                  options = pickerOptions(
                    liveSearch = TRUE,
                    title = "Select Category"
                  )
                ),
                uiOutput("cloud_graph_5") # Placeholder for the first graph
              )
            )
          ),
          column(
            width = 6,
            card(
              card_header(tags$b("Data View 6")),
              card_body(
                pickerInput(
                  inputId = "cloud_category_picker_6",
                  label = NULL,
                  choices = c(
                    "Enrolment Data" = "cloud_enrolment",
                    "SNED Learners" = "cloud_sned",
                    "IP Learners" = "cloud_ip",
                    "Muslim Learners" = "cloud_muslim",
                    "Displaced Learners" = "cloud_displaced",
                    "ALS Learners" = "cloud_als",
                    "Dropout Data" = "cloud_dropout",
                    "Teacher Inventory" = "cloud_teacherinventory",
                    "Years in Service" = "cloud_years",
                    "Classroom Inventory" = "cloud_classroom",
                    "Multigrade" = "cloud_multigrade",
                    "Organized Class" = "cloud_organizedclass",
                    "JHS Teacher Deployment" = "cloud_jhsdeployment",
                    "Shifting" = "cloud_shifting",
                    "Learning Delivery Modality" = "cloud_LDM",
                    "ARAL" = "cloud_ARAL",
                    "CRLA" = "cloud_crla",
                    "PhilIRI" = "cloud_philiri",
                    "Alternative Delivery Modality" = "cloud_adm",
                    "Reading Proficiency" = "cloud_rf",
                    "Electricity Source" = "cloud_elec",
                    "Water Source" = "cloud_water",
                    "Internet Source" = "cloud_internet",
                    "Internet Usage" = "cloud_internet_usage",
                    "Bullying Incidence" = "cloud_bully",
                    # "School Initiatives" = "cloud_initiatives",
                    # "Medium of Instruction" = "cloud_moi",
                    # "School Structure" = "cloud_sosss",
                    # "SHS Implementation" = "cloud_shsimplem",
                    "Overload Pay" = "cloud_overload",
                    "School Resources" = "cloud_resources",
                    "NAT" = "cloud_nat",
                    "NAT Sufficiency" = "cloud_nat_sufficiency",
                    "LAC" = "cloud_lac",
                    "Feeding Program" = "cloud_feeding",
                    "SHA" = "cloud_sha"
                    # "Child Protection" = "cloud_childprotection",
                    # "Extension" = "cloud_extension"
                  ),
                  selected = "cloud_enrolment",
                  multiple = FALSE,
                  options = pickerOptions(
                    liveSearch = TRUE,
                    title = "Select Category"
                  )
                ),
                uiOutput("cloud_graph_6") # Placeholder for the first graph
              )
            )
          )
        ))), # End of CLOUD nav_menu - COMMA is correct here
    
    nav_panel(
      title = tags$b("Contact Us"),
      icon = bs_icon("envelope"),
      h3("Contact Information"),
      fluidRow(
        column(12,
               tags$iframe(
                 id = "googleform",
                 src = "https://docs.google.com/forms/d/e/1FAIpQLScmWmVzlAHgsitxUncINy4OC_5gkyg2LvYcJAkAGlGAzQHNvw/viewform?embedded=true", # Replace YOUR_FORM_ID
                 width = "100%", # Or a specific pixel value like "760"
                 height = "700px", # Or a specific pixel value like "500"
                 frameborder = "0",
                 marginheight = "0",
                 marginwidth = "0")
        )
      )
    ), # End of Contact Us nav_panel - COMMA is correct here
    
    # nav_spacer(), # COMMA is correct here
    # 
    # nav_item(
    #   tags$button(
    #     id = "main_app-logout",
    #     class = "btn btn-danger btn-sm",
    #     bs_icon("box-arrow-right"), "Log Out"
    #   )
    # ) # End of Logout nav_item - NO COMMA needed as it's the LAST item overall
    
  ) # End page_navbar
}) # End renderUI
