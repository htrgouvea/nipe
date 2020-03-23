package Nipe::Utils::Install;

use strict;
use warnings;
use Nipe::Utils::Device;

sub new {
	my %device  = Nipe::Utils::Device -> new();
	my $stopTor = "sudo systemctl stop tor";

	system ("sudo mkdir -p /etc/tor/");

	if ($device{distribution} eq "debian") {
		system ("sudo apt-get install -y tor iptables");
		system ("sudo cp .configs/debian-torrc /etc/tor/torrc");
	}
	
	elsif ($device{distribution} eq "fedora") {
		system ("sudo dnf install -y tor iptables");
		system ("sudo cp .configs/fedora-torrc /etc/tor/torrc");
	}

	elsif ($device{distribution} eq "centos") {
		system ("sudo yum -y install epel-release tor iptables");
		system ("sudo cp .configs/centos-torrc /etc/tor/torrc");
	}

	else {
		system ("sudo pacman -S --noconfirm -S tor iptables");
		system ("sudo cp .configs/arch-torrc /etc/tor/torrc");
	}

	system ("sudo chmod 644 /etc/tor/torrc");

	if (-e "/etc/init.d/tor") {
		$stopTor = "sudo /etc/init.d/tor stop > /dev/null";
	}
	
	system ($stopTor);

	return 1;
}

1;