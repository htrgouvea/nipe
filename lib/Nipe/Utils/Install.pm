package Nipe::Utils::Install {
	use strict;
	use warnings;
	use File::Basename qw(dirname);
	use File::Copy;
	use Nipe::Utils::Device;

	sub new {
		my %device  = Nipe::Utils::Device -> new();
		my $nipeTorConfig = "/etc/torrc.d/nipe";

		if (! -d dirname ($nipeTorConfig)) {
			mkdir dirname ($nipeTorConfig), 0700;
		}

		if (! -f $nipeTorConfig) {
			copy ("torrc.d/nipe", $nipeTorConfig) or die "Copy failed: $!";
		}

		if (! -d dirname ($nipeTorConfig)) {
			mkdir dirname ($nipeTorConfig), 0755;
		}

		open (FILE, "+<", "/etc/tor/torrc");
		if (not grep{ /^%include \/etc\/torrc\.d\/nipe$/ } <FILE>) {
			print FILE "%include /etc/torrc.d/nipe\n";
		}
		close FILE;

		# find out if AppArmor is enabled (returns Y if true)
		open FILE, "<", "/sys/module/apparmor/parameters/enabled";
		chomp(my $apparmor = <FILE>);
		close FILE;
		if ( $apparmor eq "Y" ) {
			open APPARMOR, ">", "/etc/apparmor.d/local/system_tor";
			print APPARMOR "/etc/torrc.d/nipe r,\n";
			close APPARMOR;
		}

		if ($device{distribution} eq "debian") {
			system ("apt-get install -y tor iptables");
		}

		elsif ($device{distribution} eq "fedora") {
			system ("dnf install -y tor iptables");
		}

		elsif ($device{distribution} eq "centos") {
			system ("yum -y install epel-release tor iptables");
		}

		elsif ($device{distribution} eq "void") {
			system ("xbps-install -y tor iptables");
		}

		elsif ($device{distribution} eq "arch") {
			system ("pacman -S --noconfirm tor iptables");
		}

		else {
			print STDERR "Unknown distribution.\n";
			print STDERR "Install tor and iptables using your package manager.\n";
			die;
		}

		system ($device{stopTor});

		return 1;
	}
}

1;
