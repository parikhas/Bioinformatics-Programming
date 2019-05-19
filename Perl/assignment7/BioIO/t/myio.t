#!/usr/bin/perl
use strict;
use warnings;

use IO::Detect qw(is_filehandle);
use Test::More tests => 13;
use Test::Exception;#need this to get dies_ok and lives_ok to work
use lib '/home/ashmi/Documents/BINF6200/assignment7';

BEGIN { use_ok('BioIO::MyIO', qw( getFh makeOutputDir )) }

## create a file
my $goodFile = "goodNt_$$";
my $outFile1 = "outNt_$$";
my $outFile2 = "appendNt_$$";
createFile($goodFile);

## now further tests
my $fhInGood     = getFh("<", $goodFile);
my $fhOutGood1   = getFh(">", $outFile1);
my $fhOutGood2   = getFh(">>", $outFile2);

#use IO::Detect to test this, it's a better way
is(is_filehandle $fhInGood,   1, 			'is_filehandle passed');
is(is_filehandle $fhOutGood2, 1, 			'is_filehandle passed');
is(is_filehandle $fhOutGood1, 1, 			'is_filehandle passed');

#dies when too many arguments are given
dies_ok { getFh("<<", $fhInGood, 1) } 		'getFh dies ok when too many arguments are given';
#dies when not enough many arguments are given
dies_ok { getFh("<<") } 					'getFh dies ok when not enough arguments are given';
#dies when give it a bogus file name
dies_ok { getFh("<<", $fhInGood) } 			'getFh dies ok on <<';
#dies when no type of file to open is not given
dies_ok { getFh("", $fhInGood) } 			'getFh dies ok on no open type';
#dies when not filename is given
dies_ok { getFh("<", "") } 					'getFh dies ok on no file';
#dies when a director is given
dies_ok { getFh("<", "/home/cleslin/") } 	'getFh dies ok on a directory passed in';


dies_ok { makeOutputDir('/junk') } 			"makeOutputDir dies ok when tyring to make a directory that it can't";
my $dir = 'test';
lives_ok { makeOutputDir($dir) } 			'makeOutputDir lives ok when a directory that can be created, is created';

my $dir2 = 'test2';
`mkdir $dir2`;
lives_ok { makeOutputDir($dir2) } 			'makeOutputDir lives ok when a directory that exists is passed in';

## clean up
`rmdir $dir`;
`rmdir $dir2`;
unlink $goodFile;
unlink $outFile1;
unlink $outFile2;

sub createFile{
    my ($file) = @_;
    my $fhIn1;
    unless (open ($fhIn1, ">" , $file) ){
        die $!;
    }
    print $fhIn1 <<'_FILE_';
test
_FILE_
    close $fhIn1;
    return;
}