#!/usr/bin/perl
#
use TCPDumpXnn;
use YAML::XS;
use Data::Dumper;

my $inputFile = $ARGV[0];
my $desiredPort = $ARGV[1];
my %packet;
my $dumpFile = TCPDumpXnn->new(
	inputFile => $inputFile,
);
$dumpFile->readFile();
print Dumper($dumpFile->packets);
