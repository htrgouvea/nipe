package Nipe::Commands::Stop;
use strict;
use warnings;

sub run {
  my ($self, $arguments) = @_;

  my $options = _parse_arguments($arguments);

  for my $table ($options->{table}) {
		system ("sudo iptables -t $table -F OUTPUT");
		system ("sudo iptables -t $table -F OUTPUT");
  }

	my $tor_command = (-e "/etc/init.d/tor") ?
		"/etc/init.d/tor stop > /dev/null" :
    "systemctl stop tor";

	system("sudo $tor_command");
}

sub _parse_arguments {
  my ($arguments) = @_;

  my $options = {
	  table => ["nat", "filter"],
  };

  return $options;
}

1;
