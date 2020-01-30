use strict;
use warnings;

package Nipe::Start;

use File::Which;
use Nipe::Device;

sub new {
	shift; # discard class name
	my $custom_cfg = shift;

	# "start" command may run without a prior "install" command, thus it's
	# better to check pkg dependency first
	if (not defined(which("tor"))) {
		die ("[!] Tor not installed. First run Nipe \"install\"\n");
	}

	if (not defined(which("iptables"))) {
		die ("[!] Iptables not installed. First run Nipe \"install\"\n");
	}

	my %parsed_cfg = callTor($custom_cfg);
	print "[.] Tor executed with success\n";
	callIptables(\%parsed_cfg);
	print "[.] Firewall rules set with success\n";
	print "[.] Nipe initialized with success\n";
}

# Due to non-standard ways to call tor throughout Linux distros from start
# scripts, we are going to handle that manually:
# 1. some distros has multi-instance support, while others don't. Because of
#    that, we are going to create our own support directly calling tor binary
# 2. tor default config is also placed in different places. Thus we are not
#    using them yet.
sub callTor {
	my $cfg = shift;

	if (not defined($cfg)) {
		$cfg = "/etc/tor/torrc"
	}

	# First, check if tor configuration is valid
	my $output = `sudo tor --runasdaemon 0 -f $cfg --verify-config`;
	if ($? != 0) {
		die "[!] Failed to load config $cfg\n$output";
	}

	print "[.] Config file looks fine\n";

	my %tor      = Nipe::Device -> parseTorConfig($cfg);
	my $user     = $tor{username};
	my $daemon   = $tor{is_daemon};
	my $pid_file = $tor{pid_file};

	# We can have different tor config files to choose, but we don't support
	# multiple instances of nipe running, otherwise iptable rules may conflict
	my $run_dir   = "/var/run/nipe";
	my $lock_file = "$run_dir/instance.lock";

	system ("sudo -u $user cat $lock_file &> /dev/null");
	if ($? == 0) {
		die "[!] Running instance of Nipe found, please stop it first\n";
	}

	system ("umask u=rwx,g=rx,o= ; sudo mkdir -p $run_dir");
	if ($? != 0) {
		die "[!] Failed to create $run_dir\n";
	}
	system ("sudo chown $user:$user $run_dir");

	# Then, run tor as a non-blocking daemon with a specific pidfile for
	# future reference when we need to terminate the process, thus we know the
	# exact tor instance that nipe created
	system ("sudo tor --runasdaemon $daemon --pidfile $pid_file -f $cfg");
	if ($? != 0) {
		die "[!] Failed to run tor\n";
	}

	# Set a system-wide "lock" file with the same user:group of tor
	system ("echo \"cat $pid_file > $lock_file\" | sudo -u $user -s");

	return %tor;
}

sub callIptables {
	my $tor          = shift;
	my $dnsPort      = $tor->{dns_port};
	my $transferPort = $tor->{trans_port};
	my $network      = $tor->{network};
	my $username     = $tor->{username};
	my @table        = ("nat", "filter");

	foreach my $table (@table) {
		my $target = "ACCEPT";

		if ($table eq "nat") {
			$target = "RETURN";
		}

		system ("sudo iptables -t $table -F OUTPUT");
		system ("sudo iptables -t $table -A OUTPUT -m state --state ESTABLISHED -j $target");
		system ("sudo iptables -t $table -A OUTPUT -m owner --uid $username -j $target");

		my $matchDnsPort = $dnsPort;

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $dnsPort";
			$matchDnsPort = "53";
		}

		system ("sudo iptables -t $table -A OUTPUT -p udp --dport $matchDnsPort -j $target");
		system ("sudo iptables -t $table -A OUTPUT -p tcp --dport $matchDnsPort -j $target");

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $transferPort";
		}

		system ("sudo iptables -t $table -A OUTPUT -d $network -p tcp -j $target");

		if ($table eq "nat") {
			$target = "RETURN";
		}

		system ("sudo iptables -t $table -A OUTPUT -d 127.0.0.1/8    -j $target");
		system ("sudo iptables -t $table -A OUTPUT -d 192.168.0.0/16 -j $target");
		system ("sudo iptables -t $table -A OUTPUT -d 172.16.0.0/12  -j $target");
		system ("sudo iptables -t $table -A OUTPUT -d 10.0.0.0/8     -j $target");

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $transferPort";
		}

		system ("sudo iptables -t $table -A OUTPUT -p tcp -j $target");
	}

	system ("sudo iptables -t filter -A OUTPUT -p udp -j REJECT");
	system ("sudo iptables -t filter -A OUTPUT -p icmp -j REJECT");
}

1;