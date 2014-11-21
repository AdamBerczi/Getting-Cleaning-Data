The script first reads the data, then merges the training and test datasets.
The second block reads feature.txt, and extracts the mean and standard deviation measurements merging with the previous data.

Afterwards, the activity labels are being read: it subtract labels, and merges them with the "merge_y" file.
The next step is to create the cleansed dataset with the three merged tables.
The final step is the table created for the clean data, with a calculation for the average of each variable for each activity and subject.