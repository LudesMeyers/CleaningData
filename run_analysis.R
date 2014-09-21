#Set your working dir to the "UCI HAR Dataset" folder.
#Open this file with a R interface (i.e. R studio)
#Source this file and then type "run_analysis()" in command line.
#The "summarytable.txt" file will be located in the working dir.

run_analysis <- function() {
  
  #Load R packages needed to run scripts
  library(plyr)
  library(dplyr)
  
  #Load text data into R files
  #These text data are used to identify subject and activity measurements
  #and for generating variable names
  featuresTbl <- read.table(file("features.txt", open = "rt"), colClasses = "character")
  testSubjects <- read.table(file("test/subject_test.txt", open="rt"))
  testActivity <- read.table(file("test/y_test.txt", open="rt"))
  trainSubjects <- read.table(file("train/subject_train.txt", open="rt"))
  trainActivity <- read.table(file("train/y_train.txt", open="rt"))
  
  #Edit the text variables from the "features.txt" file
  #to make them more readable and manageable
  featuresTbl$V2 <- sapply(featuresTbl$V2, function(x) {gsub("\\(", "", x)})
  featuresTbl$V2 <- sapply(featuresTbl$V2, function(x) {gsub("\\)", "", x)})
  featuresTbl$V2 <- sapply(featuresTbl$V2, function(x) {gsub("-", "", x)})
  featuresTbl$V2 <- sapply(featuresTbl$V2, function(x) {gsub(",", "", x)})
  featuresTbl$V2 <- sapply(featuresTbl$V2, tolower)
  
  #Generate data frames containing data measurements 
  #variable names for the measurements are from the "features.txt" file
  Xtest <- read.table(file("test/X_test.txt", open = "rt"), col.names = featuresTbl$V2)
  Xtrain <- read.table(file("train/X_train.txt", open = "rt"), col.names = featuresTbl$V2)
  
  #Construct the complete data set
  
  #Add activity and subject variables to the companion data set
  #to identify the activity and subject that corresponds with 
  #data measurements in the record(row) 
  Xtest$ActivityLabel <- testActivity$V1
  Xtest$Subjects <- testSubjects$V1
  Xtrain$ActivityLabel <- trainActivity$V1
  Xtrain$Subjects <- trainSubjects$V1
  
  #Combine the training and test data sets
  completedataset <- rbind(Xtest, Xtrain)
  
  #Replace activity label numbers with activity names
  setactivity <- function(x) { if (x == 1) {
    x <- "walking"}
    else if (x == 2) {
      x <- "walkingupstairs"}
    else if (x == 3) {
      x <- "walkingdownstairs"}
    else if (x == 4) {
      x <- "sitting"}
    else if (x == 5) {
      x <- "standing"}
    else if (x == 6) {
      x <- "laying"}
  }
  completedataset$ActivityLabel <- sapply(completedataset[,"ActivityLabel"], setactivity)
  
  #Select mean and std variables
  getmeanstd <- grepl("mean|std",featuresTbl$V2)
  finaldataset <- completedataset[,getmeanstd]
  
  #Summarize the average of each variable by activity and subject
  by_activity <- group_by(finaldataset, ActivityLabel, Subjects)
  summarytable <- summarise_each(by_activity, funs(mean))
  write.table(summarytable, row.names = FALSE)
}
