GCData-Project

============================



Course Project for "Getting and Cleaning Data"


The goal of this project was to practice getting, cleaning and working with a data set.


This repository contains three files:

	- README.md to explain the contents of the repository

	- codebook.pdf to provide detailed information about the dataset and variables used  
	 (Note: to view this file, you may have to click the "View Raw" link in GitHub)

	- run_analysis.R an R script for cleaning and analyzing the dataset


More Information about run_analysis.R
-------------------------------------
  The run_analysis.R script file will create two tidy sets of data when run with the extracted files from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip located in your working directory.  
  The first dataset, "tidydata.csv" is a CSV file containing 10299 observations of 68 variables.  Each record represents measurements on 66 variables for one subject performing one activity.
  The second dataset, "tidydata2.txt" is a CSV file containing 180 observations of 68 variables.  Each record represents the average measurement on 66 variables for one subject performing one activity.  This second dataset is essentially a summary form of the first dataset.

The script file performs the following activities:

1. Read into R the training data, the test data, the variable names and the activity names.

2. Append human readable activity labels to each record of the training and test datasets.

3. Append a subject identifier to each record of the training and test datasets.

4. Merge the training and test datasets into one data frame.

5. Replace the generic column headers (V1, V2, etc.) with variable names provided in the features.txt file.

6. Extract only the columns that contain measurements of mean or standard deviation and discard the rest.

7. Replace some of the cryptic abbreviations used in the variable names with complete words.

8. Write out this data set as a csv file named "tidydata.csv"

9. Split the dataset by subject ID.  (There are 30 subjectIDs so we get 30 lists).

10. Loop over the 30 lists and split each one by activity.  (There are six activities so this gives us 6 lists per loop).

11. Compute the average of each variable.  This is the average for one subject for one activity.

12. Save the data in a new data frame and coerce the values back to their proper data types.  (Subject ID is an integer, data points should all be numbers.)

13. Write out this tidy dataset as a csv file named "tidydata2.txt".
