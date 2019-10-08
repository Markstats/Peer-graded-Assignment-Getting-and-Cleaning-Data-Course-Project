library(dplyr)
#Read data
features = read.table("./dataset/features.txt")

#Test data
Y_test = read.table("./dataset/test/y_test.txt")
names(Y_test) = "Activity"
X_test = read.table("./dataset/test/X_test.txt")
names(X_test) = features[,2]
sub_test = read.table("./dataset/test/subject_test.txt")
names(sub_test) = "Subject"
test_data = cbind(Y_test,sub_test,X_test)


#Training data
Y_train = read.table("./dataset/train/y_train.txt")
names(Y_train) = "Activity"
X_train = read.table("./dataset/train/X_train.txt")
names(X_train) = features[,2]

sub_train = read.table("./dataset/train/subject_train.txt")
names(sub_train) = "Subject"

train_data = cbind(Y_train,sub_train,X_train)

#Merge
merged_data = rbind(train_data,test_data)

#Handle labels 
vars = c(names(X_test)[grepl("std",names(X_test))],names(X_test)[grepl("mean",names(X_test))])
tidy_data = merged_data[,c("Activity","Subject",vars)]

names(tidy_data) = gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) = gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) = gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) = gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) = gsub("^t", "Time", names(tidy_data))
names(tidy_data) = gsub("^f", "FastFourierTransform", names(tidy_data))
names(tidy_data) = gsub("-std[()]", "_STD", names(tidy_data),ignore.case = TRUE)
names(tidy_data) = gsub("-freq[()]", "_Frequency", names(tidy_data),ignore.case = TRUE)
names(tidy_data) = gsub("-mean[()]", "_Mean", names(tidy_data),ignore.case = TRUE)
names(tidy_data) = gsub("[()]", "", names(tidy_data))

#Descriptive names on tasks
act_names = read.table("./dataset/activity_labels.txt")
data_set[,1] = factor(data_set[,1],levels = c(1,2,3,4,5,6),labels = act_names[,2])

#New tidy data
mean_data_set = data_set
mean_data_set $Subject = as.factor(mean_data_set $Subject)
tidy_data_mean =  mean_data_set%>% group_by(Activity,Subject) %>% summarise_all(funs(mean))

#Create txt files of the tidy datasets
write.table(tidy_data_mean, file = "mean_data.txt", sep = ",")
write.table(data_set, file = "tidy_data.txt", sep = ",")



