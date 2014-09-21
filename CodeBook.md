Code book for the run_analysis script in the README.md file.

Variables, data transformations,

The data used for this data set are measurments of signals from the accelerometer (Acc) 
and gyroscope (Gyro) sensors of Samsung Smartphones worn by individual subjects.  

The sensor signals were separated into two domains:
time domain signals--denoted with "t" and frequency domain signals--denoted with "f".
Therefore, the variables consist of time domain-accelerometer signals, 
time domain-gyroscope signals, frequency domain-accelerometer signals and
frequency domain-gyroscope signals with generalized variable names of format
t..Acc.., t..Gyro.., f..Acc.., and f..Gyro.., respectively.

The final format of the variable names were transformed to the names in "finaldataset"
by removing the characters, "(", ")", "," and "-".  In addition, all characters were 
made lower case.  Here is an example:
tBodyAcc-mean()-X was transformed to tbodyaccmeanx

Measurements were made while subjects performed each of six activities:

(1) walking, (2) walking upstairs, (3) walking downstairs, 
(4) sitting, (5) standing and (6) laying.

Numeric labels given in the y-train.txt and x_train.txt were converted to 
descriptive labels according to the coding scheme from "activity_labels.txt" file and 
described above (e.g. 1 = "walking).

The "finaldataset", which is the complete tidy data set, consists of a 
record(row)that contains the values for the mean and standard deviation for each 
variable measurement for each subject performing each activity.