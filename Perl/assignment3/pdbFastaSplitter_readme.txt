PROGRAM: pdbFastaSplitter.pl

DESCRIPTION

This program opens a FASTA file containing protein and secondary structure data and generates two files from it; one with the corresponding protein sequence (pdbProtein.fasta), and the other with the corresponding secondary structures (pdbSS.fasta). This program tells the user how many sequences were found for each of the output files.

FEATURES

There are 4 subroutines in this program.

1. getFh
This receives two arguments: 1). How to open a file ">", or "<". 2). A file name. The purpose of this subroutine is to open the file name passed in and handle reading and writing.

2. getHeaderAndSequenceArrayRefs
This receives one argument: 1). A filehandle to the fasta file used in this program. The subroutine will return two array references. One for the sequences in the file and one for the headers to the sequences in the file. There should be a one-to-one correspondence to the data. 

3. _checkSizeOfArrayRefs
This receives two arguments: 1). Reference to the header array. 2). Reference to the sequence array. This is a helper function that is called in the getHeaderAndSequenceArrayRefs subroutine. If the sizes of the arrays passed into this argument are not the same, it dies.

4. printOutFiles
This receives four arguments: 1) . Reference to the header array. 2). Reference to the sequence array. 3) Filehandle for the pdbProtein.fasta output file and 4). Filehandle for the pdbSS.fasta output file. This will write the headers and sequence of the protein to pdbProtein.fasta and the headers and sequence of the secondary structure to pdbSS.fasta.

REQUIREMENTS

As this program is written in perl, the user should have perl installed on their system to execute it.
The file entered should be a valid FASTA file.

OPERATING INSTRUCTIONS

To use this program, you have to give the input of the filename to be parsed with the program. Ex. If the file is ss.txt, then we write the following on the command line:
perl pdbFastaSplitter.pl -infile ss.txt

This will give the output:
Found 166242 protein sequences
Found 166242 ss sequences 

For more details and explanantions, please refer to the source code.


