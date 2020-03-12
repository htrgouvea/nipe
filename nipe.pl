#!/usr/bin/env perl

use 5.018;
use Switch;
use lib "./lib/";
use Nipe::Stop;
use Nipe::Start;
use Nipe::Restart;
use Nipe::Status;
use Nipe::Helper;
use Nipe::Install;

sub main {
	my $command = $ARGV[0];

	switch ($command) {
		case "stop" {
			Nipe::Stop -> new();
		}
		case "start" {
			Nipe::Start -> new();
		}
		case "status" {
			print Nipe::Status -> new();
		}
		case "restart" {
			Nipe::Restart -> new();
		}
		case "install" {
			Nipe::Install -> new();
		}

		Nipe::Helper -> new();
	}
}

main();
exit;