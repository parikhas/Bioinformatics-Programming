package Assignment5::MyIO;
use strict;
use warnings;
use Carp qw( confess );
use Exporter 'import';
our @EXPORT_OK = qw(getFh);

=head1 NAME

Assignment4::IO - package to handle opening of files and passing filehandles

=head1 SYNOPSIS

Creation:

    use Assignment5::MyIO qw(getFh);
    my $infile = 'test.txt'
    # get a filehandle for reading
    my $fh = getFh('<', $infile);

=head1 DESCRIPTION

This module was designed to be used by the Assignment 4 programs, and show how to create
a Perl package used for IO

=head1 EXPORTS

=head2 Default Behaviour

Nothing by default.

use Assignment5::MyIO qw( getFh);

=head1 FUNCTIONS

=head2 getFH

   Arg [1]    : Type of file to open, reading '<', writing '>', appending '>>'
   Arg [2]    : A name for the file

   Example    : my $fh = getFh('<', $infile);

   Description: This will return a filehandle to the file passed in.  This function
                can be used to open, write, and append, and get the File Handle. You are 
                best giving the absolute path, but since we are using this Module in the same directory 
                as the calling scripts, we are fine.

   Returntype : A filehandle

   Status     : Stable

=cut

sub getFh {
		my ( $readWrite, $file ) = @_;
		unless ( $readWrite eq '>' || $readWrite eq '<' ) {
			die "\nSpecify how to open the file\n";
		}

		open( my $fh, $readWrite, $file )
		  or die "Can't open the file", $file, $!;

		return $fh;
	}

=head1 COPYRIGHT AND LICENSE

Copyright [2018] Ashmi Parikh

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself, either Perl version 5.8.4 or, at your
option, any later version of Perl 5 you may have available.

=head1 CONTACT

Please email comments or questions to Ashmi Parikh parikh.as@husky.neu.edu

=cut

1;    # End of Assignment5::IO