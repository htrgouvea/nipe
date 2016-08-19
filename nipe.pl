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

use Switch;
use lib "./lib/";
use Nipe::Stop;
use Nipe::Start;
use Nipe::Functions;

sub main {
	my $command = $ARGV[0];

	print "\n\033[1;32m
	88b 88   88   8888Yb  888888
	88Yb88   88   88__dP  88__    Developed by
	88 Y88   88   88--    88--    Heitor Gouvêa
	88  Y8   88   88      888888\n\033[1;37m\n";

	switch ($command) {
		case "stop"    { Nipe::Stop -> new(); }
		case "start"   { Nipe::Start -> new(); }
		case "install" { Nipe::Functions -> install(); }
		else           { Nipe::Functions -> help(); }
	}
}

main();
exit;