#!/usr/bin/perl
return 1 if (caller()); #for testing
use strict;
use warnings;
use feature qw(say);
use lib '/home/ashmi/Documents/BINF6200/assignment5';
use Assignment5::MyIO qw(getFh);
use Assignment5::Config qw(getErrorString4WrongNumberArguments
  getUnigeneDirectory
  getUnigeneExtension
  getHostKeywords
);

use Getopt::Long;    # need for command line options!
use Pod::Usage;      # need for command line options!

# CLI options HERE
my $host;           ## the file to parse data from
my $gene;           ## the file to parse data from

#COMMAND LINE optins
# name of the program in $0
my $usage = "\n$0 [options]\n\n
Options:

    -host         open the host directory
    -gene         open the gene file
    -help          Show this message

";

GetOptions(
	'host=s'  => \$host,
	'gene=s'  => \$gene,
	
	help => sub { pod2usage($usage); },    # different here, we put in $usage
) or pod2usage(2);

unless ($host) {
	die
"\nDying...Make sure to provide a host name\n",
	  $usage;
}

unless ($gene) {
	die
"\nDying...Make sure to provide a gene name\n",
	  $usage;
}

# Calling the subroutines
my $Gene = uc $gene;
$host = ucfirst($host);
my $Host = modifyHostName($host);
my $file = join ("/", getUnigeneDirectory(), $Host, $Gene . '.' . getUnigeneExtension());

if(isValidGeneFileName($file)){
	my $finalHost = $Host;
	$finalHost =~ s/_/ /g;
	say "Found Gene $gene for $finalHost";
}
else {
	say "Gene $gene not found";
	exit;
}

my $tissueRef = getGeneData($Gene, $Host);
printOutput($Gene, $Host, $tissueRef);

sub modifyHostName {
	my $hostName = @_;
	#$hostName = lc($hostName);
	my $hashRef = getHostKeywords();
	if (defined $hashRef->{$hostName}){
	return $hashRef->{$hostName};
	}
	else {
		_printHostDirectoriesWhichExist();
	}
	}

sub isValidGeneFileName {
	my $file = @_;
	if (-e $file){
		return 1;
	}
	else {
		return;
	}
}

sub _printHostDirectoriesWhichExist {
	my $hashRef = getHostKeywords();
	my @commonNames = (keys %$hashRef);
	my @sciNames = (values %$hashRef);
	say "Either the Host Name you are searching for is not in the database\n",
"or If you are trying to use the scientific name please put the name in double quotes:",
"Scientific name",
"Here is a (non­case sensitive) list of available Hosts by scientific name",
@sciNames,
"Here is a (non­case sensitive) list of available Hosts by common name",
@commonNames;
}

sub getGeneData {
	my ($gene, $host) = @_;
	my $file = join ("/", getUnigeneDirectory(), $host, $gene . '.' . getUnigeneExtension());
	my $fh = getFh("<", $file);
	my @tissues;
	while (<$fh>){
		chomp;
		my $tissues;
		if (/^EXPRESS\s+(.*)/){
			$tissues = $1;
			chomp $tissues;
			@tissues = split/\|\s*/,$tissues;
		}
	}
	return \@tissues;
}

sub printOutput {
	my ($host, $gene, $tissues) = @_;
	my @sortedTissues = sort {$a cmp $b} @$tissues;
	my $tissueSize = scalar (@sortedTissues);
   say "In $host, there are $tissueSize tissues that $gene is expressed in:";
	for (my $i=0; $i < $tissueSize; $i++){
		my $in = $i + 1;
		printf "%3d", $in;
		say ". ", ucfirst($sortedTissues[$i]);
	}
} 





















