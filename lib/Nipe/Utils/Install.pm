package Nipe::Utils::Install {
	use strict;
	use warnings;
	use Nipe::Utils::Device;

	sub new {
		my %device  = Nipe::Utils::Device -> new();
		my $stopTor = "systemctl stop tor";

		if ($device{distribution} eq "debian") {
			system ("apt-get install -y tor iptables");
		}

		elsif ($device{distribution} eq "fedora") {
			system ("dnf install -y tor iptables");
		}

		elsif ($device{distribution} eq "centos") {
			system ("yum -y install epel-release tor iptables");
		}

		elsif ($device{distribution} eq "void") {
			system ("xbps-install -y tor iptables");
			$stopTor = "sv stop tor > /dev/null";
		}

		else {
			system ("pacman -S --noconfirm tor iptables");
		}

		if (-e "/etc/init.d/tor") {
			$stopTor = "/etc/init.d/tor stop > /dev/null";
		}

		system ($stopTor);

		return 1;
	}
}

1;
