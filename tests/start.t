package main;

our $VERSION = '0.001';

use strict;
use warnings;

use Test::More;
use Test::MockModule;
use Readonly;

use lib 'lib';
use_ok('Nipe::Component::Engine::Start');

Readonly my $RETRY_BUDGET => 45;

my @status_responses;
my $status_calls = 0;
my @system_calls;

my $stop_mock = Test::MockModule->new('Nipe::Component::Engine::Stop');
$stop_mock->mock('new', sub { return 1; });

my $device_mock = Test::MockModule->new('Nipe::Component::Utils::Device');
$device_mock->mock(
	'new',
	sub {
		return (
			username     => 'debian-tor',
			distribution => 'debian',
		);
	}
);

my $status_mock = Test::MockModule->new('Nipe::Component::Utils::Status');
$status_mock->mock(
	'new',
	sub {
		$status_calls++;
		return shift @status_responses;
	}
);

my $start_mock = Test::MockModule->new('Nipe::Component::Engine::Start');
$start_mock->mock(
	'_run_command',
	sub {
		push @system_calls, $_[0];
		return 0;
	}
);
$start_mock->mock(
	'_pause',
	sub {
		return 0;
	}
);

subtest 'retries status checks until Tor becomes ready' => sub {
	plan tests => 3;

	@status_responses = (
		"\n[!] ERROR: sorry, it was not possible to establish a connection to the server.\n\n",
		"\n\r[+] Status: true \n\r[+] Ip: 203.0.113.10\n\n",
	);
	$status_calls = 0;
	@system_calls = ();

	my $result = Nipe::Component::Engine::Start->new();

	is($result, 1, 'returns success once a later status check reports Tor');
	is($status_calls, 2, 'retries status until Tor is ready');
	ok(scalar @system_calls > 0, 'runs startup commands before checking status');
};

subtest 'returns the last status payload after exhausting retries' => sub {
	plan tests => 2;

	my $error = "\n[!] ERROR: sorry, it was not possible to establish a connection to the server.\n\n";
	@status_responses = (($error) x $RETRY_BUDGET);
	$status_calls = 0;

	my $result = Nipe::Component::Engine::Start->new();

	is($result, $error, 'returns the final failure status after all retries');
	is($status_calls, $RETRY_BUDGET, 'uses the configured retry budget');
};

done_testing();

1;
