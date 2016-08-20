#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvêa                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2016 Heitor Gouvêa                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Nipe::CheckIp;

use JSON;
use LWP::UserAgent;

sub new {
	my $api_check = "https://check.torproject.org/api/ip";
	my $useragent = LWP::UserAgent -> new();
	my $request   = $useragent -> get($api_check);
	my $httpCode  = $request -> code();

	if ($httpCode == "200") {
		my $data = decode_json ($request -> content);

		my $checkIp  = $data -> {'IP'};
		my $checkTor = $data -> {'IsTor'};
		
		if ($checkTor) {
			print "\nTor: Activated\nIp: $checkIp\n";
		}

		else {
			print "\nTor: Disabled\nIp: $checkIp\n";
		}
	}

	else {
		print "\nError: sorry, it was not possible to establish a connection to the server.\n";
	}
}

1;
