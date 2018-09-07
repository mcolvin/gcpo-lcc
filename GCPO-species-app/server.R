
function(input, output) {


output$gcpo <- renderPlot(
    {
    par(mar=c(0,0,0,0),oma=c(0,0,0,0))
    plot(gcpo)
    plot(states1,add=TRUE,border="darkgrey")
    plot(huc8,border="lightgrey",add=TRUE)
    for(i in input$filter_spp)
        {
        sppHucs<- subset(sppData,
            CommonName%in% i)
    #sppHucs<-unique(sppHucs$HUC8_ID )    
    plot(huc8[huc8$HUC8%in%sppHucs$HUC8_ID,],
        border=trans_red,
        col=trans_red,
       add=TRUE)
        }
    plot(gcpo,add=TRUE,border="black")
    }, height = 700, width = 1200)
  
  
  output$richness <- renderPlot(
    {
    par(mar=c(0,0,0,0),oma=c(0,0,0,0))
    plot(gcpo)
    plot(states1,add=TRUE,border="darkgrey")
    plot(huc8,border="lightgrey",add=TRUE)
    plot(gcpo,border="black",add=TRUE)
    richness<- aggregate(CommonName~HUC8_ID,sppData,length)   
    tmp<-merge(huc8,richness, by.x="HUC8",by.y="HUC8_ID")
    tmp@data[is.na(tmp@data$CommonName),]$CommonName<-0
    tmp@data$color<- gray(1-(tmp@data$CommonName/max(tmp@data$CommonName)))
    tmp<-subset(tmp,CommonName>0)
    plot(tmp,col=tmp@data$color,border=FALSE,add=TRUE)
   
    }, height = 700, width = 1200)
    
    
    ## SPECIES RICHNESS
    output$map <- renderLeaflet({    
        richness<- aggregate(CommonName~HUC8_ID,sppData,length) 
        names(richness)[2]<-"richness"
        tmp<-merge(huc8,richness, by.x="HUC8",by.y="HUC8_ID")
        tmp@data[is.na(tmp@data$richness),]$richness<-0
        tmp@data$color<- gray(1-(tmp@data$richness/max(tmp@data$richness)))
        tmp<-subset(tmp,richness>0)
        binpal <- colorNumeric(palette="YlGnBu",domain=tmp$richness)
        map<- leaflet(tmp) %>%
          addPolygons(data=states1,
            color = "#444444", weight = 1, smoothFactor = 0.5,
            opacity = 1.0, fillOpacity = 0.5,
            fillColor = "lightgrey",noClip =TRUE) %>%
           addPolygons(data=tmp,
            color=~binpal(richness),
            weight=1,
            smoothFactor=1.5,
            fillOpacity = 1,
            highlightOptions = highlightOptions(color = "white", weight = 2,
                bringToFront = TRUE),
              label=lapply(1:nrow(tmp),function(x)
                {
                HTML(paste(tmp$Name[x],"(",tmp$HUC8[x],")","<br>","Species richness: ", tmp$richness[x],sep=""))
                }))#%>%fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat))
            
            })
    ## SPECIES OVERLAPS
    filteredData <- reactive({
         if(is.null(input$filter_spp[1]))
            {       
            new<- huc8
            new@data$spp<- "None selected"
            new@data$noverlap<-0
            new@data$alpha<-  40
            new@data$alpha<- ifelse(new@data$alpha>255,255,new@data$alpha)
            new@data$pcolor<- rgb(228,16,16,alpha=new@data$alpha,maxColorValue=255) 
            return(new)
            }   
        if(input$filter_spp[1]!="None")
            {
            sppHucs<- subset(sppData,CommonName %in% input$filter_spp)
            sppHucs$tmp<-1            
            sppHucs<-reshape2::dcast(sppHucs,HUC8_ID~CommonName,value.var="tmp",sum) 
            sppHucs$spp<- NA
            indx<- c(1:ncol(sppHucs))[-c(1,length(names(sppHucs)))]
            cn<-names(sppHucs)[indx]
            for(i in 1:nrow(sppHucs))
                {
                spp<- cn[which(sppHucs[i,indx]==1)]
                if(length(spp)==1){sppHucs$spp[i]<-spp}else{sppHucs$spp[i]<-paste(spp,collapse="; ")}
                } 
            if(length(indx)>1){sppHucs$noverlap<-rowSums(sppHucs[,indx])}
            if(length(indx)==1){sppHucs$noverlap<-sppHucs[,indx]}
            sppHucs$alpha<-  40*sppHucs$noverlap
            sppHucs$alpha<- ifelse(sppHucs$alpha>255,255,sppHucs$alpha)
            sppHucs$pcolor<- rgb(228,16,16,alpha=sppHucs$alpha,maxColorValue=255) 
            new<- subset(huc8,HUC8 %in% sppHucs$HUC8_ID)
            new<-merge(new,sppHucs, by.x="HUC8",by.y="HUC8_ID")
            return(new)
            }

        
        })    
    ### MAKE MAP
    output$map_overlap <- renderLeaflet({
        leaflet(states1) %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
            opacity = 1.0, fillOpacity = 0.5,
            fillColor = "lightgrey",noClip =TRUE) %>% 
            #addTiles() %>% ## add default openstreatmap tiles
        addPolygons(data=huc8,
            color="darkgrey",
            fill=FALSE,
            weight=1,
            smoothFactor=1.5,
            label=NULL)           
        })
        
    observe({
        labs<-lapply(1:nrow(filteredData()),function(x)
                    {
                    HTML(paste("<b>",filteredData()$Name[x]," (",filteredData()$HUC8[x],")","</b><br>",
                        "<b>Number of species overlapped:</b> ",filteredData()$noverlap[x],"<br>",
                        "<b>Overlapping species:</b> ", filteredData()$spp[x],            
                        sep=""))
                    })    
        leafletProxy("map_overlap",data = filteredData()) %>%
            #clearShapes() %>%
             addPolygons(
                color=~pcolor,
                weight=1,
                smoothFactor=1.5,
                fillOpacity = 1,
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                    bringToFront = TRUE),
                  label=labs) 

  })
        
}
