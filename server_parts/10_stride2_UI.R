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
    ),
    tags$head(
      # --- INJECT JAVASCRIPT FOR DRAWER (NEW) ---
      tags$script(HTML("
        function toggleHelpDrawer() {
          var drawer = document.getElementById('strideHelpDrawer');
          var overlay = document.getElementById('strideHelpOverlay');
          if (drawer.classList.contains('open')) {
            drawer.classList.remove('open');
            overlay.style.display = 'none';
          } else {
            drawer.classList.add('open');
            overlay.style.display = 'block';
          }
        }
        function switchTab(tabId) {
          document.querySelectorAll('.drawer-tab-pane').forEach(el => el.style.display = 'none');
          document.querySelectorAll('.drawer-tab-btn').forEach(el => el.classList.remove('active'));
          document.getElementById(tabId).style.display = 'block';
          event.target.classList.add('active');
        }
      ")),
      
      tags$style(HTML("
     /* --- YOUR EXISTING NAVBAR CSS --- */
      .navbar {
        position: fixed; 
        top: 0;          
        width: 100%;     
        z-index: 1030;   
        background: white;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }
      
      body {
        padding-top: 100px; 
        background-color: #f4f6f9;
      }

     /* --- FINAL SIDEBAR FIX --- */
      .sticky-sidebar {
        position: -webkit-sticky !important;
        position: sticky !important;
        top: 0px !important; 
        align-self: flex-start !important;
        height: calc(100vh - 120px) !important;
        max-height: calc(100vh - 120px) !important;
        overflow-y: auto !important;
        z-index: 1001 !important;
      }
      
      /* --- DEPED THEMED DRAWER CSS (NEW) --- */
      .help-drawer-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 51, 102, 0.3); /* Slight Blue Tint Overlay */
        backdrop-filter: blur(2px);
        z-index: 1040; display: none;
      }
      
      .help-drawer {
        position: fixed; top: 0; right: -600px; /* Wider drawer for manual */
        width: 550px; height: 100vh;
        background: white; 
        box-shadow: -5px 0 25px rgba(0,0,0,0.2);
        border-top: 8px solid #CE1126; /* DepEd RED Top Border */
        z-index: 1050; transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        overflow-y: auto; display: flex; flex-direction: column;
      }
      
      .help-drawer.open { right: 0; }
      
      /* Header Styling */
      .drawer-header { 
        padding: 20px 25px; 
        background: #003366; /* DepEd Blue */
        color: white;
        display: flex; justify-content: space-between; align-items: center;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      }
      
      .btn-close-white {
        filter: invert(1) grayscale(100%) brightness(200%);
        opacity: 0.8;
      }
      .btn-close-white:hover { opacity: 1; }
      
      /* Tab Styling */
      .drawer-tabs {
        padding: 0; background: #fff; border-bottom: 1px solid #eee;
        display: flex; justify-content: space-around;
      }
      
      .drawer-tab-btn { 
        border: none; background: none; padding: 15px 20px; 
        font-weight: 600; color: #6c757d; 
        border-bottom: 4px solid transparent;
        flex-grow: 1; transition: all 0.2s ease;
        font-size: 0.95rem;
      }
      
      .drawer-tab-btn:hover { color: #003366; background: #f8f9fa; }
      
      .drawer-tab-btn.active { 
        color: #CE1126; /* DepEd RED Active Text */
        border-bottom: 4px solid #CE1126; /* DepEd RED Active Line */
        background-color: rgba(206, 17, 38, 0.03);
      }
      
      /* Content Area */
      .drawer-content { padding: 25px; flex-grow: 1; font-size: 0.95rem; background-color: #fcfcfc; }
      
      /* Introduction Box */
      .drawer-intro {
        background-color: #fff; border-left: 5px solid #FFB81C; /* Gold Accent */
        padding: 15px; margin-bottom: 20px; border-radius: 4px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
      }
      
      /* Accordion Styling (DepEd Theme) */
      .accordion-item { border: 1px solid #e0e0e0; margin-bottom: 8px; border-radius: 6px !important; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
      
      .accordion-button { 
        font-weight: 600; color: #003366; background-color: #ffffff; 
        padding: 15px 20px; transition: all 0.2s;
      }
      
      .accordion-button:hover { background-color: #f0f4f8; }
      
      .accordion-button:not(.collapsed) { 
        color: #ffffff; 
        background-color: #003366; /* Active Header becomes Blue */
        box-shadow: inset 0 -1px 0 rgba(0,0,0,.125); 
      }
      
      .accordion-button:not(.collapsed)::after {
        filter: brightness(0) invert(1); /* Make arrow white */
      }
      
      .accordion-body { 
        font-size: 0.9rem; line-height: 1.6; color: #333; 
        padding: 20px; background: #fff;
      }
      
      /* Manual Content Styles */
      .manual-section-title { 
        color: #003366; font-weight: 700; 
        margin-top: 20px; margin-bottom: 8px; 
        font-size: 1rem; border-left: 4px solid #FFB81C; 
        padding-left: 10px; 
      }
      .manual-ul { padding-left: 20px; margin-bottom: 15px; }
      .manual-li { margin-bottom: 8px; }
      .manual-img { 
        width: 100%; border: 1px solid #ddd; border-radius: 8px; 
        margin: 15px 0; box-shadow: 0 4px 8px rgba(0,0,0,0.05); 
      }
      
      /* FAQ & Glossary Cards */
      .faq-item, .glossary-item { 
        background: white; padding: 15px; 
        border-radius: 8px; border: 1px solid #eee; 
        margin-bottom: 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.03);
        transition: transform 0.2s;
      }
      .faq-item:hover, .glossary-item:hover {
        transform: translateX(5px); border-left: 3px solid #CE1126; /* Red Hover */
      }
      
      .glossary-term { font-weight: 700; color: #003366; display: block; font-size: 1rem; margin-bottom: 5px;}
      .faq-q { font-weight: 700; color: #003366; display: block; margin-bottom: 8px; }
      .faq-a { color: #444; margin-bottom: 0; font-size: 0.9rem; }
      
      /* Responsive fix for mobile */
      @media (max-width: 600px) {
        .help-drawer { width: 100%; right: -100%; }
      }
      
      .navbar-nav { align-items: center; } /* Fix for vertical divider */

      /* --- OTHER CSS --- */
      .js-plotly-plot .plotly .modebar {
         top: -30px !important;
      }
    "))
    ),
  ) # End navbar_title_ui
  
  
  # --- 3. Define the list of nav items ALL users can see ---
  nav_list_base <- list(
    nav_spacer(),
    
    # --- QUICK START BUTTON (Styled) ---
    nav_item(
      tags$a(
        href = "javascript:void(0);",
        onclick = "toggleHelpDrawer()", 
        class = "nav-link",
        style = "cursor: pointer; font-weight: 600; color: #003366; display: flex; align-items: center; transition: color 0.2s;",
        onmouseover = "this.style.color='#CE1126'", # Red on hover
        onmouseout = "this.style.color='#003366'",
        bs_icon("journal-bookmark"), tags$span("Quick Start", style="margin-left: 5px;")
      )
    ),
    
    # --- VERTICAL DIVIDER LINE ---
    nav_item(
      tags$div(style = "border-left: 2px solid #e0e0e0; height: 25px; margin: 0 15px; align-self: center;")
    ),
    
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
            isolation: isolate;
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
          
          .resource-card-image {
          width: 100%;
          height: 180px; /* You can adjust this height */
          object-fit: cover;
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
        
        # --- CAPABILITIES SECTION (with clickable IDs) ---
        div(
          class = "capabilities-section",
          tags$h2("Discover STRIDE's Capabilities"),
          div(
            class = "capabilities-row",
            div(class = "capability-card", div(class = "capability-card-icon", HTML("&#128269;")), tags$h3("Drilldown Function"), tags$p("Start with a high-level overview and seamlessly drill down into detailed data for regions, divisions, and individual schools.")),
            div(class = "capability-card", div(class = "capability-card-icon", HTML("&#128187;")), tags$h3("Reactive Data Tables"), tags$p("Interact with your data. Our tables are fully searchable, sortable, and filterable, updating in real-time as you make selections.")),
            div(class = "capability-card", div(class = "capability-card-icon", HTML("&#127758;")), tags$h3("Geospatial Mapping"), tags$p("Visualize resource distribution and key metrics on an interactive map. Understand your data in its geographic context."))
          )
        ),
        
        # --- RESOURCES SECTION (Card Layout) ---
        div(
          class = "resources-section",
          tags$h2("Resources & Toolkits"),
          div(
            class = "resource-row",
            div(class = "resource-card",
                tags$img(class = "resource-card-image", src = "ecp.png"), 
                div(class = "resource-card-content", 
                    tags$h4("ECP System Toolkit"), 
                    tags$p("An implementation guide for teachers on The expanded career progression system.")
                ), 
                div(class = "resource-card-footer", 
                    tags$a(href = "https://drive.google.com/file/d/1D2_0UAMqOMNoD25Z_ga6R_gTPrmqxI4f/view?usp=drive_link", class = "resource-btn", "Learn More", target = "_blank")
                )
            ),
            div(class = "resource-card",
                tags$img(class = "resource-card-image", src = "siif.png"), 
                div(class = "resource-card-content", 
                    tags$h4("SIIF Toolkit"), 
                    tags$p("A comprehensive toolkit for the School-Based Integrated Intervention Framework.")
                ), 
                div(class = "resource-card-footer", 
                    tags$a(href = "https://drive.google.com/file/d/12ogJNwkXO6cxWJFftQ7CcXCly21C5PR2/view?usp=drive_link", class = "resource-btn", "Learn More", target = "_blank")
                )
            ),
            div(class = "resource-card",
                tags$img(class = "resource-card-image", src = "teacher.png"), 
                div(class = "resource-card-content", 
                    tags$h4("Teacher Workload Toolkit"), 
                    tags$p("Resources to help schools analyze and manage teacher workload effectively.")
                ), 
                div(class = "resource-card-footer", 
                    tags$a(href = "https://drive.google.com/file/d/1Z1PqaNG67MfXL1dG14sOMI4EFWj-2nes/view?usp=drive_link", class = "resource-btn", "Learn More", target = "_blank")
                )
            )
          )
        ),
        
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
            class = "sticky-sidebar",
            width = 350,
            title = "Dashboard Controls",
            uiOutput("back_button_ui"),
            hr(), 
            h4(strong("Dashboard Presets")),
            tags$div(
              style = "margin-left: -10px; text-align: left; padding-left: 15px;",
              shinyWidgets::awesomeCheckbox(inputId = "preset_teacher", label = tags$div(style = "display: flex; align-items: center;", tags$span("Teacher Focus", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px;text-align: left;"),
              shinyWidgets::awesomeCheckbox(inputId = "preset_school", label = tags$div(style = "display: flex; align-items: center;", tags$span("School Focus", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px; text-align: left;"),
              shinyWidgets::awesomeCheckbox(inputId = "preset_classroom", label = tags$div(style = "display: flex; align-items: center;", tags$span("Infrastructure Focus", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px; text-align: left;"),
              shinyWidgets::awesomeCheckbox(inputId = "preset_enrolment", label = tags$div(style = "display: flex; align-items: center;", tags$span("Enrolment Focus", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px; text-align: left;"), 
              shinyWidgets::awesomeCheckbox(inputId = "preset_buildingcondition", label = tags$div(style = "display: flex; align-items: center;", tags$span("Building Condition", style = "margin-left: 10px; font-size: 1.1rem;")), value = FALSE),
              tags$div(style = "margin-top: 5px; text-align: left;"), 
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
                `Classroom` = c("Classrooms" = "Instructional.Rooms.2023.2024", "Classroom Requirement" =  "Classroom.Requirement", "Last Mile School" = "LMS.School", "Classroom Shortage" = "Classroom.Shortage", "Shifting" = "Shifting", "Buildings" = "Buildings", "Buildable Space" = "Buildable_Space", "Major Repairs Needed" = "Major.Repair.2023.2024"),
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
          sidebar = sidebar(class = "sticky-sidebar",width = 350,
                            title = "Advanced Filters",
                            div(id = "adv_filter_container"),
                            actionButton("add_adv_filter_btn", "Add Variable Filter", 
                                         icon = icon("plus"), class = "btn-default w-100 mb-3"),
                            hr(),
                            actionButton("adv_analytics_run", "Apply Filters & Plot", 
                                         icon = icon("play"), class = "btn-primary w-100")
          ),
          fluidRow(
            column(12,
                   card(
                     card_header("Drilldown Plot"),
                     card_body(
                       uiOutput("adv_drill_controls_ui"),
                       plotOutput("advanced_drilldown_plot", click = "adv_plot_click")
                     )
                   )
            )
          ),
          fluidRow(
            column(6,
                   card(
                     card_header("Filtered Data"),
                     card_body(
                       DT::dataTableOutput("advanced_data_table")
                     ),
                     style = "height: 700px;" 
                   )
            ),
            column(6,
                   card(
                     card_header("School Map"),
                     card_body(
                       leafletOutput("advanced_school_map", height = "600px") 
                     ),
                     style = "height: 700px;" 
                   )
            )
          )
        ) 
      ), 
      nav_panel(
        "Plantilla Positions",
        layout_sidebar(
          sidebar = sidebar(
            class = "sticky-sidebar bg-secondary text-white",
            width = 300,
            tags$div(class = "preset-filters", style = "text-align: left; padding-left: 20px;", tags$h5("Position Presets"), awesomeCheckboxGroup(inputId = "plantilla_presets", label = "Click to filter positions:", choices = c("Teacher", "Master Teacher", "School Principal", "Head Teacher", "Guidance Coordinator", "Guidance Counselor", "Engineer", "Administrative Officer", "Administrative Assistant"), inline = FALSE, status = "primary")),
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
            class = "sticky-sidebar",
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
    # --- QUICK SCHOOL SEARCH (UPDATED UI) ---
    nav_panel(
      title = tags$b("Quick Search"),
      icon = bs_icon("search"),
      layout_sidebar(
        sidebar = sidebar(
          class = "sticky-sidebar",
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
            pickerInput(inputId = "qss_region", label = "Filter by Region:", choices = sort(unique(uni$Region)), selected = NULL, multiple = FALSE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, title = "All Regions")),
            pickerInput(inputId = "qss_division", label = "Filter by Division:", choices = sort(unique(uni$Division)), selected = NULL, multiple = FALSE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, title = "All Divisions")),
            pickerInput(inputId = "qss_legdist", label = "Filter by Legislative District:", choices = sort(unique(uni$Legislative.District)), selected = NULL, multiple = FALSE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, title = "All Districts")),
            pickerInput(inputId = "qss_municipality", label = "Filter by Municipality:", choices = sort(unique(uni$Municipality)), selected = NULL, multiple = FALSE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, title = "All Municipalities"))
          ),
          input_task_button("TextRun", icon_busy = fontawesome::fa_i("refresh", class = "fa-spin", "aria-hidden" = "true"), strong("Show Selection"), class = "btn-warning")
        ), 
        
        layout_columns(
          # Column 1: Search Results Table
          card(card_header(strong("Search Output")), dataTableOutput("TextTable")),
          
          # Column 2: Map
          card(full_screen = TRUE, card_header(strong("School Mapping")), leafletOutput("TextMapping", height = 500, width = "100%")),
          
          # Column 3: Detailed Breakdown (Full Width)
          card(
            full_screen = TRUE,
            card_header(div(strong("School Details"), tags$span(em("(Select a school from the table above)"), style = "font-size: 0.7em; color: grey;"))),
            
            tagList(
              # Row 1: Basic Info
              card(card_header(strong("Basic Information")), tableOutput("schooldetails")),
              
              # Row 2: Enrolment & Teachers
              layout_columns(
                col_widths = c(4, 4, 4),
                card(card_header(strong("Enrolment Profile")), tableOutput("qs_enrolment")),
                card(card_header(strong("Teacher Inventory")), tableOutput("qs_teachers")),
                card(card_header(strong("Teacher Needs")), tableOutput("qs_teacher_needs"))
              ),
              
              # Row 3: Infrastructure
              layout_columns(
                col_widths = c(4, 4, 4),
                card(card_header(strong("Classroom Inventory")), tableOutput("qs_classrooms")),
                card(card_header(strong("Classroom Needs")), tableOutput("qs_classroom_needs")),
                card(card_header(strong("Utilities & Facilities")), tableOutput("qs_utilities"))
              ),
              
              # Row 4: Others
              layout_columns(
                col_widths = c(6, 6),
                card(card_header(strong("Non-Teaching Personnel")), tableOutput("qs_ntp")),
                card(card_header(strong("Specialization Data")), tableOutput("qs_specialization"))
              )
            )
          ),
          col_widths = c(6, 6, 12)
        ) 
      ) # End layout_sidebar
    ), # End Quick Search nav_panel # End Quick Search nav_panel
    
    # --- RESOURCE MAPPING ---
    nav_panel(
      title = tags$b("Resource Mapping"),
      icon = bs_icon("map"),
      layout_sidebar(
        sidebar = sidebar(
          class = "sticky-sidebar",
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
            
            # --- ADDED THIS WRAPPER ---
            div(
              style = "text-align: left; padding-left: 15px;", 
              
              radioButtons(
                inputId = "resource_type_selection",
                label = NULL,
                choices = c("Teaching Deployment", "Non-teaching Deployment", "Classroom Inventory", "Learner Congestion", "Industries", "Facilities", "Last Mile School"),
                selected = "Teaching Deployment"
              )
            ) # --- END OF WRAPPER ---
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
            class = "sticky-sidebar",
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
        title = tags$b("Information Database"),
        layout_sidebar(
          sidebar = sidebar(
            class = "sticky-sidebar",
            width = 350,
            h6("Data Toggles:"),
            pickerInput(inputId = "DataBuilder_HROD_Region", label = "Select a Region:", choices = sort(unique(uni$Region)), selected = sort(unique(uni$Region)), multiple = FALSE, options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE, header = "Select Categories", title = "No Category Selected", selectedTextFormat = "count > 3", dropupAuto = FALSE, dropup = FALSE)),
            uiOutput("DataBuilder_HROD_SDO"),
            pickerInput("School_Data_Toggles", strong("School Information Data Toggles"), choices = c("School Size Typology" = "School.Size.Typology", "Curricular Offering" = "Modified.COC"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE)),
            pickerInput("Teaching_Data_Toggles", strong("Teaching Data Toggles"), choices = c("Total Teachers" = "TotalTeachers", "Teacher Excess" = "Total.Excess", "Teacher Shortage" = "Total.Shortage"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE)),
            pickerInput("NTP_Data_Toggles", strong("Non-teaching Data Toggles"), choices = c("COS" = "Outlier.Status", "AOII Clustering Status" = "Clustering.Status"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE)),
            pickerInput("Enrolment_Data_Toggles", strong("Enrolment Data Toggles"), choices = c("Total Enrolment" = "TotalEnrolment", "Kinder" = "Kinder", "Grade 1" = "G1", "Grade 2" = "G2", "Grade 3" = "G3", "Grade 4" = "G4", "Grade 5" = "G5", "Grade 6" = "G6", "Grade 7" = "G7", "Grade 8" = "G8", "Grade 9" = "G9", "Grade 10" = "G10", "Grade 11" = "G11", "Grade 12" = "G12"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE)),
            pickerInput("Specialization_Data_Toggles", strong("Specialization Data Toggles"), choices = c("English" = "English", "Mathematics" = "Mathematics", "Science" = "Science", "Biological Sciences" = "Biological.Sciences", "Physical Sciences" = "Physical.Sciences"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE)),
            pickerInput("Infrastructure_Data_Toggles", strong("Infrastructure Data Toggles"), choices = c("Classroom Shortage" = "Classroom.Shortage", "Buildable Space" = "With_Buildable_space", "Last Mile Schools" = "LMS.School"), multiple = TRUE, options = pickerOptions(`actions-box` = TRUE, dropupAuto = FALSE, dropup = FALSE))
          ), # End sidebar
          layout_columns(
            card(card_header(strong("HROD Data Panel")), dataTableOutput("HROD_Table")),
            col_widths = c(12, 12)
          )
        ) # End layout_sidebar
      ) # End nav_panel
    ), # End Data Explorer nav_menu
    
    # --- mySTRIDE PANEL ---
    nav_panel(
      value = "mystride_nav", # This value is correct
      title = tags$b("InsightEd"),
      icon = bs_icon("box-arrow-right"),
      
      h3("InsightEd Access"),
      fluidRow(
        column(
          width = 6, 
          offset = 3, 
          class = "mt-5 mb-5",
          
          bslib::card( 
            card_body(
              style = "display: flex; flex-direction: column; align-items: center; justify-content: center;",
              
              tags$img(src = "InsightEd.png", 
                       alt = "InsightEd Logo",
                       style = "width: 285px; height: auto; margin-bottom: 20px;"),
              
              hr(),
              tags$img(src = "InsightEdQR.png",
                       alt = "InsightEd QR Code",
                       style = "width: 250px; height: auto; margin-top: 15px; border: 1px solid #ddd; padding: 5px; border-radius: 8px;"),
              
              tags$p("Scan the code then Add to Home Screen to install!",
                     style = "margin-top: 15px; font-style: italic; color: #555;")
            )
          ) # End bslib::card
        ) # End column
      ) # End fluidRow
    )
  )
  
  
  # --- 5. Combine the lists based on user role ---
  
  final_nav_list <- nav_list_base # Start with the base list
  
  if (!is_guest) {
    # If NOT a guest, add the auth-only items
    final_nav_list <- c(final_nav_list, nav_list_auth_only)
  }
  
  # --- 6. Build the page_navbar dynamically ---
  # We pass the final list of nav items to do.call
  navbar_ui <- do.call(
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
  
  # --- 7. Return Navbar wrapped with Drawer HTML ---
  tagList(
    navbar_ui,
    
    # --- DRAWER OVERLAY ---
    tags$div(
      id = "strideHelpOverlay", 
      class = "help-drawer-overlay", 
      onclick = "toggleHelpDrawer()" # Click outside to close
    ),
    
    # --- DRAWER CONTAINER ---
    tags$div(
      id = "strideHelpDrawer",
      class = "help-drawer",
      
      # HEADER (DepEd Blue + Gold)
      tags$div(class = "drawer-header", 
               tags$h4("STRIDE User Guide", style = "margin: 0; font-weight: 700;"), 
               tags$button(class = "btn-close btn-close-white", onclick = "toggleHelpDrawer()")
      ),
      
      # TABS (DepEd Styled)
      tags$div(class = "drawer-tabs",
               tags$button(class = "drawer-tab-btn active", onclick = "switchTab('tab-guide')", "Manual"),
               tags$button(class = "drawer-tab-btn", onclick = "switchTab('tab-glossary')", "Glossary"),
               tags$button(class = "drawer-tab-btn", onclick = "switchTab('tab-faq')", "FAQs")
      ),
      
      # CONTENT AREA
      tags$div(class = "drawer-content",
               
               # --- MANUAL TAB (Detailed + Introduction) ---
               tags$div(id = "tab-guide", class = "drawer-tab-pane", style = "display: block;",
                        
                        # 1. INTRODUCTION (Restored as requested)
                        tags$div(class = "drawer-intro",
                                 tags$h5("1. Introduction", style="color:#003366; margin-top:0; font-weight:bold;"),
                                 tags$p("Welcome to STRIDE!"),
                                 tags$p("STRIDE is your central hub for viewing and analyzing comprehensive data, including school information, human resources, infrastructure, and much more."),
                                 tags$p("This manual is designed to guide you through every feature, from creating your account to exploring complex data dashboards.")
                        ),
                        
                        tags$div(class = "accordion", id = "manualAccordion",
                                 
                                 # 2. GETTING STARTED
                                 tags$div(class = "accordion-item", tags$h2(class = "accordion-header", id = "h2", tags$button(class = "accordion-button", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#c2", "2. Getting Started: Accessing STRIDE")),
                                          tags$div(id = "c2", class = "accordion-collapse collapse show", `data-bs-parent` = "#manualAccordion", tags$div(class = "accordion-body",
                                                                                                                                                          tags$div(class = "manual-section-title", "2.1. Creating a New Account"),
                                                                                                                                                          tags$ul(class="manual-ul",
                                                                                                                                                                  tags$li(class="manual-li", "From the login page, click the 'Create an Account' text."),
                                                                                                                                                                  tags$li(class="manual-li", "Fill out all the necessary information as requested (Station, DepEd Email, and Password)."),
                                                                                                                                                                  tags$li(class="manual-li", "Click the 'Register' button to submit your request."),
                                                                                                                                                                 
                                                                                                                                                          ),
                                                                                                                                                          tags$div(class = "manual-section-title", "2.2. Logging In"),
                                                                                                                                                          tags$ul(class="manual-ul",
                                                                                                                                                                  tags$li(class="manual-li", "Enter your registered DepEd Email Address."),
                                                                                                                                                                  tags$li(class="manual-li", "Enter your Password."),
                                                                                                                                                                  tags$li(class="manual-li", "Click the 'Login' button to access the dashboard.")
                                                                                                                                                          ),
                                                                                                                                                          tags$div(class = "manual-section-title", "2.3. Using Guest Mode"),
                                                                                                                                                          tags$ul(class="manual-ul",
                                                                                                                                                                  tags$li(class="manual-li", "On the login page, click the 'Guest Mode' button."),
                                                                                                                                                                  tags$li(class="manual-li", "Note: Guest Mode collects basic analytics and has limited access compared to registered users.")
                                                                                                                                                          ),
                                                                                                                      
                                          ))
                                 ),
                                 
                                 # 3. HOME PAGE (Separated per request)
                                 tags$div(class = "accordion-item", tags$h2(class = "accordion-header", id = "h3", tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#c3", "3. Home Page")),
                                          tags$div(id = "c3", class = "accordion-collapse collapse", `data-bs-parent` = "#manualAccordion", tags$div(class = "accordion-body",
                                                                                                                                                     tags$p("After logging in, you will land on the Home Page. This page provides a brief introduction to the STRIDE platform's purpose, serving as your starting point for all data exploration.")
                                          ))
                                 ),
                                 
                                 # 4. DASHBOARD (With Sub-categories)
                                 tags$div(class = "accordion-item", tags$h2(class = "accordion-header", id = "h4", tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#c4", "4. Dashboard")),
                                          tags$div(id = "c4", class = "accordion-collapse collapse", `data-bs-parent` = "#manualAccordion", tags$div(class = "accordion-body",
                                                                                                                                                     
                                                                                                                                                     tags$div(class = "manual-section-title", "Education Resource Dashboard"),
                                                                                                                                                     tags$p("This powerful dashboard allows you to generate graphs and locate specific schools."),
                                                                                                                                                     tags$ul(class="manual-ul",
                                                                                                                                                             tags$li(class="manual-li", tags$strong("Sidebar Controls:"), " Use the Presets (Teacher, School, Infrastructure, and more) to automatically select data."),
                                                                                                                                                             tags$li(class="manual-li", tags$strong("Main Content:"), " Shows Teacher Surplus (Blue) and Shortage (Red)."),
                                                                                                                                                             tags$li(class="manual-li", tags$strong("Drill Down:"), " Click on a Region bar to view Division-level data.")
                                                                                                                                                     ),
                                                                                                                                                    
                                                                                                                                                     
                                                                                                                                                     tags$div(class = "manual-section-title", "Advanced Analytics"),
                                                                                                                                                     tags$p("Designed for advanced users to compare relationships between multiple data categories."),
                                                                                                                                                     tags$ul(class="manual-ul",
                                                                                                                                                             tags$li(class="manual-li", "Select your variables (e.g., Enrolment vs Classroom Shortage)."),
                                                                                                                                                             tags$li(class="manual-li", "Click 'Apply Filters' to generate a graph.")
                                                                                                                                                     ),
                                                                                                                                                     
                                                                                                                                                     tags$div(class = "manual-section-title", "Plantilla Position"),
                                                                                                                                                     tags$p("Provides insights into filled and unfilled personnel positions. Use Presets to select positions like 'Teacher I'."),
                                                                                                                                                     
                                                                                                                                                     tags$div(class = "manual-section-title", "Infrastructure & Education Facilities"),
                                                                                                                                                     tags$p("Detailed data on planning, allocation, and completion of physical resources.")
                                          ))
                                 ),
                                 
                                 # 5. QUICK SEARCH
                                 tags$div(class = "accordion-item", tags$h2(class = "accordion-header", id = "h5", tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#c5", "5. Quick Search")),
                                          tags$div(id = "c5", class = "accordion-collapse collapse", `data-bs-parent` = "#manualAccordion", tags$div(class = "accordion-body",
                                                                                                                                                     tags$p("Designed to help you find, locate, and get information on a specific school instantly."),
                                                                                                                                                     tags$ul(class="manual-ul",
                                                                                                                                                             tags$li(class="manual-li", tags$strong("Basic Search:"), " Type a school name in the sidebar input field."),
                                                                                                                                                             tags$li(class="manual-li", tags$strong("Advanced Search:"), " Toggle 'ON' to filter by Region, Division, or Municipality.")
                                                                                                                                                     )
                                          ))
                                 ),
                                 
                                 # 6. RESOURCE MAPPING
                                 tags$div(class = "accordion-item", tags$h2(class = "accordion-header", id = "h6", tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#c6", "6. Resource Mapping")),
                                          tags$div(id = "c6", class = "accordion-collapse collapse", `data-bs-parent` = "#manualAccordion", tags$div(class = "accordion-body",
                                                                                                                                                     tags$p("A dynamic page for geographic analysis. Data changes based on filters applied."),
                                                                                                                                                     tags$ol(class="manual-ul",
                                                                                                                                                             tags$li(class="manual-li", "Set Data Filters: Region, Division, Legislative District."),
                                                                                                                                                             tags$li(class="manual-li", "Set Resource Types: Select from Teaching Deployment, Classroom Inventory, etc."),
                                                                                                                                                             tags$li(class="manual-li", "Click 'Show Selection' to populate the map.")
                                                                                                                                                     ),
                                                                                                                                             
                                          ))
                                 ),
                                 
                                 # 7. CLOUD
                                 tags$div(class = "accordion-item", tags$h2(class = "accordion-header", id = "h7", tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#c7", "7. Cloud")),
                                          tags$div(id = "c7", class = "accordion-collapse collapse", `data-bs-parent` = "#manualAccordion", tags$div(class = "accordion-body",
                                                                                                                                                     tags$div(class = "manual-section-title", "Cloud (Regional Profile)"),
                                                                                                                                                     tags$p("Provides a high-level summary of key metrics for a selected region."),
                                                                                                                                                     
                                                                                                                                                     tags$div(class = "manual-section-title", "Cloud (SDO Breakdown)"),
                                                                                                                                                     tags$p("Detailed comparison of SDOs. Select a category (e.g., IP Learners) to see bar charts."),
                                                                                                                                                     
                                                                                                                                                     tags$div(class = "manual-section-title", "Cloud (Multivariable)"),
                                                                                                                                                     tags$p("A grid view designed for comparing up to 6 different data categories simultaneously.")
                                          ))
                                 ),
                                 
                                 # 8. DATA EXPLORER
                                 tags$div(class = "accordion-item", tags$h2(class = "accordion-header", id = "h8", tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#c8", "8. Data Explorer")),
                                          tags$div(id = "c8", class = "accordion-collapse collapse", `data-bs-parent` = "#manualAccordion", tags$div(class = "accordion-body",
                                                                                                                                                     tags$div(class = "manual-section-title", "Information Database"),
                                                                                                                                                     tags$p("The central repository for viewing raw data tables."),
                                                                                                                                                     tags$ul(class="manual-ul",
                                                                                                                                                             tags$li(class="manual-li", "Use sidebar checkboxes to show/hide columns."),
                                                                                                                                                             tags$li(class="manual-li", "Click 'CSV' or 'Excel' buttons to export data.")
                                                                                                                                                     ),
                                                                                                                                                     
                                          ))
                                 )
                        )
               ),
               
               # --- GLOSSARY TAB ---
               tags$div(id = "tab-glossary", class = "drawer-tab-pane", style = "display: none;",
                        tags$input(type="text", class="form-control mb-3", placeholder="Search glossary...", onkeyup="var val=this.value.toLowerCase(); document.querySelectorAll('.glossary-item').forEach(el => { el.style.display = el.innerText.toLowerCase().includes(val) ? 'block' : 'none'; });"),
                        
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Allocation"), "The planned or budgeted amount for an infrastructure or resource project before implementation."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Buildable Space"), "The portion of a school site that can still be used for construction or expansion."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Classroom Shortage"), "The deficit between the required number of classrooms and the existing classrooms in a school."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Completion"), "The actual progress or percentage of accomplishment of an infrastructure project."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Data Hierarchy"), "The fixed organizational structure used in STRIDE: Region > SDO/Division > Municipality > Legislative District > District > School."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Data Toggle"), "An option (checkbox or picker) used to show or hide entire columns in a data table."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Drill Down"), "The interactive action of clicking on a graph or table element to view more detailed data according to the Data Hierarchy."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Enrolment (Enrollment)"), "The total number of learners officially registered in a school for a given school year."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Facilities"), "Physical school resources such as classrooms, laboratories, water systems, electricity, and other infrastructure."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Guest Mode"), "A restricted access mode for users without an account. Limited features are available."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Implementing Unit (IU)"), "Schools with financial autonomy to manage their own funds."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Last Mile School"), "Schools considered geographically isolated, underserved, or lacking essential facilities, connectivity, and infrastructure."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Learner Congestion"), "The measure of overcrowding in classrooms, often shown as learners per room or per usable classroom."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Multivariable Analysis"), "A comparative method that displays the relationships between multiple selected data categories in a single visual output."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Picker"), "A dropdown menu used to select specific categories, variables, or criteria. Located primarily in sidebars."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Plantilla Position"), "The list of official, approved, filled, and unfilled personnel positions in DepEd."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Preset / Checkbox"), "A quick-select option that automatically checks or loads predefined related data points in a picker."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Reactive"), "A system behavior where tables, maps, or graphs instantly update when the user changes a filter."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Region"), "The highest geographic and administrative level in the STRIDE data structure."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Resource Types"), "Categories of data used in mapping: Teaching Deployment, Non-Teaching Deployment, Facilities, Classroom Inventory, etc."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "SDO / Division"), "Schools Division Office. The administrative level under the Regional Office."),
                        tags$div(class="glossary-item", tags$span(class="glossary-term", "Sidebar"), "The control panel on the left side of most STRIDE pages containing pickers, toggles, and filters.")
               ),
               
               # --- FAQ TAB ---
               tags$div(id = "tab-faq", class = "drawer-tab-pane", style = "display: none;",
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: I clicked a bar in the Interactive Dashboard, but nothing happened. Why can't I Drill Down?"),
                                 tags$p(class="faq-a", "A: The next hierarchical level (e.g., SDO/Division) may have no data for the selected region, or the Drill Down only supports up to District level in that dashboard.")
                        ),
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: My graph disappeared after I deselected an item in the Picker."),
                                 tags$p(class="faq-a", "A: The system requires at least one data variable to be selected. Ensure you have not deselected all available items.")
                        ),
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: How do I find a specific school's location?"),
                                 tags$p(class="faq-a", "A: Use the School Locator Tab in the Dashboard (after filtering by location) or, for a direct search, use the Quick School Search navigation menu.")
                        ),
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: How do I save the table data I'm viewing?"),
                                 tags$p(class="faq-a", "A: In the Data Explorer, look for the export options (CSV, Excel, Print) to save the data.")
                        ),
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: If I use the export feature, does it save all data in the database?"),
                                 tags$p(class="faq-a", "A: No. The export function saves the exact, filtered, and visible data you see on your screen.")
                        ),
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: How do I reorganize the table data from highest to lowest?"),
                                 tags$p(class="faq-a", "A: Simply click the column header (e.g., 'Enrolment'). Clicking once sorts ascending, twice sorts descending.")
                        ),
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: The map is blank or not showing any school pins. What should I do?"),
                                 tags$p(class="faq-a", "A: This happens when no results match your filters. Recheck your Region, Division, or Resource Type selections.")
                        ),
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: Why does the Data Table say 'No data found'?"),
                                 tags$p(class="faq-a", "A: Your filters might be too specific. Clear or adjust your pickers to widen the results.")
                        ),
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: Can I update or correct data in STRIDE?"),
                                 tags$p(class="faq-a", "A: Only authorized personnel can update STRIDE. Contact STRIDE support if you see errors.")
                        ),
                        tags$div(class="faq-item",
                                 tags$span(class="faq-q", "Q: Why can't I log in even with correct credentials?"),
                                 tags$p(class="faq-a", "A: Your account may not be verified, inactive, or your DepEd email may have issues. Try resetting your password or contact support.")
                        )
               )
      )
    )
  )
  
}) # End renderUI