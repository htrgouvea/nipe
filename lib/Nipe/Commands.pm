package Nipe::Commands;
use strict;
use warnings;

use Nipe::Commands::Start;
use Nipe::Commands::Stop;
use Nipe::Commands::Restart;
use Nipe::Commands::Status;
use Nipe::Commands::Install;

my $COMMANDS = {
  install => "Nipe::Commands::Install",
  restart => "Nipe::Commands::Restart",
  start   => "Nipe::Commands::Start",
  status  => "Nipe::Commands::Status",
  stop    => "Nipe::Commands::Stop",
};

my $HELP_MSG = qq{
nipe [COMMANDS]

Core Commands
==============
  Command       Description
  -------       -----------
  install       Install dependencies
  start         Start routing
  stop          Stop routing
  restart       Restart the Nipe process
  status        See status

Copyright (c) 2015 - 2020 | Heitor Gouvêa

};

sub run {
  my ($self, $arguments) = @_;

  my $subcommand = shift @$arguments || '';
  my $command_class = $COMMANDS->{$subcommand};

  unless ($command_class) {
    print $HELP_MSG;
    exit
  }

  $command_class->run($arguments);
  exit
}

1;
