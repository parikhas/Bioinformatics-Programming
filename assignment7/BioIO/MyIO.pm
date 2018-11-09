package BioIO::MyIO;
use warnings;
use strict;
use File::Path qw(make_path);
use BioIO::Config qw(getErrorString4WrongNumberArguments);
use Carp qw( confess );
use Exporter 'import';
our @EXPORT_OK = qw(getFh makeOutputDir);

=head1 NAME

BioIO::MyIO - package to handle opening of files and passing filehandles

=head1 SYNOPSIS

Creation:

   use BioIO::MyIO qw(getFh);
   my $infile = 'test.txt'
   # get a file handle for reading
   my $fh = getFh('<', $infile);

=head1 DESCRIPTION

This module was designed to be used by the Assignment 7 programs, and show how to create
a Perl package used for IO

=head1 EXPORTS

=head2 Default behavior

Nothing by default. 

use BioIO::MyIO qw( getFh );

=head1 FUNCTIONS

=head2 getFH

   Arg [1]    : Type of file to open, reading '<', writing '>', appending '>>'

   Example    : my $fh = getFh('<', $infile);

   Description:	This will return a filehandle to the file passed in.  This function
                can be used to open, write, and append, and get the File Handle. You are 
                best giving the absolute path, but since we are using this Module in the same directory 
                as the calling scripts, we are fine.

   Returntype : A filehandle

   Status     : Stable

=cut

sub getFh{
    my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '($type, $file)';
    # test the number of arguments passed in were correct 
    @_ == 2 or confess getErrorString4WrongNumberArguments() , $filledUsage;

    my ($type, $file) = @_;
   
    my $confessStatement = "Can't open " . $file;
    if ($type ne '>' && $type ne '<' && $type ne '>>'){
		confess "Can't use this type for opening/writing/appending '" , $type , "'";
    }
    # do not open a directory filehandle 
    if (-d $file){ # if what was sent in was a direcotry, die
		confess "The file you provided is a directory";
	}
    
    # error checking for specific die output
    if ($type eq '<'){
		$confessStatement .=  " for reading: ";
    }
    elsif ($type eq '>'){
    	$confessStatement .=  " for writing: ";
    }
    elsif ($type eq '>>'){
    	$confessStatement .=  " for appending: ";
    }
    
    # go forward with the open	
    my $fh; 
	unless (open($fh, $type , $file) ) {
		confess join(' ' , $confessStatement , $!);
	}
	return ($fh)
}

=head2 makeOutputDir

   Arg [1]    : A directory name that needs to be created

   Example    : makeOutputDir( 'assignment_output' );

   Description:	This function wil make the directory passed if it does not exist if you have privileges

   Returntype : undef

   Status     : Stable

=cut

sub makeOutputDir{
	my ($nameDir) = @_;
	my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '($nameDir)';
    #test the number of arguments passed in were correct 
    @_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;
	unless (-e $nameDir){
		#make directory if it does not exist	
		eval {
			make_path($nameDir);
		};
		if ($@){
			confess "Cannot make direcotory '" , $nameDir , "'" , $@;
		}
	}
	return;
	
}


=head1 COPYRIGHT AND LICENSE

Copyright [2011-2017] Chesley Leslin

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself, either Perl version 5.8.4 or, at your
option, any later version of Perl 5 you may have available.

=head1 CONTACT

Please email comments or questions to Chesley Leslin c.leslin@neu.edu
=cut

1;
