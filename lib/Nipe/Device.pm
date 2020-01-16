#!/usr/bin/env perl

package Nipe::Device;

use Config::Simple;

sub new {
	my $config    = Config::Simple -> new('/etc/os-release');
	my $id_like   = $config -> param('ID_LIKE');
	my $id_distro = $config -> param('ID');

	my %device = (
		"Username" => "",
        "Distribution"  => ""
    );
	
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

1;