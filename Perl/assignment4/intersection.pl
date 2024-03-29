#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);
use lib '/home/ashmi/Documents/BINF6200/a4';
use Assignment4::MyIO qw(getFh);

#######################################################################################
# File 		  : intersection.pl
# History     : 24-Feb-2018 (Ashmi Parikh) made the program

# Description : This program finds all gene symbols that appear both in the chr21_genes.txt file and in the HUGO_genes.txt file. 
# These gene symbols are printed to a output file intersectionOutput.txt in alphabetical order (call the ) . 
# The program also prints on the terminal how many common gene symbols were found. 
#######################################################################################

use Getopt::Long;    # need for command line options!
use Pod::Usage;      # need for command line options!

# CLI options HERE
my $IFILE1;           # the file to parse data from
my $IFILE2;           # the file to parse data from

#COMMAND LINE optins
# name of the program in $0
my $usage = "\n$0 [options]\n\n
Options:

    -file1         open the chromosome 21 gene data (chr21_genes.txt)
    -file2         open the HUGO gene data (HUGO_genes.txt)
    -help          Show this message

";

GetOptions(
	'file1=s'  => \$IFILE1,
	'file2=s'  => \$IFILE2,
	
	help => sub { pod2usage($usage); },    # different here, we put in $usage
) or pod2usage(2);

unless ($IFILE1) {
	die
"\nDying...Make sure to provide a file name\n",
	  $usage;
}

unless ($IFILE2) {
	die
"\nDying...Make sure to provide a file name\n",
	  $usage;
}
#Call the subroutine(getFh) to open the input file for reading and the output files for writing
my $fhIn1 = getFh( '<', $IFILE1 );
my $fhIn2  = getFh( '<', $IFILE2 ); 
my $fhOut  = getFh( '>', 'OUTPUT/intersectionOutput.txt' );

# Initialize the array 
my @gene_symbol;

# Loop through the file, ignore the header & put the column having gene symbol in the array
while (<$fhIn2>){
	next if $. < 2;
	chomp;
	my @columns = split('\t');
	push (@gene_symbol, $columns[0]);
}

# Initialize the array 
my @gene;

# Loop through the file, ignore the header & put the column having gene symbol in the array
while (<$fhIn1>){
	next if $. < 2;
	chomp;
	my @columns = split('\t');
	push (@gene, $columns[0]);
}

# Initialize the temporary hash to count common gene symbols
#my %seen;
# Count the number of matches in both the arrays
#foreach (@gene) { $seen{$_}++ };
#my $count = 0;
#foreach (@gene_symbol) { exists $seen{$_} and $count++; }



# Convert the elements of array to key/value pairs in a hash
my %gene = map {$_ => 1} @gene;
my %gene_symbol = map {$_ => 1} @gene_symbol;
# Get the matches and put them in an array
my @intersect = grep ($gene{$_}, @gene_symbol);
# Loop through the array, sort it alphabetically and print it to outfile
foreach (sort {$a cmp $b} @intersect){
	say $fhOut "$_";
}
print "Number of common gene symbols: ",scalar(@intersect),"\n";






