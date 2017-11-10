#####Getting and Cleaning Data Course Project

###1.Merge the training and the test sets to create one data set

#Make sure the "test" folder is your wd
setwd("~/Desktop/Coursera/Getting:Cleaning_data/CourseProject/UCI HAR Dataset/test")

#Read x test table into R
testx<-read.table("X_test.txt")

#apply 'features' as column names
setwd("~/Desktop/Coursera/Getting:Cleaning_data/CourseProject/UCI HAR Dataset")
cn<-read.table("features.txt")
colnames(testx) <- cn[,2]

#Read y test table into R
setwd("~/Desktop/Coursera/Getting:Cleaning_data/CourseProject/UCI HAR Dataset/test")
testy<-read.table("y_test.txt")
     colnames(testy)<- "label"
subtest<-read.table("subject_test.txt")
     colnames(subtest)<- "subject"

#Bind x/y/subject test data
testdf<-cbind(testx,testy)
tdf1<-cbind(testdf, subtest)

#Setwd to "train" folder
setwd("~/Desktop/Coursera/Getting:Cleaning_data/CourseProject/UCI HAR Dataset/train")

#Read tables into R
trainx<-read.table("X_train.txt")

#apply 'features' as column names
setwd("~/Desktop/Coursera/Getting:Cleaning_data/CourseProject/UCI HAR Dataset")
cn2<-read.table("features.txt")
colnames(trainx) <- cn[,2]

#Read y train table into R
setwd("~/Desktop/Coursera/Getting:Cleaning_data/CourseProject/UCI HAR Dataset/train")
trainy<-read.table("y_train.txt")
     colnames(trainy)<- "label"
subtrain<-read.table("subject_train.txt")
     colnames(subtrain)<- "subject"

#Bind x/y/subject train data
traindf<-cbind(trainx,trainy)
tdf2<-cbind(traindf, subtrain)

#Merge test/train data
alldf<-rbind(tdf1, tdf2)

###2.Extract only the measurements on the mean and sd for each measurement
#Show me columns that end with std/mean
stdvar<-grep("*std()",names(alldf))
meanvar<-grep("*mean()",names(alldf))

#Combine indices to have one list of the columns we want
int<-c(stdvar,meanvar)
intn<-sort(int)

#Create df of only the columns we are interested in
t<-alldf[,intn]
t2<-alldf[,562:563]
t3<-cbind(t,t2)

###3. Use descriptive names to name the activities in the data set
t3$label[t3$label == 1] <- "walking"
t3$label[t3$label == 2] <- "walkingupstairs"
t3$label[t3$label == 3] <- "walkingdownstairs"
t3$label[t3$label == 4] <- "sitting"
t3$label[t3$label == 5] <- "standing"
t3$label[t3$label == 6] <- "laying"

###4.Appropriately label data set with descriptive variable names
###please see lines 33 - 36

###5.Create a second, independent tidy data set with the average of each
###variable for each activity and each subject
library(dplyr)
t4<-tbl_df(t3)
t5<-group_by(t4, subject,label)
t6<-summarize_all(t5,mean, na.rm=T)

#Create txt file of new tidy data set
write.table(t6,file="Course3_project",row.name=FALSE)
