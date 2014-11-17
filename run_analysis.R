install.packages("data.table", repos="http://cran.rstudio.com/")
library(data.table)

# Load activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Load data column names
features <- read.table("./UCI HAR Dataset/features.txt")

# Load and process X_test & y_test data.
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Adding column names to file X_test.
names(x_test) = features[,2]

# Limiting columns to those dealing with mean or standard deviation.
x_test = x_test[,grepl("mean|std", features[,2])]

# Load activity labels
y_test[,2] = activity_labels[y_test[,1],2]
names(y_test) = c("activity_id", "activity_label")
names(subject_test) = "subject"

# CBind test data
test_data <- cbind(as.data.table(subject_test), y_test, x_test)

# Load and process X_train & y_train data.
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Adding column names to file X_train.
names(x_train) = features[,2]

#Limiting columns to those dealing with mean or standard deviation.
x_train = x_train[,grepl("mean|std", features[,2])]

# Load activity labels
y_train[,2] = activity_labels[y_train[,1],2]
names(y_train) = c("activity_id", "activity_label")
names(subject_train) = "subject"

# CBind train data
train_data <- cbind(as.data.table(subject_train), y_train, x_train)

# RBind train and test data
data<-rbind(train_data,test_data)

install.packages("reshape", repos="http://cran.rstudio.com/")
library(reshape)
install.packages("reshape2", repos="http://cran.rstudio.com/")
library(reshape2)

# Creating a set of ID Fields for data melt
id_set <- c("subject","activity_label","activity_id")

# Creating a set of Measure fields for data melt
measures <- colnames(x_test)

# Melting data to create a tall and skinny data set with a row for every subject, activity, measure combination
data_melt <- melt(data,id = id_set, measure.vars = measures)

# Re-casting the data set to summarize data showing the mean of each measure for every subject and activity
measures_avg <- dcast(data_melt, subject + activity_label ~ variable,mean)
