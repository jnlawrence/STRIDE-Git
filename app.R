library(tidyverse)
library(DT)
library(dplyr)
library(shiny)
library(shinydashboard)
library(bslib)
library(bsicons)
library(leaflet)
library(htmltools)
library(thematic)
library(arrow)
library(forcats)
library(fontawesome)
library(shinyjs)
library(shinyauthr)
library(httr)
library(scales)
library(tidytext)
library(ggplot2)
library(plotly)
library(readr)
library(geojsonio)
library(shinyWidgets)
library(later)
library(googlesheets4)
library(DBI)
library(RPostgres)
library(pool)
library(reactable)
library(reactablefmtr)


# HROD Data Upload

school_data <- reactiveVal(NULL)
uni48k <- read.csv("School-Unique-48k.csv")
efd2025 <- read.csv("EFD-2025Data1.csv") %>%
  mutate(across(
    .cols = -1,  # Selects all columns EXCEPT the first one
    .fns = ~ as.numeric(as.character(.))
  ))
df <- read_parquet("School-Level-v2.parquet") # per Level Data
uni45k <- read_parquet("School-Unique-v2.parquet") %>% 
  mutate(Municipality = stringr::str_to_title(Municipality)) %>% # School-level Data
  mutate(Leg.Mun = sprintf("%s (%s)", Legislative.District, Municipality))

uni <- left_join(uni48k,uni45k, by = "SchoolID") %>% mutate(
  # We will modify the column in place
  Buildable_Space = case_when(
    # First, clean the text: make it lowercase and trim whitespace
    # Then, check if the cleaned text is "yes"
    tolower(trimws(With_Buildable_space)) == "yes" ~ 1,
    
    # Check if the cleaned text is "no"
    tolower(trimws(With_Buildable_space)) == "no" ~ 0,
    
    # For any other value (including NA, "MAYBE", etc.),
    # assign NA. The 'TRUE ~ NA_real_' explicitly does this.
    # NA_real_ ensures the column type is numeric (double).
    TRUE ~ NA_real_
  )
)

# --- START: One-Time Analysis for Advanced Analytics ---
# This runs ONCE when the app starts, right after 'uni' is loaded.
# --- START: One-Time Analysis for Advanced Analytics (v2 - Clean Names) ---
# This runs ONCE when the app starts, right after 'uni' is loaded.

print("--- ADVANCED ANALYTICS: Starting column analysis... (This may take a moment) ---")

# --- 1. DEFINE a map of raw column names to clean display names ---
# CRITICAL: The 'Raw_Name' must EXACTLY match the column name in your 'uni'
# database, including capitalization (e.g., 'TotalEnrolment' vs 'totalenrolment').
# I have made my best guess based on your CSV snippets.
analytics_column_map <- tibble(
  Raw_Name = c(
    "Implementing.Unit", 
    "Modified.COC", 
    "TotalEnrolment", 
    "SH.Position", 
    "School.Size.Typology", 
    "Shifting", 
    "OwnershipType", 
    "ElectricitySource", 
    "WaterSource", 
    "Total.Excess", 
    "Total.Shortage", 
    "TotalTeachers",
    "Classroom.Shortage",
    "With_Buildable_space"
  ),
  Clean_Name = c(
    "Implementing Unit", 
    "Curricular Offering", 
    "Total Enrolment", 
    "School Head Position", 
    "School Size", 
    "Shifting", 
    "Ownership Type", 
    "Electricity Source", 
    "Water Source", 
    "Teacher Excess", 
    "Teacher Shortage", 
    "Total Teachers",
    "Classroom Shortage",
    "Buildable Space"
  )
)

# 2. Define the helper function (same as before)
get_col_type_adv <- function(column) {
  num_unique <- n_distinct(column)
  if (num_unique == 2) "Binary"
  else if (is.numeric(column) && num_unique > 20) "Numeric"
  else if (is.character(column) || is.factor(column) || num_unique <= 20) "Categorical"
  else "Other"
}

# 3. Run the analysis ONLY on our 12 columns
# We use `uni[analytics_column_map$Raw_Name]` to select just those columns
types_adv <- sapply(uni[analytics_column_map$Raw_Name], get_col_type_adv)

# 4. Create the static (non-reactive) metadata object
# This now includes the clean names
col_info_adv_static <- analytics_column_map %>%
  mutate(type = types_adv) %>%
  filter(!type == "Other") # Remove any that failed the type check

