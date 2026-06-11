package Nipe::Component::Utils::Device {
	use strict;
	use warnings;
	use Config::Simple;

	our $VERSION = '0.0.5';

	sub new {
		my $config    = Config::Simple -> new('/etc/os-release');
		my $id_like   = $config -> param('ID_LIKE') || q{};
		my $id_distro = $config -> param('ID')      || q{};

		my @distributions = (
			{ pattern => qr/[Ff]edora/xsm,                  username => 'toranon', distribution => 'fedora'   },
			{ pattern => qr/[Cc]entos|[Rr]hel|[Rr]ocky/xsm, username => 'tor',     distribution => 'centos'   },
			{ pattern => qr/[Aa]rch|[Mm]anjaro/xsm,         username => 'tor',     distribution => 'arch'     },
			{ pattern => qr/[Vv]oid/xsm,                    username => 'tor',     distribution => 'void'     },
			{ pattern => qr/[Ss]use/xsm,                    username => 'tor',     distribution => 'opensuse' },
		);

		foreach my $source ($id_distro, $id_like) {
			foreach my $distro (@distributions) {
				if ($source =~ $distro -> {pattern}) {
					return (
						username     => $distro -> {username},
						distribution => $distro -> {distribution},
					);
				}
			}
		}

		return (username => 'debian-tor', distribution => 'debian');
	}
}

1;
