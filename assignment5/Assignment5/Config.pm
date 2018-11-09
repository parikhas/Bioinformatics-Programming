package Assignment5::Config;
use strict;
use warnings;
use Carp qw( confess );
use Exporter 'import';
our @EXPORT_OK = qw(getErrorString4WrongNumberArguments
  getUnigeneDirectory
  getUnigeneExtension
  getHostKeywords
);
use Readonly;

# an error string for subroutines in this module, and to export via the function:
# getErrorString4WrongNumberArguments
Readonly our $UNIGENE_DIR => '/home/ashmi/Documents/BINF6200/assignment5';
Readonly our $UNIGENE_FILE_ENDING => 'unigene';
Readonly our $HOST_KEYWORDS       => {
	'bos taurus'        => 'Bos_taurus',
	'cow'               => 'Bos_taurus',
	'cows'              => 'Bos_taurus',
	'homo sapiens'      => 'Homo_sapiens',
	'humans'            => 'Homo_sapiens',
	'human'             => 'Homo_sapiens',
	'equus caballus'    => 'Equus_caballus',
	'horse'             => 'Equus_caballus',
	'horses'            => 'Equus_caballus',
	'mus musculus'      => 'Mus_musculus',
	'mouse'             => 'Mus_musculus',
	'mice'              => 'Mus_musculus',
	'ovis aries'        => 'Ovis_aries',
	'sheep'             => 'Ovis_aries',
	'sheeps'            => 'Ovis_aries',
	'rattus norvegicus' => 'Rattus_norvegicus',
	'rat'               => 'Rattus_norvegicus',
	'rats'              => 'Rattus_norvegicus',
  }; 
  
Readonly our $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS => "\nIncorrect number of arguments in call to subroutine. ";

=head1 NAME

Assignment4::Config - package to show how to create a config file

=head1 SYNOPSIS

Creation:

    use Assignment4::Config qw( getErrorString4WrongNumberArguments );

    sub initializeChr21Hash{
        my $filledUsage = join(' ' , 'Usage:' , (caller(0))[3]) . '($refHash, $infile)';
        # test the number of arguments passed in were correct 
        @_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;
        
        my ($infile) = @_; 

        return;
    }

=head1 DESCRIPTION

This module was designed to be used by the Assignment 4 programs, and show how to create
a configuration Perl package.

=head1 EXPORTS

=head2 Default behavior

Nothing by default. 

use Assignment4::Config qw( getErrorString4WrongNumberArguments );

=head1 FUNCTIONS

=head2 getErrorString4WrongNumberArguments

   Arg [1]    : No Arguments

   Example    : @_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;

   Description: This will return the error string defined by constant $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS 
                One can use to get a generic string for error handling when the incorrect number of 
                parameters is called in a Module.

   Returntype : A scalar

   Status     : Stable

=cut
sub getErrorString4WrongNumberArguments{
    #my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '()';
    # test the number of arguments passed in were correct 
    #@_ == 0 or confess $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS , $filledUsage;
    return $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS;
}

=head2 getUnigeneDirectory
Arg [1]    : No Arguments

   Example    : my $UNIGENE_DIR = getUnigeneDirectory(); 

   Description: This will return the directory for the genes 

   Returntype : A scalar

   Status     : Stable

=cut
sub getUnigeneDirectory {
	  #my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '()';
	 # test the number of arguments passed in were correct 
    #@_ == 0 or confess $UNIGENE_DIR , $filledUsage;
	return $UNIGENE_DIR;
}

=head2 getUnigeneExtension
Arg [1]    : No Arguments

   Example    : my $UNIGENE_FILE_ENDING = getUnigeneExtension(); 

   Description: This will return the output directory for the project 

   Returntype : A scalar

   Status     : Stable

=cut
sub getUnigeneExtension {
	 # test the number of arguments passed in were correct 
    #@_ == 0 or confess $UNIGENE_FILE_ENDING , $filledUsage;
	return $UNIGENE_FILE_ENDING;
}
=cut

=head2 getHostKeywords
Arg [1]    : No Arguments

   Example    : my $UNIGENE_FILE_ENDING = getUnigeneExtension(); 

   Description: This will return the output directory for the project 

   Returntype : A scalar

   Status     : Stable

=cut
sub getHostKeywords {
	 # test the number of arguments passed in were correct 
    #@_ == 0 or confess $UNIGENE_FILE_ENDING , $filledUsage;
	return $HOST_KEYWORDS;
}
=cut
1;





