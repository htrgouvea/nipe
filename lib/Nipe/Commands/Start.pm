package Nipe::Commands::Start;
use strict;
use warnings;

use File::Which;
use Getopt::Long qw(GetOptionsFromArray);
use Nipe::Device;

sub run {
  my ($self, $arguments) = @_;

  my $options = $self->_parse_arguments($arguments);

  my $is_tor_bin_exists = defined(which("tor"));
  die "[!] Tor not installed. First run Nipe \"install\"\n"
    unless $is_tor_bin_exists;

  my $is_iptable_bin_exists = defined(which("iptables"));
  die "[!] Iptables not installed. First run Nipe \"install\"\n"
    unless $is_iptable_bin_exists;

  my $custom_config = $options->{config_file};
  my $tor_config    = $self->_start_tor_service($custom_config);
  print "[.] Tor executed with success\n";

  $self->_setup_iptables($tor_config);
  print "[.] Firewall rules set with success\n";

  print "[.] Nipe initialized with success\n";
}

sub _start_tor_service {
  my ($self, $options) = @_;

  my $config_file = $options->{config_file};

  my $output = `sudo tor --runasdaemon 0 -f $config_file --verify-config`;
  my $is_config_error = $? != 0;
  die "[!] Failed to load config $config_file\n$output" if $is_config_error;

  print "[.] Config file looks fine\n";

  my $tor_config = Nipe::Device->parse_tor_config($config_file);
  my $user       = $tor_config->{username};
  my $daemon     = $tor_config->{is_daemon};
  my $pid_file   = $tor_config->{pid_file};

  my $run_dir   = "/var/run/nipe";
  my $lock_file = "$run_dir/instance.lock";

  system "sudo -u $user cat $lock_file &> /dev/null";
  my $is_nipe_instance_running = $? == 0;
  die "[!] Running instance of Nipe found, please stop it first\n"
    if $is_nipe_instance_running;

  system "umask u=rwx,g=rx,o= ; sudo mkdir -p $run_dir";
  my $is_create_dir_failed = $? != 0;
  die "[!] Failed to create $run_dir\n" if $is_create_dir_failed;

  system "sudo chown $user:$user $run_dir";

  system "sudo tor --runasdaemon $daemon --pidfile $pid_file -f $config_file";
  my $is_tor_start_failed = $? != 0;
  die "[!] Failed to run tor\n" if $is_tor_start_failed;

  system "echo \"cat $pid_file > $lock_file\" | sudo -u $user -s";

  return $tor_config;
}

sub _setup_iptables {
  my ($self, $tor_config) = @_;

  my $dns_port      = $tor_config->{dns_port};
  my $transfer_port = $tor_config->{trans_port};
  my $network       = $tor_config->{network};
  my $username      = $tor_config->{username};
  my $tables        = ["nat", "filter"];

  for my $table ($tables) {
    my $is_nat_table = $table eq "nat";
    my $target       = $is_nat_table ? "RETURN" : "ACCEPT";

    system "sudo iptables -t $table -F OUTPUT";
    system
      "sudo iptables -t $table -A OUTPUT -m state --state ESTABLISHED -j $target";
    system
      "sudo iptables -t $table -A OUTPUT -m owner --uid $username -j $target";

    my $match_dns_port = $dns_port;

    if ($is_nat_table) {
      $target         = "REDIRECT --to-ports $dns_port";
      $match_dns_port = "53";
    }

    system
      "sudo iptables -t $table -A OUTPUT -p udp --dport $match_dns_port -j $target";
    system
      "sudo iptables -t $table -A OUTPUT -p tcp --dport $match_dns_port -j $target";

    $target = "REDIRECT --to-ports $transfer_port" if $is_nat_table;
    system "sudo iptables -t $table -A OUTPUT -d $network -p tcp -j $target";

    $target = "RETURN" if $is_nat_table;
    system "sudo iptables -t $table -A OUTPUT -d 127.0.0.1/8    -j $target";
    system "sudo iptables -t $table -A OUTPUT -d 192.168.0.0/16 -j $target";
    system "sudo iptables -t $table -A OUTPUT -d 172.16.0.0/12  -j $target";
    system "sudo iptables -t $table -A OUTPUT -d 10.0.0.0/8     -j $target";

    $target = "REDIRECT --to-ports $transfer_port" if $is_nat_table;
    system "sudo iptables -t $table -A OUTPUT -p tcp -j $target";
  }

  system "sudo iptables -t filter -A OUTPUT -p udp -j REJECT";
  system "sudo iptables -t filter -A OUTPUT -p icmp -j REJECT";
}

sub _parse_arguments {
  my ($self, $arguments) = @_;

  my $options = {
    config_file   => "/etc/tor/torrc",
    dns_port      => "9061",
    transfer_port => "9051",
    table         => ["nat", "filter"],
    network       => "10.66.0.0/255.255.0.0",
  };

  GetOptionsFromArray(
    $arguments,
    "config=s"        => \$options->{config_file},
    "dns_port=s"      => \$options->{dns_port},
    "transfer_port=s" => \$options->{transfer_port},
    "network=s"       => \$options->{network}
  );

  return $options;
}

1;
