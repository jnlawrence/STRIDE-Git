# Authentication Module

# --- Authentication Server (Handles the logic for login and registration) ---
# ==========================================================
# --- AUTHENTICATION MODULE: LOGIN / REGISTER / GUEST ---
# ==========================================================

authentication_server <- function(input, output, session, user_status, 
                                  form_choice, sheet_url, user_database, db_trigger, 
                                  authenticated_user) {
  ns <- session$ns
  
  # --- 1️⃣ SWITCH BETWEEN LOGIN & REGISTER FORMS ---
  observeEvent(input$btn_register, { form_choice("register") })
  observeEvent(input$btn_login, { form_choice("login") })
  
  # --- 2️⃣ MAIN AUTH PAGE UI ---
  output$auth_page <- renderUI({
    if (form_choice() == "login") {
      # LOGIN PANEL
      div(
        class = "login-container",
        div(
          class = "login-left",
          div(
            class = "login-text-box text-center",
            div(
              class = "login-left-logos",
              tags$img(src = "logo1.png", class = "left-logo")
            ),
            h2(
              HTML('
        <img src="Stridelogo1.png" class="stride-logo-i" alt="I Logo">
      '),
              class = "stride-logo-text mt-3"
            ),
            p(class = "slogan-mid", "Education in Motion!"),
            div(
              class = "slogan-bottom-row",
              span(class = "slogan-left", "Data Precision."),
              span(class = "slogan-right", "Smart Decision.")
            )
          )
        )
        ,
        div(
          class = "login-right",
          div(
            class = "login-card",
            p(class = "slogan-login-top", "Welcome to STRIDE!"),
            div(
              class = "slogan-login-bottom",
              span(class = "slogan-login-bottom", "Please enter your email and password.")
            ),
            textInput(ns("login_user"), NULL, placeholder = "DepEd Email"),
            # custom password input with toggle eye (no server action triggered)
            tags$div(class = "input-group mb-2",
                     tags$input(id = ns("login_pass"), type = "password", class = "form-control", placeholder = "Password"),
                     tags$span(class = "input-group-text toggle-password", `data-target` = ns("login_pass"), HTML('<i class="fa fa-eye" aria-hidden="true"></i>'))
            ),
            actionButton(ns("do_login"), "Sign In", class = "btn-login w-100"),
            uiOutput(ns("login_message")),
            br(),
            actionLink(ns("btn_register"), "Create an account", class = "register-link"),
            br(),
            # actionButton(ns("guest_mode"), "Continue as Guest", class = "btn-secondary w-100 mt-2"),
            div(
              class = "login-logos-bottom",
              tags$img(src = "logo2.png", class = "bottom-logo"),
              tags$img(src = "HROD LOGO1.png", class = "bottom-logo"),
              tags$img(src = "logo3.png", class = "bottom-logo")
            )
          )
        )
      )
    } else {
      # REGISTER PANEL
      div(
        class = "login-container",
        
        div(
          class = "login-left",
          div(class = "login-text-box",
              h2("Create a STRIDE Account"),
              p("Register your DepEd account to access STRIDE dashboards.")
          )
        ),
        
        div(
          class = "register-wrapper d-flex gap-4 align-items-start",
          
          # LEFT PANEL: appears when Engineer or HR selected
          conditionalPanel(
            condition = paste0(
              "['Engineer II','Engineer III','Engineer IV','Engineer V','Human Resources Management Officer I']",
              ".includes(input['", ns("position"), "'])"
            ),
            div(
              class = "engineer-panel card p-3",
              h4("Engineer / HR Information"),
              textInput(ns("first_name"), "First Name"),
              textInput(ns("middle_name"), "Middle Name"),
              textInput(ns("last_name"), "Last Name"),
              numericInput(ns("age"), "Age", value = NA, min = 18, max = 100, step = 1),
              dateInput(ns("birthday"), "Birthday", format = "yyyy-mm-dd"),
              textInput(ns("address"), "Address"),
              selectInput(ns("region"), "Region", choices = sort(unique(uni$Region))),
              uiOutput(ns("division_ui")),
              uiOutput(ns("district_ui")),
              uiOutput(ns("school_ui"))
            )
          ),
          
          # RIGHT PANEL: main registration card
          div(
            class = "login-right flex-grow-1",
            div(
              class = "login-card",
              
              selectInput(ns("govlev"), "Select Station:",
                          choices = c("— Select an Option —" = "",
                                      "Central Office", "Regional Office", 
                                      "Schools Division Office", "School")),
              uiOutput(ns("station_specific_ui")),
              uiOutput(ns("position_ui")),
              
              textInput(ns("reg_user"), NULL, placeholder = "DepEd Email (@deped.gov.ph)"),
              # registration password with toggle
              tags$div(class = "input-group mb-2",
                       tags$input(id = ns("reg_pass"), type = "password", class = "form-control", placeholder = "Password"),
                       tags$span(class = "input-group-text toggle-password", `data-target` = ns("reg_pass"), HTML('<i class="fa fa-eye" aria-hidden="true"></i>'))
              ),
              # confirm password with toggle
              tags$div(class = "input-group mb-2",
                       tags$input(id = ns("reg_pass_confirm"), type = "password", class = "form-control", placeholder = "Confirm Password"),
                       tags$span(class = "input-group-text toggle-password", `data-target` = ns("reg_pass_confirm"), HTML('<i class="fa fa-eye" aria-hidden="true"></i>'))
              ),
              
              actionButton(ns("do_register"), "Register Account", class = "btn-login w-100"),
              uiOutput(ns("register_message")),
              br(),
              actionLink(ns("btn_login"), "Back to Login", class = "register-link"),
              div(class = "login-logos-bottom",
                  tags$img(src = "HROD LOGO1.png", class = "bottom-logo"))
            )
          )
        )
      )
    }
    
    
    
    
  })
  
  # --- 3️⃣ STATION-SPECIFIC INPUTS ---
  output$station_specific_ui <- renderUI({
    req(input$govlev)
    if (input$govlev == "School") {
      tagList(
        textInput(ns("school_id"), "School ID:"),
        tags$small("Enter your School ID (6 digits).", class = "text-muted")
      )
    } else if (input$govlev %in% c("Central Office", "Regional Office", "Schools Division Office")) {
      tagList(
        textInput(ns("office_name"), "Office Name:"),
        tags$small("Enter Bureau/Division. Do not abbreviate!", class = "text-muted")
      )
    } else NULL
  })
  
  # --- 4️⃣ DYNAMIC POSITION DROPDOWN ---
  output$position_ui <- renderUI({
    dfGMISPosCat <- read.csv("GMIS-Apr2025-PosCat.csv")
    req(input$govlev)
    positions <- sort(unique(dfGMISPosCat$Position))
    selectInput(ns("position"), "Position:", choices = positions)
  })
  
  # observe({
  #   pos <- input[[ns("position")]]
  #   show_list <- c("Engineer II", "Engineer III", "Engineer IV", "Engineer V", 
  #                  "Human Resources Management Officer I")
  #   
  #   if (!is.null(pos) && pos %in% show_list) {
  #     shinyjs::showElement(id = ns("engineer_hr_panel"), anim = TRUE)
  #   } else {
  #     shinyjs::hideElement(id = ns("engineer_hr_panel"), anim = TRUE)
  #   }
  # })
  
  
  
  
  # --- 6️⃣ DYNAMIC DROPDOWNS (Region -> Division -> District -> School) ---
  observeEvent(input$region, {
    req(input$region)
    divisions <- sort(unique(uni$Division[uni$Region == input$region]))
    updateSelectInput(session, "division", choices = divisions)
  })
  
  output$division_ui <- renderUI({
    req(input$region)
    selectInput(ns("division"), "Division", choices = sort(unique(uni$Division[uni$Region == input$region])))
  })
  
  output$district_ui <- renderUI({
    req(input$division)
    selectInput(ns("district"), "Legislative District",
                choices = sort(unique(uni$Legislative.District[uni$Division == input$division])))
  })
  
  output$school_ui <- renderUI({
    req(input$district)
    selectInput(ns("school_id"), "School ID (6-digit)",
                choices = sort(unique(uni$SchoolID[uni$Legislative.District == input$district])))
  })
  
  # --- 7️⃣ SUBMIT HANDLER FOR ENGINEER / HR INFO ---
  observeEvent(input$submit_engineer_hr, {
    req(input$user_name, input$user_email, input$region, input$division, input$district, input$school_id)
    new_entry <- data.frame(
      Timestamp = Sys.time(),
      Name = input$user_name,
      Email = input$user_email,
      Position = input$position,
      Region = input$region,
      Division = input$division,
      Legislative_District = input$district,
      School_ID = input$school_id,
      stringsAsFactors = FALSE
    )
    tryCatch({
      googlesheets4::sheet_append(sheet_url, data = new_user)
      print("✅ Successfully appended to Google Sheet")
      
      db_trigger(db_trigger() + 1)
      
      # Mark as registered and authenticated
      register_success(TRUE)
      user_status("authenticated")
      authenticated_user(reg_user)
      
      showNotification("✅ Registration successful! Redirecting...", type = "message", duration = 4)
      
    }, error = function(e) {
      showNotification(paste("❌ Error writing to sheet:", e$message), type = "error")
    })
    
    
  })
  
  # --- 8️⃣ LOGIN LOGIC ---
  observeEvent(input$do_login, {
    req(input$login_user, input$login_pass)
    users_db <- user_database()
    if (nrow(users_db) == 0) {
      output$login_message <- renderUI({
        tags$p("Database is empty or inaccessible.", class = "text-danger mt-2")
      })
      return()
    }
    user_row <- users_db[users_db$Email_Address == input$login_user, ]
    if (nrow(user_row) == 1 && user_row$Password == input$login_pass) {
      user_status("authenticated")
      authenticated_user(input$login_user)
      session$sendCustomMessage("showLoader", "Welcome to STRIDE...")
      print(">>> Login success — showLoader triggered")
      later::later(function() { session$sendCustomMessage("hideLoader", NULL) }, 2)
      updateTextInput(session, "login_user", value = "")
      updateTextInput(session, "login_pass", value = "")
      output$login_message <- renderUI({})
    } else {
      output$login_message <- renderUI({
        tags$p("Invalid username or password.", class = "text-danger mt-2")
      })
    }
  })
  
  # --- 9️⃣ GUEST MODE LOGIC ---
  observeEvent(input$guest_mode, {
    print("🟢 Guest mode activated")
    user_status("authenticated")
    authenticated_user("guest_user@stride")
    session$sendCustomMessage("showLoader", "Entering STRIDE2 as Guest...")
    later::later(function() { session$sendCustomMessage("hideLoader", NULL) }, 2)
  })
  
  
  
  # --- 🔟 REGISTRATION LOGIC ---
  observeEvent(input$do_register, {
    print("🔔 Register button clicked")
    
    # Collect inputs
    reg_user <- input$reg_user
    reg_pass <- input$reg_pass
    govlev <- input$govlev
    position <- input$position
    
    # Validation
    if (is.null(reg_user) || reg_user == "") {
      showNotification("❌ Please enter your DepEd email.", type = "error")
      return()
    }
    if (!endsWith(reg_user, "@deped.gov.ph")) {
      showNotification("❌ Invalid email domain. Use @deped.gov.ph", type = "error")
      return()
    }
    if (is.null(reg_pass) || reg_pass == "") {
      showNotification("❌ Please enter a password.", type = "error")
      return()
    }
    if (is.null(govlev) || govlev == "") {
      showNotification("❌ Please select your station.", type = "error")
      return()
    }
    
    # === Collect all registration data (including Engineer/HR fields) ===
    new_user <- data.frame(
      Registration_Date = as.character(Sys.time()),
      Email_Address = reg_user,
      Password = reg_pass,
      Station = govlev,
      School_ID = ifelse(govlev == "School", input$school_id, NA),
      Office = ifelse(govlev != "School", input$office_name, NA),
      Position = ifelse(!is.null(position) && position != "", position, NA),
      
      # 👇 New columns for Engineer/HR (may be NA for others)
      First_Name = ifelse(!is.null(input$first_name), input$first_name, NA),
      Middle_Name = ifelse(!is.null(input$middle_name), input$middle_name, NA),
      Last_Name = ifelse(!is.null(input$last_name), input$last_name, NA),
      Age = ifelse(!is.null(input$age), input$age, NA),
      Birthday = ifelse(!is.null(input$birthday), as.character(input$birthday), NA),
      Address = ifelse(!is.null(input$address), input$address, NA),
      Region = ifelse(!is.null(input$region), input$region, NA),
      Division = ifelse(!is.null(input$division), input$division, NA),
      Legislative_District = ifelse(!is.null(input$district), input$district, NA),
      School_ID_Selected = ifelse(!is.null(input$school_id), input$school_id, NA),
      
      stringsAsFactors = FALSE
    )
    
    print("🧩 Prepared registration data:")
    print(new_user)
    
    # === Write to Google Sheet ===
    tryCatch({
      googlesheets4::sheet_append(sheet_url, data = new_user)
      showNotification("✅ Registration successful!", type = "message")
      
      db_trigger(db_trigger() + 1)
      user_status("authenticated")
      authenticated_user(reg_user)
      
    }, error = function(e) {
      showNotification(paste("❌ Error writing to sheet:", e$message), type = "error")
    })
  })
  
  # --- Disable Register button until required fields are filled ---
  observe({
    req(input$reg_user, input$reg_pass, input$govlev, input$position)
    
    # Basic required fields
    basic_filled <- all(
      nzchar(input$reg_user),
      nzchar(input$reg_pass),
      nzchar(input$govlev),
      nzchar(input$position)
    )
    
    # Check if Engineer/HR panel is visible and collect required inputs
    engineer_positions <- c("Engineer II", "Engineer III", "Engineer IV", "Engineer V", "Human Resources Management Officer I")
    is_engineer <- input$position %in% engineer_positions
    
    if (is_engineer) {
      # Additional required fields for engineer/HR
      extra_filled <- all(
        nzchar(input$first_name),
        nzchar(input$last_name),
        !is.null(input$age) && input$age > 0,
        !is.null(input$birthday) && input$birthday != "",
        nzchar(input$address),
        nzchar(input$region),
        nzchar(input$division),
        nzchar(input$district),
        nzchar(input$school_id)
      )
    } else {
      extra_filled <- TRUE
    }
    
    enable_btn <- basic_filled && extra_filled
    shinyjs::toggleState(ns("do_register"), condition = enable_btn)
  })
  
  
}

# --- END OF AUTHENTICATION MODULE ---
# ==========================================================