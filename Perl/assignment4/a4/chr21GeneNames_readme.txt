PROGRAM: chr21GeneNames.pl

DESCRIPTION

This program asks the user to enter a gene symbol and then prints the description for that gene based on data from the chr21_genes.txt file. 
The program gives an error message if the entered symbol is not found in the table (user should need not worry about case). The program continues to ask the user for genes until "quit" is given. 

REQUIREMENTS

As this program is written in perl, the user should have perl installed on their system to execute it.
The file entered should be a valid file.

Features

This program uses a Module MyIO.pm to read and write files
It parses the file chr21_genes.txt and creates a hash containing the category as key and the description as the value
This will prompt the user to type a gene symbol and if it is a valid symbol, then it will print the description of the symbol
It will do so until the user types 'quit'
Doing so ends the program

OPERATING INSTRUCTIONS

To use this program, you have to give the input of the filename to be parsed with the program. Ex. If the file is ss.txt, then we write the following on the command line:
perl chr21GeneNames.pl -file chr21_genes.txt 

For more details and explanations, please refer to the source code.