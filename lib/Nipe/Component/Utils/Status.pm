package Nipe::Component::Utils::Status {
	use JSON;
	use strict;
	use warnings;
	use HTTP::Tiny;
	use Readonly;

	Readonly my $SUCCESS_CODE => 200;

	our $VERSION = '0.0.4';

	sub new {
		my $api_check = 'https://check.torproject.org/api/ip';
		my $request  = HTTP::Tiny -> new -> get($api_check);

		if ($request -> {status} == $SUCCESS_CODE) {
			my $data = decode_json($request -> {content});

			my $check_ip  = $data -> {'IP'};
			my $check_tor = 'false';
			if ($data -> {'IsTor'}) {
				$check_tor = 'true';
			}

			return "\n\r[+] Status: $check_tor \n\r[+] Ip: $check_ip\n\n";
		}

		return "\n[!] ERROR: sorry, it was not possible to establish a connection to the server.\n\n";
	}
}

1;
