PROGRAM: intersection.pl

DESCRIPTION

This program finds all gene symbols that appear both in the chr21_genes.txt file and in the HUGO_genes.txt file. 
These gene symbols are printed to a file in alphabetical order (the output file intersectionOutput.txt) . 
The program also prints on the terminal how many common gene symbols were found. 

REQUIREMENTS

As this program is written in perl, the user should have perl installed on their system to execute it.
The file entered should be a valid file.

FEATURES

This program uses a Module MyIO.pm to read and write files
It loops through both the files, ignore the header & put the column having gene symbol in two arrays
It gets the genes which are common in both the arrays and then prints them to the output file
It will also give the number of common genes in the terminal

OPERATING INSTRUCTIONS

To use this program, you have to give the input of the filename to be parsed with the program. Ex. If the file is ss.txt, then we write the following on the command line:
perl categories.pl -file1 chr21_genes.txt -file1 HUGO_genes.txt 

It will give the output: 'Number of common gene symbols: 204'
This will write the common genes to the file intersectionOutput.txt

For more details and explanations, please refer to the source code.