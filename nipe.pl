#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvea                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2016 Heitor Gouvea                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvea                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/HeitorG          #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/viniciushgouvea      #
#########################################################

use strict;
use Switch;
use warnings;
use Mojo::UserAgent;

my $username;
my $command    = $ARGV[0];
my $dns_port   = "9061";
my $trans_port = "9051";
my @table      = ("nat","filter");
my $network    = "10.66.0.0/255.255.0.0";
my $api_check   = "https://check.torproject.org/api/ip";
my $os         = `cat /etc/*release | grep 'ID' | cut -d '=' -f 2`;

if    ($os =~ /[U,u]buntu/) { $username = "debian-tor"; }
elsif ($os =~ /[D,d]ebian/) { $username = "debian-tor"; }
elsif ($os =~ /[F,f]edora/) { $username = "toranon"; }
elsif ($os =~ /[A,a]rch/)   { $username = "tor"; }
else  { $username = "tor"; }

print "\n\033[1;32m
88b 88   88   8888Yb  888888     
88Yb88   88   88__dP  88__    Developed by 
88 Y88   88   88--    88--    Heitor Gouvea (D3LET)  
88  Y8   88   88      888888\n\033[1;37m\n";

sub help {
	print "\n\tCOMMAND \t FUCTION\n
	install \t to install
	start   \t to start
	stop    \t to stop\n\n";
}

sub install {
	if (($os =~ /[U,u]buntu/) || ($os =~ /[D,d]ebian/)) {
		system ("sudo apt-get install tor");
		system ("sudo wget http://heitorgouvea.me/nipe/ubuntu/torrc");
	}

	elsif ($os =~ /[A,a]rch/) {
		system ("sudo pacman -S tor");
		system ("sudo wget http://heitorgouvea.me/nipe/arch/torrc");
	}

	elsif ($os =~ /[F,f]edora/) {
		system ("sudo dnf install tor");
		system ("sudo wget http://heitorgouvea.me/nipe/fedora/torrc");
	}

	else {
		system ("sudo pacman -S tor");
		system ("sudo wget http://heitorgouvea.me/nipe/arch/torrc");
	}

	system ("sudo mkdir -p /etc/tor");
	system ("sudo mv torrc /etc/tor/torrc");
	system ("sudo chmod 644 /etc/tor/torrc");
}

sub tor_check {
	my $ua = new Mojo::UserAgent;

	my $check_ip  = $ua -> get ($api_check) -> res -> json('/IP');
	my $check_tor = $ua -> get ($api_check) -> res -> json('/IsTor');

	if ($check_tor =~ /1/) { 
		print "\nTor: Activated\nIp: $check_ip\n";
	}

	elsif ($check_tor =~ /0/) {
		print "\nTor: Disabled\nIp: $check_ip\n";
	}

	else { print "\nError: sorry, it was not possible to establish a connection to the server.\n\n"; }
}

sub start {
	foreach my $nipe(@table) {
		my $target = "ACCEPT";

		if ($nipe eq "nat") { $target = "RETURN"; }

		system ("sudo iptables -t $nipe -F OUTPUT");
		system ("sudo iptables -t $nipe -A OUTPUT -m state --state ESTABLISHED -j $target");
		system ("sudo iptables -t $nipe -A OUTPUT -m owner --uid $username -j $target");

		my $match_dns_port = $dns_port;

		if ($nipe eq "nat") {
			$target = "REDIRECT --to-ports $dns_port";
			$match_dns_port = "53";
		}

		system ("sudo iptables -t $nipe -A OUTPUT -p udp --dport $match_dns_port -j $target");
		system ("sudo iptables -t $nipe -A OUTPUT -p tcp --dport $match_dns_port -j $target");

		if ($nipe eq "nat") { $target = "REDIRECT --to-ports $trans_port"; }

		system ("sudo iptables -t $nipe -A OUTPUT -d $network -p tcp -j $target");

		if ($nipe eq "nat") { $target = "RETURN"; }

		system ("sudo iptables -t $nipe -A OUTPUT -d 127.0.0.1/8    -j $target");
		system ("sudo iptables -t $nipe -A OUTPUT -d 192.168.0.0/16 -j $target");
		system ("sudo iptables -t $nipe -A OUTPUT -d 172.16.0.0/12  -j $target");
		system ("sudo iptables -t $nipe -A OUTPUT -d 10.0.0.0/8     -j $target");

		if ($nipe eq "nat") { $target = "REDIRECT --to-ports $trans_port"; }

		system ("sudo iptables -t $nipe -A OUTPUT -p tcp -j $target");
	}

	system ("sudo iptables -t filter -A OUTPUT -p udp -j REJECT");
	system ("sudo iptables -t filter -A OUTPUT -p icmp -j REJECT");

	if (($os =~ /[U,u]buntu/) || ($os =~ /[D,d]ebian/)) {
		system ("sudo service tor restart");
	}
	
	elsif (($os =~ /[A,a]rch/) || ($os =~ /[F,f]edora/)) {
		system ("sudo systemctl restart tor.service");
	}
	
	else { system ("sudo systemctl restart tor.service"); }
	tor_check();
}

sub stop {
	system ("sudo iptables -t nat -F OUTPUT");
	system ("sudo iptables -t filter -F OUTPUT");
	tor_check();
}

switch ($command) {
	case "install" { install(); }
	case "start"   { start(); }
	case "stop"    { stop(); }
	else           { help(); }
}
