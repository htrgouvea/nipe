package Nipe::Client::Tor;
use strict;
use warnings;

use JSON;
use LWP::UserAgent;

use Nipe::Errors::RequesNotSucceed;

sub check_ip {
  my ($self) = @_;

	my $ua       = LWP::UserAgent->new;
	my $response = $ua->get($api_host);
	my $is_http_success = $response->code == 200;

  Nipe::Errors::RequesNotSucceed->throws(
    status  => $response->status,
    message => 'sorry, it was not possible to establish a connection to the server',
  ) unless $is_http_success;

  my $payload = $self->_decode_json($response->content);

  return {
    ip_addr    => $payload->{'IP'},
    tor_status => $payload->{'IsTor'} ? "activated" : "disabled",
  }
}

sub _decode_json {
  my ($self, $value) = @_;
  return decode_json($value)
}

1;
