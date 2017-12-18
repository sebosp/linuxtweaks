
use Test::More;
use lib '../';
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
my %packets = %{$fileExists->packets()};
push(@{$packets{nonIPv4Header}{payload}},(66,00));
is($fileExists->isIPv4("66"), 0, "Invalid IPv4 header");
#is($fileExists->removeIPv4Header("nonIPv4Header"), 0, "Not removing invalid IPv4 header");
#push(@{$packets{invalidIPv4HeaderSize}{payload}},"45");
		#17:50:04.932359 IP 223.105.4.248.64114 > 106.186.123.201.80: Flags [P.], seq 1:261, ack 1, win 115, options [nop,nop,TS val 2848484540 ecr 1760720924], length 260: HTTP: GET http://112.124.116.170:83/index.php HTTP/1.1
done_testing();
