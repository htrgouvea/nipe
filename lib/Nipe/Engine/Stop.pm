package Nipe::Engine::Stop {
	use strict;
	use warnings;
	use Nipe::Utils::Device;

	sub new {
		my %device  = Nipe::Utils::Device -> new();
		my @table   = ("nat", "filter");
		my $stopTor = "systemctl stop tor";

		if ($device{distribution} eq "void") {
			$stopTor = "sv stop tor > /dev/null";
		}

		foreach my $table (@table) {
			system ("iptables -t $table -F OUTPUT");
			system ("iptables -t $table -F OUTPUT");
		}

		if (-e "/etc/init.d/tor") {
			$stopTor = "/etc/init.d/tor stop > /dev/null";
		}

		system ($stopTor);

		return 1;
	}
}

1;
