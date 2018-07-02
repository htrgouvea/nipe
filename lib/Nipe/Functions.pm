#!/usr/bin/perl

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
		\r\trestart       Restart the Nipe process
		\r\tstatus        See status

		\rNipe developed by Heitor Gouvêa
		\rCopyright (c) 2015-2018 Heitor Gouvêa\n\n";
}

sub install {
	my $operationalSystem = Nipe::Device -> getSystem();

	system ("sudo mkdir -p /etc/tor");

	if ($operationalSystem == "debian") {
		system ("sudo apt-get install tor iptables");
		system ("sudo cp .configs/debian-torrc /etc/tor/torrc");
	}

	elsif ($operationalSystem == "arch") {
		system ("sudo pacman -S tor iptables");
		system ("sudo cp .configs/arch-torrc /etc/tor/torrc");
	}

	elsif ($operationalSystem == "fedora") {
		system ("sudo dnf install tor iptables");
		system ("sudo cp .configs/fedora-torrc /etc/tor/torrc");
	}

	else {
		system ("sudo apt install tor iptables");
		system ("sudo cp .configs/debian-torrc /etc/tor/torrc");
	}

	system ("sudo chmod 644 /etc/tor/torrc");
	system ("sudo systemctl stop tor");
}

1;
