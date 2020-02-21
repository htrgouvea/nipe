package Nipe::Commands::Status;
use strict;
use warnings;

use Getopt::Long qw(GetOptionsFromArray);

sub run {
  my ($self, $arguments) = @_;

  my $options = _parse_arguments($arguments);

  my $api_host = $options->{api_host};

  eval {
    my $payload = Nipe::Client::Tor->check_ip($api_host);

    my $ip_addr    = $payload->{'ip_addr'};
    my $tor_status = $payload->{'tor_status'};

    print "\n\r[+] Status: ${tor_status}. \n\r[+] Ip: ${ip_addr}\n\n";

  };
  if (my $error = $@) {
    my $error_message = $error->message;

		print "\n[!] ERROR: ${error_message}.\n\n";
    exit
  }
}

sub _parse_arguments {
  my ($arguments) = @_;

  my $options = {
    api_host      => 'https://check.torproject.org/api/ip',
	  dns_port      => "9061",
	  transfer_port => "9051",
	  table         => ["nat", "filter"],
	  network       => "10.66.0.0/255.255.0.0",
  };

  GetOptionsFromArray(
    $arguments,
    "dns_port=s"      => \$options->{dns_port},
    "transfer_port=s" => \$options->{transfer_port},
    "network=s"       => \$options->{network}
  );

  return $options;
}

1;
