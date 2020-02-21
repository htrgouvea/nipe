package Nipe::Device;
use strict;
use warnings;

use Config::Simple;

my $config    = Config::Simple->new('/etc/os-release');
my $id_like   = $config->param('ID_LIKE');
my $id_distro = $config->param('ID');

sub get_username {
  my ($self) = @_;

	my $username = 'debian-tor';

	$username = "toranon" if $self->_is_fedora;
	$username = "tor" if $self->_is_arch || $self->_is_centos;

	return $username
}

sub get_system {
  my ($self) = @_;

  return 'fedora' if $self->_is_fedora;

  return 'centos' if $self->_is_centos;

  return 'arch' if $self->_is_arch;

  return 'debian'
}

sub _is_fedora {
	return ($id_like =~ /[F,f]edora/) || ($id_distro =~ /[F,f]edora/)
}

sub _is_arch {
	return ($id_like =~ /[A,a]rch/) || ($id_distro =~ /[A,a]rch/)
}

sub _is_centos {
	return ($id_like =~ /[C,c]entos/) || ($id_distro =~ /[C,c]entos/)
}

1;