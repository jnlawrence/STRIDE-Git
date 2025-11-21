# ui_parts/04_footer.R

ui_footer <- shinyjs::hidden(
  tags$footer(
    id = "app_footer",
    class = "app-footer",
    tags$p("© Based on GMIS (April 2025) and eBEIS (SY 2024–2025)")))