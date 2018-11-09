package BioIO::SeqIO;
use feature qw(say);
use Moose;
use Carp;
use lib '/home/parikh.as/programming6200/final';
use BioIO::MyIO qw(getFh);
use BioIO::Seq;
use BioIO::Config qw(getErrorString4WrongNumberArguments);
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;
use FinalTypes::MyTypes qw(FileType);
use namespace::autoclean;

has '_gi' => (
	is       => 'ro',
	isa      => 'ArrayRef',
	writer   => '_writer_gi',
	init_arg => undef,
);

has '_seq' => (
	is       => 'ro',
	isa      => 'HashRef',
	writer   => '_writer_seq',
	init_arg => undef,
);

has '_def' => (
	is       => 'ro',
	isa      => 'HashRef',
	writer   => '_writer_def',
	init_arg => undef,
);

has '_accn' => (
	is       => 'ro',
	isa      => 'HashRef',
	writer   => '_writer_accn',
	init_arg => undef,
);

has '_current' => (
	is       => 'ro',
	isa      => 'Int',
	writer   => '_writer_current',
	default  => 0,
	init_arg => undef,
);

has 'filename' => (
	is       => 'ro',
	isa      => 'Str',
	required => 1,
);

has 'fileType' => (
	is       => 'ro',
	isa      => FileType,
	required => 1,
);

=head1 SeqIO
SeqIO: objects with filename and filetype as required arguments. Other attributes are inaccesible to user via API.
=head1 Synopsis
	use BioIO::SeqIO
	my $seqIoObj = BioIO::SeqIO->new(filename => $infile , fileType => 'genbank' ); # object creation
	
	my $output = "OUTPUT";
	# go thru SeqIO obj and print all seq
	while (my $seqObj = $seqIoObj->nextSeq() ) {
	    my $fileNameOut = $output . '/' . $seqObj->accn . ".fasta"; #create an output name
	     $seqObj->writeFasta( $fileNameOut);    # write the Fasta File
       }
=cut

#-------------------------------------------------------------------------------
#_getGenbankSeqs: private to the class, and called by the BUILD method
#-------------------------------------------------------------------------------
# _getGenbankSeqs read seqs and info, and fills in the SeqIO attributes
# with _gi, _accn, _def and _seq attributes created
#-------------------------------------------------------------------------------

sub _getGenbankSeqs {
	my ($self) = @_;
	my $filledUsage = 'Usage: ' . ( caller(0) )[3] . '($self)';
	@_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;

	my $file = $self->filename;
	my $fhIn = getFh( '<', $file );
	my ( @gi_ar, %accn_h, %def, %seq );
	{
		local $/ = "//\n"
		  ;  # set the file delimiter to the record separator for a GenBank file
		my $gi;
		while ( my $gen_data = <$fhIn> ) {
			if ( $gen_data =~ /GI:(\S+)/m ) {
				$gi = $1;
				push( @gi_ar, $gi );
			}
			if ( $gen_data =~ /^VERSION\s+(\S+)/m ) {
				$accn_h{$gi} = $1;

			}
			if ( $gen_data =~ /^DEFINITION\s+(.*?\.)/ms ) {
				$def{$gi} = $1;
			}
			if ( $gen_data =~ /ORIGIN\s+(.*)/ms ) {
				my $seq = $1;
				$seq =~ s/\s+//g;
				$seq =~ s/\d+//g;
				$seq =~ s/\/\///g;
				$seq{$gi} = $seq;
			}

		}

	}

	$self->_writer_gi( \@gi_ar );
	$self->_writer_accn( \%accn_h );
	$self->_writer_def( \%def );
	$self->_writer_seq( \%seq );
}

#-------------------------------------------------------------------------------
#_getFastaSeqs: private to the class, and called by the BUILD method
#-------------------------------------------------------------------------------
# _getFastaSeqs read seqs and info, and fills in the SeqIO attributes
# with _gi, _accn, _def and _seq attributes created
#-------------------------------------------------------------------------------

sub _getFastaSeqs {
	my ($self) = @_;
	my $filledUsage = 'Usage: ' . ( caller(0) )[3] . '($self)';
	@_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;

	my $file = $self->filename;
	my $fhIn = getFh( '<', $file );

	my ( @gi_ar, %accn_h, %def, %seq );
	my @header;
	my $gi;
	my $temp_seq = "";
	while ( my $line = <$fhIn> ) {
		chomp $line;
		if ( $line =~ /^>/ ) {
			if ( $line =~ /^>gi\|(\d+)\|/ ) {
				$gi = $1;
				push( @gi_ar, $gi );
			}
			if ( $line =~ /^>gi\|.*\|(.*)/ ) {
				$def{$gi} = $1;
			}
			if ( $line =~ /^>gi\|.*?\|.*?\|(.*?)\|/ ) {
				$accn_h{$gi} = $1;
			}
			if ( $temp_seq ne "" ) {
				$seq{$gi} = $temp_seq;
				$temp_seq = "";
			}
		}
		else {
			$temp_seq .= $line;
			$temp_seq .= "\n";
		}
	}
	if ( $tempSeq ne "" ) {
		$seq{$gi} = $tempSeq;
		$tempSeq = "";
	}

	$self->_writer_gi( \@gi_ar );
	$self->_writer_accn( \%accn_h );
	$self->_writer_def( \%def );
	$self->_writer_seq( \%seq );
}

#-------------------------------------------------------------------------------
# nextSeq will first test if there is another sequence left in the object
# If there is not, it should return undef. If this test passes, the method will create a new Seq object
# and fill in the attributes for the Seq object (gi, seq, def, accn) at construction
# It will then increment the _current attribute of this instance of the BioIO::SeqIO class.
#-------------------------------------------------------------------------------

sub nextSeq {
	my ($self) = @_;
	my $filledUsage = 'Usage: ' . ( caller(0) )[3] . '($self)';
	@_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;

	my $current = $self->_current();

	if ( $current < scalar( @{ $self->_gi() } ) ) {

		my $refGi       = $self->_gi();
		my $gi          = $refGi->[$current];
		my $refHashSeq  = $self->_seq();
		my $refHashDef  = $self->_def();
		my $refHashAccn = $self->_accn();
		my $def         = $refHashDef->{$gi};
		$def =~ s/\n//g;
		$def =~ s/\s\s+/ /g;
		$def =~ s/\.//g;

		my $seq = BioIO::Seq->new(
			gi   => $gi,
			seq  => uc( $refHashSeq->{$gi} ),
			def  => $def,
			accn => $refHashAccn->{$gi}
		);

		$self->_writer_current( ++$current );

		return ($seq)

	}
	else {
		return undef;
	}

}

sub BUILD {
	my ($self) = @_;

	if ( $self->fileType eq 'genbank' ) {
		$self->_getGenbankSeqs();
	}
	elsif ( $self->fileType eq 'fasta' ) {
		$self->_getFastaSeqs();
	}
	else {
		die "Please enter a genbank or fasta file";
	}

}

1;

=head1 COPYRIGHT AND LICENSE

Copyright Ashmi Parikh

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself, either Perl version 5.8.4 or, at your
option, any later version of Perl 5 you may have available.

=head1 CONTACT

Please email comments or questions to Ashmi Parikh parikh.as@husky.neu.edu
=cut

