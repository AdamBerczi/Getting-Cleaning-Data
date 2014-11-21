# 1. Creating a data set by merging the training and the test sets
train_x = read.table("./UCI HAR Dataset/train/X_train.txt")
  train_y = read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject = read.table("./UCI HAR Dataset/train/subject_train.txt")

test_x = read.table("./UCI HAR Dataset/test/X_test.txt")
test_y = read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject = read.table("./UCI HAR Dataset/test/subject_test.txt")

merge_x = rbind(train_x, test_x)
merge_y = rbind(train_y, test_y)
merge_subject = rbind(train_subject, test_subject)

# 2. Extracting only the mean & standard deviation/measurement
features = read.table("./UCI HAR Dataset/features.txt")
measures = grep("mean\\(\\)|std\\(\\)", features[, 2])
merge_x = merge_x[, measures]

# 3. Naming & labeling the activities in the data set w/ descriptive names
activity = read.table("./UCI HAR Dataset/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", "", activity[, 2]))
substr(activity[2, 2], 8, 8) = toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) = toupper(substr(activity[3, 2], 8, 8))
act_label = activity[merge_y[, 1], 2]
merge_y[, 1] = act_label
names(merge_y) = "activity"
names(merge_subject) = "subject"
final_data = cbind(merge_subject, merge_y, merge_x)

# 4. Creating a tidy data set: the average/variable/activity & subject
subject_len = length(table(merge_subject)) 
act_len = dim(activity)[1] 
column_len = dim(final_data)[2]
result = matrix(NA, nrow=subject_len*act_len, ncol=column_len)
result = as.data.frame(result)
colnames(result) = colnames(final_data)
row = 1
for(i in 1:subject_len) {
  for(j in 1:act_len) {
    result[row, 1] = sort(unique(merge_subject)[, 1])[i]
    result[row, 2] = activity[j, 2]
    bool1 = i == final_data$subject
    bool2 = activity[j, 2] == final_data$activity
    result[row, 3:column_len] = colMeans(final_data[bool1&bool2, 3:column_len])
    row = row + 1
  }
}
head(result)
write.table(result, "tidy_data.txt")