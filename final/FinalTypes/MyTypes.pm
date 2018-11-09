package FinalTypes::MyTypes;
use strict;
use warnings;
use Carp;
use IO::File::WithFilename;
use MooseX::Types -declare => [ qw( FileType) ];
use MooseX::Types::Moose qw/Str/;

subtype FileType,
      as Str,
      where { ($_ eq 'fasta' or  $_ eq 'genbank' ) },
      message { "This term (" . $_ . ") is not fasta or genBank" };