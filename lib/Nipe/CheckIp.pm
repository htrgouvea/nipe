#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvêa                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2017 Heitor Gouvêa                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hgouvea@protonmail.com              #
# [+] SITE:         http://heitorgouvea.me              #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
# [+] TELEGRAM:     @GouveaHeitor                       #
#########################################################

package Nipe::CheckIp;

use JSON;
use LWP::UserAgent;

sub new {
	my $apiCheck = "https://check.torproject.org/api/ip";
	my $userAgent = LWP::UserAgent -> new();
	my $request   = $userAgent -> get($apiCheck);
	my $httpCode  = $request -> code();

	if ($httpCode == "200") {
		my $data = decode_json ($request -> content);

		my $checkIp  = $data -> {'IP'};
		my $checkTor = $data -> {'IsTor'};

		if ($checkTor) {
			print "
				\r\033[1;32m[+]\033[1;37m Nipe: Activated
				\r\033[1;32m[+]\033[1;37m Ip: $checkIp\n\n";
		}

		else {
			print "
				\r\033[1;32m[+]\033[1;37m Nipe: Disabled
				\r\033[1;32m[+]\033[1;37m Ip: $checkIp\n\n";
		}
	}

	else {
		print "\n\033[31m[!]\033[1;37m ERROR: sorry, it was not possible to establish a connection to the server.\n\n";
	}
}

1;
