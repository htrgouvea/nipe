#!/usr/bin/env perl

package Nipe::CheckIp;

use JSON;
use LWP::UserAgent;

sub new {
	my $apiCheck  = "https://check.torproject.org/api/ip";
	my $userAgent = LWP::UserAgent -> new();
	my $request   = $userAgent -> get($apiCheck);
	my $httpCode  = $request -> code();
		
	if ($httpCode == 200) {
		my $data = decode_json ($request -> content);

		my $checkIp  = $data -> {'IP'};
		my $checkTor = $data -> {'IsTor'};

		if ($checkTor) {
			$checkTor = "activated";
		}

		else {
			$checkTor = "disabled";
		}

		print "\n\r[+] Status: $checkTor. \n\r[+] Ip: $checkIp\n\n";
	}

	else {
		print "\n[!] ERROR: sorry, it was not possible to establish a connection to the server.\n\n";
	}
}

1;