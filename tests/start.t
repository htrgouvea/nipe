#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockModule;

use lib './lib';

my @system_calls;

BEGIN {
    *CORE::GLOBAL::system = sub { push @system_calls, "@_"; return 0; };
}

BEGIN {
    use_ok('Nipe::Component::Engine::Start');
}

my $device_mock = Test::MockModule -> new('Nipe::Component::Utils::Device');
$device_mock -> mock('new', sub { return (username => 'tor', distribution => 'arch'); });

my $status_mock = Test::MockModule -> new('Nipe::Component::Utils::Status');
$status_mock -> mock('new', sub { return '[+] Status: true'; });

@system_calls = ();
Nipe::Component::Engine::Start -> new();

subtest 'forces traffic through tor' => sub {
    plan tests => 4;

    ok((grep { index($_, '-t nat -A OUTPUT -m owner --uid tor -j RETURN') >= 0 } @system_calls), 'tor user returns directly');
    ok((grep { index($_, '-t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 9061') >= 0 } @system_calls), 'dns is redirected into tor');
    ok((grep { index($_, '-t nat -A OUTPUT -p tcp -j REDIRECT --to-ports 9051') >= 0 } @system_calls), 'tcp is redirected into tor');
    ok((grep { index($_, '-t filter -A OUTPUT -j REJECT') >= 0 } @system_calls), 'default deny on the filter chain');
};

subtest 'the tor user rule precedes the catch all redirect' => sub {
    plan tests => 1;

    my ($owner) = grep { index($system_calls[$_], '-t nat -A OUTPUT -m owner --uid tor -j RETURN') >= 0 } 0 .. $#system_calls;
    my ($catch) = grep { index($system_calls[$_], '-t nat -A OUTPUT -p tcp -j REDIRECT --to-ports 9051') >= 0 } 0 .. $#system_calls;

    ok(defined $owner && defined $catch && $owner < $catch, 'owner RETURN comes before the catch all REDIRECT');
};

done_testing();
