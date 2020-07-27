package Nipe::Utils::Install {
	use strict;
	use warnings;
	use File::Basename qw(dirname);
	use File::Copy;
	use Nipe::Utils::Device;

	sub new {
		my %device  = Nipe::Utils::Device -> new();
		my $stopTor = "systemctl stop tor";
		my $nipeTorConfig = "/etc/torrc.d/nipe";

		if (! -d dirname ($nipeTorConfig)) {
			mkdir dirname ($nipeTorConfig), 0700;
		}

		if (! -f $nipeTorConfig) {
			copy ("torrc.d/nipe", $nipeTorConfig) or die "Copy failed: $!";
		}

		open (FILE, "+<", "/etc/tor/torrc");
		if (not grep{ /^%include \/etc\/torrc\.d\/nipe$/ } <FILE>) {
			print FILE "%include /etc/torrc.d/nipe\n";
		}
		close FILE;

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
		}

		else {
			system ("pacman -S --noconfirm tor iptables");
		}

		system ($device{stopTor});

		return 1;
	}
}

1;
