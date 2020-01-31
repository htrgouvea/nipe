package Nipe::Device;

use strict;
use warnings;
use Config::Simple;

sub new {
	my %device = (
		"username" => "",
		"distribution"  => ""
	);

	my $config = new Config::Simple();
	$config -> read('/etc/os-release') or die $config -> error();

	my $id_like   = $config -> param('ID_LIKE') // "";
	my $id_distro = $config -> param('ID');

	if (($id_like =~ /[F,f]edora/) || ($id_distro =~ /[F,f]edora/)) {
		$device{username} = "toranon";
		$device{distribution} = "fedora";
	}
	
	elsif (($id_like =~ /[A,a]rch/) || ($id_distro =~ /[A,a]rch/)) {
		$device{username} = "tor";
		$device{distribution} = "arch";
	}

	else {
		$device{username} = "debian-tor";
		$device{distribution} = "debian";
	}

	return %device;
}

sub parseTorConfig {
	shift;

	my $cfg_file = shift;
	my %device   = new();

	if (not defined($cfg_file)) {
		$cfg_file = "/etc/tor/torrc";
	}

	my $config = new Config::Simple();

	$config -> read($cfg_file) or die $config -> error();

	my %tor_config = (
		"username"   => $config -> param('User') // $device{username},
		"is_daemon"  => $config -> param('RunAsDaemon') // 1,
		"pid_file"   => $config -> param('PidFile') // ".nipe_tor.pid",
		"trans_port" => $config -> param('TransPort') // 9051,
		"dns_port"   => $config -> param('DNSPort') // 9061,
		"network"    => $config -> param('VirtualAddrNetwork') // "10.66.0.0/255.255.0.0"
	);

	return %tor_config;
}

1;