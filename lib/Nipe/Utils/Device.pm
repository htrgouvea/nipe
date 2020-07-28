package Nipe::Utils::Device {
	use strict;
	use warnings;
	use Config::Simple;

	sub new {
		my $config    = Config::Simple -> new("/etc/os-release");
		my $id_like   = $config -> param("ID_LIKE") || "";
		my $id_distro = $config -> param("ID");

		my %device = (
			"username" => "",
			"distribution"  => ""
		);

		if (($id_like =~ /[F,f]edora/) || ($id_distro =~ /[F,f]edora/)) {
			$device{username} = "toranon";
			$device{distribution} = "fedora";
		}

		elsif (($id_like =~ /[A,a]rch/) || ($id_like =~ /[C,c]entos/) || ($id_distro =~ /[A,a]rch/) || ($id_distro =~ /[C,c]entos/)) {
			$device{username} = "tor";
			$device{distribution} = "arch";
		}

		elsif ($id_distro =~ /[V,v]oid/) {
			$device{username} = "tor";
			$device{distribution} = "void";
		}

		else {
			$device{username} = "debian-tor";
			$device{distribution} = "debian";
		}

		return %device;
	}
}

1;
