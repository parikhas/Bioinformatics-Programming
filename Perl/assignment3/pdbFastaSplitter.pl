#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);

#######################################################################################
# File 		  : pdbFastaSplitter.pl
# History     : 12-Feb-2018 (Ashmi Parikh) made the program

# Description : This program opens a FASTA file containing protein and secondary structure data
# and generates two files from it; one with the corresponding protein sequence (pdbProtein.fasta), and the other with the corresponding secondary structures (pdbSS.fasta).
# This program tells the user how many sequences were found for each of the output files.
#######################################################################################

use Getopt::Long;    # neeed for command line options!
use Pod::Usage;      # neeed for command line options!

# CLI options HERE
my $FILE;            ## the file to parse data from

#COMMAND LINE optins
# name of the program in $0
my $usage = "\n$0 [options]\n\n
Options:

    -infile         Provide the fasta sequence file name to do the splitting on, this file contains
                    two entries for each sequence, one with the protein sequence data, and one with 
              		the SS information
    -help           Show this message

";

GetOptions(
	'infile=s' => \$FILE,
	help       => sub { pod2usage($usage); }, # different here, we put in $usage
) or pod2usage(2);

unless ($FILE) {
	die "\nDying...Please provide the file you would like to open\n", $usage;
}

#Call the subroutine(getFh) to open the input file for reading and the output files for writing
my $fhIn   = getFh( '<', $FILE );
my $fhOut1 = getFh( '>', 'pdbProtein.fasta' );
my $fhOut2 = getFh( '>', 'pdbSS.fasta' );

#call the subroutine (getHeaderAndSequenceArrayRefs) to process the input file and make the header and sequence arrays
my ( $refArrHeaders, $refArrSeqs ) = getHeaderAndSequenceArrayRefs($fhIn);

#Call the subroutine(printOutFiles)to write to the corresponding outfiles
printOutFiles( $refArrHeaders, $refArrSeqs, $fhOut1, $fhOut2 );

# Subroutine to get file handle to sequences in the fasta file and open two outfiles named: pdbProtein.fasta and pdbSS.fasta
sub getFh {
	my ( $readWrite, $file ) = @_;
	unless ( $readWrite eq '>' || $readWrite eq '<' ) {
		die "\nSpecify how to open the file\n";
	}

	open( my $fh, $readWrite, $file )
	  or die "Can't open the file", $file, "for reading:", $!;

	return $fh;
}

# Subroutine to loop over the fasta filehandle and store the data in two arrays, one for the header line and the other for the sequence data
sub getHeaderAndSequenceArrayRefs {
	($fhIn) = @_;
	my $i = 0;

	#Initialise the arrays for header and sequence
	my @header = ();
	my @seq    = ();
	while (<$fhIn>) {    #Loop through the file in the file handle
		chomp;           #Remove end of line characters
		if ( $_ =~ /^>+/ )
		{ #If the input matches the regex for header then put it in the header array
			push( @header, $_ );
			$i += 1;
		}
		else
		{ #If the input doesn't match the regex for header, then append it and put it in the sequence array
			$seq[ $i - 1 ] .= $_;
		}
	}

	#Call the subroutine(_checkSizeofArrayRefs) for the header and seq array
	_checkSizeofArrayRefs( \@header, \@seq );
	return ( \@header, \@seq );

}

# Subroutine to check whether the number of headers and sequences are same
sub _checkSizeofArrayRefs {
	my ( $header, $seq ) = @_;
	my $headerSize = scalar(@$header);    #Get the number of headers
	my $seqSize    = scalar(@$seq);       #Get the number of sequences
	if ( $headerSize == $seqSize ) {
		return;
	}
	else {
		die
"The size of the header array and the sequence array is different.\nAre you sure the FASTA is in correct format at $!";
	}
}

# Subroutine to make the two output files
sub printOutFiles {
	my ( $header, $seq, $fhOut1, $fhOut2 ) = @_;
	my @head      = @$refArrHeaders;
	my @seq       = @$refArrSeqs;
	my $size      = scalar(@head);
	my $countProt = 0;
	my $countSS   = 0;
	for my $i ( 0 .. $size - 1 )
	{    #From the first position till the last position
		if ( $head[$i] =~ /sequence$/ )
		{    #if the header contains the protein sequence,
			print $fhOut1 $head[$i], "\n", $seq[$i], "\n"
			  ; #then print the corresponding header and sequence by index to the outfile: pdbProtein.fasta
			$countProt++;
		}
		elsif ( $head[$i] =~ /secstr$/ )
		{       #if the header contains the secondary structure sequence,
			print $fhOut2 $head[$i], "\n", $seq[$i], "\n"
			  ; #then print the corresponding header and sequence by index to the outfile: pdbSS.fasta
			$countSS++;
		}
	}

	print STDERR "Found ", $countProt, " protein sequences", "\n";
	print STDERR "Found ", $countSS,   " ss sequences",      "\n";
}

