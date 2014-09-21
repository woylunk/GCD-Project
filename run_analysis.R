#You should create one R script called run_analysis.R that does the following. 
########################################
#1. Merges the training and the test sets to create one data set.
#I will start by reading in and merging the different files within each group (test and train)

#First, read in test files:
TestSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="\t", stringsAsFactors=F)
head(TestSubjects)
TestSubjects

TestX<- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors=F)
head(TestX)
str(TestX)  
#2947 observations of 561 variables.  This matches TestY and Test Subjects (2947) and features (561).

TestY<- read.table("./UCI HAR Dataset/test/Y_test.txt", stringsAsFactors=F)
head(TestY)
summary(TestY)

#Now want to make all these into single data frame
subjects <- TestSubjects$V1
activity <- TestY$V1
TestAll <- cbind(subjects, activity, TestX)
head(TestAll)
str(TestAll)  #2957 x 563 as expected

#now repeat for train sets
TrainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
head(TrainSubjects)
TrainSubjects

TrainX<- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors=F)
head(TrainX)
str(TrainX)  
#7352 observations of 561 variables.  This matches TestY and Test Subjects (7352) and features (561).

TrainY<- read.table("./UCI HAR Dataset/train/Y_train.txt", stringsAsFactors=F)
head(TrainY)
TrainY

subjects <- TrainSubjects$V1
activity <- TrainY$V1
TrainAll <- cbind(subjects, activity, TrainX)
head(TrainAll)
str(TrainAll)  #7352 x 563 as expected

#then want to merge test and train datasets with same variables but combining rows:
Data <- rbind(TestAll, TrainAll)
head(Data)
tail(Data)
str(Data)   #10,2999 observations x 563

################################
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
Data2 <- Data[,c(1:8,43:48,83:88,123:128,163:168,203,204,216,217,229,230,243,244,255,256,268:273,296:298,347:352,375:377,426:431,454:456,505,506,515,518,519,528,531,532,541,544,545,554)]
head(Data2)
str(Data2)  #now have 10299 observations of 81 variables
#could be more elegant to read in features table, create logical vector for features including mean or std
#then bind that vector to Data and select that way...but this works!

################################################
#3. Uses descriptive activity names to name the activities in the data set.
#Add variable that has the actual names for the activities
library(plyr)
Data2$Activity <- mapvalues(Data2$activity, c(1,2,3,4,5,6),c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
head(Data2)
str(Data2)
#now remove the orginal variable with integers representing activities
Data3 <- Data2[,c(1,3:82)]
head(Data3)
#and move it to the beginning
Data4 <- subset(Data3,select=c(81,1:80))
head(Data4)

#######################################
#4. Appropriately label the data set with descriptive variable names.
#want to use modified versions of names in features.txt, so read in...
features<- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=F)
features

#First must select the actual ones we want
features2 <- features[c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,241,242,253,254,266:271,294:296,345:350,373:375,424:429,452:454,503,504,513,516,517,526,529,530,539,542,543,552),]
features2

#Then add rows for activity and subject headings
activity <- c("A","activity")
subject <- c("S","subject")
features3 <- rbind(activity, subject, features2)
features3

#now turn this list into a vector
headers <- features3[,"V2", drop=TRUE]
head(headers)

#then use that vector as column headings
names(Data4) <- headers
Data4
head(Data4)
str(Data4)

##now we want to clean up these names
names(Data4) <- gsub("-","",names(Data4))
names(Data4) <- gsub("\\()","",names(Data4))
names(Data4) <- gsub("^t","time",names(Data4))
names(Data4) <- tolower(names(Data4))
head(Data4)

########################################
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
str(Data4)  #ensure all the variables we want to average are classed as numeric

table <- ddply(Data4,c("activity","subject"), numcolwise(mean))
table
head(table)
str(table)
write.table(table, file="step5table.txt.", row.name=FALSE)

#to re-open, can use
test <-read.table("step5table.txt", header=TRUE)
