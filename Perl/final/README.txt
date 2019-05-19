PROGRAMS: genBank2Fasta.pl, restrictionCutSites.pl

DESCRIPTION
genBank2Fasta.pl: This program takes a file of genbank sequences and convert them into
fasta files.

restrictionCutSites.pl: This program takes in a fasta file and finds the cut site of 
restriction enzymes in coding region.

REQUIREMENTS

As this program is written in perl, the user should have perl installed on their system to execute it.
The file entered should be a valid file.

FEATURES

This program uses a Module MyIO.pm to open files.
It uses a configuration module Config.pm to configure the data needed for the program.
BioIO::SeqIO is a class that stores the internal of the GenBank file passed to it.
Bio::Seq is a class that stores the data for one sequence.

OPERATING INSTRUCTIONS

Run these programs as:
perl genBank2Fasta.pl
perl restrictionCutSites.pl

For more details and explanations, please refer to the source code.