# 5. CREATE THE NAMED VECTOR FOR THE UI
# This is the key for Step 2.
# It will look like: c("Implementing Unit" = "Implementing.Unit", ...)
adv_analytics_choices <- setNames(
  col_info_adv_static$Raw_Name, 
  col_info_adv_static$Clean_Name
)

print("--- ADVANCED ANALYTICS: Column analysis COMPLETE. ---")

# --- END: One-Time Analysis ---

# --- END: One-Time Analysis ---
# === PRIVATE SCHOOL DATA ===
PrivateSchools <- read.csv("Private Schools Oct.2025.csv") %>%
  mutate(
    Region = trimws(Region),
    Division = trimws(Division),
    Legislative.District = ifelse(
      is.na(Legislative.District) | Legislative.District == "",
      "Unspecified / No District Data",
      trimws(Legislative.District)
    ),
    Seats = as.numeric(gsub("[^0-9]", "", Total.Seats))
  )
IndALL <- read_parquet("IndDistance.ALL2.parquet") # Industry Distances
ind <- read_parquet("SHS-Industry.parquet") # Industry Coordinates

# Clean Sector names
ind <- ind %>%
  mutate(
    Sector = case_when(
      is.na(Sector) | Sector == "#N/A" ~ NA_character_,
      str_detect(Sector, regex("Agri", ignore_case = TRUE)) ~ "Agriculture and Agri-business",
      str_detect(Sector, regex("Business", ignore_case = TRUE)) ~ "Business and Finance",
      str_detect(Sector, regex("Hospitality|Tourism", ignore_case = TRUE)) ~ "Hospitality and Tourism",
      str_detect(Sector, regex("Manufacturing|Engineeri", ignore_case = TRUE)) ~ "Manufacturing and Engineering",
      str_detect(Sector, regex("Professional|Service", ignore_case = TRUE)) ~ "Professional/Private Services",
      str_detect(Sector, regex("Public", ignore_case = TRUE)) ~ "Public Administration",
      TRUE ~ Sector  # leave unchanged if no match
    )
  )
SDO <- read_parquet("SDOFill.parquet") # SDO and Regional Filling-up Rate
DBMProp <- read.csv("DBM-Proposal.csv") # Teacher Shortage Data

# EFD Data Upload
EFDDB <- read.csv("EFD-DataBuilder-2025.csv")
EFDMP <- read_parquet("EFD-Masterlist.parquet")
EFD_Projects <- read.csv("EFD-ProgramsList-Aug2025.csv") %>% mutate(Allocation = as.numeric(Allocation)) %>% mutate(Completion = as.numeric(Completion)) %>% filter(FundingYear >= 2020)
LMS <- read_parquet("EFD-LMS-GIDCA-NSBI2023.parquet") %>%
  mutate(
    Region = case_when(Region == "Region IV-B" ~ "MIMAROPA", TRUE ~ Region),
    With_Shortage = case_when(Estimated_CL_Shortage > 0 ~ 1, TRUE ~ 0)
  ) %>%
  left_join(
    uni %>% select(
      SchoolID,
      Latitude,
      Longitude,
      Legislative.District,
      Municipality,
      Barangay
    ),
    by = c("School_ID" = "SchoolID")
  )


geojson_data <- geojson_read("gadm41_PHL_1.json", what = "sp")
geojson_table <- as.data.frame(geojson_data)
regprov <- read.csv("RegProv.Congestion.csv")
geojson_table <- left_join(geojson_table,regprov, by="NAME_1")
buildablecsv <- read.csv("Buildable_LatLong.csv")
# Clean column names: remove line breaks, extra spaces
names(buildablecsv) <- gsub("[\r\n]", " ", names(buildablecsv))
names(buildablecsv) <- trimws(names(buildablecsv))
# Ensure lat/long are numeric
buildablecsv$Latitude <- as.numeric(buildablecsv$Latitude)
buildablecsv$Longitude <- as.numeric(buildablecsv$Longitude)


# CLOUD Data Upload
cloud <- read_parquet("Cloud_Consolidated.parquet")
cloud_v2 <- read_parquet("Cloud_Consolidated_v2.parquet")
cloud_v3 <- read_parquet("Cloud_Consolidated_v3.parquet")

