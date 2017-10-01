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
		\r\trestart       Restart the nipe process
		\r\tstatus        See status

		\rNipe developed by Heitor Gouvêa
		\rCopyright (c) 2015-2017 Heitor Gouvêa\n\n";
}

sub install {
	my $operationalSystem = Nipe::Device -> getSystem();

	if ($operationalSystem == "debian") {
		system ("sudo apt-get install tor iptables");
		system ("sudo wget https://gouveaheitor.github.io/nipe/$operationalSystem/torrc");
	}

	elsif ($operationalSystem == "arch") {
		system ("sudo pacman -S tor iptables");
	}

	elsif ($operationalSystem == "fedora") {
		system ("sudo dnf install tor iptables");
		system ("sudo wget https://gouveaheitor.github.io/nipe/$operationalSystem/torrc");
	}

	else {
		system ("sudo pacman -S tor iptables");
	}

	system ("sudo mkdir -p /etc/tor");
	system ("sudo mv torrc /etc/tor/torrc");
	system ("sudo chmod 644 /etc/tor/torrc");
	system ("sudo systemctl restart tor");
}

1;
