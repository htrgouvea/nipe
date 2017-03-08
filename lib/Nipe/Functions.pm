#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvêa                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2017 Heitor Gouvêa                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
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
		\r\tCommand       Description
		\r\t-------       -----------
		\r\tinstall       Install dependencies
		\r\tstart         Start routing
		\r\tstop          Stop routing
		\r\tstatus        See status

		\rNipe developed by Heitor Gouvêa
		\rCopyright (c) 2015-2017 Heitor Gouvêa\n\n";
}

sub install {
	my $operationalSystem = `cat /etc/os-release | grep 'ID_LIKE' | cut -d '=' -f 2`;

	chomp ($operationalSystem);

	if (($operationalSystem =~ /[U,u]buntu/) || ($operationalSystem =~ /[D,d]ebian/)) {
		system ("sudo apt-get install tor iptables");
	}

	elsif ($operationalSystem =~ /[A,a]rch/) {
		system ("sudo pacman -S tor iptables");
	}

	elsif ($operationalSystem =~ /[F,f]edora/) {
		system ("sudo dnf install tor iptables");
	}

	else {
		system ("sudo pacman -S tor iptables");
	}

	system("sudo wget http://gouveaheitor.github.io/nipe/$operationalSystem/torrc");
	system ("sudo mkdir -p /etc/tor");
	system ("sudo mv torrc /etc/tor/torrc");
	system ("sudo chmod 644 /etc/tor/torrc");
	system ("sudo systemctl restart tor");
}

1;
