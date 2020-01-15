#!/usr/bin/env perl

use 5.018;
use Switch;
use lib "./lib/";
use Nipe::Stop;
use Nipe::Start;
use Nipe::Status;
use Nipe::Helper;
use Nipe::Restart;
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
			Nipe::Status -> new();
		}
		case "restart" {
			Nipe::Restart -> new();
		}
		case "install" {
			my $force_cfg = undef;

			if ($ARGV[1] eq "-f") {
				$force_cfg = 1;
			}

			Nipe::Install -> new($force_cfg);
		}

		Nipe::Helper -> new();
	}
}

main();
exit;