fetch_eia_recs <- function() {
    library(openxlsx)
    
    url_2009_data <- "https://www.eia.gov/consumption/residential/data/2009/csv/recs2009_public.csv"
    file_2009_data <- "./data/recs2009_public.csv"
    #download.file(url_2009_data, file_2009_data)
    data_2009 <- read.csv(file_2009_data)
    url_2009_codebook <- "https://www.eia.gov/consumption/residential/data/2009/xls/recs2009_public_codebook.xlsx"
    file_2009_codebook <- "./data/recs2009_public_codebook.xlsx"
    #download.file(url_2009_codebook, file_2009_codebook)
    codebook_2009 <- read.xlsx(file_2009_codebook)
    
    url_2005_layout <- "https://www.eia.gov/consumption/residential/data/2005/layoutfiles/RECS05layoutAllData.csv"
    file_2005_layout <- "./data/RECS05layoutAllData.csv"
    #download.file(url_2005_layout, file_2005_layout)
    layout_2005 <- read.csv(file_2005_layout)
    url_2005_codebook <- "https://www.eia.gov/consumption/residential/data/2005/pdf/recs05codebook.pdf"
    file_2005_codebook <- "./data/recs05codebook.pdf"
    #download.file(url_2005_codebook, file_2005_codebook, mode="wb")
    pdf <- readPDF(control = list(c(text = "-layout")))
    pdf <- pdf(elem=list(uri=file_2005_codebook),language="en")
#    noaa_events <- as.data.frame(toupper(c(pdf$content[seq(397, 420)], pdf$content[seq(425, 448)])))
#    names(noaa_events) <- "EventName"
#    noaa_events$EventName <- as.character(noaa_events$EventName)
#    noaa_events$EventName
    url_2005_data <- "https://www.eia.gov/consumption/residential/data/2005/mdatfiles/RECS05alldata.csv"
    file_2005_data <- "./data/RECS05alldata.csv"
    #download.file(url_2005_data, file_2005_data)
    data_2005 <- read.csv(file_2005_data)
    
    # 2001
    # file 8
    url_2001_file8_data <- "https://www.eia.gov/consumption/residential/data/2001/txt/datafile82001.txt"
    file_2001_file8_data <- "./data/datafile82001.txt"
    #download.file(url_2001_file8_data, file_2001_file8_data)
    data_file8_2001 <- read.csv(file_2001_file8_data)
    url_2001_file8_codebook <- "https://www.eia.gov/consumption/residential/data/2001/txt/codebook82001.txt"
    file_2001_file8_codebook <- "./data/codebook82001.txt"
    #download.file(url_2001_file8_codebook, file_2001_file8_codebook)
    codebook_file8_2001 <- read.csv(file_2001_file8_codebook)
    # file 9
    url_2001_file9_data <- "https://www.eia.gov/consumption/residential/data/2001/txt/datafile92001.txt"
    file_2001_file9_data <- "./data/datafile92001.txt"
    #download.file(url_2001_file9_data, file_2001_file9_data)
    data_file9_2001 <- read.csv(file_2001_file9_data)
    url_2001_file9_codebook <- "https://www.eia.gov/consumption/residential/data/2001/txt/codebook92001.txt"
    file_2001_file9_codebook <- "./data/codebook92001.txt"
    #download.file(url_2001_file9_codebook, file_2001_file9_codebook)
    codebook_file9_2001 <- read.csv(file_2001_file9_codebook)
    # file 11    
    url_2001_file11_data <- "https://www.eia.gov/consumption/residential/data/2001/txt/datafile112001.txt"    
    file_2001_file11_data <- "./data/datafile112001.txt"
    #download.file(url_2001_file11_data, file_2001_file11_data)
    data_file11_2001 <- read.csv(file_2001_file11_data)
    url_2001_file11_codebook <- "https://www.eia.gov/consumption/residential/data/2001/txt/codebook112001.txt"
    file_2001_file11_codebook <- "./data/codebook112001.txt"
    #download.file(url_2001_file11_codebook, file_2001_file11_codebook)
    codebook_file11_2001 <- read.csv(file_2001_file11_codebook)
    
    url_1997_file11_data <- "https://www.eia.gov/consumption/residential/data/1997/txt/file11os.txt"
    url_1997_file11_codebook <- "https://www.eia.gov/consumption/residential/data/1997/txt/file11cdb.txt"
    
    url_1993_file11_data <- "https://www.eia.gov/consumption/residential/data/1993/txt/file11_asc.txt"
    url_1993_file11_codebook <- "https://www.eia.gov/consumption/residential/data/1993/txt/file11cdb.txt"
    
    
}