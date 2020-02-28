package Nipe::Errors::RequestNotSucceed;
use strict;
use warnings;

use Scalar::Util qw(blessed);

use overload '""' => sub { $_[0]->to_string };

sub new {
  my ($class, $args) = (shift, {@_});
  return bless $args || {}, $class;
}

sub throws {
  my ($self, $status, $message) = @_;

  $self = $self->new(status => $status, message => $message)
    unless blessed $self;

  die $self;
}

sub status {
  my ($self) = @_;
  return $self->{status};
}

sub message {
  my ($self) = @_;
  return $self->{message};
}

sub to_string {
  my $self = shift;
  return $self->{message};
}

1;
