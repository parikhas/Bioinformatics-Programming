#!/usr/bin/perl
use strict;
use warnings;
use Carp qw( confess );
use feature qw(say);
use lib '/home/parikh.as/programming6200/final';
use BioIO::SeqIO;
use BioIO::Seq;
use Data::Dumper;

use Getopt::Long;    # need for command line options!
use Pod::Usage;      # need for command line options!

########################################################################
# File   : restrictionCutSites
# History:  21-April-2018 (Ashmi Parikh) made the program                  
#
# Description: This program takes in a fasta file and finds the cut site of 
# restriction enzymes in coding region.
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
        $infile = "INPUT/p53_seq";
}

my ( $begin, $end ) = ( 11717, 18680 ); 
my $seqIoObj = BioIO::SeqIO->new(filename => $infile, fileType => 'fasta'); # object creation


# loop through the seqs in $seqIoObj
while ( my $seqObjLong = $seqIoObj->nextSeq() ) {
    my $seqObjShort = $seqObjLong->subSeq( $begin, $end );    # sub sequence
   
    # check the coding seq
    if( $seqObjShort->checkCoding()) {
    	print"The sequence starts with ATG codon and ends with a stop codon\n";
    }
    else{
       print "This is not a coding region"
    }
    
    # check the cutting sites
     my ($pos, $sequence) = $seqObjShort->checkCutSite( 'GGATCC' ); #BamH1
     if(!defined($pos)){
     	printFailedResult($seqObjShort,'BamH1')
     }else{
     printResults($pos, $sequence, $seqObjShort, 'BamH1'); # you should implement the printResults subroutine	
     }
     ($pos, $sequence) = $seqObjShort->checkCutSite( 'CGRYCG' ); #BsiEI
     if(!defined($pos)){
     	printFailedResult($seqObjShort,'BsiEI')
     }else{
     	printResults($pos, $sequence, $seqObjShort, 'BsiEI');
     }
     ($pos, $sequence) = $seqObjShort->checkCutSite( 'GACNNNNNNGTC');#DrdI 
     if(!defined($pos)){
     	printFailedResult($seqObjShort,'BamH1')
     }else{
     	printResults($pos, $sequence, $seqObjShort, 'DrdI');
     }
     
}

###############################################################################
#Void Context : printResults($pos, $sequence, $seqObjShort, 'BamH1')
##############################################################################
# Takes in 4 arguments and prints the output to the screen
############################################################################
sub printResults{
	my ($pos,$seq,$seqObj,$re)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($pos,$seq,$seqObj,$re)';
    @_ == 4 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	say ("\nThe gene gi",$seqObj->gi(),": ");
	say ("Found ",$re," cut site at position ",$pos," of the coding region, here is the matched sequence ",$seq);
	
}

###############################################################################
##Void Context : printFailedResult($seqObjShort,'BamH1')
###############################################################################
## Takes in 2 arguments and prints the output to the screen
## ###########################################################################
sub printFailedResult{
	my ($seqObj,$re)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($seqObj,$re)';
    @_ == 2 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	say ("\nThe gene gi",$seqObj->gi(),": ");
	say ($re," was not found in the coding region");
}