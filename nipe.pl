#!/usr/bin/env perl

use 5.030;
use strict;
use warnings;
use Try::Tiny;
use lib './lib/';
use Nipe::Component::Engine::Stop;
use Nipe::Component::Engine::Start;
use Nipe::Component::Engine::Newnym;
use Nipe::Network::Restart;
use Nipe::Component::Utils::Status;
use Nipe::Component::Utils::Helper;
use Nipe::Network::Install;
use English '-no_match_vars';

our $VERSION = '0.0.8';

sub main {
    my $argument = $ARGV[0];

    if (!$argument) {
        return print Nipe::Component::Utils::Helper -> new();
    }

    my $commands = {
        stop    => 'Nipe::Component::Engine::Stop',
        start   => 'Nipe::Component::Engine::Start',
        status  => 'Nipe::Component::Utils::Status',
        restart => 'Nipe::Network::Restart',
        newnym  => 'Nipe::Component::Engine::Newnym',
        install => 'Nipe::Network::Install',
        help    => 'Nipe::Component::Utils::Helper',
    };

    my $module = $commands -> {$argument};

    if (!$module) {
        return print Nipe::Component::Utils::Helper -> new();
    }

    my %needs_root = map { $_ => 1 } qw(start stop restart newnym install);

    if ($needs_root{$argument} && $REAL_USER_ID != 0) {
        die "Nipe must be run as root.\n";
    }

    try {
        my $exec = $module -> new();

        if ($exec ne '1') {
            print $exec;
        }
    }

    catch {
        print "\n[!] ERROR: $_\n";
    };

    return 1;
}

main();
