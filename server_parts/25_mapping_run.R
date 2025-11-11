# Mapping Run for Resource Mapping

observeEvent(input$Mapping_Run, {
  
  RegRCT <- input$resource_map_region
  SDORCT1 <- input$Resource_SDO
  DistRCT1 <- input$Resource_LegDist
  Lev <- input$resource_map_level
  TypeEFD <- input$EFD_Type
  
  # --- DATA PREPARATION ---
  # (Your mainreact... definitions are here)
  mainreact1 <- df %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1) %>% filter(Legislative.District == DistRCT1) %>% arrange(desc(TeacherShortage))
  mainreactreg <- df %>% filter(Region == RegRCT)
  mainreactunireg <- uni %>% filter(Region == RegRCT)
  mainreactunidiv <- uni %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1)
  mainreactdiv <- df %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1)
  mainreactNTP <- uni %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1) %>% filter(Legislative.District == DistRCT1)
  mainreactlevreg <- df %>% filter(Region == RegRCT) #%>% filter(Level == Lev)
  mainreactlevdiv <- df %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1) #%>% filter(Level == Lev)
  mainreactCR <- uni %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1) %>% filter(Legislative.District == DistRCT1) %>% distinct(SchoolID, .keep_all = TRUE) %>% arrange(desc(SBPI))
  mainreactSHS <- df %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1) %>% filter(Legislative.District == DistRCT1) %>% filter(Level == "SHS") %>% distinct(SchoolID, .keep_all = TRUE) #Remove the filter of Pilot 2 CLEA4
  mainreactind <- ind %>% filter(Region == RegRCT)
  mainreactEFD <- EFDMP %>% 
    filter(!is.na(Old.Region), Old.Region != "") %>% 
    filter(!is.na(Latitude), !is.na(Longitude)) %>% 
    mutate(Latitude = as.numeric(Latitude),
           Allocation = dollar(Allocation, prefix = "₱")) %>% # Use 'dollar' to format Allocation) %>% 
    distinct(SchoolID, FundingYear, Allocation, Category, .keep_all = TRUE) %>%
    arrange(FundingYear) %>%
    filter(Region == input$resource_map_region) %>%
    filter(Division == input$Resource_SDO) %>%
    filter(Category %in% input$EFD_Type) %>% 
    mutate(FundingCategory = factor(
      case_when(
        FundingYear < 2025 ~ "Before 2025",
        (FundingYear >= 2025 & FundingYear <= 2030) ~ "2025-2030",
        FundingYear > 2030 ~ "After 2030"
      ),
      levels = c("Before 2025", "2025-2030", "After 2030")
    ))
  mainreactLMS <- LMS %>%
    filter(LMS == 1) %>%
    left_join(buildablecsv %>% select(SCHOOL.ID,OTHER.REMARKS..Buildable.Space..), by = c("School_ID" = "SCHOOL.ID")) %>% 
    filter(Region == RegRCT) %>% filter(Division == SDORCT1)
  mainreactLMSreg <- LMS %>%
    filter(LMS == 1) %>%    # Step 1: LMS only
    left_join(buildablecsv %>% select(SCHOOL.ID,OTHER.REMARKS..Buildable.Space..), by = c("School_ID" = "SCHOOL.ID")) %>% 
    filter(Region == RegRCT)
  mainreactLMSdiv <- LMS %>%
    filter(LMS == 1) %>%    # Step 1: LMS only
    left_join(buildablecsv %>% select(SCHOOL.ID,OTHER.REMARKS..Buildable.Space..), by = c("School_ID" = "SCHOOL.ID")) %>% 
    filter(Region == RegRCT) %>% filter(Division == SDORCT1)
  mainreactCRreg <- LMS %>% 
    filter(Region == RegRCT)
  mainreactCRdiv <- LMS %>% 
    filter(Region == RegRCT) %>% filter(Division == SDORCT1)
  
  
  # --- START DEBUGGING BLOCK ---
  # We will print the column names and structure of EVERY data frame
  # used for mapping. Look for "Latitude" and "Longitude".
  
  cat("\n\n=============== MAP DATA DEBUGGER ===============\n")
  
  # --- 1. Check data for LMSMapping ---
  cat("\n--- [1] Data for LMSMapping (mainreactLMS) ---\n")
  if (exists("mainreactLMS") && !is.null(mainreactLMS) && nrow(mainreactLMS) > 0) {
    cat("Column Names:\n")
    print(colnames(mainreactLMS))
    cat("\nStructure:\n")
    print(str(mainreactLMS[, c("School_Name", "Latitude", "Longitude")], 
              list.len = 5)) # Only show relevant columns
  } else {
    cat("Data is NULL or has 0 rows!\n")
  }
  
  # --- 2. Check data for SHSMapping (Schools) ---
  cat("\n--- [2] Data for SHSMapping (Schools: mainreactSHS) ---\n")
  if (exists("mainreactSHS") && !is.null(mainreactSHS) && nrow(mainreactSHS) > 0) {
    cat("Column Names:\n")
    print(colnames(mainreactSHS))
    cat("\nStructure:\n")
    print(str(mainreactSHS[, c("School.Name", "Latitude", "Longitude")], 
              list.len = 5))
  } else {
    cat("Data is NULL or has 0 rows!\n")
  }
  
  # --- 3. Check data for SHSMapping (Industry) ---
  cat("\n--- [3] Data for SHSMapping (Industry: mainreactind) ---\n")
  if (exists("mainreactind") && !is.null(mainreactind) && nrow(mainreactind) > 0) {
    cat("Column Names:\n")
    print(colnames(mainreactind))
    cat("\nStructure:\n")
    # Assuming 'Company' is a column, adjust if needed
    print(str(mainreactind[, c("Company", "Latitude", "Longitude")], 
              list.len = 5)) 
  } else {
    cat("Data is NULL or has 0 rows!\n")
  }
  
  # --- 4. Check data for CLMapping ---
  cat("\n--- [4] Data for CLMapping (mainreactCR) ---\n")
  if (exists("mainreactCR") && !is.null(mainreactCR) && nrow(mainreactCR) > 0) {
    cat("Column Names:\n")
    print(colnames(mainreactCR))
    cat("\nStructure:\n")
    print(str(mainreactCR[, c("School.Name", "Latitude", "Longitude")], 
              list.len = 5))
  } else {
    cat("Data is NULL or has 0 rows!\n")
  }
  
  # --- 5. Check data for AO2Mapping & CongestMapping ---
  cat("\n--- [5] Data for AO2/Congest Maps (mainreactNTP) ---\n")
  if (exists("mainreactNTP") && !is.null(mainreactNTP) && nrow(mainreactNTP) > 0) {
    cat("Column Names:\n")
    print(colnames(mainreactNTP))
    cat("\nStructure:\n")
    print(str(mainreactNTP[, c("School.Name", "Latitude", "Longitude")], 
              list.len = 5))
  } else {
    cat("Data is NULL or has 0 rows!\n")
  }
  
  # --- 6. Check data for TeacherShortage_Mapping ---
  cat("\n--- [6] Data for TeacherShortage_Mapping (mainreact1) ---\n")
  if (exists("mainreact1") && !is.null(mainreact1) && nrow(mainreact1) > 0) {
    cat("Column Names:\n")
    print(colnames(mainreact1))
    cat("\nStructure:\n")
    print(str(mainreact1[, c("School.Name", "Latitude", "Longitude")], 
              list.len = 5))
  } else {
    cat("Data is NULL or has 0 rows!\n")
  }
  
  # --- 7. Check data for FacMapping ---
  cat("\n--- [7] Data for FacMapping (mainreactEFD) ---\n")
  if (exists("mainreactEFD") && !is.null(mainreactEFD) && nrow(mainreactEFD) > 0) {
    cat("Column Names:\n")
    print(colnames(mainreactEFD))
    cat("\nStructure:\n")
    print(str(mainreactEFD[, c("School.Name", "Latitude", "Longitude")], 
              list.len = 5))
  } else {
    cat("Data is NULL or has 0 rows!\n")
  }
  
  cat("\n=============== END DEBUGGING ===============\n\n")
  
  # --- END DEBUGGING BLOCK ---
  
  
  
  # --- POPUP AND LABEL CREATION ---
  # (Your original code for values... and leafletProxy calls)
  
  values.LMS <- paste(
    "School Name:",mainreactLMS$School_Name,
    "<br>Division:", mainreactLMS$Division,
    "<br>Leg. District:", mainreactLMS$Legislative_District,
    "<br>Number of Classrooms:", mainreactLMS$Instructional_Rooms,
    "<br>Classroom Requirement:", mainreactLMS$CL_Req,
    "<br>Estimated Classroom Shortage:", mainreactLMS$Estimated_CL_Shortage,
    "<br>Buildable Space:", ifelse(mainreactLMS$Buildable_space == 1, "Yes", "No")) %>% lapply(htmltools::HTML)
  
  
  # This validate() line will STOP execution if the columns are missing
  # This is a safer way to prevent the crash
  validate(
    need(
      "Longitude" %in% colnames(mainreactLMS) && "Latitude" %in% colnames(mainreactLMS),
      "Error: LMSMapping data is missing Latitude or Longitude columns."
    )
  )
  
  leafletProxy("LMSMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(
      lng = mainreactLMS$Longitude[1],
      lat = mainreactLMS$Latitude[1],
      zoom = 7
    ) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 12),
      lng = mainreactLMS$Longitude,
      lat = mainreactLMS$Latitude,
      icon = makeAwesomeIcon(icon = "education", library = "glyphicon",
                             markerColor = case_when(
                               (mainreactLMS$Buildable_space == 0 & mainreactLMS$Estimated_CL_Shortage == 0) ~ "gray",
                               mainreactLMS$Buildable_space == 0 ~ "red", # Corrected to '=='
                               mainreactLMS$Buildable_space == 1 ~ "green", # Corrected to '=='
                             )),
      label = values.LMS,
      labelOptions = labelOptions(noHide = F, textsize = "12px", direction = "top")
    )
  
  df1 <- reactive({
    
    if (is.null(input$LMSMapping_bounds)) {
      mainreactLMS
    } else {
      bounds <- input$LMSMapping_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(mainreactLMS,
             Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
    }
  })
  
  
  output$LMSTable <- renderDT(server = FALSE, {
    
    # ... (LMSTable code) ...
    
    # Final select
    finalLMS <- df1() %>%
      # 1. Convert Buildable_space from 1/0 to "Yes"/"No"
      dplyr::mutate(
        Buildable_space = dplyr::if_else(Buildable_space == 1, "Yes", "No")
      ) %>%
      # 2. Select the desired columns
      dplyr::select(
        School_Name,
        Total_Enrollment,
        Instructional_Rooms,
        Estimated_CL_Shortage,
        Buildable_space
      ) %>%
      # 3. Rename columns for display
      dplyr::rename(
        "School Name" = School_Name,
        "Total Enrolment" = Total_Enrollment,,
        "Classrooms Inventory" = Instructional_Rooms,
        "Classroom Shortage" = Estimated_CL_Shortage,
        "Buildable Space" = Buildable_space
      )
    
    datatable(
      finalLMS,
      options = list(scrollX = TRUE, pageLength = 10, dom = get_dt_dom('Bfrtip'),
                     buttons = list('csv', 'excel', 'pdf', 'print'), columnDefs = list(list(className = 'dt-center', targets = "_all"))),
      selection = "single",  # allow single row selection
      extension = 'Buttons',
      rownames = FALSE,
      callback = JS("window.dispatchEvent(new Event('resize'));") # Final closing parenthesis was missing
    )
  })
  
  
  NetShortage <- df %>% select(Region,Division,Level,TeacherShortage,TeacherExcess) %>%
    pivot_longer(cols = c(TeacherShortage, TeacherExcess), names_to = "Inventory", values_to = "Count") %>% mutate(Count=as.numeric(Count)) %>% na.omit(Count) %>% group_by(Region, Division,Level, Inventory) %>% summarize(Count = sum(Count)) %>% pivot_wider(names_from = "Inventory", values_from = "Count") %>% mutate(NetShortage=TeacherShortage-TeacherExcess) %>% mutate(NetShortage = ifelse(NetShortage < 0, 0, NetShortage))
  
  SDONetShortage <- NetShortage %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1) #%>% filter(Level == Lev)
  
  values_teacher_shortage <- paste(mainreact1$School.Name,"<br>Teacher Excess:", mainreact1$TeacherExcess,"<br>Teacher Shortage:", mainreact1$TeacherShortage) %>% lapply(htmltools::HTML)
  
  values_teacher_shortage_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreact1$School.Name,"<br>School ID:",mainreact1$SchoolID,"<br>Enrolment Size:",mainreact1$TotalEnrolment,"<br>","<br>",strong("TEACHING PERSONNEL DATA"),"<br>Teacher Inventory:", mainreact1$TotalTeachers,"<br>Teacher Excess:", mainreact1$TeacherExcess,"<br>Teacher Shortage:", mainreact1$TeacherShortage,"<br>","<br>",strong("SPECIALIZATION DATA"),"<br>English:", mainreact1$English,"<br>Mathematics:", mainreact1$Mathematics,"<br>Science:", mainreact1$Science,"<br>Biological Science:", mainreact1$Biological.Sciences,"<br>Physical Sciences:", mainreact1$Physical.Sciences,"<br>General Education:", mainreact1$General.Ed,"<br>Araling Panlipunan:", mainreact1$Araling.Panlipunan,"<br>TLE:", mainreact1$TLE,"<br>MAPEH:", mainreact1$MAPEH,"<br>Filipino:", mainreact1$Filipino,"<br>ESP:", mainreact1$ESP,"<br>Agriculture:", mainreact1$Agriculture,"<br>ECE:", mainreact1$ECE,"<br>SPED:", mainreact1$SPED) %>% lapply(htmltools::HTML)
  
  values.non_teaching <- mainreactNTP$School.Name %>% lapply(htmltools::HTML)
  
  values.non_teaching_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactNTP$School.Name,"<br>School ID:",mainreactNTP$SchoolID,"<br>Enrolment Size:",mainreactNTP$TotalEnrolment,"<br>","<br>",strong("TEACHING PERSONNEL DATA"),"<br>Teacher Inventory:", mainreactNTP$TotalTeachers,"<br>Teacher Excess:", mainreactNTP$TeacherExcess,"<br>Teacher Shortage:", mainreactNTP$TeacherShortage,"<br>","<br>",strong("NON-TEACHING PERSONNEL DATA"),"<br>Plantilla Number of AOII:", mainreactNTP$Plantilla.Number,"<br>Clustering Status:", mainreactNTP$Clustering.Status,"<br>PDO I Deployment:", mainreactNTP$PDOI_Deployment) %>% lapply(htmltools::HTML)
  
  values_classrooom_shortage <- paste(mainreactCR$School.Name,"<br>Total Enrolment:",mainreactCR$Enrolment.2023.2024 ,"<br>Classroom Inventory:", mainreactCR$Instructional.Rooms.2023.2024, "<br>Classroom Shortage:", mainreactCR$Est.CS) %>% lapply(htmltools::HTML)
  
  values_classrooom_shortage_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactCR$School.Name,"<br>School ID:",mainreactCR$SchoolID,"<br>Enrolment Size:",mainreactCR$TotalEnrolment,"<br>","<br>",strong("CLASSROOM DATA"),"<br>Estimate Classroom Shortage:", mainreactCR$Est.CS,"<br>Type of Ownership:", mainreactCR$OwnershipType,"<br>Shifting:", mainreactCR$Shifting,"<br>Electricity Source:", mainreactCR$ElectricitySource,"<br>Water Source:", mainreactCR$WaterSource) %>% lapply(htmltools::HTML)
  
  values.efdmasterlist <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactEFD$School.Name,"<br>School ID:",mainreactEFD$SchoolID,"<br>Category:",mainreactEFD$Category,"<br>Funding Year:",mainreactEFD$FundingYear,"<br>Allocation:",mainreactEFD$Allocation) %>% lapply(htmltools::HTML)
  
  
  values_industry <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactSHS$School.Name,"<br>School ID:",mainreactSHS$SchoolID) %>% lapply(htmltools::HTML)
  
  values.ind <- paste(mainreactind$Company,"<br>Province:",mainreactind$Province) %>% lapply(htmltools::HTML)
  
  # --- More validate() checks ---
  validate(
    need(
      "Longitude" %in% colnames(mainreactSHS) && "Latitude" %in% colnames(mainreactSHS),
      "Error: SHSMapping (Schools) data is missing Latitude or Longitude."
    ),
    need(
      "Longitude" %in% colnames(mainreactind) && "Latitude" %in% colnames(mainreactind),
      "Error: SHSMapping (Industry) data is missing Latitude or Longitude."
    )
  )
  
  leafletProxy("SHSMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(
      lng = mainreactSHS$Longitude[1],
      lat = mainreactSHS$Latitude[1],
      zoom = 7
    ) %>%
    
    # --- SHS Schools (always orange university icons) ---
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = mainreactSHS$Longitude,
      lat = mainreactSHS$Latitude,
      icon = makeAwesomeIcon(
        icon = "university",
        library = "fa",
        markerColor = "orange"  
      ),
      label = values_industry,
      labelOptions = labelOptions(
        noHide = FALSE,
        textsize = "12px",
        direction = "top",
        fill = TRUE,
        style = list("border-color" = "rgba(0,0,0,0.5)")
      )
    ) %>%
    
    # --- Industry markers (cog icons, colored by sector) ---
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 12),
      lng = mainreactind$Longitude,
      lat = mainreactind$Latitude,
      icon = makeAwesomeIcon(
        icon = "cog",
        library = "fa",
        markerColor = dplyr::case_when(
          mainreactind$Sector == "Manufacturing and Engineering"     ~ "red",
          mainreactind$Sector == "Hospitality and Tourism"           ~ "orange",
          mainreactind$Sector == "Professional/Private Services"     ~ "purple",
          mainreactind$Sector == "Public Administration"             ~ "green",
          mainreactind$Sector == "Business and Finance"              ~ "blue",
          mainreactind$Sector == "Agriculture and Agri-business"     ~ "pink",
          TRUE                                                      ~ "gray"
        )
      ),
      label = values.ind,
      labelOptions = labelOptions(
        noHide = FALSE,
        textsize = "12px",
        direction = "top"
      )
    )
  
  # --- Update markers with leafletProxy ---
  observe({
    req(mainreactCR)
    
    # --- Add validate() here too ---
    validate(
      need(
        "Longitude" %in% colnames(mainreactCR) && "Latitude" %in% colnames(mainreactCR),
        "Error: CLMapping data is missing Latitude or Longitude."
      )
    )
    
    icons <- awesomeIcons(
      icon = "university",
      library = "fa",
      markerColor = case_when(
        suppressWarnings(as.numeric(mainreactCR$Est.CS)) > 0 ~ "red",
        TRUE ~ "green"
      ),
      iconColor = "white"
    )
    
    leafletProxy("CLMapping") %>%
      clearMarkers() %>%
      clearMarkerClusters() %>%
      setView(
        lng = mainreactCR$Longitude[1],
        lat = mainreactCR$Latitude[1],
        zoom = 7
      ) %>%
      addAwesomeMarkers(
        clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
        lng = mainreactCR$Longitude,
        lat = mainreactCR$Latitude,
        popup = values_classrooom_shortage_popup,
        options = popupOptions(),
        label = values_classrooom_shortage,
        labelOptions = labelOptions(
          noHide = FALSE,
          textsize = "12px",
          direction = "top"
        ),
        icon = icons
      )
  })
  
  validate(
    need(
      "Longitude" %in% colnames(mainreactNTP) && "Latitude" %in% colnames(mainreactNTP),
      "Error: AO2Mapping data is missing Latitude or Longitude."
    )
  )
  
  leafletProxy("AO2Mapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(lng = mainreactNTP$Longitude[1], lat = mainreactNTP$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = mainreactNTP$Longitude,
      lat = mainreactNTP$Latitude,
      popup = values.non_teaching_popup,
      options = popupOptions(),
      label = values.non_teaching,
      labelOptions = labelOptions(noHide = FALSE, textsize = "12px", direction = "top"),
      icon = makeAwesomeIcon(
        icon = "user",
        library = "fa",
        markerColor = case_when(
          mainreactNTP$Clustering.Status %in% c("Dedicated","Clustered") & mainreactNTP$PDOI_Deployment == "With PDO I" ~ "green",
          mainreactNTP$Clustering.Status %in% c("Dedicated","Clustered") & mainreactNTP$PDOI_Deployment == "Without PDO I" ~ "orange",
          mainreactNTP$Clustering.Status == "None Deployed" & mainreactNTP$PDOI_Deployment == "With PDO I" ~ "orange",
          mainreactNTP$Clustering.Status == "None Deployed" & mainreactNTP$PDOI_Deployment == "Without PDO I" ~ "red",
          TRUE ~ "lightgray"
        )
      )
    )
  
  validate(
    need(
      "Longitude" %in% colnames(mainreact1) && "Latitude" %in% colnames(mainreact1),
      "Error: TeacherShortage_Mapping data is missing Latitude or Longitude."
    )
  )
  
  leafletProxy("TeacherShortage_Mapping") %>% clearMarkers() %>% clearMarkerClusters() %>% setView(lng = mainreact1$Longitude[1], lat = mainreact1$Latitude[1], zoom = 7) %>% 
    addAwesomeMarkers(clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15), lng = mainreact1$Longitude, lat = mainreact1$Latitude, popup = values_teacher_shortage_popup, options = popupOptions(), label = values_teacher_shortage, labelOptions = labelOptions(noHide = F, textsize = "12px", direction = "top"), icon = makeAwesomeIcon(icon = "education", library = "glyphicon", markerColor = case_when(mainreact1$TeacherShortage > 0 ~ "red", mainreact1$TeacherExcess > 0 ~ "blue", (mainreact1$TeacherExcess == 0 & mainreact1$TeacherShortage == 0) ~ "green", is.na(mainreact1$TeacherShortage) ~ "gray")))
  
  dfreact_TS <- reactive({
    
    if (is.null(input$TeacherShortage_Mapping_bounds)) {
      mainreact1
    } else {
      bounds <- input$TeacherShortage_Mapping_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(mainreact1,
             Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
    }
  })
  
  output$TeacherShortage_Table <- DT::renderDT(server = FALSE, {datatable(dfreact_TS() %>% select("School.Name","TeacherShortage","TeacherExcess") %>% rename("School" = School.Name, "Shortage" = TeacherShortage, "Excess" = TeacherExcess), extension = 'Buttons', rownames = FALSE, options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))})
  
  # ... (All your renderValueBox and other outputs) ...
  
  output$a <- renderValueBox({
    valueBox(tags$p(strong(SDO[which(SDO$Region==RegRCT & SDO$Division==SDORCT1),"FillUpRate"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$b <- renderValueBox({
    valueBox(tags$p(strong(SDO[which(SDO$Region==RegRCT & SDO$Division==SDORCT1),"Unfilled"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
    
  })
  
  output$e <- renderValueBox({
    valueBox(tags$p(strong(SDONetShortage$NetShortage), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
    
  })
  
  output$c <- renderValueBox({
    valueBox(tags$p(strong(sum(df1()$TeacherExcess)), style = "font-size: 65%;"), subtitle = NULL)
    
  })
  
  output$d <- renderValueBox({
    valueBox(tags$p(strong("-"), style = "font-size: 65%;"), subtitle = NULL)})
  
  output$f <- renderValueBox({
    valueBox(tags$p(strong(SDO[which(SDO$Division==RegRCT),"FillUpRate"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$g <- renderValueBox({
    valueBox(tags$p(strong(SDO[which(SDO$Division==RegRCT),"Unfilled"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
    
  })
  
  output$Single <- renderValueBox({
    valueBox(strong(sum(mainreactdiv$Clustering.Status == "NOT CLUSTERED")), subtitle = strong("Number of Unclustered Schools (Division)"), icon = icon("users"), color = "green")
  })
  
  output$Cluster <- renderValueBox({
    valueBox(strong(sum(mainreactdiv$Clustering.Status == "CLUSTERED")), subtitle = strong("Number of Clustered Schools (Division)"), icon = icon("school"), color = "green")
  })
  
  output$Outlier <- renderValueBox({
    valueBox(strong(sum(mainreactdiv$Clustering.Status == "Outlier")), subtitle = strong("Number of Outlier Schools (Division)"), icon = icon("school"), color = "green")
  })
  
  output$SingleR <- renderValueBox({
    valueBox(strong(sum(mainreactreg$Clustering.Status == "NOT CLUSTERED")), subtitle = strong("Number of Unclustered Schools (Region)"), icon = icon("users"), color = "navy")
  })
  
  output$ClusterR <- renderValueBox({
    valueBox(strong(sum(mainreactreg$Clustering.Status == "CLUSTERED")), subtitle = strong("Number of Clustered Schools (Region)"), icon = icon("school"), color = "navy")
  })
  
  output$OutlierR <- renderValueBox({
    valueBox(strong(sum(mainreactreg$Clustering.Status == "Outlier")), subtitle = strong("Number of Outlier Schools (Region)"), icon = icon("school"), color = "navy")
  })
  
  Ao21 <- reactive({
    
    if (is.null(input$AO2Mapping_bounds)) {
      mainreactNTP
    } else {
      bounds <- input$AO2Mapping_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(mainreactNTP,
             Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
    }
  })
  
  output$AO2Table <- DT::renderDT(Ao21() %>% select("School.Name","Clustering.Status","PDOI_Deployment") %>% rename("School" = School.Name, "AO II Deployment" = Clustering.Status, "PDOI Deployment" = PDOI_Deployment), rownames = FALSE, filter = 'top', options = list(scrollX = TRUE, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))
  
  output$f2 <- renderValueBox({
    valueBox(tags$p(strong(sum(mainreactreg$Clustering.Status == "Clustered")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$g2 <- renderValueBox({
    valueBox(tags$p(strong(sum(mainreactreg$Clustering.Status == "Dedicated")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$a2 <- renderValueBox({
    valueBox(tags$p(strong(sum(mainreactdiv$Clustering.Status == "Clustered")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$b2 <- renderValueBox({
    valueBox(tags$p(strong(sum(mainreactdiv$Clustering.Status == "Dedicated")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$e2 <- renderValueBox({
    valueBox(tags$p(strong(sum(mainreactNTP$Clustering.Status == "Clustered")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$h2 <- renderValueBox({
    valueBox(tags$p(strong(sum(mainreactNTP$Clustering.Status == "Dedicated")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$ROCRShort <- renderValueBox({
    valueBox(tags$p(strong(sum(mainreactCRreg$Estimated_CL_Shortage, na.rm = TRUE)), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$SDOCRShort <- renderValueBox({
    valueBox(tags$p(strong(sum(mainreactCRdiv$Estimated_CL_Shortage, na.rm = TRUE)), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  #output$DistCRShort <- renderValueBox({
  #valueBox(tags$p(strong(sum(mainreactNTP$Est.CS, na.rm = TRUE)), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  #})
  
  # --- Total Last Mile Schools by Region ---
  output$LMS_Total_Region <- renderValueBox({
    total_region_lms <- nrow(mainreactLMSreg)  # <-- adjust dataset/column name if needed
    
    valueBox(
      tags$p(
        strong(scales::comma(total_region_lms)),
        style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"),
      subtitle = NULL
    )
  })
  
  
  # --- Total Last Mile Schools by Division ---
  output$LMS_Total_Division <- renderValueBox({
    total_division_lms <-    nrow(mainreactLMSdiv)  # <-- adjust dataset/column name if needed
    
    valueBox(
      tags$p(
        strong(scales::comma(total_division_lms)),
        style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"),
      subtitle = NULL
    )
  })
  
  
  dfreact_CL <- reactive({
    
    if (is.null(input$CLMapping_bounds)) {
      mainreactCR
    } else {
      bounds <- input$CLMapping_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(mainreactCR,
             Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
    }
  })
  
  output$CLTable <- DT::renderDT(server = FALSE, {datatable(dfreact_CL() %>% select("School.Name","Enrolment.2023.2024","Instructional.Rooms.2023.2024","Est.CS","Buidable_space") %>% rename("School" = School.Name, "Total Enrolment" = Enrolment.2023.2024, "Classroom Inventory" = Instructional.Rooms.2023.2024, "Estimate Classroom Shortage" = Est.CS, "Buildable Space" = Buidable_space), filter = 'top', options = list(scrollX = TRUE,scrollY= "300px", columnDefs = list(list(className = 'dt-center', targets ="_all")), rownames = FALSE, dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))})
  
  dfreact_SHS <- reactive({
    
    if (is.null(input$SHSMapping_bounds)) {
      mainreactSHS
    } else {
      bounds <- input$SHSMapping_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(mainreactSHS,
             Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
    }
  })
  
  output$SHSListTable <- DT::renderDT(server = FALSE, {datatable(dfreact_SHS() %>% select("School.Name", "TotalEnrolment") %>% rename("School" = School.Name, "Total Enrolment" = TotalEnrolment), extension = 'Buttons', rownames = FALSE, options = list(scrollX = TRUE, pageLength = 5, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))})
  
  output$SHSCount <- renderValueBox({
    valueBox(tags$p(strong(nrow(mainreactSHS)), style = "font-size: 100%; text-align: center;"), subtitle = NULL)})
  
  SHS_count_reactive <- eventReactive(input$Mapping_Run, {
    
    mainvalue <- df %>% 
      filter(Region == input$resource_map_region) %>% 
      filter(Level == "SHS")
    
    # This returns the COUNT (a single number)
    return(nrow(mainvalue))
  })
  
  output$SHSCountUniv <- renderValueBox({
    valueBox(tags$p(strong(SHS_count_reactive()), style = "font-size: 100%; text-align: center;"), subtitle = NULL)})
  
  output$IndCount <- renderValueBox({
    valueBox(tags$p(strong(nrow(mainreactind)), style = "font-size: 100%; text-align: center;"), subtitle = NULL)})
  
  output$assessmentSHS <- renderUI({
    p(HTML(paste(strong(RegRCT),"has",strong(nrow(mainreactSHS)),"senior high schools and a total of ",strong(nrow(mainreactind)),"industries composed of",strong(sum(mainreactind$Sector == "Food Establishments")),"industries on Food Establishments, ",strong(sum(mainreactind$Sector == "Professional/Private Services")),"industries on Professional/Private Services, ",strong(sum(mainreactind$Sector == "Transportation")),"industries on Transportation, ",strong(sum(mainreactind$Sector == "Utilities")),"industries on Utilities",", and",strong(sum(mainreactind$Sector == "Retail")),"industries on Retail")), style = "font-family: Century Gothic; font-size: 15px; color: #111111;")
  })
  
  color_palette <- colorFactor(
    palette = c("red", "green", "blue"),
    domain = mainreactEFD$FundingCategory,
    levels = levels(mainreactEFD$FundingCategory) # Ensure the order is respected
  )
  
  validate(
    need(
      "Longitude" %in% colnames(mainreactEFD) && "Latitude" %in% colnames(mainreactEFD),
      "Error: FacMapping data is missing Latitude or Longitude."
    )
  )
  
  # 3. Use the new factor variable and color palette in your leaflet code
  leafletProxy("FacMapping", data = mainreactEFD) %>%
    clearMarkers() %>%
    clearControls() %>%
    setView(lng = mainreactEFD$Longitude[1], lat = mainreactEFD$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = ~Longitude,
      lat = ~Latitude,
      popup = values.efdmasterlist,
      icon = makeAwesomeIcon(
        icon = "education",
        library = "glyphicon",
        markerColor = case_when(mainreactEFD$FundingCategory == "Before 2025" ~ "red", mainreactEFD$FundingCategory == "2025-2030" ~ "green", mainreactEFD$FundingCategory == "After 2030" ~ "blue") # Use the new factor variable
      )
    ) %>%
    addLegend(
      "bottomright",
      pal = color_palette,
      values = ~FundingCategory, # Use the new factor variable
      title = "Funding Year",
      opacity = 1
    )
  
  dfreact_fac <- reactive({
    if (is.null(input$FacMapping_bounds)) {
      mainreactEFD
    } else {
      bounds <- input$FacMapping_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(mainreactEFD,
             Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
    }
  })
  
  output$FacTable <- DT::renderDT(server = FALSE, {
    datatable(dfreact_fac() %>% 
                select("Region","Division","School.Name","FundingYear","Allocation") %>%
                rename("School" = School.Name, "Funding Year" = FundingYear),
              extension = 'Buttons',
              rownames = FALSE,
              options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))
  })
  
  color_palette_cong <- colorFactor(
    palette = c("red", "green", "blue"),
    domain = mainreactNTP$Congestion.Index,
    levels = levels(mainreactNTP$Congestion.Index) # Ensure the order is respected
  )
  
  values.congest <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactNTP$School.Name,"<br>School ID:",mainreactNTP$SchoolID,"<br>Instructional Rooms (2023-2024):",mainreactNTP$Instructional.Rooms.2023.2024,"<br>Enrolment (2023-2024):",mainreactNTP$Enrolment.2023.2024,"<br>Congestion Index:",mainreactNTP$Congestion.Index) %>% lapply(htmltools::HTML)
  
  validate(
    need(
      "Longitude" %in% colnames(mainreactNTP) && "Latitude" %in% colnames(mainreactNTP),
      "Error: CongestMapping data is missing Latitude or Longitude."
    )
  )
  
  # 3. Use the new factor variable and color palette in your leaflet code
  leafletProxy("CongestMapping", data = mainreactNTP) %>%
    clearMarkers() %>%
    clearControls() %>%
    setView(lng = mainreactNTP$Longitude[1], lat = mainreactNTP$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = ~Longitude,
      lat = ~Latitude,
      label = values.congest,
      icon = makeAwesomeIcon(
        icon = "education",
        library = "glyphicon",
        markerColor = case_when(mainreactNTP$Congestion.Index >= 0 & mainreactNTP$Congestion.Index < 0.25 ~ "green", mainreactNTP$Congestion.Index >= 0.25 & mainreactNTP$Congestion.Index < 0.5 ~ "green", mainreactNTP$Congestion.Index >= 0.5 & mainreactNTP$Congestion.Index < 0.75 ~ "orange",mainreactNTP$Congestion.Index >= 0.75 ~ "red")))
  
  dfreact_cong <- reactive({
    if (is.null(input$CongestMapping_bounds)) {
      mainreactNTP %>% arrange(desc(Congestion.Index))
    } else {
      bounds <- input$CongestMapping_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(mainreactNTP,
             Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
    }
  })
  
  output$CongestTable <- DT::renderDT(server = FALSE, {
    datatable(dfreact_cong() %>% 
                select("Region","Division","School.Name","Instructional.Rooms.2023.2024","Enrolment.2023.2024","Congestion.Index") %>%
                rename("School" = School.Name, "Instructional Rooms" = Instructional.Rooms.2023.2024, "Total Enrolment" = Enrolment.2023.2024, "Congestion Index" = Congestion.Index),
              extension = 'Buttons',
              rownames = FALSE,
              options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))
  })
  
})
