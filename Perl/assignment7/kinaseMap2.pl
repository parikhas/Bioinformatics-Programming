#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;    #command line flags!
use Pod::Usage;      #command line flags!
use Data::Dumper;
use lib '/home/parikh.as/programming6200/assignment7';
use BioIO::MyIO qw( makeOutputDir);
use BioIO::Kinases;

################################################################################
# File   : kinaseMap2.pl
# Author : Ce Gao and Chesley Leslin
# Created: Nov 27, 2012
# Revised: Nov 29, 2013 => documentation and $usage change
################################################################################
# kinaseMap2.pl is a modification of kinaseMap1.pl, it prints only tyrosine 
# kinase genes (i.e. only where the gene name contains the word tyrosine), 
################################################################################

#### global variables
my $fileInName  = 'INPUT/kinases_map';    # default input
my $fileOutName = 'OUTPUT/output1_2.txt'; # default output
my ($kinase1, $kinase2); # store the object later

#### CLI flags
my $usage = "\n$0 [options]\n\n

Options:

    -fileIn       kinase file name
    -fileOut      output file name
    -help         display this message

        
\n\n";

GetOptions(
    'fileIn=s'    => \$fileInName,
    'fileOut=s'   => \$fileOutName,
    help            => sub { pod2usage($usage); }
) or pod2usage(2);    # exit status if something goes wrong

makeOutputDir('OUTPUT');
# create kinase object
$kinase1 = BioIO::Kinases->new($fileInName);
$kinase2 = $kinase1->filterKinases({name=>'tyrosine'});
# Could also do the following
#$kinase2 = $kinase1->filterKinases({name=>'tyrosine', symbol=>'EPLG4'});
$kinase2->printKinases($fileOutName, ['symbol','name','location', 'omim_accession']);
say STDERR "Output printed to " , $fileOutName;

