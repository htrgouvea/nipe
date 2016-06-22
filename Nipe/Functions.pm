#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvea                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2016 Heitor Gouvea                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvea                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Nipe::Functions;

my $os = `cat /etc/os-release | grep 'ID' | cut -d '=' -f 2`;

sub help {
	print "\n\tCOMMAND \t FUCTION\n
	install \t to install
	start   \t to start
	stop    \t to stop\n\n";
}

sub install {
	if (($os =~ /[U,u]buntu/) || ($os =~ /[D,d]ebian/)) {
		system ("sudo apt-get install tor perl iptables");
		system ("sudo wget http://heitorgouvea.me/nipe/ubuntu/torrc");
	}

	elsif ($os =~ /[A,a]rch/) {
		system ("sudo pacman -S tor perl iptables");
		system ("sudo wget http://heitorgouvea.me/nipe/arch/torrc");
	}

	elsif ($os =~ /[F,f]edora/) {
		system ("sudo dnf install tor perl iptables");
		system ("sudo wget http://heitorgouvea.me/nipe/fedora/torrc");
	}

	else {
		system ("sudo pacman -S tor perl iptables");
		system ("sudo wget http://heitorgouvea.me/nipe/arch/torrc");
	}

	system ("sudo mkdir -p /etc/tor");
	system ("sudo mv torrc /etc/tor/torrc");
	system ("sudo chmod 644 /etc/tor/torrc");
}

1;
