package Nipe::Component::Engine::Start {
	use strict;
	use warnings;
	use FindBin;
	use Nipe::Component::Utils::Device;
	use Nipe::Component::Utils::Status;

	our $VERSION = '0.0.8';

	sub new {
		my %device        = Nipe::Component::Utils::Device -> new();
		my $dns_port      = '9061';
		my $transfer_port = '9051';
		my @table         = qw(nat filter);
		my $network       = '10.66.0.0/255.255.0.0';
		my $torrc         = "$FindBin::RealBin/.configs/$device{distribution}-torrc";

		system q{pkill -f '[.]configs/.*-torrc' 2>/dev/null};

		system 'mkdir -p /run/nipe';

		if (! -e '/run/nipe/iptables.rules') {
			system 'iptables-save > /run/nipe/iptables.rules';
			system 'ip6tables-save > /run/nipe/ip6tables.rules 2>/dev/null';
		}

		system 'mkdir -p /run/tor /var/log/tor /var/lib/tor';
		system "chown $device{username}:$device{username} /run/tor /var/log/tor /var/lib/tor";
		system 'chmod 700 /run/tor';

		foreach my $table (@table) {
			my $target = 'ACCEPT';

			if ($table eq 'nat') {
				$target = 'RETURN';
			}

			system "iptables -t $table -F OUTPUT";
			system "iptables -t $table -A OUTPUT -m state --state ESTABLISHED -j $target";
			system "iptables -t $table -A OUTPUT -m owner --uid $device{username} -j $target";

			my $match_dns_port = $dns_port;

			if ($table eq 'nat') {
				$target         = "REDIRECT --to-ports $dns_port";
				$match_dns_port = '53';
			}

			system "iptables -t $table -A OUTPUT -p udp --dport $match_dns_port -j $target";
			system "iptables -t $table -A OUTPUT -p tcp --dport $match_dns_port -j $target";

			if ($table eq 'nat') {
				$target = "REDIRECT --to-ports $transfer_port";
			}

			system "iptables -t $table -A OUTPUT -d $network -p tcp -j $target";

			if ($table eq 'nat') {
				$target = 'RETURN';
			}

			system "iptables -t $table -A OUTPUT -d 127.0.0.1/8    -j $target";
			system "iptables -t $table -A OUTPUT -d 192.168.0.0/16 -j $target";
			system "iptables -t $table -A OUTPUT -d 172.16.0.0/12  -j $target";
			system "iptables -t $table -A OUTPUT -d 10.0.0.0/8     -j $target";

			if ($table eq 'nat') {
				$target = "REDIRECT --to-ports $transfer_port";
			}

			system "iptables -t $table -A OUTPUT -p tcp -j $target";
		}

		system 'iptables -t filter -A OUTPUT -j REJECT';

		if (-d '/proc/sys/net/ipv6') {
			system 'ip6tables -t nat -F OUTPUT';
			system 'ip6tables -t filter -F OUTPUT';
			system 'ip6tables -t filter -A OUTPUT -o lo -j ACCEPT';
			system 'ip6tables -t filter -A OUTPUT -j REJECT';
		}

		system 'conntrack -F > /dev/null 2>&1';

		system "tor -f $torrc > /dev/null";

		my $status = Nipe::Component::Utils::Status -> new();

		if ($status =~ /true/sm) {
			return 1;
		}

		return $status;
	}
}

1;
