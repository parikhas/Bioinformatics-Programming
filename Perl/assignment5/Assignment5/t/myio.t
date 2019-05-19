#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);
use Test::More tests => 6;
use Test::Exception;
use lib '/home/ashmi/Documents/BINF6200/assignment5';
use Assignment5::MyIO qw(getFh);

## create a file
my $goodFile = join('', "good_", $$);
my $outFile  = join('', "out_" , $$);
createGoodFile($goodFile);

## now further tests

# to gest files are ok, first 
my $fhInGood    = getFh("<", $goodFile);
my $fhOutGood   = getFh(">", $outFile);

is(ref $fhInGood,  'GLOB', "The input  filehandleis a glob");
is(ref $fhOutGood, 'GLOB', "The output filehandle is a glob");

# dies when given a bogus file name
dies_ok { getFh("<<", $fhInGood) } 'dies ok on <<';

# dies when no type of file to open is not given
dies_ok { getFh("", $fhInGood) } 'dies ok on no open type';

# dies when not filename is given
dies_ok { getFh("<", "") } 'dies ok on no file';

# dies when a directory is given
dies_ok { getFh(">", "/home/parikh.as/") } 'dies ok on a directory passed in';

## clean up
unlink $goodFile;
unlink $outFile;

sub createGoodFile{
    my ($file) = @_;
    my $fhIn1;
    unless (open ($fhIn1, ">" , $file) ){
        die $!;
    }
    print $fhIn1 <<'_FILE_';
This is the test file for MyIO.pm
_FILE_
    close $fhIn1;
}


