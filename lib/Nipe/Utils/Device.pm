package Nipe::Utils::Device {
	use strict;
	use warnings;
	use Config::Simple;

	our $VERSION = '0.0.1';

	sub new {
		my $config    = Config::Simple -> new("/etc/os-release");
		my $id_like   = $config -> param("ID_LIKE") || q{};
		my $id_distro = $config -> param("ID");

		my %device = (
			"username" => "debian-tor",
			"distribution" => "debian"
		);

		if (($id_like =~ /[F,f]edora/xsm) || ($id_distro =~ /[F,f]edora/xsm)) {
			$device{username} = "toranon";
			$device{distribution} = "fedora";
		}

		elsif (($id_like =~ /[A,a]rch/xsm) || ($id_like =~ /[C,c]entos/xsm) || ($id_distro =~ /[A,a]rch/xsm) || ($id_distro =~ /[C,c]entos/xsm)) {
			$device{username} = "tor";
			$device{distribution} = "arch";
		}

		elsif ($id_distro =~ /[V,v]oid/xsm) {
			$device{username} = "tor";
			$device{distribution} = "void";
		}

		elsif (($id_like =~ /[S,s]use/xsm) || ($id_distro =~ /[O,o]pen[S,s]use/xsm)) {
			$device{username} = "tor";
			$device{distribution} = "opensuse";
		}

		return %device;
	}
}

1;