#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);
use lib '/home/ashmi/Documents/BINF6200/a4';
use Assignment4::MyIO qw(getFh);
my $file1 = 'testfile.txt';
my $testfh_read = getFh("<", $file1);
while (<$testfh_read>){
	chomp;
	say $_;
}

my $file2 = 'test_write.txt';
my $testfh_write = getFh(">", $file2);
say $testfh_write "This is the test file for testing to write to the file";
