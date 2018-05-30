
function(input, output) {


output$gcpo <- renderPlot(
    {
    par(mar=c(0,0,0,0),oma=c(0,0,0,0))
    plot(gcpo)
    plot(states,add=TRUE,border="darkgrey")
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
    plot(states,add=TRUE,border="darkgrey")
    plot(huc8,border="lightgrey",add=TRUE)
    plot(gcpo,border="black",add=TRUE)
    richness<- aggregate(CommonName~HUC8_ID,sppData,length)   
    tmp<-merge(huc8,richness, by.x="HUC8",by.y="HUC8_ID")
    tmp@data[is.na(tmp@data$CommonName),]$CommonName<-0
    tmp@data$color<- gray(1-(tmp@data$CommonName/max(tmp@data$CommonName)))
    tmp<-subset(tmp,CommonName>0)
    plot(tmp,col=tmp@data$color,border=FALSE,add=TRUE)
   
    }, height = 700, width = 1200)
    
    output$map <- renderLeaflet({
    
        richness<- aggregate(CommonName~HUC8_ID,sppData,length) 
        names(richness)[2]<-"richness"
        tmp<-merge(huc8,richness, by.x="HUC8",by.y="HUC8_ID")
        tmp@data[is.na(tmp@data$richness),]$richness<-0
        tmp@data$color<- gray(1-(tmp@data$richness/max(tmp@data$richness)))
        tmp<-subset(tmp,richness>0)
        binpal <- colorNumeric(palette="YlGnBu",domain=tmp$richness)
        map<- leaflet(tmp) %>%
          addPolygons(data=states,
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

}
