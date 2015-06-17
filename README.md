# Cleaning Data Class Project
Project for the Coursera course: Getting and Clenaing Data

## Motivations

We were given a large (over 10,000 observations of 563 variables) data set gathered from thirty individuals performing six different exercises. These were gathered by the use of a Samsung Galaxy S smart phone placed at their waists during these exercises.  
The goal of this project is to take that large set of data and clean and compress it into a tidy data set that is much more managable. We will discuss how that was performed in this document.

## Set Up

Our function, run_analysis, can take a variable called "directory", which defaults to "UCI HAR Dataset", the default name of the data file. If the file in its original form is unzipped and placed into the working directory, the directory variable can be left unchanged. However, if it is different, simply supply the name of the file the data is in. Please not that the code assumes the contents of the file are unchanged, and any change to them may corrupt its results.  

For assistance in manipulating the data, we use the package dplyr. If this is not previously installed on your machine, please run "install.packages("dplyr")" prior to using this function.  

## Loading the Data

The first few lines of code load the files from your directory. testData takes the file "X_test.txt", testUsers takes the file "subject_test.txt", and testEx takes the file "y_test.txt". The train-type variables do the same for the train files.  

From there, we assign column names to the -Users and -Ex variables of "UserNumber" and "ExerciseType", respectively. The namesData takes the file "features.txt" and will be used to add the variable names to each of the measurements (However, due to interactions between the dplyr package's arrange function and several repeated collumn names which will be dropped later, we will wait to add these names until a bit later)

## Combining the Data

We now bind the test- and train- variables together using cbind (binding them together by collumn), such that we have, from left to right, the user number, the exercise type, and then all the measurements. It is vitally important that both the resulting testData and trainData are in the same order so when they are combined the data is arranged properly.  

Now we bind the testData and trainData data frames together to form the fullData. This binding is done using rbind (binding them together by row), preserving the order of the data so that they remain in the user number to exercise type to measurements order.  

For the sake or order, we use the arrange function on this fullData so that we can order it from user 1 to user 30. This is not entirely necessary, but it keeps the data orderly while the function works through it, and makes reading the data more bearable if the function were to fail following this point.

## Finishing the Column Names

Now we want to finish adding the column names to our data. It may be important to note that while we are rewriting the first two variables as "UserNumber" and "ExerciseType", we needed UserNumber to be previously encoded to use the arrange function by it. (It is likely possible to rewrite this section of the code more efficiently due to this, but it is not within the scope of the project to be concerned over this.) We also take each of the variable names stored in namesData (gathered from "features_info.txt"), and assign them to each of the remaining columns in our data.  

While the project does not call for this to be done at this point (rather expecting it to be done in Part 4), I found it useful to extract the data of interest (part 2) using the names for this data.  

With this complete, parts 1 and 4 are completed from the project.

## Extracting mean() and std() Data

Here, because we have the column names for the data, we use the grep command to search for exactly "mean()" or exactly "std()" in the column names. This command returns the numbers of each column it found with the search. We then simply make extractData out of fullData's first and second rows (user and exercises) and each of the rows found in the search.  

This completes part 2 of the project.

## Naming the Exercises

Here we want to take the current ExerciseType column and replace the numbers 1-6 with descriptors of the exercises. We find the translation key to this in the file "activity_labels.txt", but do not need to load that file. Instead, we transform the second column (ExerciseType) into a factor variable. Since it is already numbered 1-6, we simply supply the labels as the associated exercise for each number from 1 ("Walking") to 6 ("Laying").  

This completes part 3 of the project. (Note: recall part 4 is already complete)

## Making the Tidy Data

We want to generate a tidy data set in this step, and we do so by taking the mean of every unique pair of UserNumber and ExerciseType. This means User 1's Walking data would all be averaged to a single variable distinct from User 1's Sitting data and distinct from User 2's Walking data.  

To do this, we first construct a dummy data frame called finalData out of our extractData's first 180 rows. We will overwrite every line of this, but doing it in this way allows us to seamlessly transfer our collumn names and properties (such as ExerciseType's factors) to the new data frame. A note: the length of 180 is the the number of users (30) multiplied by the number of exercises (6).  

Then, we run a for loop from 1 to 30 on the variable "user", to itterate from UserNumber 1 to 30. We translate this User number to an index so that User 1's data starts at line 1, then User 2's data starts at line 7, etc.  

We then step through each line of finalData, first setting the UserNumber equal to the appropriate user. Then we set the ExerciseType to the proper exercise. Finally, we subset extractData so we are only looking at the rows for the appropriate UserNumber and ExerciseType, and use colMeans to get the averages of each column, and feed it to finalData. This is repeated first across each ExerciseType for a user, then across each ExerciseType for the next user, repeated until all 30 users have had their data tidied.  

Finally, we simply return the finalData dataset. For the sake of clarity, we do not print the table to a file in this function, but if one were to do so, they would simply return run_analysis to a variable, say "TidyData". Then, print that TidyData out using "write.table(TidyData, file = "TidyData.txt",row.name=FALSE)".  

This concludes our project. For additional information on the column names, and the originally gathered data, please refer to CodeBook.txt.