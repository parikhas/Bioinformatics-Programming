PROGRAM: nucleotideStatisticsFromFasta.pl

DESCRIPTION

This program opens a FASTA file containing sequences of nucleotides. For each sequence, it will calculate the number of A's, T's, G's, C's, and N's along with the length of the sequence and also the %GC content of the entire sequence.

FEATURES

There are 6 subroutines in this program.

1. getFh
This receives two arguments: 1). How to open a file ">", or "<". 2). A file name. The purpose of this subroutine is to open the file name passed in and handle reading and writing.

2. getHeaderAndSequenceArrayRefs
This receives one argument: 1). A filehandle to the fasta file used in this program. The subroutine will return two array references. One for the sequences in the file and one for the headers to the sequences in the file. There should be a one-to-one correspondence to the data. 

3. _checkSizeOfArrayRefs
This receives two arguments: 1). Reference to the header array. 2). Reference to the sequence array. This is a helper function that is called in the getHeaderAndSequenceArrayRefs subroutine. If the sizes of the arrays passed into this argument are not the same, it dies.

4. printSequenceStats
This receives three arguments. 1). Reference to the header array. 2). Reference to the sequence array. 3).The output filehandle the stats will go to. This is the main subroutine of this program, since it will print the top line of the output, and each sequence's numerical values. It will call two helper functions (_getAccession and _getNtOccurrence - see below) that will be called for each sequence prior to printing the data for each sequence out. 

5. _getNtOccurrence
This receives two arguments. 1). The character to find the occurrence of in the dna sequence. 2). A reference to the sequence data. It calculates the frequency of each nucleotide in the sequence.

6. _getAccession
This receives one argument. 1). A scalar that is the header to the sequence. And it returns the accession number.

REQUIREMENTS

As this program is written in perl, the user should have perl installed on their system to execute it.
The file entered should be a valid FASTA file.

OPERATING INSTRUCTIONS

To use this program, you have to give the input of the filename to be parsed with the program. Ex. If the infile is influenza.fasta and the output file we want is influenzaStats.txt, then we write the following on the command line:
perl nucleotideStatisticsFromFasta.pl -infile influenza.fasta -outfile influenza.stats.txt

This will give the create the outfile influenza.stats.txt with the nucleotide statistics.

For more details and explanantions, please refer to the source code.
