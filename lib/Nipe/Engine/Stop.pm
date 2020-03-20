package Nipe::Engine::Stop;

use strict;
use warnings;

sub new {
	my @table   = ("nat", "filter");
	my $stopTor = "sudo systemctl stop tor";

	foreach my $table (@table) {
		system ("sudo iptables -t $table -F OUTPUT");
		system ("sudo iptables -t $table -F OUTPUT");
	}

	if (-e "/etc/init.d/tor") {
		$stopTor = "sudo /etc/init.d/tor stop > /dev/null";
	}

	system ($stopTor);

	return 1;
}

1;