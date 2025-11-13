# stride2 UI - DYNAMIC VERSION
#nov12
output$STRIDE2 <- renderUI({
  
  # --- 1. CHECK USER ROLE ---
  # This code runs *before* the UI is built.
  # We use isolate() because this UI should only build ONCE.
  is_guest <- isTRUE(isolate(authenticated_user()) == "guest_user@stride")
  
  
  # --- 2. Define the Title/Brand UI Element ---
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
    
    tags$head(
      tags$style(HTML("
      .js-plotly-plot .plotly .modebar {
         top: -30px !important;
      }
    "))
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
    
    # --- HOME PANEL ---
    nav_panel(
      "Home",
      value = "home_tab",
      icon = bs_icon("house-door-fill"),
      tagList(
        useShinyjs(),
        tags$head(
          tags$style(HTML("
          /* ... (all your CSS from the home panel) ... */
          .stride-banner {
            position: relative; width: 100%; height: 300px;
            background: linear-gradient(135deg, #003366 40%, #FFB81C 100%);
            color: white; display: flex; flex-direction: column;
            align-items: center; justify-content: center; text-align: center;
            overflow: hidden; border-bottom: 6px solid #003366;
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
          }
          .stride-banner::before {
            content: ''; position: absolute; inset: 0;
            background-image: radial-gradient(rgba(255,255,255,0.15) 1px, transparent 1px);
            background-size: 30px 30px;
            animation: movePattern 8s linear infinite;
          }
          @keyframes movePattern {
            from { background-position: 0 0; }
            to { background-position: 60px 60px; }
          }
          .stride-banner-content {
            position: relative; z-index: 2; max-width: 900px; padding: 0 20px;
          }
          .stride-banner h1 {
            font-size: 2.2rem; font-weight: 800; letter-spacing: 1px;
            margin-top: -15px; margin-bottom: 10px; margin-left: -75px;
            text-shadow: 2px 2px 6px rgba(0, 0, 0, 0.3); white-space: nowrap;
          }
          .stride-banner p { font-weight: 400; opacity: 0.95; }
          .stride-logo {
            height: 243px; margin-top: -23px; margin-bottom: -46px;
            filter: 
              drop-shadow(1px 1px 0 rgba(255, 255, 255, 0.9))
              drop-shadow(-1px 1px 0 rgba(255, 255, 255, 0.9))
              drop-shadow(1px -1px 0 rgba(255, 255, 255, 0.9))
              drop-shadow(-1px -1px 0 rgba(255, 255, 255, 0.9));
            transition: filter 0.3s ease;
          }
          .home-carousel-container {
            position: relative; width: 100%; max-width: 1000px;
            margin: 60px auto; overflow: hidden; border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15); background: #fff;
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
            cursor: pointer; transition: background 0.3s ease; z-index: 10;
          }
          .carousel-nav:hover { background-color: rgba(0,0,0,0.7); }
          .prev-slide { left: 15px; }
          .next-slide { right: 15px; }
          .capabilities-section {
            max-width: 1000px;
            margin: 60px auto;
            text-align: center;
          }
          .capabilities-section h2 {
            font-weight: 700;
            color: #003366;
            margin-bottom: 40px;
          }
          .capabilities-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            gap: 20px;
          }
          .capability-card {
            flex: 1;
            min-width: 280px;
            padding: 25px;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
          }
          .capability-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
          }
          .capability-card-icon {
            font-size: 3.5rem;
            color: #FFB81C; /* Gold color */
            margin-bottom: 15px;
          }
          .capability-card h3 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #003366;
            margin-bottom: 10px;
          }
          .resources-section {
            max-width: 1000px;
            margin: 60px auto;
          }
          .resources-section h2 {
            text-align: center;
            font-weight: 700;
            color: #003366;
            margin-bottom: 40px;
          }
          .resource-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
          }
          .resource-card {
            flex: 1;
            display: flex;
            flex-direction: column; 
            min-width: 280px;
            max-width: 320px;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden; 
            transition: transform 0.3s ease, box-shadow 0.3s ease;
          }
          .resource-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
          }
          .resource-card-content {
            padding: 25px;
            flex-grow: 1;
          }
          .resource-card h4 {
            font-size: 1.3rem;
            font-weight: 600;
            color: #003366;
            margin-bottom: 10px;
          }
          .resource-card p {
            font-size: 0.95rem;
            margin-bottom: 20px;
            color: #555;
          }
          .resource-card-footer {
            padding: 0 25px 25px 25px;
          }
          .resource-btn {
            display: inline-block;
            width: 100%;
            padding: 10px 18px;
            font-size: 0.9rem;
            font-weight: 600;
            text-align: center;
            background-color: #003366;
            color: #fff !important;
            border-radius: 5px;
            border: none;
            text-decoration: none;
            transition: background-color 0.3s ease;
          }
          .resource-btn:hover {
            background-color: #FFB81C;
            color: #003366 !important;
          }
          @media (max-width: 768px) {
            .stride-banner { height: auto; padding: 30px 0; }
            .stride-banner h1 { font-size: 1.8rem; margin-left: 0; white-space: normal; }
            .stride-banner p { font-size: 1rem; }
            .home-slide img { height: 320px; }
            .slide-caption { font-size: 1rem; }
            .capabilities-row { flex-direction: column; }
            .resource-row { flex-direction: column; align-items: center; }
          }
        "))
        ),
        
        # --- STRIDE Banner Section (Unchanged) ---
        div(
          class = "stride-banner",
          div(
            class = "stride-banner-content",
            tags$img(src = "Stridelogo1.png", class = "stride-logo"),
            h1("Strategic Resource Inventory for Deployment Efficiency"),
            p("Empowering DepEd with data-driven insights to strengthen its education systems, 
              optimize resource allocation, and promote informed decision-making nationwide.")
          )
        ),
        
        # --- ORIGINAL CAROUSEL (RESTORED) ---
        div(
          class = "home-carousel-container",
          div(class = "home-slide active", tags$img(src = "5.png"), div(class = "slide-caption", "STRIDE promotes data-driven education initiatives.")),
          div(class = "home-slide", tags$img(src = "3.png"), div(class = "slide-caption", "Empowering institutions through strategic dashboards.")),
          div(class = "home-slide", tags$img(src = "2.png"), div(class = "slide-caption", "Building efficient deployment strategies for schools.")),
          tags$button(class = "carousel-nav prev-slide", HTML("&#10094;")),
          tags$button(class = "carousel-nav next-slide", HTML("&#10095;"))
        ),
        
        # --- CAPABILITIES SECTION (Static Containers) ---
        div(
          class = "capabilities-section",
          tags$h2("Discover STRIDE's Features"),
          div(
            class = "capabilities-row",
            
            # Capability 1: Drilldown
            div(
              class = "capability-card",
              div(class = "capability-card-icon", HTML("&#128269;")),
              tags$h3("Drilldown Function"),
              
              # --- UPDATED DRILLDOWN DESCRIPTION (with details): ---
              tags$p("Explore data by clicking to drill down through the full hierarchy:"),
              tags$ul(
                style = "text-align: left; padding-left: 20px; font-size: 0.9rem;", # Your style
                tags$li(tags$strong("Regional View:"), " See data aggregated by region."),
                tags$li(tags$strong("Division View:"), " Drill down to see SDO/Division data."),
                tags$li(tags$strong("Municipality View:"), " Filter data by city or municipality."),
                tags$li(tags$strong("Legislative District View:"), " Analyze data by legislative district."),
                tags$li(tags$strong("District View:"), " View metrics for specific school districts."),
                tags$li(tags$strong("School View:"), " Select an individual school for a detailed profile.")
              )
              # --- END UPDATE ---
            ),
            
            # Capability 2: Reactive Tables (No changes)
            div(
              class = "capability-card",
              div(class = "capability-card-icon", HTML("&#128187;")),
              tags$h3("Reactive Data Tables"),
              tags$p("The data tables in STRIDE are dynamic and respond instantly to your inputs."),
              tags$ul(
                style = "text-align: left; padding-left: 20px; font-size: 0.9rem;",
                tags$li(tags$strong("Sort:"), " Click any column header to sort the data."),
                tags$li(tags$strong("Filter:"), " Use the selection inputs to narrow down the data."),
                tags$li(tags$strong("Search:"), " Use the search box to find specific records instantly.")
              )
            ),
            
            # Capability 3: Maps
            div(
              class = "capability-card",
              div(class = "capability-card-icon", HTML("&#127758;")),
              tags$h3("Geospatial Mapping"),
              
              # --- UPDATED MAP DESCRIPTION (with markers): ---
              tags$p("Visualize your data in its geographic context to uncover spatial patterns."),
              tags$ul(
                style = "text-align: left; padding-left: 20px; font-size: 0.9rem;",
                tags$li(tags$strong("Interactive Leaflet Map:"), " Pan, zoom, and click on map features."),
                tags$li(tags$strong("Data-Driven Markers:"), " See locations plotted as interactive markers."),
                tags$li(tags$strong("School Locations:"), " Pinpoint individual schools and access their data.")
              )
              # --- END UPDATE ---
            )
          )
        ),
        # --- RESOURCES SECTION (Card Layout) ---
        div(
          class = "resources-section",
          tags$h2("Resources & Toolkits"),
          div(
            class = "resource-row",
            
            # Resource Card 1
            div(
              class = "resource-card",
              div(
                class = "resource-card-content",
                tags$h4("SGC Advocacy Materials"),
                tags$p("Tools and guides for promoting effective School Governance Council operations.")
              ),
              div(
                class = "resource-card-footer",
                tags$a(href = "#", class = "resource-btn", "Access Toolkit", target = "_blank")
              )
            ),
            
            # Resource Card 2
            div(
              class = "resource-card",
              div(
                class = "resource-card-content",
                tags$h4("SIIF Toolkit"),
                tags$p("Provides online forms and monitoring tools to help schools implement the School Innovation and Improvement Fund (SIIF) and track data-driven interventions.")
              ),
              div(
                class = "resource-card-footer",
                tags$a(href = "SIIF.pdf", class = "resource-btn", "Access Toolkit", target = "_blank")
              )
            ),
            
            # Resource Card 3
            div(
              class = "resource-card",
              div(
                class = "resource-card-content",
                tags$h4("Teacher Workload Toolkit"),
                tags$p("A practical reference for school heads to implement workload policies. Includes step-by-step guides, templates, FAQs, and a Teaching Load Simulator.")
              ),
              div(
                class = "resource-card-footer",
                tags$a(href = "TWP-TOOLKIT.pdf", class = "resource-btn", "Access Toolkit", target = "_blank")
              )
            )
          )
        ),
        
        # ---!!!--- IMPORTANT SCRIPT (FIXES CAROUSEL & MODALS) ---!!!---
        tags$script(HTML("
          // ... (Your Javascript from the file) ...
          try {
            let currentSlide = 0;
            const slides = document.querySelectorAll('.home-slide');
            const nextBtn = document.querySelector('.next-slide');
            const prevBtn = document.querySelector('.prev-slide');

            if (slides.length > 0 && nextBtn && prevBtn) {
            
              function showSlide(index) {
                slides.forEach((slide, i) => {
                  slide.classList.remove('active');
                  if (i === index) slide.classList.add('active');
                });
              }
              
              nextBtn.addEventListener('click', function() {
                currentSlide = (currentSlide + 1) % slides.length;
                showSlide(currentSlide);
              });
              
              prevBtn.addEventListener('click', function() {
                currentSlide = (currentSlide - 1 + slides.length) % slides.length;
                showSlide(currentSlide);
              });
              
              let slideInterval = setInterval(function() {
                 currentSlide = (currentSlide + 1) % slides.length;
                 showSlide(currentSlide);
              }, 5000); 
              
              const carousel = document.querySelector('.home-carousel-container');
              if (carousel) {
                carousel.addEventListener('mouseenter', () => clearInterval(slideInterval));
                carousel.addEventListener('mouseleave', () => {
                  slideInterval = setInterval(function() {
                     currentSlide = (currentSlide + 1) % slides.length;
                     showSlide(currentSlide);
                  }, 5000);
                });
              }
            }
          } catch (e) {
            console.error('Carousel script failed: ', e);
          }
          
          try {
            document.getElementById('showDrilldownModal').addEventListener('click', function() {
              Shiny.setInputValue('showDrilldownModal', Math.random());
            });
            
            document.getElementById('showTablesModal').addEventListener('click', function() {
              Shiny.setInputValue('showTablesModal', Math.random());
            });
            
            document.getElementById('showMapModal').addEventListener('click', function() {
              Shiny.setInputValue('showMapModal', Math.random());
            });
          } catch (e) {
             console.error('Modal click script failed: ', e);
          }
        "))
      ) # End tagList
    ), # End Home nav_panel
    
    # --- DASHBOARD MENU ---
    nav_menu(
      title = tagList(bs_icon("speedometer"), tags$b("Dashboard")),
      value = "dashboard_menu",
      # ... (Your entire "Dashboard" nav_menu and its 3 nav_panels go here) ...
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
              shinyWidgets::awesomeCheckbox(inputId = "preset_enrolment", label = tags$div(style = "display: flex; align-items: center;", tags$span("Enrolment Focus", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px;"), 
              shinyWidgets::awesomeCheckbox(inputId = "preset_buildingcondition", label = tags$div(style = "display: flex; align-items: center;", tags$span("Building Condition", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px;"), 
              shinyWidgets::awesomeCheckbox(inputId = "preset_roomcondition", label = tags$div(style = "display: flex; align-items: center;", tags$span("Classroom Condition", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE)
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
                `Classroom` = c("Classrooms" = "Instructional.Rooms.2023.2024", "Classroom Requirement" =  "Classroom.Requirement", "Classroom Shortage" = "Classroom.Shortage", "Shifting" = "Shifting", "Buildings" = "Buildings", "Buildable Space" = "With_Buildable_space", "Major Repairs Needed" = "Major.Repair.2023.2024"),
                `Facilities` = c("Seats Inventory" = "Total.Total.Seat", "Seats Shortage" = "Total.Seats.Shortage"),
                `Resources` = c("Ownership Type" = "OwnershipType", "Electricity Source" = "ElectricitySource", "Water Source" = "WaterSource")
              ),
              multiple = TRUE,
              options = pickerOptions(`actions-box` = TRUE, liveSearch = TRUE, header = "Select Data Columns", title = "No Data Column Selected", dropupAuto = FALSE, dropup = FALSE)
            ),
            pickerInput(
              inputId = "Combined_Conditions_Toggles_Build",
              label = strong("Select Condition Metrics"),
              choices = list(
                `Building Status` = c("Condemned (Building)" = "Building.Count_Condemned...For.Demolition", "For Condemnation (Building)" = "Building.Count_For.Condemnation", "For Completion (Building)" = "Building.Count_For.Completion", "On-going Construction (Building)" = "Building.Count_On.going.Construction", "Good Condition (Building)" = "Building.Count_Good.Condition", "For Major Repairs (Building)" = "Building.Count_Needs.Major.Repair", "For Minor Repairs (Building)" = "Building.Count_Needs.Minor.Repair"),
                `Classroom Status` = c("Condemned (Classroom)" = "Number.of.Rooms_Condemned...For.Demolition", "For Condemnation (Classroom)" = "Number.of.Rooms_For.Condemnation", "For Completion (Classroom)" = "Number.of.Rooms_For.Completion", "On-going Construction (Classroom)" = "Number.of.Rooms_On.going.Construction", "Good Condition (Classroom)" = "Number.of.Rooms_Good.Condition", "For Major Repairs (Classroom)" = "Number.of.Rooms_Needs.Major.Repair", "For Minor Repairs (Classroom)" = "Number.of.Rooms_Needs.Minor.Repair")
              ),
              multiple = TRUE,
              options = pickerOptions(`actions-box` = TRUE, liveSearch = TRUE, header = "Select Data Columns", title = "No Data Column Selected", dropupAuto = FALSE, dropup = FALSE)
            ),
            shinyWidgets::pickerInput(
              inputId = "Infra_Programs_Picker_Build",
              label = "Infrastructure Programs",
              choices = list(
                "ALS/CLC" = c("ALS/CLC (2024)" = "ALS.CLC_2024_Allocation"),
                "Electrification" = c("Electrification (2017)" = "ELECTRIFICATION.2017", "Electrification (2018)" = "ELECTRIFICATION.2018", "Electrification (2019)" = "ELECTRIFICATION.2019", "Electrification (2023)" = "ELECTRIFICATION.2023", "Electrification (2024)" = "ELECTRIFICATION.2024"),
                "Gabaldon" = c("Gabaldon (2020)" = "GABALDON.2020", "Gabaldon (2021)" = "GABALDON.2021", "Gabaldon (2022)" = "GABALDON.2022", "Gabaldon (2023)" = "GABALDON.2023", "Gabaldon (2024)" = "GABALDON.2024"),
                "LibHub" = c("LibHub (2024)" = "LibHub.2024"),
                "LMS" = c("LMS (2020)" = "LMS.2020", "LMS (2021)" = "LMS.2021", "LMS (2022)" = "LMS.2022", "LMS (2023)" = "LMS.2023", "LMS (2024)" = "LMS.2024"),
                "NC" = c("NC (2014)" = "NC.2014", "NC (2015)" = "NC.2015", "NC (2016)" = "NC.2016", "NC (2017)" = "NC.2017", "NC (2018)" = "NC.2018", "NC (2019)" = "NC.2019", "NC (2020)" = "NC.2020", "NC (2021)" = "NC.2021", "NC (2023)" = "NC.2023", "NC (2024)" = "NC.2024"),
                "QRF" = c("QRF (2019)" = "QRF.2019", "QRF (2020)" = "QRF.2020", "QRF (2021)" = "QRF.2021", "QRF (2022)" = "QRF.2022.REPLENISHMENT", "QRF (2023)" = "QRF.2023", "QRF (2024)" = "QRF.2024"),
                "Repair" = c("Repair (2020)" = "REPAIR.2020", "Repair (2021)" = "REPAIR.2021", "Repair (2022)" = "REPAIR.2022", "Repair (2023)" = "REPAIR.2023", "Repair (2024)" = "REPAIR.2024"),
                "School Health Facilities" = c("Health (2022)" = "SCHOOL.HEALTH.FACILITIES.2022", "Health (2024)" = "SCHOOL.HEALTH.FACILITIES.2024"),
                "SPED/ILRC" = c("SPED (2024)" = "SPED.ILRC.2024")
              ),
              multiple = TRUE, 
              options = shinyWidgets::pickerOptions(actionsBox = TRUE, deselectAllText = "Clear All", selectAllText = "Select All", liveSearch = TRUE, noneSelectedText = "Select Programs...")
            )
          ), # End sidebar
          bslib::navset_card_tab(
            full_screen = TRUE,
            bslib::nav_panel(
              title = "Interactive Dashboard",
              uiOutput("dashboard_grid")
            ),
            bslib::nav_panel(
              title = "School Locator",
              tagList(
                conditionalPanel(
                  condition = "output.current_drill_level == 'Region'",
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
                ),
                conditionalPanel(
                  condition = "output.current_drill_level != 'Region'",
                  tagList(
                    bslib::layout_columns(
                      col_widths = c(6, 6), 
                      bslib::card(
                        full_screen = TRUE,
                        bslib::card_header("Filtered Data (Click a row)"),
                        bslib::card_body(DT::dataTableOutput("school_table"))
                      ),
                      bslib::card(
                        full_screen = TRUE,
                        bslib::card_header("School Map (Click a school)"),
                        bslib::card_body(leaflet::leafletOutput("school_map", height = "500px"))
                      )
                    ), 
                    bslib::card(
                      full_screen = TRUE,
                      card_header(div(strong("School Details"),
                                      tags$span(em("(Select a school from the table or map above)"),
                                                style = "font-size: 0.7em; color: grey;"
                                      ))),
                      card_body(uiOutput("build_dashboard_school_details_ui"))
                    )
                  ) 
                ) 
              ) 
            )
          )
        )
      ),
      # --- *** END OF NEW LAYLUT *** ---
      # --- ADVANCED ANALYTICS PANEL (UPDATED) ---
      nav_panel(
        title = "Advanced Analytics",
        icon = icon("chart-line"),
        layout_sidebar(
          sidebar = sidebar(width = 350,
            title = "Advanced Filters",
            
            # 1. Container for dynamic filters
            # New filters will be added here by the server
            div(id = "adv_filter_container"),
            
            # 2. "Add Filter" Button
            actionButton("add_adv_filter_btn", "Add Variable Filter", 
                         icon = icon("plus"), class = "btn-default w-100 mb-3"),
            
            hr(),
            
            # 3. "Apply" Button
            actionButton("adv_analytics_run", "Apply Filters & Plot", 
                         icon = icon("play"), class = "btn-primary w-100")
          ),
          
          # --- Main Panel for Plot and Description ---
          # --- Main Panel for Plot and Description (UPDATED) ---
          fluidRow(
            column(12,
                   # This card will hold the plot
                   card(
                     card_header("Drilldown Plot"),
                     card_body(
                       # The Reset and Back buttons
                       uiOutput("adv_drill_controls_ui"),
                       
                       # The plot (with the click ID)
                       plotOutput("advanced_drilldown_plot", click = "adv_plot_click")
                     )
                   )
            )
          ),
          fluidRow(
            column(6,
                   # This card will hold the data table
                   card(
                     card_header("Filtered Data"),
                     card_body(
                       DT::dataTableOutput("advanced_data_table")
                     ),
                     # Set a fixed height for better alignment
                     style = "height: 700px;" 
                   )
            ),
            column(6,
                   # This card will hold the map
                   card(
                     card_header("School Map"),
                     card_body(
                       # The map
                       leafletOutput("advanced_school_map", height = "600px") 
                     ),
                     # Set a fixed height for better alignment
                     style = "height: 700px;" 
                   )
            )
          )
        ) # End layout_sidebar
      ), # End nav_panel("Advanced Analytics") 
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
          ),
          layout_columns(uiOutput("dynamic_positions_ui"))
        )
      ),
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
          ),
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
          )
        ) 
      )
    ), # End Dashboard nav_menu
    
    # --- QUICK SCHOOL SEARCH ---
    nav_panel(
      title = tags$b("Quick Search"),
      icon = bs_icon("search"),
      layout_sidebar(
        sidebar = sidebar(
          shinyWidgets::switchInput(inputId = "search_mode", label = "Advanced Search", value = FALSE, onLabel = "On", offLabel = "Off", size = "small"),
          conditionalPanel(
            condition = "input.search_mode == false",
            h5("Simple Search"),
            textInput("text_simple", "School Name:", placeholder = "Enter school name (or part of it)")
          ),
          conditionalPanel(
            condition = "input.search_mode == true",
            h5("Advanced Search"),
            textInput("text_advanced", "School Name (Optional):", placeholder = "Filter by name..."),
            hr(),
            h5("Advanced Filters"),
            pickerInput(inputId = "qss_region", label = "Filter by Region:", choices = sort(unique(uni$Region)), selected = NULL, multiple = TRUE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, title = "All Regions")),
            pickerInput(inputId = "qss_division", label = "Filter by Division:", choices = sort(unique(uni$Division)), selected = NULL, multiple = TRUE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, title = "All Divisions")),
            pickerInput(inputId = "qss_legdist", label = "Filter by Legislative District:", choices = sort(unique(uni$Legislative.District)), selected = NULL, multiple = TRUE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, title = "All Districts")),
            pickerInput(inputId = "qss_municipality", label = "Filter by Municipality:", choices = sort(unique(uni$Municipality)), selected = NULL, multiple = TRUE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, title = "All Municipalities"))
          ),
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
      ) # End layout_sidebar
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
      # ... (Your entire "CLOUD" nav_menu and its 3 nav_panels go here) ...
      nav_panel(
        title = "CLOUD (Regional Profile)",
        layout_columns(
          card(height = 300, card_header(tags$b("Region Filter")), card_body(pickerInput(inputId = "cloud_region_profile_filter", label = NULL, choices = c("Region II" = "Region II", "MIMAROPA" = "MIMAROPA", "Region XII" = "Region XII", "CAR" = "CAR"), selected = "Region II", multiple = FALSE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, header = "Select Regions", title = "No Region Selected", selectedTextFormat = "count > 3", dropupAuto = FALSE, dropup = FALSE), choicesOpt = list()))),
          uiOutput("cloud_profile_main_content_area")
        )
      ),
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
      ),
      nav_panel(
        title = tagList("CLOUD", em("(Multi-variable)")),
        fluidRow(
          column(width = 6, card(card_header(tags$b("Data View 1")), card_body(pickerInput(inputId = "cloud_category_picker_1", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_enrolment", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_1")))),
          column(width = 6, card(card_header(tags$b("Data View 2")), card_body(pickerInput(inputId = "cloud_category_picker_2", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_teacherinventory", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_2")))),
          column(width = 6, card(card_header(tags$b("Data View 3")), card_body(pickerInput(inputId = "cloud_category_picker_3", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_classroom", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_3")))),
          column(width = 6, card(card_header(tags$b("Data View 4")), card_body(pickerInput(inputId = "cloud_category_picker_4", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_shifting", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_4")))),
          column(width = 6, card(card_header(tags$b("Data View 5")), card_body(pickerInput(inputId = "cloud_category_picker_5", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "Bullying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_enrolment", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_5")))),
          column(width = 6, card(card_header(tags$b("Data View 6")), card_body(pickerInput(inputId = "cloud_category_picker_6", label = NULL, choices = c("Enrolment Data" = "cloud_enrolment", "SNED Learners" = "cloud_sned", "IP Learners" = "cloud_ip", "Muslim Learners" = "cloud_muslim", "Displaced Learners" = "cloud_displaced", "ALS Learners" = "cloud_als", "Dropout Data" = "cloud_dropout", "Teacher Inventory" = "cloud_teacherinventory", "Years in Service" = "cloud_years", "Classroom Inventory" = "cloud_classroom", "Multigrade" = "cloud_multigrade", "Organized Class" = "cloud_organizedclass", "JHS Teacher Deployment" = "cloud_jhsdeployment", "Shifting" = "cloud_shifting", "Learning Delivery Modality" = "cloud_LDM", "ARAL" = "cloud_ARAL", "CRLA" = "cloud_crla", "PhilIRI" = "cloud_philiri", "Alternative Delivery Modality" = "cloud_adm", "Reading Proficiency" = "cloud_rf", "Electricity Source" = "cloud_elec", "Water Source" = "cloud_water", "Internet Source" = "cloud_internet", "Internet Usage" = "cloud_internet_usage", "BulGlying Incidence" = "cloud_bully", "Overload Pay" = "cloud_overload", "School Resources" = "cloud_resources", "NAT" = "cloud_nat", "NAT Sufficiency" = "cloud_nat_sufficiency", "LAC" = "cloud_lac", "Feeding Program" = "cloud_feeding", "SHA" = "cloud_sha"), selected = "cloud_enrolment", multiple = FALSE, options = pickerOptions(liveSearch = TRUE, title = "Select Category")), uiOutput("cloud_graph_6"))))
        )
      )
    ) # End CLOUD nav_menu
  )
  
  
  # --- 4. Define the nav items only for AUTHENTICATED (non-guest) users ---
  nav_list_auth_only <- list(
    
    # --- DATA EXPLORER MENU ---
    nav_menu(
      value = "data_explorer_nav", # This value is correct
      title = tags$b("Data Explorer"),
      icon = bs_icon("table"),
      
      nav_panel(
        title = tags$b("Human Resource Database"),
        layout_sidebar(
          sidebar = sidebar(
            width = 350,
            h6("Data Toggles:"),
            pickerInput(inputId = "DataBuilder_HROD_Region", label = "Select a Region:", choices = sort(unique(uni$Region)), selected = sort(unique(uni$Region)), multiple = FALSE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, header = "Select Categories", title = "No Category Selected", selectedTextFormat = "count > 3", dropupAuto = FALSE, dropup = FALSE)),
            uiOutput("DataBuilder_HROD_SDO"),
            pickerInput("School_Data_Toggles", strong("School Information Data Toggles"), choices = c("School Size Typology" = "School.Size.Typology", "Curricular Offering" = "Modified.COC"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE)),
            pickerInput("Teaching_Data_Toggles", strong("Teaching Data Toggles"), choices = c("Total Teachers" = "TotalTeachers", "Teacher Excess" = "Total.Excess", "Teacher Shortage" = "Total.Shortage"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE)),
            pickerInput("NTP_Data_Toggles", strong("Non-teaching Data Toggles"), choices = c("COS" = "Outlier.Status", "AOII Clustering Status" = "Clustering.Status"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE)),
            pickerInput("Enrolment_Data_Toggles", strong("Enrolment Data Toggles"), choices = c("Total Enrolment" = "TotalEnrolment", "Kinder" = "Kinder", "Grade 1" = "G1", "Grade 2" = "G2", "Grade 3" = "G3", "Grade 4" = "G4", "Grade 5" = "G5", "Grade 6" = "G6", "Grade 7" = "G7", "Grade 8" = "G8", "Grade 9" = "G9", "Grade 10" = "G10", "Grade 11" = "G11", "Grade 12" = "G12"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE)),
            pickerInput("Specialization_Data_Toggles", strong("Specialization Data Toggles"), choices = c("English" = "English", "Mathematics" = "Mathematics", "Science" = "Science", "Biological Sciences" = "Biological.Sciences", "Physical Sciences" = "Physical.Sciences"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE))
          ), # End sidebar
          layout_columns(
            card(card_header(strong("HROD Data Panel")), dataTableOutput("HROD_Table")),
            col_widths = c(12, 12)
          )
        ) # End layout_sidebar
      ), # End nav_panel
      
      nav_panel(
        title = tags$b("DepEd Officials"),
        layout_sidebar(
          sidebar = sidebar(
            width = 350,
            h6("Strand Filter:"),
            pickerInput(inputId = "ThirdLevel_Strands", label = "Select Strand(s):", width = "100%", choices = c("Administration", "Deped Attached Agencies", "Finance", "Human Resource And Organizational Development", "Learning System", "Legal And Legislative Affairs", "Office Of The Secretary", "Operations", "Procurement", "Strategic Management", "Teachers And Education Council Secretariat"), selected = c("Administration", "Deped Attached Agencies", "Finance", "Human Resource And Organizational Development", "Learning System", "Legal And Legislative Affairs", "Office Of The Secretary", "Operations", "Procurement", "Strategic Management", "Teachers And Education Council Secretariat"), multiple = TRUE, options = pickerOptions(container = "body", width = "350px", actionsBox = TRUE, liveSearch = TRUE, header = "Select Strand(s)", title = "No Strand Selected", selectedTextFormat = "count > 3", dropupAuto = FALSE, dropup = FALSE), choicesOpt = list(style = "white-space: normal; word-break: break-word; overflow-wrap: break-word;"))
          ), # End sidebar
          layout_columns(
            card(
              full_screen = TRUE,
              style = "width: 100%; max-height: 85vh; overflow-y: auto; margin-bottom: 20px;",
              card_header(strong("HROD Data Panel"), style = "font-size: 22px; padding: 15px 20px; text-align: center; background-color: #00234d; border-bottom: 2px solid #dee2e6;"),
              card_body(div(style = "padding: 10px; overflow-x: auto; height: calc(85vh - 80px);", dataTableOutput("ThirdLevel_Table")))
            ),
            col_widths = c(12)
          )
        ) # End layout_sidebar
      ) # End nav_panel
    ), # End Data Explorer nav_menu
    
    # --- mySTRIDE PANEL ---
    nav_panel(
      value = "mystride_nav", # This value is correct
      title = tags$b("mySTRIDE"),
      icon = bs_icon("box-arrow-right"),
      
      h3("mySTRIDE Access"),
      fluidRow(
        column(
          width = 6, 
          offset = 3, 
          class = "mt-5 mb-5",
          style = "text-align: center;", 
          bslib::card( 
            tags$h5("Access mySTRIDE here"),
            div(
              style = "text-align:center; margin-top: 20px;", 
              actionButton(
                inputId = "goto_dashboard_btn", 
                label = "mySTRIDE",
                class = "go-dashboard-btn" 
              )
            )
          ) # End bslib::card
        ) # End column
      ) # End fluidRow
    ) # End mySTRIDE nav_panel
  ) # End auth-only list
  
  
  # --- 5. Combine the lists based on user role ---
  
  final_nav_list <- nav_list_base # Start with the base list
  
  if (!is_guest) {
    # If NOT a guest, add the auth-only items
    final_nav_list <- c(final_nav_list, nav_list_auth_only)
  }
  
  # --- 6. Build the page_navbar dynamically ---
  # We pass the final list of nav items to do.call
  do.call(
    page_navbar, 
    c(
      list(
        id = "STRIDE2_navbar",
        title = navbar_title_ui,
        theme = bs_theme(
          version = 5,
          bootswatch = "sandstone",
          font_scale = 0.9,
          base_font = font_google("Poppins")
        )
      ),
      final_nav_list # Add the list of nav panels/menus
    )
  )
  
}) # End renderUI