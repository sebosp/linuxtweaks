#!/usr/bin/perl

package TCPDumpXnn v0.0.1;
use Mouse; # automatically turns on strict and warnings
use Sub::Identify;
use namespace::autoclean;

has inputFile   => (is => 'ro', isa => 'Str',     default => '/var/log/tcpdump.log');
has filterPort => (is => 'ro', isa => 'Num',     default => 0);
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

__PACKAGE__->meta->make_immutable();

1;
