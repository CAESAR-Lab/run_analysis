# run_analysis.R
rm(list=ls()) # removes all objects from the current workspace (R memory)

library(dplyr)
library(magrittr)

## Get required data into a list
Data_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest_file = "~/Downloads/HAR.zip"
ex_dir = "~"
download.file(Data_URL, destfile = dest_file) # Download the compressed file
unzip(dest_file, exdir = ex_dir) # Unzip the file
File_Names <- c("train/X_train.txt", "train/y_train.txt", "train/subject_train.txt", "test/X_test.txt", "test/y_test.txt", "test/subject_test.txt", "features.txt")
File_Paths <- paste0("~/UCI HAR Dataset/", File_Names)
df_names <- c("X_train", "y_train", "subject_train", "X_test", "y_test", "subject_test", "features")
df_list <- list()
for (i in 1:length(File_Paths)) {
  df_list[[i]] <- read.table(File_Paths[i], stringsAsFactors = FALSE) # Import TXT file
}
names(df_list) <- df_names


## Merges the training and the test sets to create one data set
X <- rbind(df_list$X_train, df_list$X_test) # Use the rbind() function to merge observations
y <- rbind(df_list$y_train, df_list$y_test) 
subject <- rbind(df_list$subject_train, df_list$subject_test) 
df <- cbind(y, X) # Use cbind() function to merge features, y and subject ID
df <- cbind(subject, df)


## Extracts only the measurements on the mean and standard deviation for each measurement
feature_names <- df_list$features$V2
has_mean_std <- feature_names %>%
  grepl(pattern = "mean|std") # Use the grepl() function to identify where the "mean" or "std" text appears in the features data
has_meanFreq <- feature_names %>%
  grepl(pattern = "meanFreq()") # Use the grepl() function to identify the locations where the meanFrequency() text appears in the "features" data, these should be excluded
feature_selector <- has_mean_std & !has_meanFreq
feature_selector <- c(TRUE, TRUE, feature_selector) # Keep the two variables: "subject ID" and "y"
mean_std_df <- df[, feature_selector]


## Uses descriptive activity names to name the activities in the data set
activities <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
for (i in 1:length(activities)) {
  mean_std_df[, 2][mean_std_df[, 2] == i] <- activities[i]
}
return(mean_std_df)


## Appropriately labels the data set with descriptive variable names
feature_names <- df_list$features$V2
has_mean_std <- feature_names %>%
  grepl(pattern = "mean()|std()")
has_meanFreq <- feature_names %>%
  grepl(pattern = "meanFreq()")
feature_selector <- has_mean_std & !has_meanFreq
variable_names <- c("subject", "activity", feature_names[feature_selector])
names(mean_std_df) <- variable_names



## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_data_set <- mean_std_df %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

## Export the table
Output_Path = setwd(getwd())
write.table(tidy_data_set,file=paste0(Output_Path,"/tidy_data_set.txt"),row.names = FALSE)
#library(data.table)
write.csv(tidy_data_set,file=paste0(Output_Path,"/tidy_data_set.csv"),row.names = FALSE)

