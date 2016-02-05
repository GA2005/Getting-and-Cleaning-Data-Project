# Set the working directory for the Project
setwd ("C://DataSceince//cleaning data//Week4//Project")
#Download the file from the file location
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
#unZip the file for data
unzip(zipfile="./data/Dataset.zip",exdir="./data")
#Set the new direcotry for the project dataset
setwd ("C://DataSceince//cleaning data//Week4//Project//data//UCI HAR Dataset")
#Read all the dataset file to variables
xtest <- read.table(".//test//X_test.txt", sep = "")
ytest <- read.table(".//test//y_test.txt", sep = "")
subtest <- read.table(".//test//subject_test.txt", sep = "")
xtrain <- read.table(".//train//X_train.txt", sep="")
ytrain <- read.table(".//train//y_train.txt", sep ="")
subtrain <- read.table(".//train//subject_train.txt", sep ="")
activity_lab <- read.table(".//activity_labels.txt")
features <- read.table(".//features.txt")
# Name the dataset columns approriately using the readme.txt
names(subtrain)<- "subject"
names(ytrain)<-"activity"
names(xtrain)<-features$V2
#combine the Train dataset by understing the data
train<- cbind(ytrain,xtrain)
str(train)
train_s <- cbind(subtrain,train)
str(train_s)
#Name the Test Dataset
names(subtest)<- "subject"
names(ytest)<- "activity"
names(xtest)<-features$V2
#Combine the Test Dataset
test<- cbind(ytest,xtest)
str(test)
Test_s<- cbind(subtest,test)
str(Test_s)
#Combine all the train and test dataset
Bind_all<- rbind(Test_s,train_s)
str(Bind_all) #test it
#Extract the mean and std deviation columns
featurename<- features$V2[grep("mean\\(\\)|std\\(\\)",features$V2)]
selectedNames<-c(as.character(featurename), "subject", "activity" )
selectedNames
#Subset the data for tidy required dataset for analysis
Data_all <- subset(Bind_all,select=selectedNames)
#Add descriptive names for the variable names
library(qdapTools)
Data_all$activity <-lookup(Data_all$activity, (activity_lab$V1), c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
names(Data_all)<-gsub("Acc", "Accelerometer", names(Data_all))
names(Data_all)<-gsub("^f", "frequency", names(Data_all))
names(Data_all)<-gsub("Gyro", "Gyroscope", names(Data_all))
names(Data_all)<-gsub("BodyBody", "Body", names(Data_all))
names(Data_all)<-gsub("Mag", "Magnitude", names(Data_all))
#Summarize the data subject and activity and create a new tidy dataset.
library(dplyr)
data_summary <- group_by(Data_all,subject,activity)
data_sum<-summarise_each(data_summary,funs(mean))
write.table(data_sum, file = "tidydata.txt",row.name=FALSE)
#CReate code book using the knitr package
library(knitr)
rmarkdown::render("codebook.md")
