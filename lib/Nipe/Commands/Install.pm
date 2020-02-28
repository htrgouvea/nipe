package Nipe::Commands::Install;
use strict;
use warnings;

use Nipe::Device;

sub run {
  my ($self, $arguments) = @_;

  my $options = $self->_parse_arguments($arguments);

  $self->_prepare_directories;

  my $os_name = Nipe::Device->get_system;
  $self->_os_tor_installation($os_name);

  $self->_stop_service;
}

sub _os_tor_installation {
  my ($self, $os_name) = @_;

  my $systems = {
    debian => sub {
      system "sudo apt-get install tor iptables";
    },
    fedora => sub {
      system "sudo dnf install tor iptables";
    },
    centos => sub {
      system "sudo yum install epel-release tor iptables";
    },
    arch => sub {
      system "sudo pacman -S tor iptables";
    }
  };

  my $distro_name = exists $systems->{$os_name} ? $os_name : 'arch';
  my $install_tor_function = $systems->{$distro_name};

  $install_tor_function->();
  system "sudo cp .configs/${$distro_name}-torrc /etc/tor/torrc";

  system "sudo chmod 644 /etc/tor/torrc";
}

sub _prepare_directories {
  system "sudo mkdir -p /etc/tor";
}

sub _stop_service {
  my $tor_command
    = (-e "/etc/init.d/tor")
    ? "/etc/init.d/tor stop > /dev/null"
    : "systemctl stop tor";
  system "sudo ${tor_command}";
}

sub _parse_arguments {
  my ($self, $arguments) = @_;

  my $options = {};
  return $options;
}

1;
