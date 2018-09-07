

library(rfishbase)
library(xlsx)
dat<-read.xlsx("Fishbase_SpeciesList.xlsx",sheetName="SpeciesList")
dat$spp<-apply(dat[,c(1,3)],1,paste, collapse=" ")
dat$id<-1:nrow(dat)

maturityData<-data.frame()
for(i in dat$id)
    {
    pp<-try(maturity(species_list = dat$spp[i]),silent=TRUE)
    if(class(pp)!="try-error")
        {
        if(nrow(pp)>0 )
            {
            pp$id<- i
            maturityData<- rbind(pp,maturityData)
            }
        }
    print(i)
    }
maturity<- merge(dat,maturityData,by="id",all=TRUE)

write.csv(maturity,"maturity.csv")


maturityData$Lm # length at maturity
maturityData$tm # age at maturity


## MAXIMUM SIZE
growthData<-data.frame()
for(i in dat$id)
    {
    pp<-try(popgrowth(species_list = dat$spp[i]),silent=TRUE)
    if(class(pp)!="try-error")
        {
        if(nrow(pp)>0 )
            {
            pp$id<- i
            growthData<- rbind(pp,growthData)
            }
        }
    print(i)
    }
as.data.frame(growthData)



## MAXIMUM SIZE
fec<-data.frame()
for(i in dat$id)
    {
    pp<-try(fecundity(species_list = dat$spp[i]),silent=TRUE)
    if(class(pp)!="try-error")
        {
        if(nrow(pp)>0 )
            {
            pp$id<- i
            fec<- rbind(pp,fec)
            }
        }
    print(i)
    }
as.data.frame(fec)