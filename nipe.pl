#!/usr/bin/env perl

use 5.018;
use Switch;
use lib "./lib/";
use Nipe::Engine::Stop;
use Nipe::Engine::Start;
use Nipe::Engine::Restart;
use Nipe::Utils::Status;
use Nipe::Utils::Helper;
use Nipe::Utils::Install;

sub main {
	my $command = $ARGV[0];

	switch ($command) {
		case "stop" {
			Nipe::Engine::Stop -> new();
		}
		case "start" {
			Nipe::Engine::Start -> new();
		}
		case "status" {
			print Nipe::Utils::Status -> new();
		}
		case "restart" {
			Nipe::Engine::Restart -> new();
		}
		case "install" {
			Nipe::Utils::Install -> new();
		}

		print Nipe::Utils::Helper -> new();
	}
}

main();
exit;