


navbarPage("Stuff",
    tabPanel("Species Richness",
        plotOutput("richness")),
    tabPanel("Species Distribution",
        selectInput("filter_spp",
            "Select a species",
            choices=unique(sppData$CommonName),
            multiple=TRUE),    
        plotOutput("gcpo"))       
        
        )