#Data Explorer 
ThirdLevel <- read.csv("2025-Third Level Officials DepEd-cleaned.csv", stringsAsFactors = FALSE)

# dfGMIS data
dfGMIS <- read.csv("GMIS-FillingUpPerPosition-Oct2025.csv") %>% filter(GMIS.Region != "<not available>")
all_available_positions <- unique(dfGMIS$Position)

# Get unique positions for the dropdown
all_positions <- c("All Positions" = "All", 
                   sort(unique(as.character(dfGMIS$Position))))

# Calculate overall totals
overall_totals <- dfGMIS %>%
  summarise(
    Total.Filled = sum(Total.Filled, na.rm = TRUE),
    Total.Unfilled = sum(Total.Unfilled, na.rm = TRUE)
  )

# end of dfGMIS data

metric_choices <- c("Number of Schools" = "Total.Schools",
                    "Teachers" = "TotalTeachers",
                    "Teacher Shortage" = "Total.Shortage",
                    "Teacher Excess" = "Total.Excess",
                    "Enrolment" = "TotalEnrolment",
                    "Classrooms" = "Instructional.Rooms.2023.2024",
                    "Classroom Requirement" =  "Classroom.Requirement",
                    "Buildings" = "Buildings",
                    "Shifting" = "Shifting",
                    "Classroom Shortage" = "Est.CS",
                    "Major Repairs Needed" = "Major.Repair.2023.2024",
                    "Total Seats Available" = "Total.Seats.2023.2024",
                    "Total Seats Shortage" = "Total.Seats.Shortage.2023.2024",
                    "Curricular Offering" = "Modified.COC",
                    "Size Typology" = "School.Size.Typology",
                    "School Head" = "SH.Position",
                    "Ownership Type" = "OwnershipType",
                    "Electricity Source" = "ElectricitySource",
                    "Water Source" = "WaterSource",
                    "Buildable Space" = "Buidable_space")



user_base <- tibble::tibble(
  user = c("iamdeped", "depedadmin"),
  password = c("deped123", "stride123"), # In a real app, use hashed passwords
  password_hash = sapply(c("deped123", "stride123"), sodium::password_store), # Hashed passwords
  permissions = c("admin", "standard"),
  name = c("User One", "User Two")
)

SERVICE_ACCOUNT_FILE <- "service_account.json"
# Check if the file exists before attempting to authenticate
print("Checking for service_account.json...")
print(file.exists(SERVICE_ACCOUNT_FILE))

if (file.exists(SERVICE_ACCOUNT_FILE)) {
  library(googlesheets4)
  gs4_auth(
    scopes = "https://www.googleapis.com/auth/spreadsheets",
    path = SERVICE_ACCOUNT_FILE
  )
  print("googlesheets4 authenticated successfully using Service Account.")
} else {
  warning(paste("❌ Service account key not found at:", SERVICE_ACCOUNT_FILE))
}
sheet_url <- "https://docs.google.com/spreadsheets/d/1e3ni50Jcv3sBAkG8TbwBt4v7kjjMRSVvf9gxtcMiqjU/edit?gid=0#gid=0"
SHEET_ID <- "https://docs.google.com/spreadsheets/d/1x9D8xfXtkT1Mbr4M4We7I9sUqoj42X4SFX9N9hu24wM/edit?gid=0#gid=0"
SHEET_NAME <- "Sheet1" # Assuming the data is on the first tab
GUEST_SHEET_ID <- "https://docs.google.com/spreadsheets/d/1SvlP7gyfgmymo10hpstKyYs2N9jErCg5tqrmELboTRg/edit?gid=0#gid=0"



# (ui_head, ui_containers, ui_loading, ui_footer)
source("ui_parts/01_head_elements.R")
source("ui_parts/02_page_containers.R")
source("ui_parts/03_loading_overlay.R")
source("ui_parts/04_footer.R")

# Use bslib::page_fluid for the root UI, which is the standard bslib container
ui <- page_fluid(
  
  # Use shinyjs to easily show/hide elements
  shinyjs::useShinyjs(), 
  
  # Apply a clean theme (e.g., Bootstrap 5's "litera")
  theme = bs_theme(version = 5,
                   bootswatch = "litera",
                   font_scale = 0.9,
                   base_font = font_google("Alan Sans")),
  
  # --- ADD YOUR SOURCED UI PIECES ---
  ui_head,
  ui_containers,
  ui_loading,
  ui_footer
  # Note: The 'app_header' you commented out could be another file)
  
)

