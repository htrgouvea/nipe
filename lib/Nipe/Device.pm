#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvêa                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2017 Heitor Gouvêa                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] SITE:         http://heitorgouvea.me              #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
# [+] TELEGRAM:     @GouveaHeitor                       #
#########################################################

package Nipe::Device;

my $operationalSystem = `cat /etc/os-release | grep 'ID' | cut -d '=' -f 2`;

sub getUsername {
	my $username;

	if ($operationalSystem =~ /[U,u]buntu/) {
		$username = "debian-tor";
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
	my $mySystem;

	if ($operationalSystem =~ /[U,u]buntu/) {
		$mySystem = "debian";
	}

	elsif ($operationalSystem =~ /[D,d]ebian/) {
		$mySystem = "debian";
	}

	elsif ($operationalSystem =~ /[F,f]edora/) {
		$mySystem = "fedora";
	}

	elsif ($operationalSystem =~ /[A,a]rch/) {
		$mySystem = "arch";
	}

	else {
		$mySystem = "debian";
	}

	return $mySystem;
}

1;
