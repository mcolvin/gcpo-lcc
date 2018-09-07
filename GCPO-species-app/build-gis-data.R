library(rgdal)
library(googledrive)
library(rmapshaper)
states<-readOGR("_dat","GCPO_States")
states<-spTransform(states, 
    CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80
    +towgs84=0,0,0"))
simplified_shape <- ms_simplify(states)    
saveRDS(simplified_shape,"_dat/states-shape.RDS")

gcpo<-readOGR("_dat","GCPO_Outline")
simplified_shape <- ms_simplify(gcpo)
saveRDS(simplified_shape,"_dat/gcpo-shape.RDS")

HUC8<-readOGR("_dat","HUC8")
simplified_shape <- ms_simplify(HUC8)
saveRDS(simplified_shape,"_dat/HUC8-shape.RDS")

HUC8_intersecting<-readOGR("_dat","HUC8_intersectingGCPO")
simplified_shape <- ms_simplify(HUC8_intersecting)
saveRDS(simplified_shape,"_dat/HUC8-intersecting-shape.RDS")





library(xlsx)
comm<-odbcConnectExcel2007("C:/Users/mcolvin/Google Drive/GCPO - species lists/SpeciesTable.xlsx",
    readOnly = TRUE)
sppData<- read.xlsx("C:/Users/mcolvin/Google Drive/GCPO - species lists/SpeciesTable.xlsx",
    sheetName="Master_SpeciesList_GCPO")     
## odbc drops 0 in huc delineation
sppData2<- sqlFetch(comm,"Master_SpeciesList_GCPO",as.is=TRUE)  
## read meta by odbc as readxlsx is being stupid
sppMeta<- sqlFetch(comm,"Species_lookup")
sppMeta<-subset(sppMeta, !is.na(Genus))    
saveRDS(sppMeta,"_dat/sppMeta.RDS") 
saveRDS(sppData,"_dat/sppData.RDS")
 
par(mar=c(0,0,0,0),oma=c(0,0,0,0))
plot(gcpo)
plot(states,add=TRUE,border="darkgrey")
plot(HUC8,border="lightgrey",add=TRUE)
plot(gcpo,border="black",add=TRUE)
richness<- aggregate(CommonName~HUC8_ID+HUC8_Name+State,sppData,length)   
richness<- aggregate(CommonName~HUC8_ID+HUC8_Name+State,sppData2,length)   
tmp<-merge(HUC8,richness, by.x="HUC8",by.y="HUC8_ID")
tmp@data[is.na(tmp@data$CommonName),]$CommonName<-0
tmp@data$color<- gray(1-(tmp@data$CommonName/max(tmp@data$CommonName)))
tmp<-subset(tmp,CommonName>0)
plot(tmp,col=tmp@data$color,border=FALSE,add=TRUE)

    
   
    
      
    
    
    
    
    
    
    

    