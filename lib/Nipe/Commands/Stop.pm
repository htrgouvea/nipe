package Nipe::Commands::Stop;
use strict;
use warnings;

use Nipe::Device;

sub run {
  my ($self, $arguments) = @_;

  my $user      = Nipe::Device->tor_username;
  my $lock_file = "/var/run/nipe/instance.lock";

  my $options = _parse_arguments($arguments);

  for my $table ($options->{table}) {
    system "sudo iptables -t $table -F OUTPUT";
    system "sudo iptables -t $table -F OUTPUT";
  }

  my $nipe_pid           = `sudo -u $user cat $lock_file 2>&1`;
  my $nipe_command_error = $? != 0;
  chomp($nipe_pid);

  if ($nipe_command_error) {
    print "[.] No instance of tor executed by Nipe was found\n";
    return;
  }

  system "sudo -u $user kill -SIGINT $nipe_pid > /dev/null";
  system "sudo -u $user rm -f $lock_file > /dev/null";
  print "[.] Tor instance with PID=$nipe_pid terminated\n";
}

sub _parse_arguments {
  my ($arguments) = @_;

  my $options = {table => ["nat", "filter"],};

  return $options;
}

1;
