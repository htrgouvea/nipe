package Nipe::Component::Engine::Stop {
	use strict;
	use warnings;

	our $VERSION = '0.0.5';

	sub new {
		my @table = qw(nat filter);

		system q{pkill -f '[.]configs/.*-torrc' 2>/dev/null};

		foreach my $table (@table) {
			system "iptables -t $table -F OUTPUT";
			system "ip6tables -t $table -F OUTPUT 2>/dev/null";
		}

		if (-s '/run/nipe/iptables.rules') {
			system 'iptables-restore < /run/nipe/iptables.rules';
		}

		if (-s '/run/nipe/ip6tables.rules') {
			system 'ip6tables-restore < /run/nipe/ip6tables.rules 2>/dev/null';
		}

		system 'rm -f /run/nipe/iptables.rules /run/nipe/ip6tables.rules';

		return 1;
	}
}

1;
