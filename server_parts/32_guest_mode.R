# ===========================================
# GUEST MODE MODULE
# ===========================================

observeEvent(input$guest_mode_btn, {
  showModal(modalDialog(
    title = "Guest Information",
    easyClose = FALSE,
    footer = tagList(
      modalButton("Cancel"),
      shinyjs::disabled(
        actionButton("submit_guest_info", "Continue", class = "btn btn-primary")
      )
    ),
    textInput("guest_name", "Full Name"),
    textInput("guest_email", "DepEd Email Address", 
              placeholder = "user@deped.gov.ph"),
    
    tags$small(id = "guest_email_msg", 
               class = "guest-validation-msg"), 
    
    textInput("guest_org", "Organization / Affiliation"),
    
    # --- 💡 MODIFICATION START ---
    
    # 1. Replaced the old textAreaInput with radioButtons
    radioButtons("guest_purpose_choice", "Purpose of Visit:",
                 choices = c("Exploring dashboards", 
                             "Data reference for a report", 
                             "Academic research", 
                             "Others"),
                 selected = character(0)), # Start with nothing selected
    
    # 2. Add a conditionalPanel that only appears if "Others" is selected
    conditionalPanel(
      condition = "input.guest_purpose_choice == 'Others'",
      textAreaInput("guest_purpose_other", "Please specify your purpose:",
                    placeholder = "e.g., I am a stakeholder validating school data for...")
    ),
    
    # 3. This error message will now be used for the "Others" text box
    tags$small(id = "guest_purpose_msg", 
               class = "guest-validation-msg"),
    # --- MODIFICATION END ---
    
    width = 500
  ))
})

# 💡 REVISED OBSERVER (v4): Validate guest form inputs with choices
observe({
  # 1. Check Name
  name_ok <- !is.null(input$guest_name) && nzchar(trimws(input$guest_name))
  
  # 2. Check Email
  email_val <- input$guest_email
  email_ok <- !is.null(email_val) && endsWith(trimws(email_val), "@deped.gov.ph")
  
  # 3. 💡 NEW: Check Purpose
  purpose_choice <- input$guest_purpose_choice
  purpose_choice_ok <- !is.null(purpose_choice) && nzchar(purpose_choice)
  
  purpose_ok <- FALSE # Assume false until proven true
  purpose_msg <- ""    # Reset message
  
  if (purpose_choice_ok) {
    if (purpose_choice == "Others") {
      # If "Others", validate the text area
      purpose_other_val <- trimws(input$guest_purpose_other)
      purpose_length_ok <- nchar(purpose_other_val) >= 10
      purpose_has_vowels <- grepl("[aeiouy]", purpose_other_val, ignore.case = TRUE)
      
      purpose_ok <- purpose_length_ok && purpose_has_vowels
      
      # Set error message if user started typing but it's invalid
      if (!purpose_ok && nzchar(purpose_other_val)) {
        purpose_msg <- "Purpose must be at least 10 characters and include recognizable words (with vowels)."
      }
    } else {
      # If not "Others" (e.g., "Research"), it's automatically valid
      purpose_ok <- TRUE
    }
  }
  # --- END NEW LOGIC ---
  
  # 4. Enable/disable button logic
  if (name_ok && purpose_ok && email_ok) {
    shinyjs::enable("submit_guest_info")
    shinyjs::html("guest_email_msg", "")
    shinyjs::html("guest_purpose_msg", "")
  } else {
    shinyjs::disable("submit_guest_info")
    
    # Show email error
    if (!email_ok && !is.null(email_val) && nzchar(email_val)) {
      shinyjs::html("guest_email_msg", "Email must be a valid @deped.gov.ph address.")
    } else {
      shinyjs::html("guest_email_msg", "")
    }
    
    # Show purpose error
    shinyjs::html("guest_purpose_msg", purpose_msg)
  }
})

# When guest info is submitted
observeEvent(input$submit_guest_info, {
  
  # 💡 UPDATED: req() now checks the new choice input
  req(input$guest_name, input$guest_purpose_choice, input$guest_email)
  
  if (!endsWith(input$guest_email, "@deped.gov.ph")) {
    showNotification("Invalid DepEd Email. Please check your entry.", type = "error")
    return()
  }
  
  # --- 💡 NEW: Final Purpose Logic ---
  final_purpose <- input$guest_purpose_choice
  
  if (final_purpose == "Others") {
    # If "Others", validate the text box again on the server-side
    other_purpose_val <- trimws(input$guest_purpose_other)
    purpose_length_ok <- nchar(other_purpose_val) >= 10
    purpose_has_vowels <- grepl("[aeiouy]", other_purpose_val, ignore.case = TRUE)
    
    if (!(purpose_length_ok && purpose_has_vowels)) {
      showNotification("Please provide a valid purpose (min 10 chars, with vowels).", type = "error")
      return() # Stop
    }
    # If valid, set the purpose to the typed text
    final_purpose <- other_purpose_val
  }
  # --- END NEW LOGIC ---
  
  guest_entry <- tibble::tibble(
    Timestamp = as.character(Sys.time()),
    Name = input$guest_name,
    Email = input$guest_email, 
    Organization = input$guest_org,
    Purpose = final_purpose # 💡 Use the final_purpose variable
  )
  
  # Use separate Google Sheet for guests
  GUEST_SHEET_ID <- "https://docs.google.com/spreadsheets/d/1SvlP7gyfgmymo10hpstKyYs2N9jErCg5tqrmELboTRg/edit?gid=0#gid=0"
  
  tryCatch({
    googlesheets4::sheet_append(ss = GUEST_SHEET_ID, data = guest_entry)
    removeModal()
    showNotification("Guest record saved. Welcome!", type = "message")
    
    # This existing logic is correct
    user_status("authenticated")
    authenticated_user("guest_user@stride") 
    
  }, error = function(e) {
    showNotification(paste("Error saving to Google Sheets:", e$message),
                     type = "error")
  })
})