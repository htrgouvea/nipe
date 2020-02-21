package Nipe::Commands::Start;
use strict;
use warnings;

use Getopt::Long qw(GetOptionsFromArray);
use Nipe::Device;

sub run {
  my ($self, $arguments) = @_;

  my $options = _parse_arguments($arguments);

	my $username = Nipe::Device->get_username;
	my $tor_command = (-e "/etc/init.d/tor") ?
		"/etc/init.d/tor start > /dev/null" :
    "systemctl start tor";

	system("sudo $tor_command");

	for my $table ($options->{table}) {
    my $dns_port      = $options->{dns_port};
    my $transfer_port = $options->{transfer_port};

    my $target          = "ACCEPT";
		my $match_dns_port  = $dns_port;

    if ($table eq "nat") {
      $match_dns_port = "53";
      $target = "RETURN";
    }

		system("sudo iptables -t $table -F OUTPUT");
		system("sudo iptables -t $table -A OUTPUT -m state --state ESTABLISHED -j $target");
		system("sudo iptables -t $table -A OUTPUT -m owner --uid $username -j $target");

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $dns_port";
		}

		system("sudo iptables -t $table -A OUTPUT -p udp --dport $match_dns_port -j $target");
		system("sudo iptables -t $table -A OUTPUT -p tcp --dport $match_dns_port -j $target");

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $transfer_port";
		}

		system("sudo iptables -t $table -A OUTPUT -d $network -p tcp -j $target");

		if ($table eq "nat") {
			$target = "RETURN";
		}

		system("sudo iptables -t $table -A OUTPUT -d 127.0.0.1/8    -j $target");
		system("sudo iptables -t $table -A OUTPUT -d 192.168.0.0/16 -j $target");
		system("sudo iptables -t $table -A OUTPUT -d 172.16.0.0/12  -j $target");
		system("sudo iptables -t $table -A OUTPUT -d 10.0.0.0/8     -j $target");

		if ($table eq "nat") {
			$target = "REDIRECT --to-ports $transfer_port";
		}

		system("sudo iptables -t $table -A OUTPUT -p tcp -j $target");
	}

	system("sudo iptables -t filter -A OUTPUT -p udp -j REJECT");
	system("sudo iptables -t filter -A OUTPUT -p icmp -j REJECT");
}

sub _parse_arguments {
  my ($arguments) = @_;

  my $options = {
	  dns_port      => "9061",
	  transfer_port => "9051",
	  table         => ["nat", "filter"],
	  network       => "10.66.0.0/255.255.0.0",
  };

  GetOptionsFromArray(
    $arguments,
    "dns_port=s"      => \$options->{dns_port},
    "transfer_port=s" => \$options->{transfer_port},
    "network=s"       => \$options->{network}
  );

  return $options;
}

1;
