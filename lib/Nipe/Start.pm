#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvêa                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2017 Heitor Gouvêa                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hgouvea@protonmail.com              #
# [+] SITE:         http://heitorgouvea.me              #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
# [+] TELEGRAM:     @GouveaHeitor                       #
#########################################################

package Nipe::Start;

use Nipe::Device;
use Nipe::CheckIp;

sub new {
	my $dns_port   = "9061";
	my $trans_port = "9051";
	my @table      = ("nat", "filter");
	my $network    = "10.66.0.0/255.255.0.0";

	my $username = Nipe::Device -> getUsername();

	foreach my $table (@table) {
		my $target = "ACCEPT";

		if ($table eq "nat") {
			$target = "RETURN";
		}

		system ("sudo iptables -t $table -F OUTPUT");
		system ("sudo iptables -t $table -A OUTPUT -m state --state ESTABLISHED -j $target");
		system ("sudo iptables -t $table -A OUTPUT -m owner --uid $username -j $target");

		my $match_dns_port = $dns_port;

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $dns_port";
			$match_dns_port = "53";
		}

		system ("sudo iptables -t $table -A OUTPUT -p udp --dport $match_dns_port -j $target");
		system ("sudo iptables -t $table -A OUTPUT -p tcp --dport $match_dns_port -j $target");

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $trans_port";
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
			$target = "REDIRECT --to-ports $trans_port";
		}

		system ("sudo iptables -t $table -A OUTPUT -p tcp -j $target");
	}

	system ("sudo iptables -t filter -A OUTPUT -p udp -j REJECT");
	system ("sudo iptables -t filter -A OUTPUT -p icmp -j REJECT");

	Nipe::CheckIp -> new();
}

1;
