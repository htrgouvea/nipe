#!/usr/bin/env perl

package Nipe::Install;

use Nipe::Device;

sub new {
	shift; # ignore class name
	
	my ($force_cfg, $custom_cfg) = @_;
	my $tor_cfg = "/etc/tor/torrc";

	my %device = Nipe::Device -> new();

	if ($device{distribution} eq "debian") {
		system ("sudo apt-get install tor iptables");
	}
	
	elsif ($device{distribution} eq "fedora") {
		system ("sudo dnf install tor iptables");
	}

	elsif ($device{distribution} eq "centos") {
		system ("sudo yum install epel-release tor iptables");
	}

	else {
		system ("sudo pacman -S tor iptables");
	}

	if (defined($force_cfg)) {
		if (defined($custom_cfg)) {
			$tor_cfg = $custom_cfg;
			print "[.] Writing Nipe's custom Tor config file\n";
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

	if (-e "/etc/init.d/tor") {
		system ("sudo /etc/init.d/tor stop > /dev/null");
	}

	else {
		system ("sudo systemctl stop tor");
	}

	return true;
}

1;