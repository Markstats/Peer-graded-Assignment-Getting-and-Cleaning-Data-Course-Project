library(dplyr)

#Download the data and unzip it
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile = "./data.zip")
unzip("data.zip")
#Read data
features = read.table("./UCI HAR Dataset/features.txt")

#Test data
Y_test = read.table("./UCI HAR Dataset/test/y_test.txt")
names(Y_test) = "Activity"
X_test = read.table("./UCI HAR Dataset/test/X_test.txt")
names(X_test) = features[,2]
sub_test = read.table("./UCI HAR Dataset/test/subject_test.txt")
names(sub_test) = "Subject"
test_data = cbind(Y_test,sub_test,X_test)


#Training data
Y_train = read.table("./UCI HAR Dataset/train/y_train.txt")
names(Y_train) = "Activity"
X_train = read.table("./UCI HAR Dataset/train/X_train.txt")
names(X_train) = features[,2]

sub_train = read.table("./UCI HAR Dataset/train/subject_train.txt")
names(sub_train) = "Subject"

train_data = cbind(Y_train,sub_train,X_train)

#Merge
merged_data = rbind(train_data,test_data)

#Handle labels 
vars = c(names(X_test)[grepl("[Ss]td",names(X_test))],names(X_test)[grepl("[Mm]ean",names(X_test))])
tidy_data = merged_data[,c("Activity","Subject",vars)]

#Descriptive names on actitivites
act_names = read.table("./UCI HAR Dataset/activity_labels.txt")
tidy_data[,1] = factor(tidy_data[,1],levels = c(1,2,3,4,5,6),labels = act_names[,2])

names(tidy_data) = gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) = gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) = gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) = gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) = gsub("^t", "Time", names(tidy_data))
names(tidy_data) = gsub("^f", "FastFourierTransform", names(tidy_data))
names(tidy_data) = gsub("[()]", "", names(tidy_data))
names(tidy_data) = gsub("[-]", ".", names(tidy_data))
names(tidy_data) = gsub("std", "Std", names(tidy_data),ignore.case = TRUE)
names(tidy_data) = gsub("freq", "Frequency", names(tidy_data),ignore.case = TRUE)
names(tidy_data) = gsub("mean", "Mean", names(tidy_data),ignore.case = TRUE)


Complete_data = tidy_data%>% group_by(Activity,Subject) %>% summarise_all(funs(mean))


write.table(Complete_data, file = "Complete.txt", sep = ",")



