package Nipe::Network::Install {
	use strict;
	use warnings;
	use Nipe::Component::Utils::Device;
	use Nipe::Component::Engine::Stop;

	our $VERSION = '0.0.4';

	sub new {
		my %device  = Nipe::Component::Utils::Device -> new();

		my %install = (
			debian    => 'apt-get install -y tor iptables',
			fedora    => 'dnf install -y tor iptables',
			centos    => 'yum -y install epel-release tor iptables',
			void      => 'xbps-install -y tor iptables',
			arch      => 'pacman -S --noconfirm tor iptables',
			opensuse  => 'zypper install -y tor iptables',
			darwin    => 'brew install tor',
		);

		system $install{$device{distribution}};

		my $stop = Nipe::Component::Engine::Stop -> new();

		if ($stop) {
			return 1;
		}

		return 0;
	}
}

1;