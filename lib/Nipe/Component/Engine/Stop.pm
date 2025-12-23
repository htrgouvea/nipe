package Nipe::Component::Engine::Stop {
	use strict;
	use warnings;
	use Nipe::Component::Utils::Device;

	our $VERSION = '0.0.5';

	sub new {
		my %device  = Nipe::Component::Utils::Device -> new();
		my @table   = qw(nat filter);
		my $stop_tor = 'systemctl stop tor';

		if ($device{distribution} eq 'darwin') {
			# macOS: Disable pfctl and stop Tor
			system "pfctl -d 2>/dev/null";  # Disable packet filter
			system "rm -f /tmp/nipe-pf.conf 2>/dev/null";  # Remove pf config

			# Stop Tor service
			if (-e '/usr/local/bin/brew') {
				$stop_tor = 'brew services stop tor';
			} else {
				$stop_tor = 'killall -9 tor 2>/dev/null';
			}

			system $stop_tor;
			return 1;
		}
		elsif ($device{distribution} eq 'void') {
			$stop_tor = 'sv stop tor > /dev/null';
		}

		# Linux: Flush iptables rules
		foreach my $table (@table) {
			system "iptables -t $table -F OUTPUT";

			# Check if IPv6 is available
			my $ipv6_available = 0;
			if ($device{distribution} eq 'darwin') {
				# macOS: Check if IPv6 is configured
				my $ipv6_check = `ifconfig 2>/dev/null | grep -c inet6`;
				chomp($ipv6_check);
				$ipv6_available = $ipv6_check > 0;
			} else {
				# Linux: Check /proc/sys/net/ipv6
				$ipv6_available = -d '/proc/sys/net/ipv6';
			}

			if ($ipv6_available) {
				system "ip6tables -t $table -F OUTPUT";
			}
		}

		if ( -e '/etc/init.d/tor' ) {
			$stop_tor = '/etc/init.d/tor stop > /dev/null';
		}

		system $stop_tor;

		return 1;
	}
}

1;
