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

package Nipe::Functions;

use Nipe::Device;

sub help {
	print "
	\r\033[1;37mCore Commands
	\r==============
	Command       Description
	-------       -----------
	help          Show help menu
	start         Start routing
	stop          Stop routing
	status        See status

	\rNipe developed by Heitor Gouvêa
	\rCopyright (c) 2015-2017 Heitor Gouvêa\n\n";
}

sub install {
	my $os = `cat /etc/os-release | grep 'ID' | cut -d '=' -f 2`;

	if (($os =~ /[U,u]buntu/) || ($os =~ /[D,d]ebian/)) {
		system ("sudo apt-get install tor iptables");
		system ("sudo wget http://gouveaheitor.github.io/nipe/ubuntu/torrc");
	}

	elsif ($os =~ /[A,a]rch/) {
		system ("sudo pacman -S tor iptables");
		system ("sudo wget http://gouveaheitor.github.io/nipe/arch/torrc");
	}

	elsif ($os =~ /[F,f]edora/) {
		system ("sudo dnf install tor iptables");
		system ("sudo wget http://gouveaheitor.github.io/nipe/fedora/torrc");
	}

	else {
		system ("sudo pacman -S tor iptables");
		system ("sudo wget http://gouveaheitor.github.io/nipe/arch/torrc");
	}

	system ("sudo mkdir -p /etc/tor");
	system ("sudo mv torrc /etc/tor/torrc");
	system ("sudo chmod 644 /etc/tor/torrc");
	system ("sudo systemctl restart tor");
}

1;
