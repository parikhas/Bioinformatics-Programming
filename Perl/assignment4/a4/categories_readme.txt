PROGRAM: categories.pl

DESCRIPTION

This program counts how many genes are in each category (1.1, 1.2, 2.1 etc.) based on data from the chr21_genes.txt file. 
The program prints the results such that categories are arranged in ascending order to an output file (categories.txt).

REQUIREMENTS

As this program is written in perl, the user should have perl installed on their system to execute it.
The file entered should be a valid file.

Features

This program uses a Module MyIO.pm to read and write files
It parses the file chr21_genes.txt and creates a hash containing the category as key and the number of genes in that category as the value
It parses the file chr21_genes_categories.txt and creates a hash containing the category as key and description as the value.
Then it loops over both the hashes, matches the key (category) which is common in both of them and gives the occurrence of each category along with the description. 

OPERATING INSTRUCTIONS

To use this program, you have to give the input of the filename to be parsed with the program. Ex. If the file is ss.txt, then we write the following on the command line:
perl categories.pl -file1 chr21_genes.txt -file1 chr21_genes_categories.txt 

This will write the output to the file categories.txt

For more details and explanations, please refer to the source code.