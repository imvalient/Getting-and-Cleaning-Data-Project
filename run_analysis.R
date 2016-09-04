# Getting and Cleaning Data Course Project.
# Author: Imanol Valiente Martín.
# Year: 2016.

# Required reshape2 package.
if (!require("reshape2"))
  install.packages("reshape2")

# load features and activity labels data.
features <- read.table('features.txt')
activityLabels <- read.table('activity_labels.txt')

# Filter mean and standard deviation features.
measuredFeatures <- grepl("mean()|std()", features[, 2])
measuredFeaturesNames <- features[measuredFeatures, 2]

# Load x, y and subject test data.
xTest <- read.table('./test/X_test.txt')
yTest <- read.table('./test/Y_test.txt')
subjectTest <- read.table('./test/subject_test.txt')

# Load x, y and subject train data.
xTrain <- read.table('./train/X_train.txt')
yTrain <- read.table('./train/Y_train.txt')
subjectTrain <- read.table('./train/subject_train.txt')

# Merge x, y and subject train and test data.
xSet <- rbind(xTest, xTrain)
ySet <- rbind(yTest, yTrain)
subjectSet <- rbind(subjectTest, subjectTrain)

# Significative name to subject data set.
names(subjectSet) <- "subject"

# Merge activity labels with 'Y' activity ID data set.
ySet[, 2] <- activityLabels[ySet[, 1], 2]
# Assign a significative name to 'Y' data set.
names(ySet) <- c('idActivity', 'activityLabel')

# Obtain X values corresponding to the Mean and Standard deviation values only.
measuredXSet <- xSet[, measuredFeatures]
# Significative name to the measurable X data set.
names(measuredXSet) <- measuredFeaturesNames

# Merge subject, Y data set and X data set into a tidy data set.
tidyData <- cbind(subjectSet, ySet, measuredXSet)

# Reorganize data so  mean and standard deviation values are set as two columns key value per corresponding row.
gatheredData <- gather(tidyData, key, value, 4:82)

# Cast data calculating for each row, the mean of the var column and group data by activity and subject.
meanTidyData <- dcast(gatheredData, activityLabel + subject ~ key, mean)

# Output the data into a text file named "tidy-data.txt".
write.table(meanTidyData, file = 'tidy-data.txt', row.names = FALSE)
