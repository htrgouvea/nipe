#!/usr/bin/perl

#########################################################
# Nipe developed by Heitor Gouvea                       #
# This work is licensed under MIT License               #
# Copyright (c) 2015-2016 Heitor Gouvea                 #
#                                                       #
# [+] AUTOR:        Heitor Gouvea                       #
# [+] EMAIL:        hi@heitorgouvea.me                  #
# [+] GITHUB:       https://github.com/GouveaHeitor     #
# [+] TWITTER:      https://twitter.com/GouveaHeitor    #
# [+] FACEBOOK:     https://fb.com/GouveaHeitor         #
#########################################################

package Nipe::Stop;

sub new {
	my @table = ("nat","filter");

	foreach my $table (@table) {
		system ("sudo iptables -t $table -F OUTPUT");
		system ("sudo iptables -t $table -F OUTPUT");	
	}
	
	Nipe::Check -> new;
}

1;