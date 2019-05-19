#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);
use Scalar::Util qw(looks_like_number);
########################################################################################################################################################################################
# File    : descriptiveStatistics.pl
# History : 25-jan-2018 (Ashmi Parikh) made the program
#
#######################################################################################################################################################################################

# Get the filename from user
my $filename = $ARGV[0];

# Get the column to parse from user
my $COLUMN_TO_PARSE = $ARGV[1];

# Open the file given by user
open( INFILE, "<", $filename ) or die "Can't open $filename\n";

# Initialise the arrays and scalars which will be used to store the values we need from the subroutines.
my @data;
my $num_column;
my $count;
my $validNum;
my @valid_data;
my @sort_asc;

# Loop throught the input file
while (<INFILE>) {
	#remove end of line characters
	chomp;
	#split columns by tab
	my @columns = split('\t');
	#get the number of columns
	$num_column = scalar(@columns);
	# add the column specified ny user to the array (@data)
	push( @data, $columns[$COLUMN_TO_PARSE] );
	#count the number of values in the column
	$count++;
}
# If the user input for column number is greater than the number of columns in the data file, then kill the program and give an error message
if ( $COLUMN_TO_PARSE > $num_column ) {
	die "There is no valid number in column $COLUMN_TO_PARSE";
}

# If the data (@data) has valid numbers, then save the valid numbers to an array (@valid_data)
foreach (@data) {
	if ( looks_like_number($_) ) {
		if ( lc($_) ne lc("NaN") && lc("INF") && lc("INFINITY") ) {
			$validNum++;
			push( @valid_data, $_ );
		}
	}
}

# If there are no valid numbers in the column specified, then kill the program and give an error message
if ( scalar(@valid_data) == 0 ) {
	die
	  "There is no valid number in column $COLUMN_TO_PARSE";
}

# Make a subroutine to sort the column values in ascending order and then get the first value to find the minimum value of the column
sub minimum {
	my @valid_data = @_;
	@sort_asc = sort { $a <=> $b } @valid_data;
	return $sort_asc[0];
}

my $min = minimum(@valid_data);

# Make a subroutine to sort the column values in descending order and then get the first value to find the maximum value of the column
sub max {
	my @valid_data = @_;
	my @sort_desc = sort { $b <=> $a } @valid_data;
	return $sort_desc[0];
}

my $max = max(@valid_data);

# Make a subroutine to find the average of the column values
sub average {
	my @valid_data = @_;
	my $sum;
	foreach (@valid_data) {
		$sum += $_;
	}
	return $sum / @valid_data;
}

my $avg = average(@valid_data);

# Make a subroutine to find the variance of the column values
sub variance {
	my @valid_data = @_;
	if ( @valid_data == 1 ) {
		return 0;
	}
	my $sqtotal = 0;
	foreach (@valid_data) {
		$sqtotal += ( $_ - $avg )**2;
	}
	return $sqtotal / ( scalar @valid_data - 1 );
}

my $var = variance(@valid_data);

# Calculate standard deviation from variance
my $std_dev = sqrt($var);

# Make a subroutine to find the median of the column values
sub median {
	my @sort_asc = @_;
	my $len      = @sort_asc;
	if ( $len % 2 ) {
		return $sort_asc[ int( $len / 2 ) ];
	}
	else {
		return (
			$sort_asc[ int( $len / 2 ) - 1 ] + $sort_asc[ int( $len / 2 ) ] ) /
		  2;
	}
}

my $median = median(@sort_asc);

# Print the descriptive statistics we have calculated 
printf "Count    = %10.3f \n",    $count;
printf "validNum = %10.3f \n", $validNum;
printf "Average  = %10.3f \n",  $avg;
printf "Maximun  = %10.3f \n",  $max;
printf "Minimum  = %10.3f \n",  $min;
printf "Variance = %10.3f\n", $var;
printf "Std Dev  = %10.3f\n",   $std_dev;
printf "Median   = %10.3f\n",    $median;
