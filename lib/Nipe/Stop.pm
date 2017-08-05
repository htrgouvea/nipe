#!/usr/bin/perl

package Nipe::Stop;

sub new {
	my @table = ("nat", "filter");

	foreach my $table (@table) {
		system ("sudo iptables -t $table -F OUTPUT");
		system ("sudo iptables -t $table -F OUTPUT");
	}
}

1;
