CreateRECSDataset <- function(work.dir) {
  library(openxlsx)
  
#  setwd(work.dir)
  
  # URLs for EIA RECS public microdata
  data.url <- "http://www.eia.gov/consumption/residential/data/2009/csv/recs2009_public.csv"
  data.file <- paste0(work.dir, "/data/recs2009_public.csv")
  codebook.url <- "http://www.eia.gov/consumption/residential/data/2009/xls/recs2009_public_codebook.xlsx"
  codebook.file <- paste0(work.dir, "/data/recs2009_public_codebook.xlsx")
  
  # if the data file doesn't exist, download it
  if (!file.exists(data.file)) {
      download.file(data.url, data.file)
  }
  
  #if the codebook file doesn't exist, download it
  if (!file.exists(codebook.file)) {
      download.file(codebook.url, codebook.file)
  }
  
  # Read raw code book
  cb <- read.xlsx(codebook.file)
  # The first two rows are headers and we don't care about 
  # the columns after D
  cb <- cb[3:nrow(cb), 1:4]
  # name the variables
  names(cb) <- c("variable_name","variable_description","response_code","response_label")

  # Since many variables in the dataset are codes with labels 
  # (e.g. REGIONC is 1="Northeast", 2="Midwest", etc.)
  # a lookup table is need so these variables can be translated to factors
  
  # filter DOEID and NAs in response_code
  cb.lookups.raw <- cb[!is.na(cb$response_code) & cb$variable_name!="DOEID",]
  # response labels starting with "Number of" or "Total number of" just have
  # numeric values
  cb.lookups.raw <- cb.lookups.raw[!grepl("^(total )?number of", cb.lookups.raw$response_label, ignore.case = T),]
  # response codes with " - " exactly are integers values.  these response codes show the range
  cb.lookups.raw <- cb.lookups.raw[!grepl(" - ", cb.lookups.raw$response_code),]

  # loop through each variable and split out codes and labels based on EOL character(s)  
  cb.lookups <- data.frame()
  for (i in 1:nrow(cb.lookups.raw)) {
    response.codes <- unlist(strsplit(cb.lookups.raw[i,]$response_code, "\\r?\\n"))
    response.labels <- unlist(strsplit(cb.lookups.raw[i,]$response_label, "\\r?\\n"))
    
    # remove any blanks
    response.codes <- response.codes[nchar(response.codes)>0]
    response.labels <- response.labels[nchar(response.labels)>0]
    
    # create a temporary data frame with this variable's results
    new.var <- data.frame(variable_name=cb.lookups.raw[i,]$variable_name,
                          response_code=response.codes, 
                          response_label=response.labels, 
                          stringsAsFactors = F)
    
    # append to final df
    cb.lookups <- rbind(cb.lookups, new.var)
  }
  
  # trim any leading or trailing spaces
  cb.lookups$variable_name <- gsub("^\\s*|\\s*$", "", cb.lookups$variable_name)
  cb.lookups$response_code <- gsub("^\\s*|\\s*$", "", cb.lookups$response_code)
  cb.lookups$response_label <- gsub("^\\s*|\\s*$", "", cb.lookups$response_label)

  # read in the raw RECS data  
  recs <- read.csv(data.file)

  # loop through each variable in the lookup df
  # and convert the variable in the data to a factor
  for (v in unique(cb.lookups$variable_name)) {
    vlevels <- cb.lookups[cb.lookups$variable_name==v,]$response_code
    vlabels <- cb.lookups[cb.lookups$variable_name==v,]$response_label
    recs[,v] <- factor(recs[,v], levels=vlevels, labels=vlabels)
  }  
  
  base <- c("DOEID","NWEIGHT","TOTSQFT")
  
  geography <- c("REGIONC","DIVISION","Climate_Region_Pub","UR")
  #house <- c("TYPEHUQ","KOWNRENT","YEARMADERANGE","WALLTYPE","ROOFTYPE","BEDROOMS","TOTSQFT")
  #person <- c("EMPLOYHH","SDESCENT","Householder_Race","EDUCATION","NHSLDMEM","MONEYPY")
  demographic <- c("TYPEHUQ","KOWNRENT","YEARMADERANGE","EMPLOYHH","EDUCATION","MONEYPY")
  pool <- c("SWIMPOOL","POOL","FUELPOOL")
  heat <- c("HEATHOME","EQUIPM","FUELHEAT","PROTHERM")
  cool <- c("SWAMPCOL","COOLTYPE","PROTHERMAC")
  eleckwh <- c("KWH","KWHSPH","KWHCOL","KWHWTH","KWHRFG","KWHOTH")
  elecdol <- c("DOLLAREL","DOLELSPH","DOLELCOL","DOLELWTH","DOLELRFG","DOLELOTH")
  nghcf <- c("CUFEETNG","CUFEETNGSPH","CUFEETNGWTH","CUFEETNGOTH")
  ngdol <- c("DOLLARNG","DOLNGSPH","DOLNGWTH","DOLNGOTH")
  vars <- list(base=base,geography=geography,demographic=demographic,pool=pool,heat=heat,cool=cool,
               eleckwh=eleckwh,elecdol=elecdol,nghcf=nghcf,ngdol=ngdol)
  
  # filter data frame down to just the variables for the product
  recs <- recs[,unlist(vars)]
  cb <- cb[cb$variable_name %in% unlist(vars),]
  cb.lookups <- cb.lookups[cb.lookups$variable_name %in% unlist(vars),]
  
  # return a list of three dataframes:
  # 1) Full RECS data
  # 2) variable category list (vars)
  # 3) codebook with just variable names and descriptions
  # 4) lookup table
  
  ret.list <- list(recs.data=recs, 
                   recs.varCategory=vars,
                   recs.codebook=cb[,c("variable_name","variable_description")],
                   recs.lookup=cb.lookups)
  ret.list
}
