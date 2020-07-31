library(dplyr)

#Assumes you already downloaded the file into your workspace, wherever it is for you
setwd("~/Documents/Workspace/R/JHU Courses/Getting and Cleaning Data/Peer Review/UCI HAR Dataset/")

#Loading Data In
features <- read.table("features.txt", col.names = c("n", "functions"))
activity_labels <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

#Merging Data
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subjects <- rbind(subject_train, subject_test)
MergedData <- cbind(Subjects, X, Y)

#Filtering just for means and stds
CleanedData <- MergedData %>% select(subject, code, contains("mean"), contains("std"))

#Labelling Activities
CleanedData$code <- activity_labels[CleanedData$code, 2]

#Labelling with descriptive variable names
columnNames <- names(CleanedData)
columnNames[2] <- "Activity"
columnNames <- gsub("^t", "Time", columnNames)
columnNames <- gsub("Acc", "Accelerometer", columnNames)
columnNames <- gsub("Mag", "Magnitude", columnNames)
columnNames <- gsub("Gyro", "Gyroscope", columnNames)
columnNames <- gsub("^f", "Frequency", columnNames)
columnNames <- gsub("Freq", "Frequency", columnNames)
columnNames <- gsub("BodyBody", "Body", columnNames)
columnNames <- gsub("angle", "Angle", columnNames)
columnNames <- gsub("gravity", "Gravity", columnNames)
columnNames <- gsub("std", "STD", columnNames)
names(CleanedData) <- columnNames

#Grouping by subject and activity
GroupedData <- CleanedData %>% 
  group_by(subject, Activity) %>%
  summarize_all(funs(mean))

write.table(GroupedData, file = "GroupedData.txt", row.name = FALSE)