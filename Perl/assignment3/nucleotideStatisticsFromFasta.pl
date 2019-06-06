#!/usr/bin/perl
use warnings;

#use strict;
use feature qw(say);

use Getopt::Long;    # neeed for command line options!
use Pod::Usage;      # neeed for command line options!

# CLI options HERE
my $IFILE;           ## the file to parse data from
my $OFILE;           ##the file to write the output to

#COMMAND LINE optins
# name of the program in $0
my $usage = "\n$0 [options]\n\n
Options:

    -infile         Provide the fasta sequence file name to do the parsing on
    -outfile         Provide the fasta sequence file name to do the parsing to
    -help           Show this message

";

GetOptions(
	'infile=s'  => \$IFILE,
	'outfile=s' => \$OFILE,
	help => sub { pod2usage($usage); },    # different here, we put in $usage
) or pod2usage(2);

unless ($IFILE) {
	die
"\nDying...Make sure to provide a file name of a sequence in FASTA format\n",
	  $usage;
}

	unless ($OFILE) {
		die "\nDying...Make sure to provide an outfile name for the stats\n",
		  $usage;
	}

	#Call the subroutine(getFh) to open the input file for reading and the output files for writing
	my $fhIn  = getFh( '<', $IFILE );
	my $fhOut = getFh( '>', $OFILE );
	#call the subroutine (getHeaderAndSequenceArrayRefs) to process the input file and make the header and sequence arrays
	my ( $refArrHeaders, $refArrSeqs ) = getHeaderAndSequenceArrayRefs($fhIn);
	#Call the subroutine(printSequenceStats)to write to the corresponding outfile
	printSequenceStats( $refArrHeaders, $refArrSeqs, $fhOut );

# Subroutine to get file handle to sequences in the fasta file and open two outfiles named: pdbProtein.fasta and pdbSS.fasta
	sub getFh {
		my ( $readWrite, $file ) = @_;
		unless ( $readWrite eq '>' || $readWrite eq '<' ) {
			die "\nSpecify how to open the file\n";
		}

		open( my $fh, $readWrite, $file )
		  or die "Can't open the file", $file, $!;

		return $fh;
	}

	#Initialise the arrays for header and sequence
	my @header = ();
	my @seq    = ();

# Subroutine to loop over the fasta filehandle and store the data in two arrays, one for the header line and the other for the sequence data
	sub getHeaderAndSequenceArrayRefs {
		($fhIn) = @_;
		my $i = 0;

		#parse the infile
		while (<$fhIn>) {
			chomp;

	 # if the input matches the regex for header then put it in the header array
	 # otherwise put it in the sequence array
			if ( $_ =~ /^>+/ ) {
				push( @header, $_ );
				$i += 1;
			}
			else {
				$seq[ $i - 1 ] .= $_;
			}
		}

# call the subroutine to check if the number of headers & sequences are the same
		_checkSizeofArrayRefs( \@header, \@seq );
		return ( \@header, \@seq );

	}

	# Subroutine to check whether the number of headers and sequences are same
	sub _checkSizeofArrayRefs {
		my ( $header, $seq ) = @_;
		my $headerSize = scalar(@$header);
		my $seqSize    = scalar(@$seq);
		if ( $headerSize == $seqSize ) {
			return;
		}
		else {
			die
"The size of the header array and the sequence array is not the same\n";
		}
	}

	# Subroutine to print the sequence statistics
	sub printSequenceStats {
		my ( $header, $seq, $fhOut ) = @_;

		#Initialize the counter for header to zero
		my $countin = 0;
		print $fhOut "Number\tAccession\tA's\tG'c\tC's\tT's\tN's\tLength\tGC%\n";

		# Loop through each sequence and get the sequence statistics
		foreach (@$seq) {
			my $accession = _getAccession( $header[$countin] );
			my $numAs     = _getNtOccurrence( 'A', $_ ); #Get the number of A nucleotides
			my $numCs     = _getNtOccurrence( 'C', $_ ); #Get the number of C nucleotides
			my $numTs     = _getNtOccurrence( 'T', $_ ); #Get the number of T nucleotides
			my $numGs     = _getNtOccurrence( 'G', $_ ); #Get the number of G nucleotides
			my $numNs     = _getNtOccurrence( 'N', $_ ); #Get the number of N nucleotides
			my $GC        = ( ( $numCs + $numGs ) / length($_) ) * 100;
			my $fpGC = sprintf("%.1f", $GC);
			my $seqlength = length($_);
			my $num       = ( $countin + 1 );
			say $fhOut
"$num	$accession	$numAs	$numGs	$numCs	$numTs	$numNs	$seqlength	$fpGC";

			# Increment the counter header
			$countin++;
		}

	}

	# Subroutine to calculate the number of nucleotides
	sub _getNtOccurrence {
		my ( $nt, $seq ) = @_;

		my $countbase = 0;
		unless ( $nt eq 'A'
			|| $nt eq 'T'
			|| $nt eq 'G'
			|| $nt eq 'C'
			|| $nt eq 'N' )
		{
			die "\nPlease enter a valid Nucleotide\n";
		}
		
		 #Join the multiple sequence lines and put it in an array 
		my @oneLineSeq = split( "", $seq );
		foreach (@oneLineSeq) {
			my $base = $_;
			if ( $base eq $nt ) {
				#Get the total count of the base
				$countbase++;
			}

		}
		return $countbase;
	}

	# Subroutine to get the accession number from the header
	sub _getAccession {
		my ($accNo) = @_;
		#match the characters staring with > and ending with a space
		if ( $accNo =~ /^>(.*?)\s/ ) {
			$accNo = $1;
		}
		return $accNo;
	}

