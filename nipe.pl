#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvêa                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2017 Heitor Gouvêa                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] SITE:         https://heitorgouvea.me             #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TELEGRAM:     @GouveaHeitor                       #
#########################################################

use Switch;
use lib "./lib/";
use Nipe::Stop;
use Nipe::Start;
use Nipe::CheckIp;
use Nipe::Functions;

sub main {
	my $command = $ARGV[0];

	switch ($command) {
		case "help" {
			Nipe::Functions -> help();
		}

		case "stop" {
			Nipe::Stop -> new();
			Nipe::CheckIp -> new();
		}

		case "start" {
			Nipe::Start -> new();
			Nipe::CheckIp -> new();
		}

		case "status" {
			Nipe::CheckIp -> new();
		}

		case "restart" {
			Nipe::Stop -> new();
			Nipe::Start -> new();
			Nipe::CheckIp -> new();
		}

		case "install" {
			Nipe::Functions -> install();
		}

		else {
			Nipe::Functions -> help();
		}
	}
}

main();
exit;
