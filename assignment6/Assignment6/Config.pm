package Assignment6::Config;
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

# an error string for subroutines in this module
Readonly our $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS  => "\nIncorrect number of arguments in call to subroutine. ";
# the directory where the data can be found for this project
Readonly our $UNIGENE_DIR                           => '/data/PROGRAMMING/assignment5';
# an extension of the data
Readonly our $UNIGENE_FILE_ENDING                   => 'unigene';

# keywords for lookup
Readonly our $HOST_KEYWORDS => {
    'bos taurus'        => 'Bos_taurus',
    'cow'               => 'Bos_taurus',
    'cows'              => 'Bos_taurus',

    'equus caballus'    => 'Equus_caballus',
    'horse'             => 'Equus_caballus',
    'horses'            => 'Equus_caballus',

    'homo sapiens'      => 'Homo_sapiens',
    'human'             => 'Homo_sapiens',
    'humans'            => 'Homo_sapiens',

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

=head1 NAME

Assignment5::Config - package to show how to create a config file

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
    my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '()';
    # test the number of arguments passed in were correct 
    @_ == 0 or confess $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS , $filledUsage;
    return $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS;
}

=head2 getUnigeneExtension

   Arg [1]    : No Arguments

   Example    : my $file = join("/", getUnigeneDirectory(), $HOST, $GENE . '.' . getUnigeneExtension() );

   Description: This will return unigene extension used for this project

   Returntype : A scalar

   Status     : Stable

=cut
sub getUnigeneExtension{
    my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '()';
    #test the number of arguments passed in were correct 
    @_ == 0 or confess $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS , $filledUsage;
    return $UNIGENE_FILE_ENDING;
}

=head2 getUnigeneDirectory

   Arg [1]    : No Arguments

   Example    : my $file = join("/", getUnigeneDirectory(), $HOST, $GENE . '.' . getUnigeneExtension() );

   Description: This will return unigene directory used for this project

   Returntype : A scalar

   Status     : Stable

=cut
sub getUnigeneDirectory{
    my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '()';
    #test the number of arguments passed in were correct 
    @_ == 0 or confess $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS , $filledUsage;
    return $UNIGENE_DIR;
}
=head2 getHostKeywords

   Arg [1]    : No Arguments

   Example    : my $hostKeywords = getHostKeywords();
                if(exists $hostKeywords->{$host}){
                   $host = $hostKeywords->{$host};
                }    
                else {
                    
                }

   Description: returns hash ref containing keyword lookup table. This idea of passing back the hash was from Dan Shea

   Returntype : A refernece to as hash

   Status     : Stable

=cut

sub getHostKeywords{
    my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '()';
    #test the number of arguments passed in were correct 
    @_ == 0 or confess $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS , $filledUsage;
    return $HOST_KEYWORDS;
}
=head1 COPYRIGHT AND LICENSE

Copyright [2011-2016] Chesley Leslin

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself, either Perl version 5.8.4 or, at your
option, any later version of Perl 5 you may have available.

=head1 CONTACT

Please email comments or questions to Chesley Leslin c.leslin@neu.edu
=cut

1;
