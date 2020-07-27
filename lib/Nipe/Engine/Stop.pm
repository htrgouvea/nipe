package Nipe::Engine::Stop {
	use strict;
	use warnings;
	use Nipe::Utils::Device;

	sub new {
		my %device  = Nipe::Utils::Device -> new();
		my @table   = ("nat", "filter");

		foreach my $table (@table) {
			system ("iptables -t $table -F OUTPUT");
			system ("iptables -t $table -F OUTPUT");
		}

		system ($device{stopTor});

		return 1;
	}
}

1;
