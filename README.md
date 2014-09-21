run_analysis <- function() {
  #Load R packages needed to run scripts
  library(plyr)
  library(dplyr)
  
  #Load data into R files
  featuresTbl <- read.table(file("features.txt", open = "rt"), colClasses = "character")
  testSubjects <- read.table(file("test/subject_test.txt", open="rt"))
  testActivity <- read.table(file("test/y_test.txt", open="rt"))
  trainSubjects <- read.table(file("train/subject_train.txt", open="rt"))
  trainActivity <- read.table(file("train/y_train.txt", open="rt"))

  #Edit the text variables
  featuresTbl$V2 <- sapply(featuresTbl$V2, function(x) {gsub("\\(", "", x)})
  featuresTbl$V2 <- sapply(featuresTbl$V2, function(x) {gsub("\\)", "", x)})
  featuresTbl$V2 <- sapply(featuresTbl$V2, function(x) {gsub("-", "", x)})
  featuresTbl$V2 <- sapply(featuresTbl$V2, function(x) {gsub(",", "", x)})
  featuresTbl$V2 <- sapply(featuresTbl$V2, tolower)

  #Generate data frames with variable names from the "features.txt" file
  Xtest <- read.table(file("test/X_test.txt", open = "rt"), col.names = featuresTbl$V2)
  Xtrain <- read.table(file("train/X_train.txt", open = "rt"), col.names = featuresTbl$V2)

  #Construct the complete data set from the separate file data
  Xtest$ActivityLabel <- testActivity$V1
  Xtest$Subjects <- testSubjects$V1
  Xtrain$ActivityLabel <- trainActivity$V1
  Xtrain$Subjects <- trainSubjects$V1
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
  write.table(summarytable, "C:/Users/JHLM/coursera/CleaningData/ProjectFiles/SummaryTable.txt", row.names = FALSE)
}
