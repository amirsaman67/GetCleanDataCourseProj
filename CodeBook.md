---
title: "CodeBook.md"
author: "Brett Crosby"
date: "27 July 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Getting and Cleaning Data - Week 4 Assignment

## Libraries
library(stringr)  
library(dplyr)  
library(tidyr)  
library(reshape2)  

## Functions
**fileDownloader <- function (url, fname, directory = "./data") {}**  

Create a helper function to download the files. This function achieves the following:  
 * It ensures that the data directory exists  
 * If the file already exists it isn't re-downloaded  
 * It also determines the download mode (based on the file extension)

**readInData <- function(fnFileName, ...) {}**   

There is a lot of boilerplate in the read functions, this helper function takes care of a lot of that.

## Variables
These variables appear in the order they appear in the code. As some of them rely on what has come prior, this makes most sense to me.

| Variables        | Description                               |  
|:-----------------|:------------------------------------------|  
| ZipFileURL    | The URL of the zip file to be downloaded |  
| ZipName       | The name of the actual file at the end of the ZipFileURL |  
| dataDir       | The name of the directory that the zip file is extracted to |  
| baseDataDir   | Base Directory of the working data files |  
| testDataDir   | Location of the test data files |  
| trainDataDir  | Location of the train data files |  
| activityLabels | The list of activities that the subjects were measured against. |  
| featureLabels | The names and IDs of the measurements that were recorded |  
| featureLabels.meanstd |  Vector of measurements to do with Mean and Std.Dev (TRUE/FALSE) |  
| featureLabels.names | The actual names of the measurements |  
| RegexSubs     | A vector of regular expressions and substitute text |  

## Datasets
### Test data files
| Variable Name    | Description                               |  
|:-----------------|:------------------------------------------| 
| testDataSubjects | Test Subject data |  
| testDataActivities | Test Activity data |  
| testDataRecords | Test Measurements |  
| test.data | All Test data combined into a single dataset |  

### Train data files
| Variable Name    | Description                               |  
|:-----------------|:------------------------------------------| 
| trainDataSubjects | Train Subject data |  
| trainDataActivities | Train Activity data |  
| trainDataRecords | Train Measurements |  
| train.data | All Train data combined into a single dataset |  

### Combined data 
| Variable Name    | Description                               |  
|:-----------------|:------------------------------------------| 
| combined.data | The combined Test and Train data |  
| melted.data | A long-format version of the combined data |  
| mean.data | Dataset with means calculated for each subject/activity combination |  