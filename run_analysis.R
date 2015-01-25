#load dplyr package for easy manipulation of tables
library(dplyr)

#read in the feature names
features<-read.table("features.txt")

#read in training data, first the binary values
train.data<-read.table("train/X_train.txt")
#set the names to the feature names
names(train.data)<-features$V2
#read in the subject id for each row of the data
train.subject<-read.table("train//subject_train.txt",col.names=c("subject"))
#read in the activity id for each row of the data
train.activity<-read.table("train//y_train.txt",col.names=c("activity"))
#bind all into on table, the subject id and the activity id are the last 2 columns
train.all<-cbind(train.data,train.subject,train.activity)

#repeat the same procedure for the test data
test.data<-read.table("test/X_test.txt")
names(test.data)<-features$V2
test.subject<-read.table("test//subject_test.txt",col.names=c("subject"))
test.activity<-read.table("test//y_test.txt",col.names=c("activity"))
test.all<-cbind(test.data,test.subject,test.activity)

#merge the two data sets
data.all<-rbind(test.all,train.all)
#create new table with columns only the variables that contain mean, std and the two last columns for activity and subject id
data.meanstd<-data.all[,c(grep("mean",names(data.all)),grep("std",names(data.all)),grep("activity",names(data.all)),grep("subject",names(data.all)))]
#read in the labels for the activities
activities<-read.table("activity_labels.txt")
#calculate the mean grouped by activity of all the columns (except the activity and subject column)
data.by_activity<-aggregate(subset(data.meanstd,select=-c(subject,activity)),by=list(data.meanstd$activity),FUN=mean)
#set names of activities
row.names(data.by_activity)<-activities$V2
#calculate the mean grouped by subject of all the columns (except the activity and subject column)
data.by_subject<-aggregate(subset(data.meanstd,select=-c(subject,activity)),by=list(data.meanstd$subject),FUN=mean)
#subjects don't have labels the same way activities do (probably due to some form of privacy protection)
#we can still call them something meaningful and more obvious (subject 1, subject 2, etc)
subjectnames<-lapply(1:dim(data.by_subject)[1],function (x) paste("subject ",as.character(x)))
row.names(data.by_subject)<-subjectnames
#create the final tidy data set, which has columns the measured variables  and rows first the activities (named) and then the subjects (again named)
data.out<-rbind(data.by_activity,data.by_subject)
#write the output
#for some reason, it's required that the row names are removed. This makes the dataset harder to understand
write.table(data.out,file="output.txt",row.names=FALSE)
write.table(data.out,file="output-named.txt")