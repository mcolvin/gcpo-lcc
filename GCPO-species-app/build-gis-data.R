library(rgdal)
library(googledrive)

states<-readOGR("SpeciesLists","GCPO_States")
states<-spTransform(states, 
    CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80
    +towgs84=0,0,0"))
saveRDS(states,"_dat/states-shape.RDS")

gcpo<-readOGR("SpeciesLists","GCPO_Outline")
saveRDS(gcpo,"_dat/gcpo-shape.RDS")

HUC8<-readOGR("_dat","HUC8")
saveRDS(HUC8,"_dat/HUC8-shape.RDS")

HUC8_intersecting<-readOGR("SpeciesLists","HUC8_intersectingGCPO")
saveRDS(HUC8_intersecting,"_dat/HUC8-intersecting-shape.RDS")



library(xlsx)
sppData<- read.xlsx("C:/Users/mcolvin/Google Drive/GCPO - species lists/(5-21)SpeciesTable.xlsx",sheetName="Master_SpeciesList_GCPO")    

    par(mar=c(0,0,0,0),oma=c(0,0,0,0))
    plot(gcpo)
    plot(states,add=TRUE,border="darkgrey")
    plot(huc8,border="lightgrey",add=TRUE)
    plot(gcpo,border="black",add=TRUE)
    richness<- aggregate(CommonName~HUC8_ID+HUC8_Name,sppData,length)   
    tmp<-merge(huc8,richness, by.x="HUC8",by.y="HUC8_ID")
    tmp@data[is.na(tmp@data$CommonName),]$CommonName<-0
    tmp@data$color<- gray(1-(tmp@data$CommonName/max(tmp@data$CommonName)))
    tmp<-subset(tmp,CommonName>0)
    plot(tmp,col=tmp@data$color,border=FALSE,add=TRUE)

saveRDS(sppMeta,"_dat/sppMeta.RDS") 
sppMeta<- read.xlsx("C:/Users/mcolvin/Google Drive/GCPO - species lists/(5-21)SpeciesTable.xlsx",sheetName="Species_lookup")    
saveRDS(sppData,"_dat/sppData.RDS")    
   
    
      
    
    
    
    
    
    
    

    