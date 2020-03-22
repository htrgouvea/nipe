package Nipe::Utils::Status;

use JSON;
use HTTP::Tiny;

sub new {
    my $apiCheck = "https://check.torproject.org/api/ip";
    my $response = HTTP::Tiny -> new -> get($apiCheck);
		
	if ($response -> {status} == 200) {
	 	my $data = decode_json ($response -> {content});

		my $checkIp  = $data -> {'IP'};
		my $checkTor = $data -> {'IsTor'} ? "activated" : "disabled";

		return "\n\r[+] Status: $checkTor. \n\r[+] Ip: $checkIp\n\n";
	}

	return "\n[!] ERROR: sorry, it was not possible to establish a connection to the server.\n\n";
}

1;