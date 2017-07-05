#These are notes and examples I made for reading files in R

#  - Reading csv files
#  - Reading xlsx files
#  - Reading xml files
#  - Reading json files



#Set environment
#I will use the getURLDownload() function defined in download.file.R
source("download.file.R")



#-------------------------------
#Reading csv files

#Setup: Get Baltimore traffic camera data in csv format
fileURL1 <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
fileName1 <- getURLDownload(fileURL1, "BTrafCam.", ".csv")

#Example 1: Read Baltimore traffic camera data using read.table()
cameraData1 <- read.table(fileName1, sep=",", header=TRUE)

#Example 2: Read Baltimore traffic camera data using read.csv()
cameraData2 <- read.csv(fileName1)

#Example 3: Confirm cameraData1 is identical to cameraData2
identical(cameraData1, cameraData2)



#-------------------------------
#Reading xlsx files

#Setup
library(xlsx)
#Note: corresponding xlsx data was not found within the Baltimore website
#  - Work around: 
#    - Use excel to open the above csv and save as xlsx
#    - Do not otherwise modify the name
fileName2 <- gsub("\\csv", "xlsx", fileName1)

#Example 1: Read an xslx file
cameraData3 <- read.xlsx(fileName2, sheetIndex = 1, header = TRUE) 

#Example 2: Read a column row identified section of an xlsx file
cameraData4 <- read.xlsx(fileName2, sheetIndex = 1, header = TRUE, 
                         colIndex = 2:3, rowIndex = 1:4)



#-------------------------------
#Reading xml files

#Setup
library(XML)
fileURL2 <- "http://www.w3schools.com/xml/simple.xml"
fileName3 <- getURLDownload(fileURL2,"breakFastData.",".xml")

#Example 1: Parse and access xml data
#Parse xml document
doc <- xmlTreeParse(fileName3, useInternalNodes = TRUE)
#Define top level node for access
rootNode <- xmlRoot(doc)
#Return top level node
xmlName(rootNode)
#Returns the first child of the root node
rootNode[[1]]
#Returns the third child of the first child of the root node
rootNode[[1]][[3]]
#Returns the names of the children of the first child of the root node
names(rootNode[[1]])

#Example 2: xmlApply
#For each child of the root node, the values of it's child nodes are conctenated
#  These character vectors of length 1 are retuned in a list 
xmlApply(rootNode,xmlValue)

#Example 3: xmlSApply
#Same as example 2 but returns a character vector rather than list of character elements
xmlSApply(rootNode,xmlValue)

#Example 4: Get all values for element "name", returns as a vector
xpathSApply(rootNode, "//name", xmlValue)

#Example 5: Get all values for element "price", returns as a vector
xpathSApply(rootNode, "//price", xmlValue)


#-------------------------------
#Reading json files

#Setup
library(jsonlite)
jsonData<-fromJSON("https://api.github.com/users/jtleek/repos")

#Example 1: Parsing json data
#Returns names of properties
names(jsonData)
#Returns the properties of the "owner" object
names(jsonData$owner)
#Returns the logins of all json "owner" objects
jsonData$owner$login

#Example 2: write a dataframe to a json object
myJson <- toJSON(iris, pretty = TRUE)
#concatenate and print json object
cat(myJson)