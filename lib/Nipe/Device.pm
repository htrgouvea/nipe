#!/usr/bin/env perl

package Nipe::Device;

use Config::Simple;

my $config    = Config::Simple -> new('/etc/os-release');
my $id_like   = $config -> param('ID_LIKE');
my $id_distro = $config -> param('ID');

sub getUsername {
	my $username;
	
	if (($id_like =~ /[F,f]edora/) || ($id_distro =~ /[F,f]edora/)) {
		$username = "toranon";
	}
	
	elsif (($id_like =~ /[A,a]rch/) || ($id_like =~ /[C,c]entos/) || ($id_distro =~ /[A,a]rch/) || ($id_distro =~ /[C,c]entos/)) {
		$username = "tor";
	}

	else {
		$username = "debian-tor";
	}

	return $username;
}

sub getSystem {
	my $distribution;

	if (($id_like =~ /[F,f]edora/) || ($id_distro =~ /[F,f]edora/)) {
		$distribution = "fedora";
	}

	elsif (($id_like =~ /[A,a]rch/) || ($id_distro =~ /[A,a]rch/)) {
		$distribution = "arch";
	}

	elsif (($id_like =~ /[C,c]entos/) || ($id_distro =~ /[C,c]entos/)) {
		$distribution = "centos"
	}

	else {
		$distribution = "debian";
	}

	return $distribution;
}

1;