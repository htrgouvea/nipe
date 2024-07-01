#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockModule;
use lib '../lib/';
use Nipe::Engine::Stop;
use Nipe::Utils::Device;

my $mock_device = Test::MockModule -> new('Nipe::Utils::Device');
$mock_device -> mock('new', sub {
    return (
        'distribution' => 'debian', 
        'username' => 'debian-tor'
    );
});

my $mock_stop = Test::MockModule -> new('Nipe::Engine::Stop');
$mock_stop -> mock('system', sub { return 1; });

{
    my $stop = Nipe::Engine::Stop -> new();
    ok($stop, 'Stop module initialized correctly');
}

$mock_device -> unmock_all();
$mock_stop -> unmock_all();

done_testing();
