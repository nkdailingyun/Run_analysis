# Merges the training and the test sets to create one data set, in the name of wholedata
# The raw files were downloaded in a single folder "UCI HAR Dataset" under current working directory
subject.test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
test.y<-read.table("./UCI HAR Dataset/test/Y_test.txt")
test.x<-read.table("./UCI HAR Dataset/test/X_test.txt")
testset<-cbind(subject.test, test.y, test.x)
subject.train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
train.y<-read.table("./UCI HAR Dataset/train/Y_train.txt")
train.x<-read.table("./UCI HAR Dataset/train/X_train.txt")
trainset<-cbind(subject.train, train.y, train.x)
wholedata<-rbind(testset, trainset)

# Appends headings (subject, activity, all the measurement features) in wholedata set
featureslist<-as.character(read.table("./UCI HAR Dataset/features.txt")$V2)
colnames(wholedata)[c(1,2)]<-c("subject", "activity_number")
colnames(wholedata)[3:(length(featureslist)+2)]<-featureslist

# Extracts only the measurements on the mean and standard deviation for each measurement. 
readinlist<-grep("mean[:():]|std[:():]", names(wholedata))
subdata<-wholedata[, c(1:2, readinlist)]

# Uses descriptive activity names to name the activities in the data set
activitylabels<-read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=F)
colnames(activitylabels)<-c("activity_number1", "activity_name")
subdatan<-merge(subdata, activitylabels, by.x="activity_number", by.y="activity_number1", all=T)
subdatan<-subdatan[,-1]
subdatan<-subdatan[,c(1, ncol(subdatan), 2:(ncol(subdatan)-1))]

# Appropriately labels the data set with descriptive variable names.
# Specifically, to elaborate the meaning of prefix 't' with 'Time', the meaning of prefix 'f' with 'Frequency'.
names(subdatan)<-gsub("tBody", "Time_Body", names(subdatan))
names(subdatan)<-gsub("tGravity", "Time_Gravity", names(subdatan))
names(subdatan)<-gsub("fBody", "Frequency_", names(subdatan))

# From the data set in step 4, creates a second, independent tidy data set.  
# In the end, each column displays one variable, each row represents the average of each measurement variable for each activity and each subject. 
tidydata_mean<-aggregate(.~subject + activity_name, data=subdatan, mean)
write.table(tidydata_mean, file="./UCI HAR Dataset/tidydata_mean.txt", quote=F, sep="\t", row.names=F, col.names=T)


