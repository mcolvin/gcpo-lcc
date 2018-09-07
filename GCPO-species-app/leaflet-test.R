library(htmltools)
library(rgdal)
library(leaflet)
trans_red<- rgb(228,16,16,alpha=40,maxColorValue=255)
library(rgdal)
library(leaflet)
states<-readRDS("_dat/states-shape.RDS")
gcpo<-readRDS("_dat/gcpo-shape.RDS")
huc8<- readRDS("_dat/HUC8-shape.RDS")
HUC8_intersecting<- readRDS("_dat/HUC8-intersecting-shape.RDS")
sppData<- readRDS("_dat/sppData.RDS")
sppMeta<- readRDS("_dat/sppData.RDS")

 par(mar=c(0,0,0,0),oma=c(0,0,0,0))
    plot(gcpo)
    plot(states,add=TRUE,border="darkgrey")
    plot(huc8,border="lightgrey",add=TRUE)
    plot(gcpo,border="black",add=TRUE)
    
    
    richness<- aggregate(CommonName~HUC8_ID,sppData,length) 
    names(richness)[2]<-"richness"
    tmp<-merge(huc8,richness, by.x="HUC8",by.y="HUC8_ID")
    tmp@data[is.na(tmp@data$richness),]$richness<-0
    tmp@data$color<- gray(1-(tmp@data$richness/max(tmp@data$richness)))
    tmp<-subset(tmp,richness>0)
    plot(tmp,col=tmp@data$color,border=FALSE,add=TRUE)
    HTML(sprintf("<em>%s:</em> %s", htmlEscape(x), htmlEscape(y)))},
               tmp$HUC8, tmp$richness, SIMPLIFY = F)
    tmp$lab<-unlist(lapply(1:nrow(tmp),function(x)
        {
        HTML(paste(tmp$HUC8[x],"<br>","Species richness: ", tmp$richness[x],sep=""))
        }))
        
    binpal <- colorNumeric(palette="YlGnBu",domain=tmp$richness)
 
map<- leaflet(states) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
    opacity = 1.0, fillOpacity = 0.5,
    fillColor = "lightgrey",noClip =TRUE) %>%#,
    #highlightOptions = NULL)#highlightOptions(color = "white", weight = 2,
      #bringToFront = FALSE))
  addPolygons(data=tmp,
    color=~binpal(richness),
    weight=1,
    smoothFactor=1.5,
    #opacity = 1, 
    fillOpacity = 1,
    #fillColor="lightgreen",
      highlightOptions = highlightOptions(color = "white", weight = 2,
        bringToFront = TRUE),
      label=lapply(1:nrow(tmp),function(x)
        {
        HTML(paste(tmp$Name[x],"(",tmp$HUC8[x],")","<br>","Species richness: ", tmp$richness[x],sep=""))
        }))%>%
    addLegend("bottomright", 
        pal = binpal, 
        values = tmp$richness,
        title = "Species richness",
        opacity = 1)

map
  
library(htmlwidgets)
saveWidget(map, file="m.html")  
 


## OVERLAPPING POLYGONS
sppHucs<- subset(sppData,
            CommonName%in% c("Alabama Shad"))
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

     
map<- leaflet(states) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
    opacity = 1.0, fillOpacity = 0.5,
    fillColor = "lightgrey",noClip =TRUE) %>%
  addPolygons(data=new,
    color=~new$pcolor,
    weight=1,
    smoothFactor=1.5,
    fillOpacity = 1,
      highlightOptions = highlightOptions(color = "white", weight = 2,
        bringToFront = TRUE),
      label=lapply(1:nrow(new),function(x)
        {
        HTML(paste("<b>",new$Name[x]," (",new$HUC8[x],")","</b><br>",
            "<b>Number of species overlapped:</b> ",new$noverlap[x],"<br>",
            "<b>Overlapping species:</b> ", new$spp[x],            
            sep=""))
        }))
        
map        
        
        %>%
    addLegend("bottomright", 
        pal = binpal, 
        values = tmp$richness,
        title = "Species richness",
        opacity = 1)
