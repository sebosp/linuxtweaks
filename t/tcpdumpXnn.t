
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
is($fileExists->packets->{"17:50:04.932359"}->{payload}->[0],"45", "Data header first chars");
is($fileExists->packets->{"17:50:04.932359"}->{payload}->[-1],"0a", "Data header last chars");
		#17:50:04.932359 IP 223.105.4.248.64114 > 106.186.123.201.80: Flags [P.], seq 1:261, ack 1, win 115, options [nop,nop,TS val 2848484540 ecr 1760720924], length 260: HTTP: GET http://112.124.116.170:83/index.php HTTP/1.1
done_testing();
