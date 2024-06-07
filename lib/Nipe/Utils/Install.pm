package Nipe::Utils::Install {
	use strict;
	use warnings;
	use Nipe::Utils::Device;

	sub new {
		my %device  = Nipe::Utils::Device -> new();
		
		my %install = (
			"debian" => "apt-get install -y tor iptables",
			"fedora" => "dnf install -y tor iptables",
			"centos" => "yum -y install epel-release tor iptables",
			"void"   => "xbps-install -y tor iptables",
			"arch"   => "pacman -S --noconfirm tor iptables",
			"opensuse" => "zypper install -y tor iptables"
		);

		system("$install{$device{distribution}}");

		my $stop = Nipe::Engine::Stop -> new();

		if ($stop) {
			return 1;
		}

		return 0;
	}
}

1;
