package BioIO::SeqIO;
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
        is => 'ro',
	isa => 'ArrayRef',
	writer => '_writer_gi',
	init_arg => undef,
	);
has '_seq' => (
        is => 'ro',
	isa => 'HashRef',
	writer => '_writer_seq',
	init_arg => undef,
	);
has '_def' => (
        is => 'ro',
	isa => 'HashRef',
	writer => '_writer_def',
	init_arg => undef,
	);
has '_accn' => (
        is => 'ro',
	isa => 'HashRef',
	writer => '_writer_accn',
	init_arg => undef,
	);
has '_current' => (
        is => 'ro',
	isa => 'Int',
	writer => '_writer_current',
	default => 0,
	init_arg => undef,
	);
has 'filename' => (
        is => 'ro',
	isa => 'Str',
	required => 1,
	);			
has 'fileType' => (
        is => 'ro',
	isa => FileType,
	required => 1,
	);				


sub BUILD{
	my ($self) = @_;
	
	
	if($self->fileType eq 'genbank'){
		$self->_getGenbankSeqs();
	}
	elsif($self->fileType eq 'fasta'){
		$self->_getFastaSeqs();
	}
	else{
		die"Not coded for this situation";
	}
		
}

sub _getGenbankSeqs{
	my($self) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self)';
    @_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;
	
	my $file = $self->filename;
	my $fhIn = getFh('<',$file);
	my (@giArr,%accns,%def,%seq);
	{
		local $/ = "//\n";
		my $gi;
		while(my $genbankData = <$fhIn>){
			if($genbankData=~/GI:(\S+)/m){
				$gi=$1;
				push(@giArr,$gi);
			}
			if($genbankData=~/^VERSION\s+(\S+)/m){
				$accns{$gi} = $1;
				
			}
			if($genbankData=~/^DEFINITION\s+(.*?\.)/ms){
				$def{$gi} = $1;
			}
			if($genbankData=~/ORIGIN\s+(.*)/ms){
				my $seq=$1;
				$seq=~s/\s+//g;
				$seq=~s/\d+//g;
				$seq=~s/\/\///g;
				$seq{$gi} = $seq;
			}
			
		}
		
	}
	
	
		$self->_writer_gi(\@giArr);
		$self->_writer_accn(\%accns);
		$self->_writer_def(\%def);
		$self->_writer_seq(\%seq);
}


sub _getFastaSeqs{
	my ($self)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self)';
    @_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
    
    my $file = $self->filename;
	my $fhIn = getFh('<',$file);
	
	my (@giArr,%accns,%def,%seq);
	my @header;
	my $gi;
	my $tempSeq="";
	while(my $line = <$fhIn>){
		chomp $line;
		if ($line =~ /^>/) {
			if($line =~ /^>gi\|(\d+)\|/){
				$gi = $1;
				push(@giArr,$gi);
			}
			if($line=~/^>gi\|.*\|(.*)/){
				$def{$gi} = $1;
			}
			if($line=~/^>gi\|.*?\|.*?\|(.*?)\|/){
				$accns{$gi} = $1;
			}
			if ($tempSeq ne "") { 
          		$seq{$gi} = $tempSeq;
          		$tempSeq = ""; 
       		}
		}	
       	else {
   				$tempSeq .= $line; 
  				$tempSeq .= "\n";
    	}		
	}
	if ($tempSeq ne "") { 
          $seq{$gi} = $tempSeq;
          $tempSeq = ""; 
    } 
 
	$self->_writer_gi(\@giArr);
	$self->_writer_accn(\%accns);
	$self->_writer_def(\%def);
	$self->_writer_seq(\%seq);   
}

sub nextSeq{
	my($self)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self)';
    @_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	my $current = $self->_current();
	
	if( $current < scalar(@{$self->_gi()})){
		
		my $refGi = $self->_gi();
		my $gi = $refGi->[$current];
		my $refHashSeq = $self->_seq();
		my $refHashDef = $self->_def();
		my $refHashAccn = $self->_accn();
		my $def = $refHashDef->{$gi};
		$def=~s/\n//g;
		$def=~s/\s\s+/ /g;
		$def=~s/\.//g;
		
		my $seq = BioIO::Seq->new(gi =>$gi, seq =>uc($refHashSeq->{$gi}), def =>$def, accn =>$refHashAccn->{$gi});
		
		$self->_writer_current(++$current);
		
		return($seq)
		
	}
	else{
			return undef;
		}	
	
}

1;
