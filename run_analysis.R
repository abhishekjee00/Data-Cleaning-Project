run_analysis <- function() {

  if (!file.exists("./activity_labels.txt")) { 
    stop("Missing file: activity_labels.txt")  
  }  

  if (!file.exists("./features.txt")) { 
    stop("Missing file: features.txt")  
  }   

  if (!file.exists("./test/X_test.txt")) { 
    stop("Missing file: x_test.txt")  
  }   
  
  if (!file.exists("./test/y_test.txt")) { 
    stop("Missing file: y_test.txt")  
  }     

  if (!file.exists("./train/X_train.txt")) { 
    stop("Missing file: x_train.txt")  
  }   
  
  if (!file.exists("./train/y_train.txt")) { 
    stop("Missing file: y_train.txt")  
  } 
  
  ## load activity_label data
  activity_labels <- read.table("./activity_labels.txt", col.names = c("Activity.ID", "Activity.Name"))
  
  ## load features data to prepare feature factor for namining the col names
  features <- read.table("./features.txt")
  
  ## Load test data
  x_test <- read.table("./test/X_test.txt", col.names = features[,"V2"], check.names = TRUE)
  y_test <- read.table("./test/y_test.txt", col.names = c("Activity.ID"))
  
  ## Load training data
  x_train <- read.table("./train/X_train.txt", col.names = features[,"V2"], check.names = TRUE)
  y_train <- read.table("./train/y_train.txt", col.names = c("Activity.ID"))
  
  ## Merge the training & test sets to create one data set including Activity Name and Set
  merged_data <- rbind(cbind(Set = "test", y_test, x_test), cbind(Set = "training", y_train, x_train))
  rm(x_test)
  rm(y_test)
  rm(x_train)
  rm(y_train)
  
  merged_data_df <- tbl_df(merge(merged_data, activity_labels, by.x = "Activity.ID", by.y = "Activity.ID"))  
  rm(merged_data)
  
  ## Prepare the final merged data containing mean and standard deviation value
  merged_data_summary <- merged_data_df %>% 
    select(Activity.Name, Set, contains("mean"), contains("std")) %>%
    group_by(Activity.Name, Set) %>%
    summarize(tBodyAcc.mean.X = mean(tBodyAcc.mean...X, na.rm = TRUE),
              tBodyAcc.mean.Y = mean(tBodyAcc.mean...Y, na.rm = TRUE),
              tBodyAcc.mean.Z = mean(tBodyAcc.mean...Z, na.rm = TRUE)) %>%
    print
  
  write.table(merged_data_summary, "final.txt", row.name = FALSE)
  
}
