#!/usr/bin/env perl

package Nipe::Start;

use Nipe::Device;

sub new {
	my $dnsPort      = "9061";
	my $transferPort = "9051";
	my @table        = ("nat", "filter");
	my $network      = "10.66.0.0/255.255.0.0";

	my $username = Nipe::Device -> getUsername();

	if (-e "/etc/init.d/tor") {
		system ("sudo /etc/init.d/tor start > /dev/null");
	}

	else {
		system ("sudo systemctl start tor");
	}
	
	foreach my $table (@table) {
		my $target = "ACCEPT";

		if ($table eq "nat") {
			$target = "RETURN";
		}

		system ("sudo iptables -t $table -F OUTPUT");
		system ("sudo iptables -t $table -A OUTPUT -m state --state ESTABLISHED -j $target");
		system ("sudo iptables -t $table -A OUTPUT -m owner --uid $username -j $target");

		my $matchDnsPort = $dnsPort;

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $dnsPort";
			$matchDnsPort = "53";
		}

		system ("sudo iptables -t $table -A OUTPUT -p udp --dport $matchDnsPort -j $target");
		system ("sudo iptables -t $table -A OUTPUT -p tcp --dport $matchDnsPort -j $target");

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $transferPort";
		}

		system ("sudo iptables -t $table -A OUTPUT -d $network -p tcp -j $target");

		if ($table eq "nat") {
			$target = "RETURN";
		}

		system ("sudo iptables -t $table -A OUTPUT -d 127.0.0.1/8    -j $target");
		system ("sudo iptables -t $table -A OUTPUT -d 192.168.0.0/16 -j $target");
		system ("sudo iptables -t $table -A OUTPUT -d 172.16.0.0/12  -j $target");
		system ("sudo iptables -t $table -A OUTPUT -d 10.0.0.0/8     -j $target");

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $transferPort";
		}

		system ("sudo iptables -t $table -A OUTPUT -p tcp -j $target");
	}

	system ("sudo iptables -t filter -A OUTPUT -p udp -j REJECT");
	system ("sudo iptables -t filter -A OUTPUT -p icmp -j REJECT");

	return true;
}

1;