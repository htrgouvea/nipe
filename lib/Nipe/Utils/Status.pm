package Nipe::Utils::Status {
	use JSON;
	use strict;
	use warnings;
	use HTTP::Tiny;

	sub new {
		my $apiCheck = "https://check.torproject.org/api/ip";
		my $request = HTTP::Tiny -> new -> get($apiCheck);
			
		if ($request -> {status} == 200) {
			my $data = decode_json ($request -> {content});

			my $checkIp  = $data -> {"IP"};
			my $checkTor = $data -> {"IsTor"} ? "true" : "false";

			return "\n\r[+] Status: $checkTor. \n\r[+] Ip: $checkIp\n\n";
		}

		return "\n[!] ERROR: sorry, it was not possible to establish a connection to the server.\n\n";
	}
}

1;