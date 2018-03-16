#!/usr/bin/perl

package Nipe::Device;

my $operationalSystem = `cat /etc/os-release | grep 'ID_LIKE' | cut -d '=' -f 2`;

sub getUsername {
	my $username;

	if ($operationalSystem =~ /[U,u]buntu/) {
		$username = "tor";
	}

	elsif ($operationalSystem =~ /[D,d]ebian/) {
		$username = "debian-tor";
	}

	elsif ($operationalSystem =~ /[F,f]edora/) {
		$username = "toranon";
	}

	elsif ($operationalSystem =~ /[A,a]rch/) {
		$username = "tor";
	}

	else {
		$username = "tor";
	}

	return $username;
}

sub getSystem {
	my $distribution;

	if ($operationalSystem =~ /[U,u]buntu/) {
		$distribution = "debian";
	}

	elsif ($operationalSystem =~ /[D,d]ebian/) {
		$distribution = "debian";
	}

	elsif ($operationalSystem =~ /[F,f]edora/) {
		$distribution = "fedora";
	}

	elsif ($operationalSystem =~ /[A,a]rch/) {
		$distribution = "arch";
	}

	else {
		$distribution = "debian";
	}

	return $distribution;
}

1;
