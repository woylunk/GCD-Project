GCD-Project
===========
The attached script (run_analysisR) assumes that you have set your working directory and that the UCI HAR Dataset folder lies within that working directory.  It was created and run with R 3.1.1 (32-bit version).  Many details about the process are also provided within the script itself, providing justification for particular code lines.  The script is also divided into steps for each step of the assignment, as follows:

1. Merge training and test data sets into one data set:  This was done by first reading in the 3 files (subject, X, Y) for test and train, then creating a single dataset each for train and test.  Those 2 datasets were then combine to form one final dataset.

2. Extract only the variables for mean and standard deviation for each measurement: To do this, I referenced the features.txt file to determine which variables needed to be included.  All variables with mean or std in the title were selected, except for the angle variables (as those were refering to angles between vectors, some of which were means themselves, but the angle variable itself was not a mean).

3. Add descriptive activity names: I used mapvalues to substitute the descriptive activity names from activty_labels.txt for the numeric codes already in the dataset as a new variable.  I then removed the original, numeric variable for activity and moved my new variable to the far left of the dataset.

4. Label dataset with descriptive variable names:  I read in the features.txt file to access the descriptive variable names provided by the project, and selected for the variables that used mean or standard deviation (as done above), then added rows for activity and subject (the only variables in the main dataset not listed in the features table).  I turned this list (column 2 of the features table) into a vector that I then used to rename column headings in the main dataset.  Finally, I cleaned up the names by removing hyphens, parentheses and making them all lowercase.  I also substituted in "time" for the "t" at the start of some variables in order to be more descriptive. I left the f as it was, as FFT didn't seem much more descriptive, and writing out the full "fastfouriertransform" seemed far too long and more likely to decrease readability.

5. From the dataset created in step 4, create an independent, tidy dataset with average of feature variables by subject and activity:  I used ddply to create a table showing means of the feature variables by activity and subject, then wrote the resulting table to a text file ("step5table.txt").  To re-open this table in R, place the file in the working directory, then use:    test <-read.table("step5table.txt", header=TRUE)







