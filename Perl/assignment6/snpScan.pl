#!/usr/bin/perl
return 1 if ( caller() );    #for testing
use strict;
use warnings;
use feature qw(say);
use lib '/home/parikh.as/programming6200/assignment6';
use Assignment6::MyIO qw(getFh);
use Data::Dumper;

#use Assignment6::Config qw(getErrorString4WrongNumberArguments);
use Assignment6::Config qw(getErrorString4WrongNumberArguments);

######################################################################################
# File   :  snpScan.pl
# History     : 31-March-2018 (Ashmi Parikh) made the program

# Description This program has three command line flags, one for the query file (-query), one for the eQTL data file (-eqtl), 
# and one for the outfile (-outfile) that is used to store the output from the program. 
# The program utilizes a subroutine to store the site positions the biologist gave as input  in a hash of arrays,
# A second subroutine reads in the eQTL dataset, stores the loci from the eQTL dataset in another hash of arrays, 
# and stores the additional information for each eQTL in a hash of hashes. 
# It also utilizes a third subroutine which then iterates through the array of your sites and finds the nearest eQTL to that site and generates the output
# in the named outfile given at the command line option.
# We get an outfile containing the original query site, its distance to the nearest eQTL, the eQTL, and the gene information associated with that eQTL 
########################################################################################
use Getopt::Long;    # need for command line options!
use Pod::Usage;      # need for command line options!

# CLI options HERE
my $query;           ## the query file to parse data from

my $eqtl;            ## the eQTLfile to parse data from

my $outfile;         ## the file to write to

#COMMAND LINE optins
# name of the program in $0
my $usage = "\n$0 [options]\n\n
Options:

    -query         open the query file
    -eqtl			open the eQTL file
    -outfile			open the output file
    -help          Show this message

";

GetOptions(
	'query=s' => \$query,

	'eqtl=s' => \$eqtl,

	'outfile=s' => \$outfile,

	help => sub { pod2usage($usage); },    # different here, we put in $usage
) or pod2usage(2);


unless ($query) {
	die
	  "\nDying...Make sure to provide a query file\n",
	  $usage;
}

unless ($eqtl) {
	die
	  "\nDying...Make sure to provide a eQTL data file\n",
	  $usage;
}

unless ($outfile) {
	die
	  "\nDying...Make sure to provide an output file\n",
	  $usage;
}

# Calling the subroutines
my ($qHoA) = getQuerySites($query);
my ( $eQTLHoA, $eQTLHoH ) = getEqtlSites($eqtl);
compareInputSitesWithQtlSites( $qHoA, $eQTLHoA, $eQTLHoH, $outfile );

#------------------------------------------------------------------------------
# my ($qHoA) = getQuerySites($query);
#------------------------------------------------------------------------------
# receives one arguments: 1). A file name for the input query                       
#
# This subroutine opens a file handle, and with a while loop iterates over the query file 
# and create a hash key for each chromosome with a value of an array of all of the positions for that chromosome. 
# This subroutine returns a reference to the HoA. 
#------------------------------------------------------------------------------

sub getQuerySites {
	my $filledUsage = join('', 'Usage:' . (caller(0))[3]) . '($query)';
	@_ == 1 or confess getErrorStrings4WrongNumberArguments();
	my ($query) = @_;
	my $fhIn1 = getFh( '<', $query );
	my %q;
	while (<$fhIn1>) {
		chomp;
		next if $. < 2;

		#split columns by tab
		my @columns = split('\t');

		my $chr_n = $columns[0];
		my $end   = $columns[2];
		if (exists $columns[2]) {
			if ( defined $chr_n ) {
				if ( exists $q{$chr_n} ) {
					push( @{ $q{$chr_n} }, $end );
				}
				else {
					$q{$chr_n} = [$end];
				}

			}
		}
	}

	#print Dumper \%q;
	return ( \%q );

}

#------------------------------------------------------------------------------
# my ( $eQTLHoA, $eQTLHoH ) = getEqtlSites($eqtl);
#------------------------------------------------------------------------------
# receives one arguments: 1). A file name for the eQTL dataset                       
#
# This subroutine opens the eQTL dataset, and will iterate over the eQTL file and create a Hash of Arrays, 
# with the hash key being each chromosome and the a value will be an array reference of all the positions for that chromosome. 
# Simultaneously, it should create a Hash of Hashes, with the hash key being each chromosome, and the value is hash reference 
# which has keys for each position and the values being the descriptions of the genes affected by the eQTL so this description can be called for and output in the final step. 
# This subroutine will return the references to the two data structures created in this subroutine.
#
#------------------------------------------------------------------------------

