package BioIO::Seq;
use Moose;
use Carp;
use feature qw(say);
use lib '/home/parikh.as/programming6200/final';
use BioIO::MyIO qw(getFh);
use BioIO::Config qw(getErrorString4WrongNumberArguments);
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;
use namespace::autoclean();

has 'gi' => (
	is => 'rw',
        isa => 'Int',
	required => 1,
	);
			
has 'seq' => (
	is => 'rw',
        isa => 'Str',
	required => 1,
	);
has 'def' => (
	is => 'rw',
        isa => 'Str',
	required => 1,
	);
has 'accn' => (
	is => 'rw',
        isa => 'Str',
	required => 1,
	);			

#-------------------------------------------------------------------------------
# void context: $seqObj->writeFasta($fileNameOut, $width) 	
#-------------------------------------------------------------------------------
# write the seq object to fasta file, where $fileNameOut is the outfile and $width is
# the width of the sequence column (default 70 if none provided)
#-------------------------------------------------------------------------------

sub writeFasta{
	my ($self,$outfile,$width) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self,$outfile,$width)';
    @_ == 3 or @_==2 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	if(!defined($width)){
		$width=70;
	}
	my $fhOut = getFh('>',$outfile);
	my $len = length($self->seq);
	my $def =$self->def;
	$def=~s/\n//g;
	$def=~s/\s\s+/ /g;
	$def=~s/\.//g;
	say $fhOut (">gi|",$self->gi,"|ref",$self->accn,"|",$def);
	my $str = $self->seq;
	my $s;
	say $fhOut "$s" while $s = substr $str, 0, $width, '';
}

#------------------------------------------------------------------------------------
# scalar context: my $newSeqObj = $seqObj->subSeq($begin, $end)
#------------------------------------------------------------------------------------
# subSeq receives the beginning and the ending sites, and returns a new BioIO::Seq object
# between the sites (inclusive, sites are bio-friendly num). This method should
# test to make sure that $begin and $end have been defined, and that you would not
# use "subSeq" outside the length of the sequence
#--------------------------------------------------------------------------------------

sub subSeq{
	my($self,$begin,$end)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self,$begin,$end)';
    	@_ == 3 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	my $seq = $self->seq;
	$seq=~s/\n//g;
	my $subSeq;
	if(!defined($begin) || !defined($end)){
		die "Begin and end are not defined , $!";
	}
	elsif ($begin-1 < 0 || $begin > length($seq) || $end < 0 || $end > length($seq)){
		die "Either Begin or end lies outside the length of a sequence, $!";
	}
	else{
		$subSeq = substr($seq,$begin-1,($end-$begin+1));
	}
	
	my $seqObj = BioIO::Seq->new(gi =>$self->gi, seq =>$subSeq, def =>$self->def, accn =>$self->accn);
	return($seqObj);
}

#---------------------------------------------------------------------------------------
#scalar (bool = 1 or return;) context: my $isCoding = $seqObj->checkCoding()
#----------------------------------------------------------------------------------------
# ckeckCoding checks if a seq starts with ATG codon and ends with a stop codon,
# i.e. TAA, TAG, or TGA
#-----------------------------------------------------------------------------------------

sub checkCoding{
	my($self)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self)';
    	@_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	my $seq=$self->seq;
	
	if(substr($seq,0,3) =~ /ATG/ && substr($seq,length($seq)-3,length($seq)) =~ /(TAA|TAG|TGA)/){
		return 1;
	}else{
		return;
	}
}

#-----------------------------------------------------------------------------------------
# my ($pos, $seqFound) = $seqObj->checkCutSite('GGATCC');
#-----------------------------------------------------------------------------------------
# checkCutSite receives a site pattern. It searches the seq, and determines the location
# of a restriction cut site and returns the position and the sequence that matched.
# Returns undef for both the position and the sequence if the cut site is not found.
#------------------------------------------------------------------------------------------

sub checkCutSite{
	my($self,$pattern)= @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self,$pattern)';
    @_ == 2 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	my $origPattern = $pattern;
	my $revPattern = $pattern;
	my $matchedSeq;
	$revPattern=~tr/atgcrynATGCRYN/tacgyrnTACGYRN/;
	
	
	if($pattern=~/r/ig && $revPattern=~/r/ig){
		$pattern=~s/r/[A|G]/ig;
		$revPattern=~s/r/[A|G]/ig;
	}
	if($pattern=~/y/ig && $revPattern=~/y/ig){
		$pattern=~s/y/[C|T]/ig;
		$revPattern=~s/y/[C|T]/ig;
	}
	if($pattern=~/n/ig && $revPattern=~/n/ig){
		$pattern=~s/n/[A|T|G|C]/ig;
		$revPattern=~s/n/[A|T|G|C]/ig;
	}
	
	
	my $seq = $self->seq;
	
	my $position;
	if($seq=~/$pattern/ig || $seq=~/$revPattern/ig ){
		$position = ($-[0]+1);
		$matchedSeq =$&;
		#$matchedSeq = substr $seq,$position-1,length($origPattern);
	}
	if(defined($position)){
		return($position,$matchedSeq);
	}else{
		return(undef,undef);
	}
}			
1;			

=head1 CONTACT

Please email comments or questions to Ashmi Parikh parikh.as@husky.neu.edu

=cut
