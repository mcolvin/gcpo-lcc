
build<- function(fileName,bld="PAGE",docs=FALSE)
    {# BUILD: PAGE, ENTIRE, SCRIPT
    if(bld=="PAGE" & docs ==FALSE)
        {
        library(knitr)
        rmarkdown::render_site(paste(fileName,
            ".Rmd",sep=""))# build website
        } else
    if(bld=="ENTIRE" & docs ==FALSE)
        {
        library(knitr)
        rmarkdown::render_site()# build webpage
        } else
    if(bld=="SCRIPT" & docs ==FALSE)
        {
        ## PURL R CODE FROM CLASS NOTES
        p<- knitr::purl(paste(fileName,
            ".Rmd",sep=""))
        knitr::read_chunk(p)
        chunks <- knitr:::knit_code$get()
        chunkss<- lapply(1:length(chunks),
            function(x){if(!(names(chunks[x]) %in% c("echo=FALSE" ,"eval=FALSE"))){c(paste0("## ----", names(chunks)[x] ,"---- ##"),chunks[[x]]," "," "," ")}})
        xxx<- unlist(chunkss)
        fp<- paste("./scripts/", fileName,".R",
            sep="")
        writeLines(xxx,fp)
        system(paste("xcopy",
            '"C:/Users/mcolvin/Documents/Teaching/WFA8433-Natural-Resource-Decision-Making/Course-Materials/_site"',     
            '"C:/Users/mcolvin/Documents/Teaching/WFA8433-Natural-Resource-Decision-Making/Docs"',     "/E /C /H /R /K /O /Y")) 
        } else
     if(bld=="PAGE" & docs ==TRUE)
        {
        library(knitr)
        rmarkdown::render_site(paste(fileName,
            ".Rmd",sep=""))# build website
        system(paste("xcopy",'"C:/Users/mcolvin/Documents/Teaching/WFA8433-Natural-Resource-Decision-Making/Course-Materials/_site"',     '"C:/Users/mcolvin/Documents/Teaching/WFA8433-Natural-Resource-Decision-Making/Docs"',     "/E /C /H /R /K /O /Y")) 
       
        } else
    if(bld=="ENTIRE" & docs ==TRUE)
        {
        library(knitr)
        rmarkdown::render_site()# build webpage
        system(paste("xcopy",
            '"C:/Users/mcolvin/Documents/Teaching/WFA8433-Natural-Resource-Decision-Making/Course-Materials/_site"',     
            '"C:/Users/mcolvin/Documents/Teaching/WFA8433-Natural-Resource-Decision-Making/Docs"',     "/E /C /H /R /K /O /Y")) 
       
        } else
    if(bld=="SCRIPT" & docs ==TRUE)
        {
        ## PURL R CODE FROM CLASS NOTES
        p<- knitr::purl(paste(fileName,
            ".Rmd",sep=""))
        knitr::read_chunk(p)
        chunks <- knitr:::knit_code$get()
        chunkss<- lapply(1:length(chunks),
            function(x){if(!(names(chunks[x]) %in% c("echo=FALSE" ,"eval=FALSE"))){c(paste0("## ----", names(chunks)[x] ,"---- ##"),chunks[[x]]," "," "," ")}})
        xxx<- unlist(chunkss)
        fp<- paste("./scripts/", fileName,".R",
            sep="")
        writeLines(xxx,fp)
        system(paste("xcopy",
            '"C:/Users/mcolvin/Documents/Teaching/WFA8433-Natural-Resource-Decision-Making/Course-Materials/_site"',     
            '"C:/Users/mcolvin/Documents/Teaching/WFA8433-Natural-Resource-Decision-Making/Docs"',     "/E /C /H /R /K /O /Y")) 
        } else  {return(NULL)}
    q(save="no")   
    }