package Nipe::Component::Utils::Device {
	use strict;
	use warnings;
	use Config::Simple;

	our $VERSION = '0.0.5';

	sub new {
		# Check if running on macOS/Darwin
		my $uname = `uname -s 2>/dev/null` || q{};
		chomp($uname);

		if ($uname eq 'Darwin') {
			my %device = (
				'username'     => '_tor',
				'distribution' => 'darwin'
			);
			return %device;
		}

		# For Linux systems, read /etc/os-release
		my $config    = Config::Simple -> new('/etc/os-release');
		my $id_like   = $config -> param('ID_LIKE') || q{};
		my $id_distro = $config -> param('ID');

		my %device = (
			'username'     => 'debian-tor',
			'distribution' => 'debian'
		);

		my @distributions = (
			{
				pattern      => qr/[F,f]edora/xsm,
				username     => 'toranon',
				distribution => 'fedora',
			},
			{
				pattern      => qr/[A,a]rch|[C,c]entos/xsm,
				username     => 'tor',
				distribution => 'arch',
			},
			{
				pattern      => qr/[V,v]oid/xsm,
				username     => 'tor',
				distribution => 'void',
			},
			{
				pattern      => qr/[S,s]use|[O,o]pen[S,s]use/xsm,
				username     => 'tor',
				distribution => 'opensuse',
			},
		);

		for my $distro (@distributions) {
			if (($id_like =~ $distro -> {pattern}) || ($id_distro =~ $distro -> {pattern})) {
				$device{username}     = $distro -> {username};
				$device{distribution} = $distro -> {distribution};

				last;
			}
		}

		return %device;
	}
}

1;