#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockModule;
use lib '../lib/';
use Nipe::Engine::Restart;
use Nipe::Engine::Stop;
use Nipe::Engine::Start;

my $mock_stop = Test::MockModule -> new('Nipe::Engine::Stop');
$mock_stop -> mock('new', sub {
    my $self = bless {}, 'Nipe::Engine::Stop';
    return 1;  
});

my $mock_start = Test::MockModule -> new('Nipe::Engine::Start');
$mock_start -> mock('new', sub {
    my $self = bless {}, 'Nipe::Engine::Start';
    return 1;  
});

my $restart = Nipe::Engine::Restart -> new();
ok($restart, 'Restart module initialized correctly');

$mock_stop -> unmock_all();
$mock_start -> unmock_all();

done_testing();