sub getEqtlSites {
	my $filledUsage = join('', 'Usage:' . (caller(0))[3]) . '($eqtl)';
	@_ == 1 or confess getErrorStrings4WrongNumberArguments();
	my ($eqtl) = @_;
	my $fhIn2 = getFh( '<', $eqtl );
	my %eQTLHoA;
	my %eQTLHoH;
	while (<$fhIn2>) {
		chomp;
		next if $. < 2;
		my @c      = split('\t');
		my $chr    = $c[1];
		my @ch     = split /:/, $chr;
		my $ac_chr = $ch[2];
		my $loc    = $ch[3];
		my $gene;

		$gene = $c[3];
		if ( exists $eQTLHoH{$ac_chr} ) {
			$eQTLHoH{$ac_chr}{$loc} = $gene;
			push @{ $eQTLHoA{$ac_chr} }, $loc;
		}
		else {
			$eQTLHoH{$ac_chr} = { $loc => $gene };
			$eQTLHoA{$ac_chr} = [$loc];
		}

	}

	#say Dumper \%eQTLHoA;

	#print Dumper \%eQTLHoH;
	return ( \%eQTLHoA, \%eQTLHoH );
}

#------------------------------------------------------------------------------
# compareInputSitesWithQtlSites( $qHoA, $eQTLHoA, $eQTLHoH, $outfile );
#------------------------------------------------------------------------------
# receives four arguments:  1). A reference to the HoA in sub1. 
#							2). A reference to the HoA created in sub2. 
#							3). A reference to the HoH created in sub2. 
#							4). file name for the outfile passed into the command line options.
#                           
#                      
#
# This subroutine should iterate over each site in the query sites hash and compare 
# it to the sites in the eQTL hash to find the nearest site, remember chromosomes have to match. 
# Print to your outfile the original query site, its distance to the nearest eQTL, the eQTL, and 
# the gene information associated with that eQTL in a tab-delimited fashion 
#------------------------------------------------------------------------------

sub compareInputSitesWithQtlSites {
	my $filledUsage = join('', 'Usage:' . (caller(0))[3]) . '($qHoA, $eQTLHoA, $eQTLHoH, $outfile)';
	@_ == 4 or confess getErrorStrings4WrongNumberArguments();
	( $qHoA, $eQTLHoA, $eQTLHoH, $outfile ) = @_;
	my $fhOut = getFh( '>', $outfile );
	say $fhOut join ("\t","#Site","Distance","eQTL","[Gene:P-val:Population]");
	my %qHoA = %$qHoA;
	my %HoH  = %$eQTLHoH;
	foreach my $chr ( sort { $a <=> $b } ( keys %qHoA ) ) {

		foreach my $pos ( sort { $a <=> $b } ( @{ $qHoA{$chr} } ) ) {

			if ( my $nearestPosition = _findNearest( $chr, $pos, $eQTLHoA ) ) {

				my $distance = abs( $pos - $nearestPosition );
				my $geneDesc = $HoH{$chr}{$nearestPosition};
				say $fhOut join( "\t",
					"$chr:$pos",             "$distance",
					"$chr:$nearestPosition", "$geneDesc" );
			}
			else {
				warn "Cannot find requested chromosome position in data ",
				  "chr = ", $chr, " position = ", $pos;
			}
		}
	}
}

#------------------------------------------------------------------------------
# my $nearestPosition = _findNearest($chr, $pos, $hoaRef2);
#------------------------------------------------------------------------------
# receives three arguments: 1). A chromosome
#                           2). A position on the chromosome
#                           3). A reference to the HoA created in sub2.
#
# This subroutine should find the closest position on the same chromosome to
# the queried position and return that position.  Returns void if no position
# is found.
#------------------------------------------------------------------------------

sub _findNearest {
	#getErrorString4WrongNumberArguments(3, @_);
	my $filledUsage = join(' ', 'Usage:' . (caller(0))[3]) . '($chr, $pos, $eQTLHoA)';
	@_ == 3 or confess getErrorStrings4WrongNumberArguments();
	my ( $chr, $pos, $eQTLHoA ) = @_;
	my %HoA  = %$eQTLHoA;
	my $diff = -1;
	my $finalP;

	foreach my $chr_m ( keys %HoA ) {
		foreach my $pos_sub ( @{ $HoA{$chr_m} } ) {
			if ( $chr eq $chr_m ) {
				if ( $diff == -1 ) {
					$diff   = abs( $pos - $pos_sub );
					$finalP = $pos_sub;

					#say $finalP;
				}
				elsif ( $diff > abs( $pos - $pos_sub ) ) {
					$diff   = abs( $pos - $pos_sub );
					$finalP = $pos_sub;

					#say $finalP;
				}
			}
		}
	}

	#say "$chr: $pos    $finalP";
	return $finalP;

}

