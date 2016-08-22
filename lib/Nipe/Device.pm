#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvêa                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2016 Heitor Gouvêa                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvêa                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Nipe::Device;

my $os = `cat /etc/os-release | grep 'ID' | cut -d '=' -f 2`;

sub username {
	my $username;

	if ($os =~ /[U,u]buntu/) {
		$username = "debian-tor";
	}

	elsif ($os =~ /[D,d]ebian/) {
		$username = "debian-tor";
	}
	
	elsif ($os =~ /[F,f]edora/) {
		$username = "toranon";
	}
	
	elsif ($os =~ /[A,a]rch/) {
		$username = "tor";
	}
	
	else {
		$username = "tor";
	}
}

1;