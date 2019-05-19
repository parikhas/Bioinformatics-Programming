#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 16;
use Test::Exception;    # need this to get dies_ok and lives_ok to work
use Test::Exit;

require_ok 'snpScan.pl';
use feature qw(say);

my $query = 'testInput.txt';
my $eqtl  = 'testAffy.txt';
is( ( isValidFileName($query) ), 1,     'the file exists' );
is( ( isValidFileName('') ),     undef, 'the file does not exist' );
my ($qHoA) = getQuerySites($query);
is( ref $qHoA, 'HASH', 'the reference coming from getQuerySites is a Hash' );
my ( $eQTLHoA, $eQTLHoH ) = getEqtlSites($eqtl);
is( ref $eQTLHoA, 'HASH', 'the reference coming from getEqtlSites is a Hash' );
is( ref $eQTLHoH, 'HASH', 'the reference coming from getEqtlSites is a Hash' );
my $chr             = 1;
my $pos             = 216055001;
my $correct         = 216055212;
my $nearestPosition = _findNearest( $chr, $pos, $eQTLHoA );
is( $nearestPosition, $correct, 'found correct nearest position' );

lives_ok {  compareInputSitesWithQtlSites( $qHoA, $eQTLHoA, $eQTLHoH ) }       'lives fine with non STDERR print';

dies_ok {  compareInputSitesWithQtlSites( hoa, hash1 , hash2 ) }       'dies ok with non STDERR argument';



