package Nipe::Component::Engine::Stop {
	use strict;
	use warnings;
	use Nipe::Component::Utils::Device;

	our $VERSION = '0.0.2';

	sub new {
		my %device  = Nipe::Component::Utils::Device -> new();
		my @table   = qw(nat filter);
		my $stop_tor = 'systemctl stop tor';

		if ($device{distribution} eq 'void') {
			$stop_tor = 'sv stop tor > /dev/null';
		}

		foreach my $table (@table) {
			system "iptables -t $table -F OUTPUT";
			system "iptables -t $table -F OUTPUT";
		}

		if ( -e '/etc/init.d/tor' ) {
			$stop_tor = '/etc/init.d/tor stop > /dev/null';
		}

		system $stop_tor;

		return 1;
	}
}

1;