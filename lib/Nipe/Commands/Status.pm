package Nipe::Commands::Status;
use strict;
use warnings;

use Getopt::Long qw(GetOptionsFromArray);

use Nipe::Client::Tor;

sub run {
  my ($self, $arguments) = @_;

  my $options = _parse_arguments($arguments);

  my $api_host = $options->{api_host};

  eval { Nipe::Client::Tor->check_ip($api_host) };
  if (my $error = $@) {
    my $error_message = $error->message;
    die "\n[!] ERROR: ${error_message}.\n\n";
  }
}

sub _parse_arguments {
  my ($arguments) = @_;

  my $options = {api_host => 'https://check.torproject.org/api/ip',};

  GetOptionsFromArray($arguments, "api_host=s" => \$options->{api_host},);

  return $options;
}

1;
