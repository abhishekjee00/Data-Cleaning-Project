### Introduction

The purpose of this project is to demonstrate ability to collect, work with, and clean a data set for Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. The goal is to prepare tidy data that can be used for later analysis.

### run_analysis.R

The script "run_analysis.R" contains function in the same name. The function validates existence of files in the test and train folders. In case the file is missing then the program will error out with the error message of the missing file.

### Step 1

The script uses read.table function to load data in the respective data frames. While loading the data from x_test and x_train, the col.names have been constructed from feautres dataset

col.names = features[,"V2"]

Additionally, check.names clause has been used to strip off () and - (minus) sign from the variable names as this was causing problem later in selecting these columns for summarize.

check.names = TRUE

Thus, the command looks like
x_test <- read.table("./test/X_test.txt", col.names = features[,"V2"], check.names = TRUE)

### Step 2

Once the data has been loaded in the respective data frames then x_test and y_test is combined using cbind function. Similarly x_train and y_train is combined.
test <- cbind(Set = "test", y_test, x_test)
train <- cbind(Set = "training", y_train, x_train)

In order to merge the test and train dataset the rbind function is used
merged_data <- rbind(test, train)

### Step 3

Finally, the complete dataset is prepared by merging the merged_data with activity_labels dataset to find the activity_name

merge(merged_data, activity_labels, by.x = "Activity.ID", by.y = "Activity.ID")

Now the final data is ready meeting the criteria
1. Merge the training and the test sets to create one data set.
2. Use descriptive activity names to name the activities in the data set
3. Appropriately labels the data set with descriptive variable names

### Step 4

The merged_data is now loaded into "data frame table using tbl_df. Now using the chaining (%>%) command following commands are executed

merged_data_summary <- merged_data_df %>% 
    select(Activity.Name, Set, contains("mean"), contains("std")) %>%
    group_by(Activity.Name, Set) %>%
    summarize(tBodyAcc.mean.X = mean(tBodyAcc.mean...X, na.rm = TRUE),
              tBodyAcc.mean.Y = mean(tBodyAcc.mean...Y, na.rm = TRUE),
              tBodyAcc.mean.Z = mean(tBodyAcc.mean...Z, na.rm = TRUE)) %>%
    print

The "contains" function allows to select variables which has mean and std in its name. Secondly, while computing the average na.rm = TRUE is used in the mean function to ignore NA cases

### Note

The code restricts to tBodyAcc.mean.X, tBodyAcc.mean.Y and tBodyAcc.mean.Z variables only and the code can be extended to load other variables as they are available in the data frame.
