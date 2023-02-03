#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
use Try::Tiny;
use lib "./lib/";
use Nipe::Engine::Stop;
use Nipe::Engine::Start;
use Nipe::Engine::Restart;
use Nipe::Utils::Status;
use Nipe::Utils::Helper;
use Nipe::Utils::Install;

sub main {
	my $argument = $ARGV[0];
	
	if ($argument) {
		die "Nipe must be run as root.\n" if $< != 0;

		my $commands = {
			stop    => "Nipe::Engine::Stop",
			start   => "Nipe::Engine::Start",
			status  => "Nipe::Utils::Status",
			restart => "Nipe::Engine::Restart",
			install => "Nipe::Utils::Install",
			help    => "Nipe::Utils::Helper"
		};

		try {
			my $exec = $commands -> {$argument} -> new();

			if ($exec ne "1") {
				print $exec;
			}
		}

		catch {
  			print "\n[!] ERROR: this command could not be run\n\n";
		};

		return 1;
	}

	return print Nipe::Utils::Helper -> new();
}

exit main();