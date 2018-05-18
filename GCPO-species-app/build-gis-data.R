library(rgdal)
library(googledrive)

states<-readOGR("SpeciesLists","GCPO_States")
states<-spTransform(states, 
    CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80
    +towgs84=0,0,0"))
saveRDS(states,"_dat/states-shape.RDS")

gcpo<-readOGR("SpeciesLists","GCPO_Outline")
saveRDS(gcpo,"_dat/gcpo-shape.RDS")

HUC8<-readOGR("SpeciesLists","HUC8")
saveRDS(HUC8,"_dat/HUC8-shape.RDS")

HUC8_intersecting<-readOGR("SpeciesLists","HUC8_intersectingGCPO")
saveRDS(HUC8_intersecting,"_dat/HUC8-intersecting-shape.RDS")





par(mar=c(0,0,0,0),oma=c(0,0,0,0))
plot(states)
plot(gcpo,add=TRUE)
plot(HUC8[HUC8$HUC8==12040103,],
    add=TRUE,col="lightgrey")



library(xlsx)
sppData<- read.xlsx("C:/Users/mcolvin/Google Drive/GCPO - species lists/(5-14)Master_SpeciesLists.xlsx",sheetName="Master_SpeciesList_GCPO")    
sppMeta<- read.xlsx("C:/Users/mcolvin/Google Drive/GCPO - species lists/(5-14)Master_SpeciesLists.xlsx",sheetName="Species_lookup")    
saveRDS(sppData,"_dat/sppData.RDS")    
saveRDS(sppMeta,"_dat/sppMeta.RDS")    
    
    
    
    
    
    
    
    
    
    
    
    
sppData<-data.frame(huc8=HUC8$HUC8)
sppData$species<-sample(c(0,1),
    nrow(sppData),replace=TRUE)
for(ss in 2:5)
    {
    tmp<-sppData
    tmp$species<-sample(c(0,ss),
        nrow(sppData),replace=TRUE)
    sppData<-rbind(sppData,tmp)
    }

sppData<-sppData[which(sppData$species>0),]

saveRDS(sppData,"sppData.RDS")
    
    