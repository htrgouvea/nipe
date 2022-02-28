package Nipe::Engine::Start {
	use strict;
	use warnings;
	use Nipe::Utils::Device;

    sub get_subnets {
        my @nets = `ip a s` =~ /inet +(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d+)/ig;
        return @nets if @nets > 0;
        while (`ifconfig` =~ /inet +([^ ]+) +netmask +([^ ]+)/ig) {
            my ($ip, $mask) = ($1, $2);
            my $bin = join '', map { sprintf "%b", $_ } split /\./, $mask;
            $mask = length($bin =~ s/0+$//r);
            push @nets, "$ip/$mask";
        }
        @nets
    }

	sub new {
		my %device       = Nipe::Utils::Device -> new();
		my $dnsPort      = "9061";
		my $transferPort = "9051";
		my @table        = ("nat", "filter");
		my $startTor     = "systemctl start tor";

		if ($device{distribution} eq "void") {
			$startTor = "sv start tor > /dev/null";
		}

		elsif (-e "/etc/init.d/tor") {
			$startTor = "/etc/init.d/tor start > /dev/null";
		}

		system ("tor -f .configs/$device{distribution}-torrc > /dev/null");
		system ($startTor);

        my @subnets = get_subnets();

		foreach my $table (@table) {
			my $target = "ACCEPT";

			if ($table eq "nat") {
				$target = "RETURN";
			}

			system ("iptables -t $table -F OUTPUT");
			system ("iptables -t $table -A OUTPUT -m state --state ESTABLISHED -j $target");
			system ("iptables -t $table -A OUTPUT -m owner --uid $device{username} -j $target");

			my $matchDnsPort = $dnsPort;

			if ($table eq "nat") {
				$target = "REDIRECT --to-ports $dnsPort";
				$matchDnsPort = "53";
			}

			system ("iptables -t $table -A OUTPUT -p udp --dport $matchDnsPort -j $target");
			system ("iptables -t $table -A OUTPUT -p tcp --dport $matchDnsPort -j $target");

			if ($table eq "nat") {
				$target = "REDIRECT --to-ports $transferPort";
			}

			if ($table eq "nat") {
				$target = "RETURN";
			}

            system ("iptables -t $table -A OUTPUT -d $_ -j $target") for @subnets;

			if ($table eq "nat") {
				$target = "REDIRECT --to-ports $transferPort";
			}

			system ("iptables -t $table -A OUTPUT -p tcp -j $target");
		}

        # disable IPv6
        system("sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null");
        system("sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null");

		return 1;
	}
}

1;
