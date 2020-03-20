package Nipe::Utils::Install;

use strict;
use warnings;
use Nipe::Utils::Device;

sub new {
	my %device  = Nipe::Utils::Device -> new();
	my $stopTor = "sudo systemctl stop tor";

	if ($device{distribution} eq "debian") {
		system ("sudo apt-get install tor iptables");
		system ("sudo cp .configs/debian-torrc \$HOME/.niperc");
	}
	
	elsif ($device{distribution} eq "fedora") {
		system ("sudo dnf install tor iptables");
		system ("sudo cp .configs/fedora-torrc \$HOME/.niperc");
	}

	elsif ($device{distribution} eq "centos") {
		system ("sudo yum install epel-release tor iptables");
		system ("sudo cp .configs/centos-torrc \$HOME/.niperc");
	}

	else {
		system ("sudo pacman -S tor iptables");
		system ("sudo cp .configs/arch-torrc \$HOME/.niperc");
	}

	system ("sudo chmod 644 \$HOME/.niperc");

	if (-e "/etc/init.d/tor") {
		$stopTor = "sudo /etc/init.d/tor stop > /dev/null";
	}
	
	system ($stopTor);

	return 1;
}

1;