# MAIN SERVER CONTENT 
# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  get_dt_dom <- function(default_dom = 'lBfrtip') {
    # Check for guest status
    # We use isTRUE() to safely handle NULL values during startup
    is_guest_user <- isTRUE(authenticated_user() == "guest_user@stride")
    
    if (is_guest_user) {
      # If guest, remove 'B' (Buttons) from the dom string
      return(gsub("B", "", default_dom, fixed = TRUE))
    } else {
      # Otherwise, return the default dom string
      return(default_dom)
    }
  }
  
  # source("server_parts/01_tutorial_section.R", local = TRUE)
  source("server_parts/02_dashboard_back_button.R", local = TRUE)
  source("server_parts/03_authentication.R", local = TRUE)
  source("server_parts/04_gmis_dashboard.R", local = TRUE)
  source("server_parts/05_comprehensive_dashboard.R", local = TRUE)
  source("server_parts/06_private_schools.R", local = TRUE)
  source("server_parts/07_compredb_mapping.R", local = TRUE)
  source("server_parts/08_priority_divisions.R", local = TRUE)
  source("server_parts/09_data_input_form.R", local = TRUE)
  source("server_parts/10_stride2_UI.R", local = TRUE)
  source("server_parts/11_erdb_sidebar_mode.R", local = TRUE)
  source("server_parts/12_resource_mapping.R", local = TRUE)
  source("server_parts/13_dynamic_selectInput.R", local = TRUE)
  source("server_parts/14_cloud_multivariable.R", local = TRUE)
  source("server_parts/15_cloud_regional_profile.R", local = TRUE)
  source("server_parts/16_cloud_picker_content.R", local = TRUE)
  source("server_parts/17_efd_infra_dashboard.R", local = TRUE)
  source("server_parts/18_hrod_databuilder.R", local = TRUE)
  source("server_parts/19_third_level_db.R", local = TRUE)
  # source("server_parts/21_welcome_modal_UI.R", local = TRUE)
  source("server_parts/22_quick_school_search.R", local = TRUE)
  source("server_parts/23_plantilla_dynamic_db.R", local = TRUE)
  source("server_parts/24_renderleaflet_resource_mapping.R", local = TRUE)
  source("server_parts/25_mapping_run.R", local = TRUE)
  # source("server_parts/26_rows_selected_for_datatables.R", local = TRUE)
  source("server_parts/27_cloud_graphs_and_tables.R", local = TRUE)
  source("server_parts/28_login_page.R", local = TRUE)
  source("server_parts/31_build_your_dashboard.R", local = TRUE)
  source("server_parts/32_guest_mode.R", local = TRUE)
  #source("server_parts/33_stride2_guest_UI.R", local = TRUE)
  source("server_parts/34_home.R", local = TRUE)
  source("server_parts/AdvancedAnalytics_Server.R", local = TRUE)
  
  
  # COMMENTED PARTS
  source("server_parts/94_resource_mapping_graphs.R", local = TRUE)
  source("server_parts/95_dynamic_panel_dashboard.R", local = TRUE)
  source("server_parts/96_home_old_version.R", local = TRUE)
  source("server_parts/97_home_accordion.R", local = TRUE)
  source("server_parts/98_commented_sections.R", local = TRUE)
  source("server_parts/99_others.R", local = TRUE)
  
  # Make sure you have this in your UI definition (e.g., inside fluidPage)
  # shinyjs::useShinyjs()
  
  # ---
  
  # Home Nav panel go to dashboard button function
  # This function now redirects the browser to your index.html page
  observeEvent(input$goto_dashboard_btn, {
    
    # This is the path to your HTML file, relative to the 'www' folder.
    # Since we put it in 'www/my_dashboard/index.html',
    # the browser can find it at 'my_dashboard/index.html'.
    dashboard_url <- "my_dashboard/index.html"
    
    # This JavaScript command tells the browser to navigate to the new URL.
    # We use sprintf to safely insert the URL into the command.
    shinyjs::runjs(sprintf("window.location.href = '%s';", dashboard_url))
    
  })
  
}

source("server_parts/29_authentication_module.R", local = TRUE)
source("server_parts/30_data_input_retrieve_data.R", local = TRUE)


shinyApp(ui, server)
