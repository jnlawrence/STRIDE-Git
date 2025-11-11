# stride2 GUEST UI (Data Explorer and mySTRIDE removed)

output$STRIDE2_guest <- renderUI({
  
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
    id = "STRIDE2_navbar_guest", # <-- Gave it a unique ID
    title = navbar_title_ui,
    
    theme = bs_theme(
      version = 5,
      bootswatch = "sandstone",
      font_scale = 0.9,
      base_font = font_google("Poppins")
    ), 
    
    nav_spacer(),
    
    # ==========================================================
    # --- HOME PANEL (with STRIDE Banner + News Carousel) ---
    # ==========================================================
    nav_panel(
      title = tags$b("Home"),
      icon = bs_icon("house-door-fill"),
      value = "home_tab",
      tagList(
        useShinyjs(),
        
        # --- Inline CSS (Scoped only to Home Panel) ---
        tags$head(
          tags$style(HTML("
        /* ================================
           STRIDE HOME BANNER & CAROUSEL
        ================================ */
        /* ... (all your CSS from the home panel) ... */
        .stride-banner {
          position: relative;
          width: 100%;
          height: 300px;
          background: linear-gradient(135deg, #003366 40%, #FFB81C 100%);
          color: white;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          text-align: center;
          overflow: hidden;
          border-bottom: 6px solid #003366;
          box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .stride-banner::before {
          content: '';
          position: absolute;
          inset: 0;
          background-image: radial-gradient(rgba(255,255,255,0.15) 1px, transparent 1px);
          background-size: 30px 30px;
          animation: movePattern 8s linear infinite;
        }
        @keyframes movePattern {
          from { background-position: 0 0; }
          to { background-position: 60px 60px; }
        }
        .stride-banner-content {
          position: relative;
          z-index: 2;
          max-width: 900px;
          padding: 0 20px;
        }
      .stride-banner h1 {
    font-size: 2.2rem;
    font-weight: 800;
    letter-spacing: 1px;
    margin-top: -15px;
    margin-bottom: 10px;
    margin-left: -75px;
    text-shadow: 2px 2px 6px rgba(0, 0, 0, 0.3);
    white-space: nowrap;
}
        .stride-banner p {
    font-weight: 400;
    opacity: 0.95;
}
.stride-logo {
    height: 243px;
    margin-top: -23px;
    margin-bottom: -46px;
    filter: drop-shadow(0 0 4px rgba(255, 255, 255, 0.4)) /* soft white glow */ drop-shadow(2px 2px 6px rgba(0, 0, 0, 0.6));
    transition: filter 0.3s 
ease;
}
.stride-logo:hover {
  filter:
    drop-shadow(0 0 6px rgba(255, 255, 255, 0.6))
    drop-shadow(2px 2px 8px rgba(0, 0, 0, 0.8));
}
        .home-carousel-container {
          position: relative;
          width: 100%;
          max-width: 1000px;
          margin: 60px auto;
          overflow: hidden;
          border-radius: 15px;
          box-shadow: 0 4px 20px rgba(0,0,0,0.15);
          background: #fff;
        }
        .home-slide { display: none; text-align: center; position: relative; }
        .home-slide img { width: 100%; height: 500px; object-fit: cover; border-radius: 15px; }
        .home-slide.active { display: block; animation: fadeIn 1s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        .slide-caption {
          position: absolute; bottom: 40px; left: 50%; transform: translateX(-50%);
          background: rgba(0, 51, 102, 0.75); color: #fff; padding: 15px 25px;
          border-radius: 8px; font-size: 1.2rem; font-weight: 500; max-width: 80%;
        }
        .carousel-nav {
          position: absolute; top: 50%; transform: translateY(-50%);
          background-color: rgba(0,0,0,0.5); color: #fff;
          font-size: 2rem; border: none; padding: 10px 15px; border-radius: 50%;
          cursor: pointer; transition: background 0.3s ease;
        }
        .carousel-nav:hover { background-color: rgba(0,0,0,0.7); }
        .prev-slide { left: 15px; }
        .next-slide { right: 15px; }
        .go-dashboard-btn {
          display: inline-block;
          margin: 40px auto;
          padding: 14px 36px;
          font-size: 1.1rem;
          font-weight: 600;
          background-color: #003366;
          color: #fff !important;
          border-radius: 8px;
          border: none;
          transition: all 0.3s ease;
          text-decoration: none;
        }
        .go-dashboard-btn:hover {
          background-color: #FFB81C;
          color: #003366 !important;
          transform: translateY(-3px);
          box-shadow: 0 6px 15px rgba(0,0,0,0.2);
        }
        @media (max-width: 768px) {
          .stride-banner { height: 230px; }
          .stride-banner h1 { font-size: 2rem; }
          .stride-banner p { font-size: 1rem; }
          .home-slide img { height: 320px; }
          .slide-caption { font-size: 1rem; }
        }
      "))
        ),
        # --- STRIDE Banner Section ---
        div(
          class = "stride-banner",
          div(
            class = "stride-banner-content",
            tags$img(
              src = "Stridelogo1.png",
              class = "stride-logo"
            ),
            h1("Strategic Resource Inventory for Deployment Efficiency"),
            
            p("Empowering DepEd with data-driven insights to strengthen its education systems, 
      optimize resource allocation, and promote informed decision-making nationwide.")
          )
        ),
        # --- Carousel Section ---
        div(
          class = "home-carousel-container",
          div(class = "home-slide active", tags$img(src = "5.png"), div(class = "slide-caption", "STRIDE promotes data-driven education reform initiatives.")),
          div(class = "home-slide", tags$img(src = "3.png"), div(class = "slide-caption", "Empowering the institutions through strategic information dashboards.")),
          div(class = "home-slide", tags$img(src = "2.png"), div(class = "slide-caption", "Building efficient deployment strategies for schools and teachers.")),
          tags$button(class = "carousel-nav prev-slide", "<"),
          tags$button(class = "carousel-nav next-slide", ">")
        ),
        tags$script(HTML("
      let currentSlide = 0;
      const slides = document.querySelectorAll('.home-slide');
      function showSlide(index) {
        slides.forEach((slide, i) => {
          slide.classList.remove('active');
          if (i === index) slide.classList.add('active');
        });
      }
      document.addEventListener('click', function(e) {
        if (e.target.classList.contains('next-slide')) {
          currentSlide = (currentSlide + 1) % slides.length;
          showSlide(currentSlide);
        } else if (e.target.classList.contains('prev-slide')) {
          currentSlide = (currentSlide - 1 + slides.length) % slides.length;
          showSlide(currentSlide);
        }
      });
    "))
      ) # End tagList
    ), # End Home nav_panel
    
    # --- DASHBOARD MENU ---
    nav_menu(
      title = tagList(bs_icon("speedometer"), tags$b("Dashboard")),
      value = "dashboard_menu",
      # ... (Copy the entire contents of your "Dashboard" nav_menu here) ...
      nav_panel(
        title = "Education Resource Dashboard",
        value = "build_dashboard_tab",  
        layout_sidebar(
          sidebar = sidebar(
            width = 350,
            title = "Dashboard Controls",
            uiOutput("back_button_ui"),
            hr(), 
            h4(strong("Dashboard Presets")),
            tags$div(
              style = "margin-left: -10px;",
              shinyWidgets::awesomeCheckbox(inputId = "preset_teacher", label = tags$div(style = "display: flex; align-items: center;", tags$span("Teacher Focus", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px;"),
              shinyWidgets::awesomeCheckbox(inputId = "preset_school", label = tags$div(style = "display: flex; align-items: center;", tags$span("School Focus", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px;"),
              shinyWidgets::awesomeCheckbox(inputId = "preset_classroom", label = tags$div(style = "display: flex; align-items: center;", tags$span("Infrastructure Focus", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px;"),
              shinyWidgets::awesomeCheckbox(inputId = "preset_enrolment", label = tags$div(style = "display: flex; align-items: center;", tags$span("Enrolment Focus", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE)
            ),
            hr(),
            h4(strong("Dashboard Filters")),
            pickerInput(
              inputId = "Combined_HR_Toggles_Build",
              label = strong("Select Human Resource Metrics"),
              multiple = TRUE,
              options = pickerOptions(`actions-box` = TRUE, liveSearch = TRUE, dropupAuto = FALSE, dropup = FALSE, header = "Select HR Metrics", title = "No HR Metrics Selected"),
              choices = list(
                `School Information` = c("Number of Schools" = "Total.Schools", "School Size Typology" = "School.Size.Typology", "Curricular Offering" = "Modified.COC"),
                `Teaching Data` = c("Total Teachers" = "TotalTeachers", "Teacher Excess" = "Total.Excess", "Teacher Shortage" = "Total.Shortage"),
                `Non-teaching Data` = c("COS" = "Outlier.Status", "AOII Clustering Status" = "Clustering.Status"),
                `Enrolment Data` = c("Total Enrolment" = "TotalEnrolment", "Kinder" = "Kinder", "Grade 1" = "G1", "Grade 2" = "G2", "Grade 3" = "G3", "Grade 4" = "G4", "Grade 5" = "G5", "Grade 6" = "G6", "Grade 7" = "G7", "Grade 8" = "G8", "Grade 9" = "G9", "Grade 10" = "G10", "Grade 11" = "G11", "Grade 12" = "G12"),
                `Specialization Data` = c("English" = "English", "Mathematics" = "Mathematics", "Science" = "Science", "Biological Sciences" = "Biological.Sciences", "Physical Sciences" = "Physical.Sciences")
              )
            ),
            pickerInput(
              inputId = "Combined_Infra_Toggles_Build",
              label = strong("Select Infrastructure Metrics"),
              choices = list(
                `Classroom` = c("Classrooms" = "Instructional.Rooms.2023.2024", "Classroom Requirement" =  "Classroom.Requirement", "Classroom Shortage" = "Est.CS", "Shifting" = "Shifting", "Buildings" = "Buildings", "Buildable Space" = "Buidable_space", "Major Repairs Needed" = "Major.Repair.2023.2024"),
                `Facilities` = c("Total Seats Available" = "Total.Seats.2023.2024", "Total Seats Shortage" = "Total.Seats.Shortage.2023.2024"),
                `Resources` = c("Ownership Type" = "OwnershipType", "Electricity Source" = "ElectricitySource", "Water Source" = "WaterSource"
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
          ), # End sidebar
          bslib::navset_card_tab(
            full_screen = TRUE,
            bslib::nav_panel(title = "Interactive Dashboard", uiOutput("dashboard_grid")),
            bslib::nav_panel(title = "School Locator", uiOutput("data_explorer_content"))
          )
        ) # End layout_sidebar
      ), # End nav_panel
      nav_panel(
        "Plantilla Positions",
        layout_sidebar(
          sidebar = sidebar(
            width = 500,
            class = "bg-secondary text-white",
            tags$div(class = "preset-filters", tags$h5("Position Presets"), awesomeCheckboxGroup(inputId = "plantilla_presets", label = "Click to filter positions:", choices = c("Teacher", "Master Teacher", "School Principal", "Head Teacher", "Guidance Coordinator", "Guidance Counselor", "Engineer", "Administrative Officer", "Administrative Assistant"), inline = FALSE, status = "primary")),
            hr(), 
            h5("Select Positions"),
            pickerInput(inputId = "selected_positions", label = NULL, choices = sort(unique(dfGMIS$Position)), selected = head(sort(unique(dfGMIS$Position)), 1), multiple = TRUE, options = list(`actions-box` = TRUE, `dropup-auto` = FALSE, `live-search` = TRUE, `live-search-style` = 'contains')),
            br(),
            actionButton("btn_back_drilldown", "⬅ Back", class = "btn btn-light w-100 mt-3")
          ), # End sidebar
          layout_columns(uiOutput("dynamic_positions_ui"))
        ) # End layout_sidebar
      ), # End nav_panel
      nav_panel(
        title = "Infrastructure and Education Facilities",
        layout_sidebar(
          sidebar = sidebar(
            width = 350,
            div(
              card(card_header("Filter by Category"), height = 400, card_body(pickerInput(inputId = "selected_category", label = NULL, choices = all_categories, selected = all_categories, multiple = TRUE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, header = "Select Categories", title = "No Category Selected", selectedTextFormat = "count > 3", dropupAuto = FALSE, dropup = FALSE), choicesOpt = list()))),
              card(card_header("Filter by Region"), height = 400, card_body(pickerInput(inputId = "selected_region", label = NULL, choices = all_regions, selected = all_regions, multiple = TRUE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, header = "Select Regions", title = "No Region Selected", selectedTextFormat = "count > 3", dropupAuto = FALSE, dropup = FALSE), choicesOpt = list()))),
              card(card_header("Filter by Division"), height = 400, card_body(pickerInput(inputId = "selected_division", label = NULL, choices = NULL, selected = NULL, multiple = TRUE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, header = "Select Divisions", title = "No Division Selected", selectedTextFormat = "count > 3", dropupAuto = FALSE, dropup = FALSE), choicesOpt = list())))
            )
          ), # End sidebar
          tagList(
            h3("Allocation and Completion Overview"),
            layout_columns(
              col_widths = c(12,12,12,12),
              navset_card_tab(
                nav_panel("Allocation Overview", layout_columns(card(full_screen = TRUE, plotlyOutput("allocationStackedBar", height = "100%"), fill = TRUE, fillable = TRUE, max_height = "auto", height = 500))),
                nav_panel("Completion Overview", card(full_screen = TRUE, plotlyOutput("completionByCategoryPlot", height = "100%"), fill = TRUE, fillable = TRUE, max_height = "auto", height = 500))
              ),
              card(
                layout_columns(col_widths = 12, card(card_header("Detailed Project Data for Selected Bar Segment"), DT::dataTableOutput("projectDetailTable", height = "100%"), fill = TRUE, fillable = TRUE, max_height = "auto", height = 700)),
                layout_columns(col_widths = 12, row_heights = "fill", card(card_header("Allocation Trend per Category per Funding Year (Line Graph)"), plotlyOutput("allocationTrendLine", height = "100%"), fill = TRUE, fillable = TRUE, max_height = "auto", height = 600, full_screen = TRUE))
              )
            )
          ) # End tagList
        ) # End layout_sidebar
      ) # End nav_panel
    ), # End Dashboard nav_menu
    
    # --- QUICK SCHOOL SEARCH ---
    nav_panel(
      title = tags$b("Quick School Search"),
      icon = bs_icon("search"),
      layout_sidebar(
        sidebar = sidebar(
          textInput("text","Enter School Name"),
          input_task_button("TextRun", icon_busy = fontawesome::fa_i("refresh", class = "fa-spin", "aria-hidden" = "true"), strong("Show Selection"), class = "btn-warning")
        ),
        layout_columns(
          card(card_header(strong("Search Output")), dataTableOutput("TextTable")),
          card(full_screen = TRUE, card_header(strong("School Mapping")), leafletOutput("TextMapping", height = 500, width = "100%")),
          card(full_screen = TRUE, card_header(div(strong("School Details"), tags$span(em("(Select a school from the table above)"), style = "font-size: 0.7em; color: grey;"))),
               layout_columns(
                 card(full_screen = TRUE, card_header(strong("Basic Information")), tableOutput("schooldetails")),
                 card(full_screen = TRUE, card_header(strong("HR Data")), tableOutput("schooldetails2")),
                 card(full_screen = TRUE, card_header(strong("Classroom Data")), tableOutput("schooldetails3")),
                 card(full_screen = TRUE, card_header(div(strong("Specialization Data"), tags$span(em("(based on eSF7 for SY 2023-2024)"), style = "font-size: 0.7em; color: grey;"))), tableOutput("schooldetails5")),
                 col_widths = c(6,6,6,6)
               )
          ),
          col_widths = c(6,6,12)
        )
      )
    ), # End Quick Search nav_panel
    
    # --- RESOURCE MAPPING ---
    nav_panel(
      title = tags$b("Resource Mapping"),
      icon = bs_icon("map"),
      layout_sidebar(
        sidebar = sidebar(
          width = 375,
          title = "Resource Mapping Filters",
          card(
            height = 400,
            card_header(tags$b("Data Filters")),
            pickerInput(inputId = "resource_map_region", label = "Region:", choices = c("Region I" = "Region I","Region II" = "Region II","Region III" = "Region III", "Region IV-A" = "Region IV-A","MIMAROPA" = "MIMAROPA","Region V" = "Region V", "Region VI" = "Region VI","NIR" = "NIR","Region VII" = "Region VII", "Region VIII" = "Region VIII","Region IX" = "Region IX","Region X" = "Region X", "Region XI" = "Region XI","Region XII" = "Region XII","CARAGA" = "CARAGA", "CAR" = "CAR","NCR" = "NCR"), selected = "Region I", multiple = FALSE, options = list(`actions-box` = FALSE, `none-selected-text` = "Select a region", dropupAuto = FALSE, dropup = FALSE)),
            pickerInput(inputId = "Resource_SDO", label = "Select a Division:", choices = NULL, selected = NULL, multiple = FALSE, options = list(`actions-box` = FALSE, `none-selected-text` = "Select a division", dropupAuto = FALSE, dropup = FALSE)),
            pickerInput(inputId = "Resource_LegDist", label = "Select Legislative District(s):", choices = NULL, selected = NULL, multiple = TRUE, options = list(`actions-box` = TRUE, `none-selected-text` = "Select one or more districts", dropupAuto = FALSE, dropup = FALSE)),
            input_task_button("Mapping_Run", strong("Show Selection"), class = "btn-warning")
          ),
          hr(),
          card(
            card_header(tags$b("Resource Types")),
            radioButtons(
              inputId = "resource_type_selection",
              label = NULL,
              choices = c("Teaching Deployment", "Non-teaching Deployment", "Classroom Inventory", "Learner Congestion", "Industries", "Facilities", "Last Mile School"),
              selected = "Teaching Deployment"
            )
          )
        ), # End sidebar
        mainPanel(
          width = 12,
          uiOutput("dynamic_resource_panel")
        )
      ) # End layout_sidebar
    ), # End Mapping nav_panel
    
    # --- CLOUD MENU ---
    nav_menu(
      title = tagList(bs_icon("cloud"), tags$b("CLOUD")),
      
      nav_panel(
        title = "CLOUD (Regional Profile)",
        layout_columns(
          card(height = 300, card_header(tags$b("Region Filter")), card_body(pickerInput(inputId = "cloud_region_profile_filter", label = NULL, choices = c("Region II" = "Region II", "MIMAROPA" = "MIMAROPA", "Region XII" = "Region XII", "CAR" = "CAR"), selected = "Region II", multiple = FALSE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, header = "Select Regions", title = "No Region Selected", selectedTextFormat = "count > 3", dropupAuto = FALSE, dropup = FALSE), choicesOpt = list()))),
          uiOutput("cloud_profile_main_content_area")
        )
      ), # End nav_panel
      
      nav_panel(
        title = "CLOUD (SDO Breakdown)",
        layout_sidebar(
          sidebar = sidebar(
            width = 350,
            title = "Dashboard Navigation",
            card(height = 400, card_header(tags$b("Select Category")), card_body(pickerInput(inputId = "cloud_main_category_picker", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "general_school_count", multiple = FALSE, options = pickerOptions(actionsBox = FALSE, liveSearch = TRUE, header = "Select a Category", title = "Select Category", dropupAuto = FALSE, dropup = FALSE), choicesOpt = list()))),
            hr(),
            card(height = 400, card_header(tags$b("Region Filter")), card_body(pickerInput(inputId = "cloud_region_filter", label = NULL, choices = c("Region II" = "Region II", "MIMAROPA" = "MIMAROPA", "Region XII" = "Region XII", "CAR" = "CAR"), selected = "Region II", multiple = FALSE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, header = "Select Regions", title = "No Region Selected", selectedTextFormat = "count > 3", dropupAuto = FALSE, dropup = FALSE), choicesOpt = list())))
          ), # End sidebar
          uiOutput("cloud_main_content_area")
        ) # End layout_sidebar
      ), # End nav_panel
      
      nav_panel(
        title = tagList("CLOUD", em("(Multi-variable)")),
        fluidRow(
          column(width = 6, card(card_header(tags$b("Data View 1")), card_body(pickerInput(inputId = "cloud_category_picker_1", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_enrolment", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_1")))),
          column(width = 6, card(card_header(tags$b("Data View 2")), card_body(pickerInput(inputId = "cloud_category_picker_2", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_teacherinventory", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_2")))),
          column(width = 6, card(card_header(tags$b("Data View 3")), card_body(pickerInput(inputId = "cloud_category_picker_3", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_classroom", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_3")))),
          column(width = 6, card(card_header(tags$b("Data View 4")), card_body(pickerInput(inputId = "cloud_category_picker_4", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_shifting", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_4")))),
          column(width = 6, card(card_header(tags$b("Data View 5")), card_body(pickerInput(inputId = "cloud_category_picker_5", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_enrolment", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_5")))),
          column(width = 6, card(card_header(tags$b("Data View 6")), card_body(pickerInput(inputId = "cloud_category_picker_6", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_enrolment", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_6"))))
        )
      ) # End nav_panel
    ) # End CLOUD nav_menu
    
    # --- *** "Data Explorer" and "mySTRIDE" have been DELETED from this file *** ---
    
  ) # End page_navbar
}) # End renderUI