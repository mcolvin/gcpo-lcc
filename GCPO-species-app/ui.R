
 navbarPage("Superzip",

  tabPanel("Species Richness",
    div(class="outer",
        tags$head(includeCSS("style.css")),# Include our custom CSS
        leafletOutput("map", height="600")
        )),
        
        
        
    tabPanel("Species Distribution",
        div(class="outer",    
    
        selectInput("filter_spp",
            "Select a species",
            choices=unique(sppData$CommonName),
            multiple=TRUE),    
        plotOutput("gcpo")))  
)


