#These are notes and examples I made for use of data.table()

#  - data.table()
#  - tables()
#  - Subsetting rows of a data table
#  - Subsetting columns of a data table
#  - Assigning an existing data table, new data table not created... implications
#  - Multiple operations
#  - setkey()
#  - Compare times for reading data.table vs. data.frame



#Set environment
library(data.table)
x0 <- rnorm(9)
y0 <- rep(c("a", "b", "c"),each = 3)
z0 <- rnorm(9)



#-------------------------------      
#data.table() & tables()

#Example 1: Create data frame
DF <- data.frame(x = x0, y = y0, z = z0)
print(head(DF))

#Exmaple 2: Create data table paralleling data frame
DT <- data.table(x = x0, y = y0, z = z0)
print(head(DT))

#Example 3: See all data tables in memory
print(tables())



#-------------------------------
#Subsetting rows

#Example 1: Get row 2
DT[2,]
#  This is identical, not what was taught in class, but tested after encountering example 3
DT[2]

#Example 2: Get all rows such that $y == "a"
DT[DT$y == "a",]

#Example 3: Get rows 2 and 3
DT[c(2,3)]
#  This is identical, not necessary, but is what I would naturally call based on example 1
DT[c(2,3),]



#-------------------------------
#Subsetting columns
#  NO!!! Don't do this --> DT[,c(2,3)]

#Example 1: Get the mean over x values and the sum over z 
DT[,list(mean(x),sum(z))]

#Example 2: Make a table from y values
DT[,table(y)]

#Example 3: Create column W (:= does this) from z^2
DT[,w:=z^2]

#Example 4: Create column a, assign bool for x > 0
DT[, a := x > 0]



#-------------------------------
#Assigning an existing data table

#Example 1: Assign DT to DT2
#  Above examples, new data table not created, rather existing data table amended
#  With the below example because DT2 is assigned DT, amending DT will amend DT2
DT2 <- DT
#  Make y == 2
DT[, y := 2] 
#  Now observe DT2
DT2



#-------------------------------
#Multiple operations

#Example 1: Create column m, assign log(x + y + 5)
DT[, m := {tmp <- (x + z); log(tmp + 5)}]

#Example 2: Create column b from assignment two sets of calculations based on bool values of a 
#  For rows | a == TRUE, mean of (x+w) --> b
#  For rows | a == FALSE, mean of (x+w) --> b
#  Note: the b column is comprised of two values
DT[, b := mean(x + w), by = a] 

#Example 2: Execute a count command over a column of DT
#  Create a data table from 100,000 observations of random letters from "a", "b", "c"
DT <- data.table(x = sample(letters[1:3], 1E5, TRUE))
#  For each unique value of x, return N(x_i):
#    N(x_i): an integer of length 1 equal to the numbr of times x_i appears in x
DT[, .N, by = x]



#-------------------------------
#setkey

#Example 1: Parse a from x using
#  Create a DT from, x = 100 "a", 100 "b", 100 "c", y = 300 randoms from normal
DT <- data.table(x = rep(c("a", "b", "c"), each = 100), y=rnorm(300))
#  Sets values of DT over which to parse
setkey(DT, x) 
DT['a']

#Example 2: Merge DT1 and DT2 from permutation of shared elements in x
DT1 <- data.table(x=c("a", "a", "b", "dt1"), y = 1:4)
DT2 <- data.table(x=c("a", "b", "dt2"), z = 5:7)
setkey(DT1, x); setkey(DT2, x)
merge(DT1, DT2)



#-------------------------------
#Compare times for reading data.table vs. data.frame

#Example 1: 
#  Create a big data frame
big_df <- data.frame(x = rnorm(1E6), y = rnorm(1E6))
file <- tempfile()
#  Create tab delimited file from big_df
write.table(big_df, file = file, row.names = FALSE, col.names = TRUE, sep = "\t", quote = FALSE)
#  Read in tab delimited file as data table, capture time
system.time(fread(file))
#  Read in tab delimited file as data frame, capture time
system.time(read.table(file, header=TRUE, sep="\t"))
