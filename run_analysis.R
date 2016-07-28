# ------------------------------------------------------
#    Getting and Cleaning Data - Week Four Assignment
# ------------------------------------------------------
# Step 1: Set up environment for the project and load the necessary libraries
setwd("./../git/Coursera/GetClearData/")
library(stringr)
library(dplyr)
library(tidyr)
library(reshape2)

# Step 2: Download and upzip files

# Create a helper function to download the files
# This function makes sure that:
#  a) the data directory exists
#  b) if the file already exists it isn't re-downloaded

fileDownloader <- function (url, fname, directory = "./data") {
    # check to see if the directory exists, if not, create it
    if(!file.exists(directory)) {
        message(paste("Creating directory:", directory))
        dir.create(directory)
    } else {
        message(paste(directory, "directory already exists..."))
    }
    
    #Create a full path to the file
    fullFileName <- paste(directory, fname, sep = "/")
    
    # Determine the download method based on the file type
    # 1. Extract the file type from the fname parameter
    #    The str_match function returns an array based on the grep pattern used
    #    Since I have used backreferences - by using brackets "()" - the value
    #    that I need is in the second item "[, 2]". The full match, including the period,
    #    is in the first item "[, 1]"
    # 2. Compare the filename to known file types and set the download mode
    FileType <- str_match(fname, pattern = "\\.(.+)$")[, 2]
    BinaryFileTypes <- c("zip", "xlsx")
    DownloadMode <- ifelse(FileType %in% BinaryFileTypes, "wb", "auto")
    
    # Check if the file exists. If not, download it using the correct
    # download method
    if(!file.exists(fullFileName)) {
        message(paste("Downloading file", fname))
        download.file(url, fullFileName, mode = DownloadMode)
    } else {
        message("File already downloaded...")
    }
}

# --- Download the Zip File

# Define the download URL.
ZipFileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Grep out the filename - we'll use that again
# This regex finds the string %2F and then starts capturing from that point. If if finds %2F in the string,
# it restarts the capture from that point until the end of the line.
# Also, replace the GET version of space (%20) in the filename with a space.
ZipName <- str_match(ZipFileURL, "\\%2F((?:(?!\\%2F).)*)$")[, 2]
ZipName <- str_replace_all(ZipName, "%20", " ")

# Download the ZIP file and then unzip it
fileDownloader(ZipFileURL, ZipName)
unzip(paste("./data", ZipName, sep = "/"), exdir = "./data")

# The output directory doesn't have a .zip extension. Strip of the extension so we can use that name.
dataDir <- str_replace(ZipName, ".zip", "")

# Define the directories where the data is located.
baseDataDir  <- file.path("./data", dataDir)
testDataDir  <- file.path(baseDataDir, "test")
trainDataDir <- file.path(baseDataDir, "train")

# Create a generic function to read in files
readInData <- function(fnFileName, ...) {
    read.table(fnFileName, header = FALSE, ...)
}

# Load activity labels + features
# Also, convert the text field to character (not factor) and assign heading values
activityLabels <- readInData(file.path(baseDataDir,  "activity_labels.txt"), 
                             colClasses = c("numeric", "character"), 
                             col.names = c("id", "activity"))
featureLabels <- readInData(file.path(baseDataDir,  "features.txt"), 
                            colClasses = c("numeric", "character"), 
                            col.names = c("id", "feature"))

# Work out which of the features we need (mean and std.dev columns)
# Grep selects either mean or std followed by ().
# First, return a vector of indexes showing those labels that contain mean() or std()
# Then, make the names CamelCase and remove the brackets and hyphens.
featureLabels.meanstd <- grep("(?:mean|std)\\(", featureLabels$feature)

# Extract the names and store in the file
featureLabels.names <- featureLabels[featureLabels.meanstd, 2]

# 1. Define a vector of regexes and substitutions
#    Replace -mean and -std with Mean and Std respectively then remove the hyphens and brackets
#    Then remove the abbreviations and make the names descriptive
RegexSubs <- c("\\-mean"   = "Mean",
               "\\-std"    = "StdDev",
               "[-()]"     = "",
               "^f"        = "frequency",
               "^t"        = "time",
               "Acc"       = "Accelerometer",
               "BodyBody"  = "Body",
               "Gyro"      = "Gyroscope",
               "Mag"       = "Magnitude")

# 3. Apply these regexes to the featureLabels.names vector
featureLabels.names <- str_replace_all(featureLabels.names, RegexSubs)

# Read in the test data files
testDataSubjects    <- readInData(file.path(testDataDir, "subject_test.txt"), col.names = "subject")
testDataActivities  <- readInData(file.path(testDataDir, "y_test.txt"), col.names = "activity")
testDataRecords     <- readInData(file.path(testDataDir, "X_test.txt"))[, featureLabels.meanstd]
colnames(testDataRecords) <- featureLabels.names

# Combine all test files into a single dataset
test.data <- cbind(testDataSubjects, testDataActivities, testDataRecords)

# Read in the train data files
trainDataSubjects   <- readInData(file.path(trainDataDir, "subject_train.txt"), col.names = "subject")
trainDataActivities <- readInData(file.path(trainDataDir, "y_train.txt"), col.names = "activity")
trainDataRecords    <- readInData(file.path(trainDataDir, "X_train.txt"))[, featureLabels.meanstd]
colnames(trainDataRecords) <- featureLabels.names

# Combine all train files into a single dataset
train.data <- cbind(trainDataSubjects, trainDataActivities, trainDataRecords)

#Combine the train and test data together to make a full dataset.
combined.data <- rbind(test.data, train.data)

# Convert activities and subjects into factors
# With subjects we only have their ID
# With Activities we have their ID and their description

combined.data$subject <- as.factor(combined.data$subject)
combined.data$activity <- factor(combined.data$activity, 
                                 levels = activityLabels$id, 
                                 labels = activityLabels$activity)

# Use this dataset to create the second dataset
# First, convert the dataset to long format 
melted.data <- melt(combined.data, id = c("subject", "activity"))

# Calculate the means of each variable for each subject/activity combination
mean.data <- dcast(melted.data, subject + activity ~ variable, mean)

# Finally, write the mean.data file out to disc.
write.table(mean.data, "TidyData.txt", sep = ",", row.names = FALSE)

#----------------------------------------------
#               End of File
#==============================================