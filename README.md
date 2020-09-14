# run_analysis
Getting and Cleaning Data Course Project

 # 0 Get required data into a list
Download the compressed file 
## Unzip the file
## Import TXT file via for loop
 
 # 1 Merges the training and the test sets to create one data set
## Use the rbind() function to merge observations
## Use cbind() function to merge features, y and subject ID

 # 2 Extracts only the measurements on the mean and standard deviation for each measurement
## Use the grepl() function to identify where the "mean" or "std" text appears in the features data
## Use the grepl() function to identify the locations where the meanFrequency() text appears in the "features" data, these should be excluded
## Keep the two variables: "subject ID" and "y"

 # 3 Uses descriptive activity names to name the activities in the data set
## activities <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

 # 4 Appropriately labels the data set with descriptive variable names
## grepl(pattern = "mean()|std()")
## grepl(pattern = "meanFreq()")

 # 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
## tidy_data_set <- mean_std_df %>%
##  group_by(subject, activity) %>%
##  summarise_all(mean)

 # 6 Export the table
## Export the tidy_data_set.txt and tidy_data_set.csv

