# GetCleanDataProject
The script run_analysis.R reads in the data and applies the proper labels to rows and columns.
It then filters the std and mean variables, calculates the mean of each of them by subject and activity.
The final output is a file where each column (except the 1st) is the mean of the corresponding variable,
and the rows are first the activities and then the subjects. 

# Running the script
The script can be run through Rstudio. Since the data file is larger than the github limit,
the user needs to provide this for themselves

# Output file
Present in output.txt
Also available the version output-named.txt, which includes the row names, for clarity