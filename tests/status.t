package main;

our $VERSION = '0.001';

use strict;
use warnings;

use Test::More;
use Test::MockModule;

use lib 'lib';
use_ok('Nipe::Component::Utils::Status');

my %mock_response;
my $requested_url;

my $http_mock = Test::MockModule->new('HTTP::Tiny');
$http_mock->mock(
	'new',
	sub {
		return bless {}, 'HTTP::Tiny';
	}
);
$http_mock->mock(
	'get',
	sub {
		my ($self, $url) = @_;
		$requested_url = $url;

		return {%mock_response};
	}
);

subtest 'returns tor-enabled status when the API reports Tor' => sub {
	plan tests => 2;

	%mock_response = (
		status  => 200,
		content => '{"IP":"203.0.113.10","IsTor":true}',
	);
	$requested_url = undef;

	my $result = Nipe::Component::Utils::Status->new();

	is($requested_url, 'https://check.torproject.org/api/ip', 'requests the Tor status API');
	is($result, "\n\r[+] Status: true \n\r[+] Ip: 203.0.113.10\n\n", 'returns the expected success payload');
};

subtest 'returns tor-disabled status when the API reports a non-Tor IP' => sub {
	plan tests => 1;

	%mock_response = (
		status  => 200,
		content => '{"IP":"198.51.100.7","IsTor":false}',
	);

	my $result = Nipe::Component::Utils::Status->new();

	is($result, "\n\r[+] Status: false \n\r[+] Ip: 198.51.100.7\n\n", 'marks the status as false');
};

subtest 'returns an error message when the API request fails' => sub {
	plan tests => 1;

	%mock_response = (
		status  => 500,
		content => q{},
	);

	my $result = Nipe::Component::Utils::Status->new();

	is(
		$result,
		"\n[!] ERROR: sorry, it was not possible to establish a connection to the server.\n\n",
		'returns the connection error message'
	);
};

done_testing();

1;
