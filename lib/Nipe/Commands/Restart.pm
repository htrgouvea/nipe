package Nipe::Commands::Restart;
use strict;
use warnings;

use Getopt::Long qw(GetOptionsFromArray);
use Nipe::Commands::Start;
use Nipe::Commands::Stop;

sub run {
  my ($self, $arguments) = @_;

  Nipe::Commands::Stop->run($arguments);
  Nipe::Commands::Start->run($arguments);
}

1;
