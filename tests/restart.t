package main;

our $VERSION = '0.001';

use strict;
use warnings;

use Test::More;
use Test::MockModule;

use lib 'lib';
use_ok('Nipe::Network::Restart');

my @sequence;
my $stop_result  = 1;
my $start_result = 1;

my $stop_mock = Test::MockModule -> new('Nipe::Component::Engine::Stop');
$stop_mock -> mock(
    'new',
    sub {
        push @sequence, 'stop';

        return $stop_result;
    }
);

my $start_mock = Test::MockModule -> new('Nipe::Component::Engine::Start');
$start_mock -> mock(
    'new',
    sub {
        push @sequence, 'start';

        return $start_result;
    }
);

sub run_restart {
    my (%options) = @_;

    @sequence     = ();
    $stop_result  = 1;
    $start_result = 1;

    if (defined $options{stop}) {
        $stop_result = $options{stop};
    }

    if (defined $options{start}) {
        $start_result = $options{start};
    }

    return Nipe::Network::Restart -> new();
}

subtest 'stops the routing before starting it again' => sub {
    plan tests => 2;

    my $result = run_restart();

    is($result, 1, 'reports success');
    is_deeply(\@sequence, ['stop', 'start'], 'stops first and starts afterwards');
};

subtest 'does not start the routing when stopping fails' => sub {
    plan tests => 2;

    my $result = run_restart(stop => 0);

    is($result, 0, 'reports a failure');
    is_deeply(\@sequence, ['stop'], 'never reaches the start step');
};

subtest 'reports a failure when the routing cannot be started' => sub {
    plan tests => 2;

    my $result = run_restart(start => 0);

    is($result, 0, 'reports a failure');
    is_deeply(\@sequence, ['stop', 'start'], 'still attempts both steps');
};

done_testing();

1;
