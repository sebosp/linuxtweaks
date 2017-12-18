#!/usr/bin/perl

package TCPDumpXnn v0.0.1;
use Mouse; # automatically turns on strict and warnings
use Sub::Identify;
use namespace::autoclean;

has inputFile   => (is => 'ro', isa => 'Str',     default => '/var/log/tcpdump.log');
has filterPort  => (is => 'ro', isa => 'Num',     default => 0);
has packets     => (is => 'rw', isa => 'HashRef', default => sub{{}});
has headerRegEx => (is => 'ro', isa => 'RegexpRef',
	default => sub{qr/^([0-9:.]{15}) IP ([0-9.]+)\.([0-9]+) > ([0-9.]+)\.([0-9.]+): Flags .*/}
);
has DataRegEx   => (is => 'ro', isa => 'RegexpRef',
	default => sub{qr/^\s+(.*):\s+(.{40})\s+ .*/}
);

sub checkFile{
	my ($self) = @_;
	if(! -f $self->inputFile || ! -r $self->inputFile || -z $self->inputFile){
		return 0;
	}
	return 1;
}

sub isIPv4{
	my ($self,$packetData) = @_;
	print "Got data: $packetData\n";
	my ($version) = split(//,$packetData);
	if($version eq "4"){
		return 1;
	}
	return 0;
}

sub removeIPv4Header{
	my ($self,$packetKey) = @_;
	my %packet = %{ $self->packets() };
	return 0 unless($self->isIPv4($packet{$packetKey}{payload}[0]));
	my ($version,$headerSize) = split(//,$packet{$packetKey}{payload}[0]);
	# headerSize is how many 32-bit words is header
	# Transformed into bytes n*32/8 => n*4
	$headerSize *= 4;
	if($headerSize > scalar(@{$packet{$packetKey}{payload}})){
		# Invalid packet size.
		return 0;
	}
	splice(@{$packet{$packetKey}{payload}},0,$headerSize);
	$packet{$packetKey}{_hasIPv4Header}=0;
	$self->packets(\%packet);
	return 1;
}

sub removeTCPHeader{
	my ($self,$packetKey) = @_;
	my %packet = %{ $self->packets() };
	if(!exists($packet{$packetKey}{_hasIPv4Header}) || $packet{$packetKey}{_hasIPv4Header} == 1){
		return -1 unless($self->removeIPv4Header($packetKey));
	}
	# Byte Pos | Packet Payload fields:
	# 0        | [Source port]	[Destination port]
	# 4        | [Sequence number]x2
	# 8        | [Acknowledgment number (if ACK set)]x2
	# 12       | [Data offset(4 bits) ... reserved ]
	my $dataOffsetPosition = 12;
	if($dataOffsetPosition > scalar(@{$packet{$packetKey}{payload}})){
		return 0;
	}
	my ($dataOffset) = split(//,$packet{$packetKey}{payload}[$dataOffsetPosition]);
	# dataOffset is how many 32-bit words is TCP header
	# Transformed into bytes n*32/8 => n*4
	$dataOffset *= 4;
	if($dataOffset > scalar(@{$packet{$packetKey}{payload}})){
		# invalid packet size
		return 0;
	}
	splice(@{$packet{$packetKey}{payload}},0,$dataOffset);
	$packet{$packetKey}{_hasTCPHeader}=0;
	$self->packets(\%packet);
	return 1;
	
}

sub readFile{
	my ($self) = @_;
	open(my $fh,"<",$self->inputFile);
	return if(!$self->checkFile());
	my %packet = %{ $self->packets() };
	my $packetTime = "";
	while(my $inputLine = <$fh>){
		if($inputLine =~ $self->headerRegEx){
			$packetTime = $1;
			$packet{$packetTime}{srcIP}=$2;
			$packet{$packetTime}{srcPort}=$3;
			$packet{$packetTime}{dstIP}=$4;
			$packet{$packetTime}{dstPort}=$5;
			next;
		}
		if( $inputLine =~ $self->DataRegEx && 
		    ( $self->filterPort == 0  ||
		        ( !$self->filterPort == 0 && 
		          $self->filterPort == $packet{$packetTime}{srcPort} 
		))){
			push(@{$packet{$packetTime}{payload}},(join('',split(/ /,$2)) =~ /../g));
			next;
		}
	}
	close($fh);
	$self->packets(\%packet);
}

sub cleanHeaders{
	my($self) = @_;
	my %packet = %{ $self->packets() };
	foreach my $packetTime(keys(%packet)){
		next unless ($self->removeIPv4Header($packetTime));
		next unless ($self->removeTCPHeader($packetTime));
	}
}

__PACKAGE__->meta->make_immutable();

1;
