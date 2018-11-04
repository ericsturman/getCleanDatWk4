featuresRead <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("label","activity"))
colIndices <- grep("mean|std", featuresRead$V2)
features <- featuresRead[colIndices,]
XTestRead<-read.table("./UCI HAR Dataset/test/X_test.txt")
XTest <- XTestRead[,colIndices]
yTest<-read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "label")
yTestLabels <- merge(activities, yTest, by="label")
subjectTest<-read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
testTotal <- cbind(XTest, activity=yTestLabels$activity, subjectTest, testOrTrain = rep("TEST", nrow(XTest)))
XTrainRead<-read.table("./UCI HAR Dataset/train/X_train.txt")
XTrain <- XTrainRead[,colIndices]
colnames(XTest) <- features$V2
yTrain<-read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "label")
yTrainLabels <- merge(activities, yTrain, by="label")
subjectTrain<-read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
headerDat <- c(as.vector(features[,2]),"activity", "subject", "testOrTrain")
trainTotal <- cbind(XTrain, activity=yTrainLabels$activity, subjectTrain, testOrTrain = rep("TRAIN", nrow(XTrain)))
totalData <- rbind(trainTotal, testTotal)
names(totalData) <- headerDat
orderedTotalData <- totalData[order(totalData$testOrTrain, totalData$subject, totalData$activity),]
#removing NAs does not result in less rows, so there are no NAs in the data set.
#noNAs<- totalData[complete.cases(totalData),]
tidyFinal <- aggregate(orderedTotalData[names(orderedTotalData)[1:79]], by=orderedTotalData[c("activity", "subject", "testOrTrain")], FUN=mean)
write.table(tidyFinal, "tidyDataSet.txt", row.name=FALSE)