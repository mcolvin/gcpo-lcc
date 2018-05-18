
dat<-read.xlsx("_dat/GarAbundance.xlsx",sheetIndex=1)

names(dat)<-c("lake","year","month","day","transect","effort",
    "spotted","shortnose","longnose","alligator")
    
for(i in 7:ncol(dat)){dat[,i]<-ifelse(dat[,i]>0,1,0)}