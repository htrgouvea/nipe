#!/usr/bin/perl

#########################################################
# [+] AUTOR:        Heitor Gouvea                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/HeitorG          #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/viniciushgouvea      #
#########################################################

use strict;
use Switch;
use warnings;
use WWW::Mechanize;
use LWP::Protocol::https;

my $username;
my $command    = $ARGV[0];
my $dns_port   = "9061";
my $trans_port = "9051";
my $network    = "10.66.0.0/255.255.0.0";
my @table      = ("nat","filter");
my $os         = `cat /etc/*release | grep 'ID' | cut -d '=' -f 2`;

if    ($os =~ /[U,u]buntu/) { $username = "debian-tor"; }
elsif ($os =~ /[D,d]ebian/) { $username = "debian-tor"; }
elsif ($os =~ /[F,f]edora/) { $username = "debian-tor"; }
elsif ($os =~ /[A,a]rch/)   { $username = "debian-tor"; }
else  { $username = "tor"; }

print "\n\033[1;32m
88b 88   88   8888Yb  888888     Developed by 
88Yb88   88   88__dP  88__      Heitor Gouvea (D3LET)
88 Y88   88   88--    88--       
88  Y8   88   88      888888\n\033[1;37m\n";

sub help {
	print "\n\tCOMMAND \t FUCTION\n
	install \t To install.
	start   \t To start.
	stop    \t To stop.\n\n";
}

sub install {
	if (($os =~ /[U,u]buntu/) || ($os =~ /[D,d]ebian/)) {
		system ("sudo apt-get install tor");
		system ("sudo wget https://heitorgouvea.com/nipe/ubuntu/torrc");
	}

	elsif ($os =~ /[A,a]rch/) {
		system ("sudo pacman -S tor");
		system ("sudo wget https://heitorgouvea.com/nipe/arch/torrc");
	}

	elsif ($os =~ /[F,f]edora/) {
		system ("sudo dnf install tor");
		system ("sudo wget https://heitorgouvea.com/nipe/fedora/torrc");
	}

	else {
		system ("sudo apt-get install tor");
		system ("sudo wget https://heitorgouvea.com/nipe/ubuntu/torrc");
	}

	system ("sudo mkdir -p /etc/tor");
	system ("sudo mv torrc /etc/tor/torrc");
	system ("sudo chmod 644 /etc/tor/torrc");
	
	if (($os =~ /[U,u]buntu/) || ($os =~ /[D,d]ebian/) || ($os =~ /[F,f]edora/)) {
		system ("sudo service tor restart");
	}

	else {
		system ("sudo systemctl restart tor.service");
	}
}

sub tor_check {
	my $mech       = new WWW::Mechanize;
	my $tor_check  = "https://check.torproject.org/?lang=en";
	my $ip_check   = "https://wtfismyip.com/text";

	$mech -> get ("$tor_check");
	my $response_tor = $mech -> content (format => "text");

	$mech -> get ("$ip_check");
	my $response_ip = $mech -> content (format => "text");

	if ($response_tor =~ /Congratulations/) { 
		print "\nTor: Activated\nIp: $response_ip\n";
	}

	elsif ($response_tor =~ /Sorry/) {
		print "\nTor: Disabled\nIp: $response_ip\n";
	}

	else {
		print "\nError: sorry, it was not possible to establish a connection to the server.\n\n";
	}
}

sub start {
	foreach my $nipe(@table) {
		my $target = "ACCEPT";

		if ($nipe eq "nat") {
			$target = "RETURN";
		}

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

		if ($nipe eq "nat") {
			$target = "REDIRECT --to-ports $trans_port";
		}

		system ("sudo iptables -t $nipe -A OUTPUT -d $network -p tcp -j $target");

		if ($nipe eq "nat") {
			$target = "RETURN";
		}

		system ("sudo iptables -t $nipe -A OUTPUT -d 127.0.0.1/8    -j $target");
		system ("sudo iptables -t $nipe -A OUTPUT -d 192.168.0.0/16 -j $target");
		system ("sudo iptables -t $nipe -A OUTPUT -d 172.16.0.0/12  -j $target");
		system ("sudo iptables -t $nipe -A OUTPUT -d 10.0.0.0/8     -j $target");

		if ($nipe eq "nat") {
			$target = "REDIRECT --to-ports $trans_port";
		}

		system ("sudo iptables -t $nipe -A OUTPUT -p tcp -j $target");
	}

	system ("sudo iptables -t filter -A OUTPUT -p udp -j REJECT");
	system ("sudo iptables -t filter -A OUTPUT -p icmp -j REJECT");
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
