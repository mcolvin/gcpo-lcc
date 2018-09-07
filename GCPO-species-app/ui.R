
 navbarPage("GCPO Aquatic Species Investigator",

  tabPanel("Species Richness",
    div(class="outer",
        p("Web app is in proof of concept stage. The 
            app will be updated and modified continually and results are considered provisional."),
        p("Mouse over the HUC8 polygon for species richness information."),
        leafletOutput("map", height="600")
        )),
        
        
        
    tabPanel("Species Distribution",
        div(class="outer", 
        tags$head(includeCSS("style.css")),# Include our custom CSS
            h4("Select one or more species from the list below to plot overlapping distributions"),
            p("Mississippi and Texas are currently done and the 
                app will be updated and modified continually and results are considered provisional.."),
        p("Mouse over the HUC8 polygon for species overlap information."),
                selectInput("filter_spp",
                "Select a species",
                choices=unique(as.character(sppData$CommonName)),
                selected=NULL,
                multiple=TRUE),    
            #plotOutput("gcpo"),
            leafletOutput("map_overlap", height="600") 
            )# div
        )# tabPanel
)


