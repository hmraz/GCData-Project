#########################################################################
# GETTING AND CLEANING DATA COURSE PROJECT
#
# The purpose of this project is to demonstrate your ability to collect, work with, 
# and clean a data set. The goal is to prepare tidy data that can be used for later analysis.
# 
# You should create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.
#########################################################################

#Data downloaded as a zip file from a link provided on the Coursera website:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#I then unzipped the file to my local drive

#Read in all of the data, take a peek at it and then start cleaning it up
testData <- read.table("test/X_test.txt")
str(testData)
head(testData)
testActivity <- read.table("test/y_test.txt")
head(testActivity)
testSubj <- read.table("test/subject_test.txt")
head(testSubj)
trainData <- read.table("train/X_train.txt")
trainActivity <- read.table("train/y_train.txt")
trainSubj <- read.table("train/subject_train.txt")
varNames <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt")
#Make the labels look a bit nicer
activityLabels2 <- factor(activityLabels$V1, levels=activityLabels$V1, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Lying"))

#First, append activity names to the datasets
testActivityName <- factor(testActivity$V1, levels= activityLabels$V1, labels=activityLabels2 )
testData <- cbind( testActivityName, testData)
colnames(testData)[1] <- "activity"
trainActivityName <- factor(trainActivity$V1, levels=activityLabels$V1, labels=activityLabels2)
trainData <- cbind(trainActivityName, trainData)
colnames(trainData)[1] <- "activity"

#second, add in the subject identifier
colnames(testSubj)[1] <- "subjectID"
testData <- cbind( testSubj, testData)
colnames(trainSubj)[1] <- "subjectID"
trainData <- cbind(trainSubj, trainData)

#Now let's merge the data.  The columns are identical between the two sets
mergedData <- merge(trainData, testData, all=TRUE)

#Finally, fix up the column headers using the information in the features.txt file
for( i in 1:561){
        colnames(mergedData)[i+2] <- as.character(varNames$V2[i])
}

#Now, extract measurements of mean and standard deviation for each meausure

good <- grepl("mean()", names(mergedData), fixed=TRUE)
good[1] = TRUE; good[2] = TRUE  #manually set these to true so we don't lose the subject ID and activity
good2 <- grepl("std()", names(mergedData), fixed=TRUE)
tidyData <- mergedData[good | good2]
#improve variable labels
names(tidyData) <- sub("tBody", "timeBody", names(tidyData))
names(tidyData) <- sub("tGrav", "timeGrav", names(tidyData))
names(tidyData) <- sub("fBody", "freqBody", names(tidyData))
names(tidyData) <- sub("Acc", "Acceleration", names(tidyData))
names(tidyData) <- sub("Gyro", "Gyroscope", names(tidyData))
names(tidyData) <- sub("-Y", "-Yaxis", names(tidyData))
names(tidyData) <- sub("-X", "-Xaxis", names(tidyData))
names(tidyData) <- sub("-Z", "-Zaxis", names(tidyData))
names(tidyData)

#write out the data as a csv file
write.csv(tidyData, file="tidyData.csv")
#End of creation of initial tidy data set, "tidyData"


######################################################
#Create a second tidy data set with the average of each variable for each subject for each activity

#release memory for data frames we no longer need
rm(testData)
rm(trainData)
gc()

#first, split the tidyData created above by subjectID and get some other data so you don't have to keep going back for it
split1 <- split(tidyData, tidyData$subjectID)
subjVec <- unique(tidyData$subjectID)
activityVec <- unique(tidyData$activity)
secondDataset <- data.frame(stringsAsFactors=FALSE)
#put in one row from tidyData so that we get our data to come in as char instead of factor.
secondDataset <- rbind(secondDataset, tidyData[1,])

#now, loop over those split lists and split by activity, then take average and add it to data frame
for( i in subjVec){
        tempTable <- split1[[i]]
        split2 <- split(tempTable, tempTable$activity)
        for( j in activityVec){
                meanVec <- colMeans(split2[[j]][,3:68],na.rm=TRUE )
                rowEntry <- c(i, j, meanVec)
                secondDataset <- rbind(secondDataset, rowEntry)
        }       
}
#now remove the bogus row we added
secondDataset <- secondDataset[-1,]
names(secondDataset) <- names(tidyData)
#need to get the correct data types back
secondDataset$subjectID <- as.integer(secondDataset$subjectID)
for( i in 3:68){
        secondDataset[,i] <- as.numeric(secondDataset[,i])
}
str(secondDataset)
#write out the data as a csv file
write.csv(secondDataset, file="tidyData2.txt", row.names=FALSE)


