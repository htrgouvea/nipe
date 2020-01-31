#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;
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
			my $custom_cfg = undef;

			if (defined($ARGV[1]) and $ARGV[1] eq "-c") {
				if (!defined($ARGV[2])) {
					print "[!] Invalid argument\n";
					Nipe::Helper -> new();
					exit 1;
				}

				$custom_cfg = $ARGV[2];
			}

			Nipe::Start -> new($custom_cfg);
		}

		case "status" {
			my $status = Nipe::Status -> new();
			print $status;
		}

		case "restart" {
			Nipe::Restart -> new();
		}

		case "install" {
			my $force_cfg = undef;
			my $custom_cfg = undef;

			if (defined($ARGV[1])) {
				if ($ARGV[1] eq "-f") {
					$force_cfg = 1;
				}

				elsif ($ARGV[1] eq "-c") {
					if (!defined($ARGV[2])) {
						print "[!] Invalid argument\n";
						Nipe::Helper -> new();
						exit 1;
					}

					$force_cfg = 1;
					$custom_cfg = $ARGV[2];
				}
			}

			Nipe::Install -> new($force_cfg, $custom_cfg);

			# Force the user to call "start" command with the new config
			Nipe::Stop -> new();
			print "[.] Installation complete\n";
		}

		Nipe::Helper -> new();
	}
}

main();
exit;