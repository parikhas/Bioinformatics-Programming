#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;#need this to get dies_ok and lives_ok to work
use lib '/home/ashmi/Documents/BINF6200/assignment7';

BEGIN { use_ok('BioIO::Config', qw(getErrorString4WrongNumberArguments )) }
#dies when given too many argurments
dies_ok { getErrorString4WrongNumberArguments(1) } 	'dies ok when an argument is passed';
# Test getErrorString4WrongNumberArguments
ok(getErrorString4WrongNumberArguments(),           'Argument checking works.');

