
use Test::More;
use lib '../';
use Data::Dumper;
use_ok('TCPDumpXnn','0.0.1');
ok(my $defaults = TCPDumpXnn->new(), "Class with defaults");
ok(my $fileNoExists = TCPDumpXnn->new(
	inputFile => ' /Z/nonExistantFile'
),"Class with non existent file");
is($fileNoExists->checkFile(),0,"File not exists recognized");
ok(my $fileExists = TCPDumpXnn->new(
	inputFile => './t/tcpdumpXnn.input',
),"Class with existsing file");
is($fileExists->checkFile(),1,"File exists recognized");
ok($fileExists->readFile(),"File read properly");
ok(exists($fileExists->packets->{"17:50:04.932359"}), "Date key exists");
is($fileExists->packets->{"17:50:04.932359"}->{payload}->[0],"45", "IP Packet header first byte");
is($fileExists->packets->{"17:50:04.932359"}->{payload}->[-1],"0a", "IP Packet header last byte");
is($fileExists->removeIPv4Header("17:50:04.932359"), 1, "Removing IPv4 Header");
is($fileExists->packets->{"17:50:04.932359"}->{payload}->[0],"fa", "TCP Packet header first byte");
push(@{$fileExists->packets->{nonIPv4Header}->{payload}},("66","00"));
is($fileExists->isIPv4("66"), 0, "Invalid IPv4 header");
is($fileExists->removeIPv4Header("nonIPv4Header"), 0, "Not removing invalid IPv4 header");
push(@{$fileExists->packets->{invalidIPv4HeaderSize}->{payload}},"49");
is($fileExists->removeIPv4Header("invalidIPv4HeaderSize"), 0, "Invalid IPv4 Header Size recognized");
push(@{$fileExists->packets->{invalidTCPHeaderSize}->{payload}},"");
$fileExists->packets->{invalidTCPHeaderSize}->{_hasIPv4Header} = 0;
is($fileExists->removeTCPHeader("invalidTCPHeaderSize"), 0, "Invalid TCP Header Size recognized");
push(@{$fileExists->packets->{invalidTCPDataOffset}->{payload}},
	( "fa","72", # Source Port
	  "00","50", # Destination Port
	  "1e","e2","4a","1d", # Sequence number
	  "54","14","7e","5e", # Acknowledge number
	  #"80","18","00","73", # Data offset, reserved, flags, 
));
$fileExists->packets->{invalidTCPDataOffset}->{_hasIPv4Header} = 0;
is($fileExists->removeTCPHeader("invalidTCPDataOffset"), 0, "TCP Data Offset not found");
push(@{$fileExists->packets->{invalidTCPDataSize}->{payload}},
	( "fa","72", # Source Port
	  "00","50", # Destination Port
	  "1e","e2","4a","1d", # Sequence number
	  "54","14","7e","5e", # Acknowledge number
	  "80","18","00","73", # Data offset, reserved, flags, 
));
$fileExists->packets->{invalidTCPDataSize}->{_hasIPv4Header} = 0;
is($fileExists->removeTCPHeader("invalidTCPDataSize"), 0, "TCP Invalid Data Size recognized");
is($fileExists->removeTCPHeader("17:50:04.932359"), 1, "Removing TCP Header");
is($fileExists->packets->{"17:50:04.932359"}->{payload}->[0],"47", "TCP Packet Data first byte");
is($fileExists->printPacketData("17:50:04.932359"), 1, "Printed Packet Data");


		#17:50:04.932359 IP 223.105.4.248.64114 > 106.186.123.201.80: Flags [P.], seq 1:261, ack 1, win 115, options [nop,nop,TS val 2848484540 ecr 1760720924], length 260: HTTP: GET http://112.124.116.170:83/index.php HTTP/1.1
done_testing();
