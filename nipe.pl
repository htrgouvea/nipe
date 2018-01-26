#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvêa                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2018 Heitor Gouvêa                 #
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
		case "stop" {
			Nipe::Stop -> new();
			sleep(1);
			Nipe::CheckIp -> new();
		}

		case "start" {
			Nipe::Start -> new();
			sleep(1);
			Nipe::CheckIp -> new();
		}

		case "status" {
			Nipe::CheckIp -> new();
		}

		case "restart" {
			Nipe::Stop -> new();
			sleep(1);
			Nipe::Start -> new();
			sleep(1);
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
