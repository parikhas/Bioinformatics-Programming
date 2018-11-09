PROGRAM: descriptiveStatistics.pl

DESCRIPTION

This program calculates descriptive statistics for numbers found in columns of a given input file.
This program opens the file and gathers descriptive statistics on the column specified by the command line.

FEATURES

This program will calculate the following statistics:
1. Count (number to values)
2. validNum (number of valid numbers e.g. if will count 2, 8, 6.73 etc but will not count gh67, poa.j, NaN, infinity as valid numbers)
3. Average
4. Maximum value 
5. Minimum value
6. Variance
7. Standard Deviation
8. Median

REQUIREMENTS

As this program is written in perl, to execute it, the user should have perl installed on their system.
The file entered should be a valid file.
The file should have tab separated columns.
The column specified should be present in the file.
 

OPERATING INSTRUCTIONS

To use this program to check the statistics of a column in a file, you have to give the inputs of the filename followed by the column with the program.
E.g. If the file is dataFile.txt and we want to find the statistics for the 3rd column, we write the following on the command line:
perl descriptiveStatistics.pl dataFile.txt 2
Here, we write 2 as in perl, indexing begins at 0.
Therefore, first column is [0], second column is [1] and so on.

For more details and explanations, please refer to the source code.
