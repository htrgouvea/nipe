package Nipe::Component::Engine::Start {
	use strict;
	use warnings;
	use Nipe::Component::Utils::Device;
	use Nipe::Component::Utils::Status;
    use Nipe::Component::Engine::Stop;

	our $VERSION = '0.0.5';

	sub new {
        my $stop          = Nipe::Component::Engine::Stop -> new();
		my %device        = Nipe::Component::Utils::Device -> new();
		my $dns_port      = '9061';
		my $transfer_port = '9051';
		my @table         = qw(nat filter);
		my $network       = '10.66.0.0/255.255.0.0';
		my $start_tor     = 'systemctl start tor';

		if ($device{distribution} eq 'void') {
			$start_tor = 'sv start tor > /dev/null';
		}

		elsif (-e '/etc/init.d/tor') {
			$start_tor = '/etc/init.d/tor start > /dev/null';
		}

		system "tor -f .configs/$device{distribution}-torrc > /dev/null";
		system $start_tor;

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
				$target = "REDIRECT --to-ports $dns_port";
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

		system 'iptables -t filter -A OUTPUT -p udp -j REJECT';
		system 'iptables -t filter -A OUTPUT -p icmp -j REJECT';

		system 'sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null';
		system 'sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null';

		my $status = Nipe::Component::Utils::Status -> new();

		if ($status =~ /true/sm) {
			return 1;
		}

		return $status;
	}
}

1;