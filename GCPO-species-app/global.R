
trans_red<- rgb(228,16,16,alpha=40,maxColorValue=255)
library("rgdal")
states<-readRDS("data/states-shape.RDS")
gcpo<-readRDS("data/gcpo-shape.RDS")
huc8<- readRDS("data/HUC8-shape.RDS")
HUC8_intersecting<- readRDS("data/HUC8-intersecting-shape.RDS")
sppData<- readRDS("data/sppData.RDS")
sppMeta<- readRDS("data/sppData.RDS")