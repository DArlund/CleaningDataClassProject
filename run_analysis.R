run_analysis <- function(directory = "UCI HAR Dataset"){
  library("dplyr")
  loader <- list.files(directory, full.names=TRUE)
  testload <- list.files(loader[5], full.names=TRUE)
  testData <- read.table(testload[3])
  testUsers <- read.table(testload[2])
  testEx <- read.table(testload[4])
  trainload <- list.files(loader[6], full.names=TRUE)
  trainData <- read.table(trainload[3])
  trainUsers <- read.table(trainload[2])
  trainEx <- read.table(trainload[4])
  names(testUsers) <- "UserNumber"
  names(trainUsers) <- "UserNumber"
  names(testEx) <- "ExerciseType"
  names(trainEx) <- "ExerciseType"
  namesData <- read.table(loader[2])
  testData <- cbind(testUsers, testEx, testData)
  trainData <- cbind(trainUsers, trainEx, trainData)
  fullData <- rbind(testData, trainData)
  fullData <- arrange(fullData, UserNumber)
  names(fullData) <- c("UserNumber","ExerciseType",as.character(namesData[,2]))
  ##This completes Parts 1 and 4
  extract <- sort(c(grep("mean()",names(fullData), fixed=TRUE),grep("std()",names(fullData), fixed=TRUE)))
  extractData <- fullData[,c(1:2,extract)]
  ##This completes Part 2
  extractData[,2] <- factor(extractData[,2], labels = c("Walking","WalkingUpstairs","WalkingDownstairs","Sitting","Standing","Laying"))
  ##This completes Part 3
  finalData <- extractData[1:180,] ##This is just to copy over the names. We will be overwriting every line of this
  for(user in 1:30){
    index <- (user-1)*6+1
    finalData[index:(index+5),1] <- user
    finalData[index,2] <- "Walking"
    finalData[index,3:68] <- colMeans(extractData[((extractData[,2] =="Walking")&(extractData[,1]==user)),3:68])
    finalData[index+1,2] <- "WalkingDownstairs"
    finalData[index+1,3:68] <- colMeans(extractData[((extractData[,2] =="WalkingDownstairs")&(extractData[,1]==user)),3:68])
    finalData[index+2,2] <- "WalkingUpstairs"
    finalData[index+2,3:68] <- colMeans(extractData[((extractData[,2] =="WalkingUpstairs")&(extractData[,1]==user)),3:68])
    finalData[index+3,2] <- "Sitting"
    finalData[index+3,3:68] <- colMeans(extractData[((extractData[,2] =="Sitting")&(extractData[,1]==user)),3:68])
    finalData[index+4,2] <- "Standing"
    finalData[index+4,3:68] <- colMeans(extractData[((extractData[,2] =="Standing")&(extractData[,1]==user)),3:68])
    finalData[index+5,2] <- "Laying"
    finalData[index+5,3:68] <- colMeans(extractData[((extractData[,2] =="Laying")&(extractData[,1]==user)),3:68])
  }  
  finalData
  ##This completes Part 5
}

