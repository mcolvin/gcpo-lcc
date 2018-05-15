
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

}
