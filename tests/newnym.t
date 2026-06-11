#!/usr/bin/env perl

use strict;
use warnings;
use Test::MockModule;
use Test::More;

use lib './lib';

BEGIN {
    use_ok('Nipe::Component::Engine::Newnym');
}

subtest 'reports an error when the control socket is unreachable' => sub {
    plan tests => 1;

    my $socket_mock = Test::MockModule -> new('IO::Socket::UNIX');
    $socket_mock -> mock('new', sub { return; });

    my $output = Nipe::Component::Engine::Newnym -> new();
    ok(index($output, 'cannot reach tor control socket') >= 0, 'unreachable socket is reported');
};

done_testing();
