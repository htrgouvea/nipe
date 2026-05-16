package main;

our $VERSION = '0.001';

use strict;
use warnings;

use Test::More;
use Test::MockModule;

use lib 'lib';
use_ok('Nipe::Component::Utils::Device');

my %mock_params;
my $config_path;

my $config_mock = Test::MockModule->new('Config::Simple');
$config_mock->mock(
	'new',
	sub {
		my ($class, $path) = @_;
		$config_path = $path;

		return bless {}, 'Config::Simple';
	}
);
$config_mock->mock(
	'param',
	sub {
		my ($self, $name) = @_;

		return $mock_params{$name};
	}
);

subtest 'defaults to Debian settings for unknown distributions' => sub {
	plan tests => 2;

	%mock_params = (
		ID      => 'debian',
		ID_LIKE => q{},
	);
	$config_path = undef;

	my %device = Nipe::Component::Utils::Device->new();

	is($config_path, '/etc/os-release', 'reads the system os-release file');
	is_deeply(
		\%device,
		{
			username     => 'debian-tor',
			distribution => 'debian',
		},
		'returns the default Debian device settings'
	);
};

subtest 'maps Fedora-like systems to the Fedora Tor user' => sub {
	plan tests => 1;

	%mock_params = (
		ID      => 'nobara',
		ID_LIKE => 'fedora',
	);

	my %device = Nipe::Component::Utils::Device->new();

	is_deeply(
		\%device,
		{
			username     => 'toranon',
			distribution => 'fedora',
		},
		'returns Fedora-specific settings'
	);
};

subtest 'maps Arch systems from the ID field' => sub {
	plan tests => 1;

	%mock_params = (
		ID      => 'arch',
		ID_LIKE => q{},
	);

	my %device = Nipe::Component::Utils::Device->new();

	is_deeply(
		\%device,
		{
			username     => 'tor',
			distribution => 'arch',
		},
		'returns Arch-specific settings'
	);
};

subtest 'maps Void systems from the ID field' => sub {
	plan tests => 1;

	%mock_params = (
		ID      => 'void',
		ID_LIKE => q{},
	);

	my %device = Nipe::Component::Utils::Device->new();

	is_deeply(
		\%device,
		{
			username     => 'tor',
			distribution => 'void',
		},
		'returns Void-specific settings'
	);
};

subtest 'maps OpenSUSE systems from the ID_LIKE field' => sub {
	plan tests => 1;

	%mock_params = (
		ID      => 'tumbleweed',
		ID_LIKE => 'opensuse',
	);

	my %device = Nipe::Component::Utils::Device->new();

	is_deeply(
		\%device,
		{
			username     => 'tor',
			distribution => 'opensuse',
		},
		'returns OpenSUSE-specific settings'
	);
};

done_testing();

1;
