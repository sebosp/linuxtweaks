#!/usr/bin/perl
#
use lib './lib';
use TCPDumpXnn;
#use YAML::XS;
use Data::Dumper;

my $inputFile = $ARGV[0];
my $desiredPort = $ARGV[1];
my %packet;
my $dumpFile = TCPDumpXnn->new(
	inputFile => $inputFile,
);
$dumpFile->readFile();
$dumpFile->cleanHeaders();
print Dumper($dumpFile->packets);
$dumpFile->printPacketData("12:02:29.079453");
