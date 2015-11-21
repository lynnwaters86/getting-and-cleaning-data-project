### The project for "getting and cleaning data" course.
### This R script called run_analysis.R that does the following: 
### 1 Merges the training and the test sets to create one data set.
### 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
### 3 Uses descriptive activity names to name the activities in the data set
### 4 Appropriately labels the data set with descriptive variable names. 
### 5 From the data set in step 4, creates a second, independent tidy data 
###   set with the average of each variable for each activity and each subject.


library(data.table)

activity_labels <- read.table("./project/activity_labels.txt")[,2]   ### Read activity labels.
features <- read.table("./project/features.txt")[,2]   ### Read data column names.
extract_features <- grepl("mean|std", features)  ### Extract mean and sd.

### First we read and process the test data.
subject_test <- read.table("./project/test/subject_test.txt") ## Read subject_test data.
X_test <- read.table("./project/test/X_test.txt")  ## Read X_test data.
y_test <- read.table("./project/test/y_test.txt")  ## Read y_test data.
names(X_test) = features       ## Give name to X_test data.
names(subject_test) = "subjectid"   ## Give name to subject_test data.

X_test = X_test[,extract_features]  ## Extract mean and sd.
y_test[,2] = activity_labels[y_test[,1]]   ## Read activity labels
names(y_test) = c("Activity_ID", "Activity_Label") ## Give name to y_test data.
test_data <- cbind(as.data.table(subject_test), y_test, X_test)  ## Bind subject,y&x data.

### We do the same thing on training data as test data above. 
subject_train <- read.table("./project/train/subject_train.txt")
X_train <- read.table("./project/train/X_train.txt")
y_train <- read.table("./project/train/y_train.txt")
names(X_train) = features
names(subject_train) = "subjectid"

X_train = X_train[,extract_features]
y_train[,2] = activity_labels[y_train[,1]]  
names(y_train) = c("Activity_ID", "Activity_Label")
train_data <- cbind(as.data.table(subject_train), y_train, X_train) 

### Merges the training and the test sets to create one data set.
data = rbind(test_data, train_data)  
id_labels  = c("subjectid", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
merge_data  = melt(data, id = id_labels, measure.vars = data_labels)
write.table(merge_data, file = "./merge_data.txt", row.name=FALSE)

### Using write.table function to creat a txt file and save it.
final_data  = dcast(merge_data, subjectid + Activity_Label ~ variable, mean)
write.table(final_data, file = "./final_data.txt", row.name=FALSE)
