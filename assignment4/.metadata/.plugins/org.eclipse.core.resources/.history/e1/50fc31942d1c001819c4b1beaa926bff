#!/usr/bim/perl
use strict;
use warnings;
use feature qw(say);
use lib 'home/ashmi/Documents/BINF6200/a4';
use Assignment4::MyIO qw(getFh);

#######################################################################################
# File 		  : chr21GeneNames.pl
# History     : 24-Feb-2018 (Ashmi Parikh) made the program

# Description : This program  asks the user to enter a gene symbol and then prints the description 
# for that gene based on data from the chr21_genes.txt file. The program gives an error message 
# if the entered symbol is not found in the table. The program continues to ask the user for genes until "quit" is given. 
#######################################################################################


use Getopt::Long;    # need for command line options!
use Pod::Usage;      # need for command line options!

# CLI options HERE
my $IFILE;           ## the file to parse data from

#COMMAND LINE optins
# name of the program in $0
my $usage = "\n$0 [options]\n\n
Options:

    -file         open the chromosome 21 gene data (chr21_genes.txt)
    -help           Show this message

";

GetOptions(
	'file=s'  => \$IFILE,
	help => sub { pod2usage($usage); },    # different here, we put in $usage
) or pod2usage(2);

unless ($IFILE) {
	die
"\nDying...Make sure to provide a file name\n",
	  $usage;
}

#Call the subroutine(getFh) to open the input file for reading and the output files for writing
my $fhIn  = getFh( '<', $IFILE );

#Initialized the hash for storing gene name and description
my %sym_desc;

# Loop through the file, put the column having gene symbol as the key and description as value in the hash
while (<$fhIn>) {
	chomp;
	#split columns by tab
	my @columns = split('\t');
	my $sym = $columns[0];
	$sym = uc $sym;
	my $desc = $columns[1];
	$sym_desc{$sym} = $desc;
	}	

say "Enter gene name of interest. Type quit to exit:";
while (my $input = <STDIN>){
    chomp $input;
	$input = uc $input;
	if (exists $sym_desc{$input}){
		say $input, " found! Here is the description:";
		say $sym_desc{$input};
		say "Enter gene name of interest. Type quit to exit:";
		}
	elsif ($input eq 'QUIT'){
		last;
		} 
	else {
		say "Not a valid Symbol. Please try again."
		}
	}
	
	
			
	


	
	
	
	
	
	
