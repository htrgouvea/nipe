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
		  system "sudo cp .configs/debian-torrc /etc/tor/torrc";
	  },
	  fedora => sub {
		  system "sudo dnf install tor iptables";
		  system "sudo cp .configs/fedora-torrc /etc/tor/torrc";
	  },
	  centos => sub {
		  system "sudo yum install epel-release tor iptables";
		  system "sudo cp .configs/centos-torrc /etc/tor/torrc";
	  },
    default => sub {
      system "sudo pacman -S tor iptables";
      system "sudo cp .configs/arch-torrc /etc/tor/torrc";
    }
  };

  my $install_for_os = $systems->{$os_name} || $systems->{default};
  $install_for_os->();

	system "sudo chmod 644 /etc/tor/torrc";
}

sub _prepare_directories {
	system "sudo mkdir -p /etc/tor";
}

sub _stop_service {
  my $tor_command = (-e "/etc/init.d/tor") ? "/etc/init.d/tor stop > /dev/null" : "systemctl stop tor";
  system "sudo ${tor_command}";
}

sub _parse_arguments {
  my ($arguments) = @_;

  my $options = {};
  return $options;
}

1;
