# 1. read training dataset of features and test dataset of features and merge them into one dataset
dat.train <- read.table("train/X_train.txt",sep="")
dat.test <- read.table("test/X_test.txt",sep='')
dat <- rbind(dat.train,dat.test)
# Add Names of columns for feature dataset
colname <- read.table("features.txt", stringsAsFactors=FALSE)
colname <- colname$V2
colnames(dat) <- colname
# delete useless dataset
rm(dat.train)
rm(dat.test)

sub.test <- read.table("test/subject_test.txt")
sub.train <- read.table("train/subject_train.txt")
sub <- rbind(sub.train,sub.test)
# delete useless dataset
rm(sub.train)
rm(sub.test)

label.test <-testLabel <- read.table("test/y_test.txt")
label.train <- read.table("train/y_train.txt")
label <- rbind(label.train,label.test)
# delete useless dataset
rm(label.train)
rm(label.test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
colnames(dat) <- tolower(colnames(dat))
dat.extrated <- dat[ , grep("mean|std", colnames(dat))]

# 3. Uses descriptive activity names to name the activities in the data set
label.activity <- read.table("activity_labels.txt")
label$V1 <- factor(label$V1,labels=label.activity$V2)
colnames(label) <- "Activity"

# 4. Appropriately labels the data set with descriptive variable names. 
colnames(sub) <- "Subject"
data.tidy <- data.frame(label, dat.extrated, sub)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
data.tidy.2nd <- ddply(data.tidy,c("Activity", "Subject"),function(data.tidy) {
  ave <- colMeans(data.tidy[,2:87])
  data.frame(ave)
})
write.table(data.tidy.2nd, "data.tidy.2nd.txt",row.name=FALSE)






