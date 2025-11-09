# ui_parts/01_head_elements.R

# We use tagList() to group multiple UI elements together
ui_head <- tagList(
  # Global Head elements
  tags$head(
    # Custom styling for btn-warning
    tags$style(HTML("
    .btn-warning {
      background-color: #ffc107 !important;
      border-color: #ffc107 !important;
      color: #212529 !important;
      font-weight: 600;
    }
    .btn-warning:hover {
      background-color: #e0a800 !important;
      border-color: #d39e00 !important;
      color: #fff !important;
    }
    ")),
    
    # External files (ensure they are in the 'www' folder)
  includeCSS("www/style.css"),
  includeScript("www/script.js"),
 
    
    tags$link(rel = "icon", type = "image/png", href = "deped_logo.png"),
    
    # Leaflet smooth marker bouncing script
    tags$script(src = "https://unpkg.com/leaflet.smoothmarkerbouncing/leaflet.smoothmarkerbouncing.js"),
    
    # Viewport meta tag
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0, maximum-scale=3.0")
  ),
  
  # Font tags (also part of the head, but good to keep together)
  tags$head(
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap",
      rel = "stylesheet"
    ),
    tags$style(HTML("
    body, h1, h2, h3, h4, h5, h6, p, span, button {
      font-family: 'Poppins', sans-serif;
    }
  "))
  ),
  tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = "anonymous")
)