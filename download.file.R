#These are notes and examples I made for use of the dowwnload.file() command

#  - Function I made for downloading a file with date/time configured to the naming convention
#  - Examples of getURLDownload() put to use
#  - Returns relative file extension for download


#-------------------------------
#getURLDownload(fileURL, fileNameHead, fileNameTail)
#  - getURLDownload utilizes download.file() to propogate a file into a /data directory within your working directory
#  - if /data does not exist in your working directory, it will be created

getURLDownload<-function(fileURL, fileNameHead, fileNameTail){
        
        #Checks for existence for /data and creates if it does not exist
        if(!file.exists("data")){
                dir.create("data")
        }
        
        #dateTime needed to be rounded, otherwise strange behavior was encountered if called within another function
        #  - Strange behavior reference:  https://gist.github.com/mchantosa/b3485a411b8098720049a6249f24e549
        dateTime <- round(unclass(Sys.time()), 0)
        dFile <- paste(c("./data/", fileNameHead, dateTime, fileNameTail), collapse = "")
        download.file(fileURL, destfile = dFile )
        # if on a mac, use the follwing 
        #download.file(fileURL, destfile = dFile, method = "curl" )
        dFile
}



#-------------------------------
#Example of calling getURLDownload

#Example 1: Download traffic camera data from Baltimore format .csv
#  Commented out, otherwise sourcing this would propagate a csv
#fileUrl0 <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
#x <- getURLDownload(fileURL = fileUrl0, "BTrafficCam.", ".csv")
#print(x)
#print(list.files("./data"))