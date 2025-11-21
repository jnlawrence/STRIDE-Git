# ui_parts/04_footer.R

ui_footer <- shinyjs::hidden(
  tags$footer(
    id = "app_footer",
    class = "app-footer",
    
    # Container to stack the items vertically
    div(
      style = "display: flex; flex-direction: column; align-items: center; gap: 5px;",
      
      # 1. Existing Copyright / Data Source Line
      tags$span(
        "© Based on GMIS (April 2025) and eBEIS (SY 2024–2025)",
        style = "font-weight: 600;"
      ),
      
      # 2. New Contact Information Line
      div(
        style = "font-size: 0.9em; color: #666; display: flex; gap: 15px; align-items: center;",
        
        # Email
        tags$span(
          bsicons::bs_icon("envelope-fill", size = "0.9em"), 
          " support@stride.deped.gov.ph" # <-- Replace with actual email
        ),
        
        # Vertical Separator
        tags$span("|", style = "color: #ccc;"),
        
        # Phone
        tags$span(
          bsicons::bs_icon("telephone-fill", size = "0.9em"), 
          " (02) 8633-7248" # <-- Replace with actual number
        )
      )
    )
  )
)