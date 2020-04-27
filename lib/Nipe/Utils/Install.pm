package Nipe::Utils::Install;

use strict;
use warnings;
use Nipe::Utils::Device;

sub new {
	my %device  = Nipe::Utils::Device -> new();
	my $stopTor = "sudo systemctl stop tor";

	if ($device{distribution} eq "debian") {
		system ("sudo apt-get install -y tor iptables");
	}
	
	elsif ($device{distribution} eq "fedora") {
		system ("sudo dnf install -y tor iptables");
	}

	elsif ($device{distribution} eq "centos") {
		system ("sudo yum -y install epel-release tor iptables");
	}

	else {
		system ("sudo pacman -S --noconfirm -S tor iptables");
	}

	if (-e "/etc/init.d/tor") {
		$stopTor = "sudo /etc/init.d/tor stop > /dev/null";
	}
	
	system ($stopTor);

	return 1;
}

1;