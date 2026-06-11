#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockModule;

use lib './lib';

BEGIN {
    use_ok('Nipe::Component::Utils::Status');
}

my $http_mock = Test::MockModule -> new('HTTP::Tiny');

subtest 'reports tor when IsTor is true' => sub {
    plan tests => 2;

    $http_mock -> mock('get', sub {
        return { status => 200, content => '{"IsTor":true,"IP":"185.220.101.1"}' };
    });

    my $output = Nipe::Component::Utils::Status -> new();
    ok(index($output, 'Status: true') >= 0,    'status is true');
    ok(index($output, '185.220.101.1') >= 0,   'ip is shown');
};

subtest 'reports not tor when IsTor is false' => sub {
    plan tests => 1;

    $http_mock -> mock('get', sub {
        return { status => 200, content => '{"IsTor":false,"IP":"8.8.8.8"}' };
    });

    my $output = Nipe::Component::Utils::Status -> new();
    ok(index($output, 'Status: false') >= 0, 'status is false');
};

subtest 'reports an error when the request fails' => sub {
    plan tests => 1;

    $http_mock -> mock('get', sub {
        return { status => 599, content => q{} };
    });

    my $output = Nipe::Component::Utils::Status -> new();
    ok(index($output, 'not possible to establish a connection') >= 0, 'error branch');
};

done_testing();
