package Nipe::Install;

use strict;
use warnings;
use File::Which;
use Nipe::Device;

sub new {
	shift;
	
	my ($force_cfg, $custom_cfg) = @_;

	my $tor_cfg = "/etc/tor/torrc";

	my %device = Nipe::Device -> new();

	if ($device{distribution} eq "debian") {
		system ("sudo apt-get -y install tor iptables");
	}
	
	elsif ($device{distribution} eq "fedora") {
		system ("sudo dnf -y install tor iptables");
	}

	elsif ($device{distribution} eq "centos") {
		system ("sudo yum -y install epel-release tor iptables");
	}

	else {
		system ("sudo pacman --noconfirm -S tor iptables");
	}

	if (not defined(which("tor"))) {
		die ("[!] tor was not correctly installed\n");
	}

	if (not defined(which("iptables"))) {
		die ("[!] iptables was not correctly installed\n");
	}

	if (defined($force_cfg)) {
        if ( -e $tor_cfg) {
            system ("sudo mv /etc/tor/torrc /etc/tor/torrc.bak");
            print "[.] Backup your Tor config file to /etc/tor/torrc.bak\n";
        }
		if (defined($custom_cfg)) {
			$tor_cfg = $custom_cfg;
			print "[.] Writing Nipe's custom Tor config file\n";
            system ("sudo cp ")
		}

		else {
			print "[.] Overwriting system Tor's config file\n";
		}

		print "[.]   .configs/$device{distribution}-torrc -> $tor_cfg\n";
		system ("sudo cp .configs/$device{distribution}-torrc $tor_cfg");
		system ("sudo chmod 644 $tor_cfg");
	}

	else {
		print "[.] Refer to our custom Tor config files in project home\n";
	}
}

1;
