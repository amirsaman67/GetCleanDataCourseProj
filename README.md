---
title: "README.md"
author: "Brett Crosby"
date: "28 July 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Getting and Cleaning Data - Week 4 Assignment

## Project Description  
This is the "Getting and Cleaning Data"" Course Project. The task is to read in a series of raw data files, perform a series of manipulations on the data to make it "tidy" and then write out a tidy file as the end result. This tidy file may be used for further analysis at a later time.  
**Steps**  (From the Coursera Assignment Page)  
1. Read in and merge the training and the test sets to create one data set.  
2. Extract only the measurements on the mean and standard deviation for each measurement.  
3. Use descriptive activity names to name the activities in the data set  
4. Appropriately label the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

## Instructions  
The code is self contained to the point that, once you set a working directory the code then downloads and places all input files into a hierarchical file structure. All downloaded files go into the **./data/** directory and then the unzipped files go into **./data/UCI HAR Dataset/**.  
There are no manual manipulations of the files to either extract or set filenames or any other variables. All naming variables are calculated from the downloaded file name.  
To use this code simply place the file in the appropriate directory, install and load the appropriate packages (see CodeBook.md for details), and run the script.
The final output file (TidyData.txt) is saved to the same directory that this file is stored.  

## Data Set Information:
The description below is from the **UCI Center for Machine Learning and Intelligent Systems** website (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).  

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.  

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.  

## Attribute Information:

For each record in the dataset it is provided:  
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.  
- Triaxial Angular velocity from the gyroscope.  
- A 561-feature vector with time and frequency domain variables.  
- Its activity label.  
- An identifier of the subject who carried out the experiment.   
