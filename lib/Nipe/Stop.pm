package Nipe::Stop;

use strict;
use warnings;
use Nipe::Device;

sub new {

	system ("sudo iptables-restore < before_run.iptables");

	my %device    = Nipe::Device -> new();
	my $user      = $device{username};
	my $lock_file = "/var/run/nipe/instance.lock";

	chomp (my $pid = `sudo -u $user cat $lock_file 2>&1`);

	if ($? != 0) {
		print "[.] No instance of tor executed by Nipe was found\n";
	}

	else {
		system ("sudo -u $user kill -SIGINT $pid > /dev/null");
		system ("sudo -u $user rm -f $lock_file > /dev/null");
		print "[.] Tor instance with PID=$pid terminated\n";
	}
}

1;
