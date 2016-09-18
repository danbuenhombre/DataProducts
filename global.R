#setwd("~/dataScience/dataProducts/DataProducts")
source("./eia_recs/parse_2009.R")
recs.list <- CreateRECSDataset("./eia_recs")

GetCatList <- function(r, category) {
    l.names <- r$recs.codebook[r$recs.codebook$variable_name %in% r$recs.varCategory[[category]],]$variable_description
    l <- r$recs.varCategory[[category]]
    names(l) <- l.names
    if (category!="demographic") l <- c("All"="All",l)
    return(l)
}

GetFilterList <- function(r, category.name) {
    if (category.name == "All") return("All")
    f <- levels(r$recs.data[,category.name])
    f <- c("All", f)
    return(f)
}

CalcMean <- function(r, geogCat, geogFilter, demoCat, demoFilter, energyVar) {
    wt.var <- "NWEIGHT"
    # filter geography
    if (geogFilter!="All" & geogCat != "All") {
        DF <- r$recs.data[r$recs.data[,geogCat]==geogFilter,c(demoCat,wt.var,energyVar)]
    } else {
        DF <- r$recs.data[,c(demoCat,wt.var,energyVar)]
    }

    # filter demographics
    if (demoFilter!="All") {
        DF <- DF[DF[,demoCat]==demoFilter,]
    }
    
    # Because weighted mean can be calculated by different variables, a variable (energyVar) has to be used 
    # I found out how to do this on Stack Overflow
    #  Attribution:
    # http://stackoverflow.com/questions/26724124/standard-evaluation-in-dplyr-summarise-on-variable-given-as-a-character-string
    DF <- DF %>% group_by_(demoCat) %>% 
        summarize_(mean_wt = interp(~weighted.mean(energyVar, wt.var, na.rm=TRUE), energyVar=as.name(energyVar), wt.var=as.name(wt.var)))
    
    DF <- as.data.frame(DF)
    names(DF) <- c("xAxis","yAxis")
    return(DF)
}

GenerateScatterDF <- function(r, geogCat, geogFilter, demoCat, demoFilter, xAxis, yAxis) {
    varList <- c(demoCat,xAxis,yAxis,"NWEIGHT")
    
    # Filter geography, if necessary
    if (geogFilter != "All") {
        DF <- r$recs.data[r$recs.data[,geogCat]==geogFilter,varList]
    } else {
        DF <- r$recs.data[,varList]
    }
    # filter demographic, if necessary
    if (demoFilter != "All")
        DF <- DF[DF[,demoCat]==demoFilter,]
    
    names(DF) <- c(demoCat, "xAxis","yAxis","NWEIGHT")
    DF$xAxis <- DF$xAxis*DF$NWEIGHT
    DF$NWEIGHT <- NULL
    DF[,demoCat] <- NULL
    
    return(DF)
}