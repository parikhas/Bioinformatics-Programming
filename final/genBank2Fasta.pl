#!/usr/bin/perl
use strict;
use warnings;
use Carp qw( confess );
use feature qw(say);
use BioIO::SeqIO;
use Data::Dumper;

use Getopt::Long;    # need for command line options!
use Pod::Usage;      # need for command line options!

########################################################################
# File   : genBank2Fasta.pl
# History:  21-April-2018 (Ashmi Parikh) made the program                  
#
# Description: This program takes a file of genbank sequences and convert them into
# fasta files.
##########################################################################

# CLI options HERE
my $infile;           ## the query file to parse data from

#COMMAND LINE options
# name of the program in $0
my $usage = "\n$0 [options]\n\n
Options:

    -infile         open the query file
    -help          Show this message

";

GetOptions(
	'infile=s' => \$infile,

	help => sub { pod2usage($usage); },    # different here, we put in $usage
) or pod2usage(2);

if (!defined($infile)) {
        $infile = "INPUT/genbank_seq";
}


my $seqIoObj = BioIO::SeqIO->new(filename => $infile , fileType => 'genbank', => _gi => []); # object creation

my $output = "OUTPUT";
# Go through SeqIO obj and print all sequences
while (my $seqObj = $seqIoObj->nextSeq() ) {
   my $fileNameOut = $output . '/' . $seqObj->accn . ".fasta"; 
   $seqObj->writeFasta( $fileNameOut);   
}
