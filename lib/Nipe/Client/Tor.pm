package Nipe::Client::Tor;
use strict;
use warnings;

use HTTP::Tiny;
use JSON;

use Nipe::Errors::RequestNotSucceed;

sub check_ip {
  my ($self, $api_host) = @_;

  my $http_tiny       = HTTP::Tiny->new;
  my $response        = $http_tiny->get($api_host);
  my $is_http_success = $response->{status} == 200;

  Nipe::Errors::RequestNotSucceed->throws(
    status  => $response->status,
    message => 'sorry, it was not possible to establish a connection to the server',
  ) unless $is_http_success;

  my $payload = $self->_decode_json($response->{content});
  my $data = {
    ip_addr    => $payload->{'IP'},
    tor_status => $payload->{'IsTor'} ? "activated" : "disabled",
  };

  my ($ip, $status) = ($data->{ip_addr}, $data->{tor_status});
  print "\n\r[+] Status: $status. \n\r[+] Ip: $ip\n\n";

  return $data
}

sub _decode_json {
  my ($self, $value) = @_;
  return decode_json($value)
}

1;
