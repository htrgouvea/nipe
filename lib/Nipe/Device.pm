package Nipe::Device;
use strict;
use warnings;

use Config::Simple;

our $SYSTEM_INFO;

sub os_release {
  my ($self) = @_;

  return $SYSTEM_INFO if $SYSTEM_INFO;

  my $config = Config::Simple->new;
  $config->read('/etc/os-release') or die $config->error;

  $SYSTEM_INFO
    = {id_like => $config->param('ID_LIKE'), id_distro => $config->param('ID')};

  return $SYSTEM_INFO;
}

sub tor_username {
  my ($self) = @_;

  my $username = 'debian-tor';

  $username = "toranon" if $self->is_fedora;
  $username = "tor"     if $self->is_arch || $self->is_centos;

  return $username;
}

sub os_name {
  my ($self) = @_;

  return 'fedora' if $self->is_fedora;

  return 'centos' if $self->is_centos;

  return 'arch' if $self->is_arch;

  return 'debian';
}

sub is_fedora {
  my $self = shift;

  my $os = $self->os_release;
  my ($id_like, $id_distro) = ($os->{id_like}, $os->{id_distro});

  return ($id_like =~ /[F,f]edora/) || ($id_distro =~ /[F,f]edora/);
}

sub is_arch {
  my $self = shift;

  my $os = $self->os_release;
  my ($id_like, $id_distro) = ($os->{id_like}, $os->{id_distro});

  return ($id_like =~ /[A,a]rch/) || ($id_distro =~ /[A,a]rch/);
}

sub is_centos {
  my $self = shift;

  my $os = $self->os_release;
  my ($id_like, $id_distro) = ($os->{id_like}, $os->{id_distro});

  return ($id_like =~ /[C,c]entos/) || ($id_distro =~ /[C,c]entos/);
}

sub is_debian {
  my $self = shift;
  return !$self->is_fedora && !$self->is_centos && !$self->is_arch;
}

sub tor_config {
  my ($self, $config_file) = @_;
  $config_file //= "/etc/tor/torrc";

  my $username = $self->tor_username;

  my $config = Config::Simple->new;
  $config->read($config_file) or die $config->error;

  return {
    "username"   => $config->param('User')        // $username,
    "is_daemon"  => $config->param('RunAsDaemon') // 1,
    "pid_file"   => $config->param('PidFile')     // ".nipe_tor.pid",
    "trans_port" => $config->param('TransPort')   // 9051,
    "dns_port"   => $config->param('DNSPort')     // 9061,
    "network"    => $config->param('VirtualAddrNetwork')
      // "10.66.0.0/255.255.0.0"
  };
}

1;