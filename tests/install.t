package main;

our $VERSION = '0.001';

use strict;
use warnings;

use Test::More;
use Test::MockModule;

my @system_calls;

BEGIN {
    *CORE::GLOBAL::system = sub {
        push @system_calls, join q{ }, @_;

        return 0;
    };
}

use lib 'lib';
use_ok('Nipe::Network::Install');

my $stop_calls  = 0;
my $stop_result = 1;

my %device = (
    username     => 'debian-tor',
    distribution => 'debian',
);

my $device_mock = Test::MockModule -> new('Nipe::Component::Utils::Device');
$device_mock -> mock('new', sub { return %device; });

my $stop_mock = Test::MockModule -> new('Nipe::Component::Engine::Stop');
$stop_mock -> mock(
    'new',
    sub {
        $stop_calls++;

        return $stop_result;
    }
);

sub run_install {
    my ($distribution, %options) = @_;

    %device = (username => 'tor', distribution => $distribution);

    @system_calls = ();
    $stop_calls   = 0;
    $stop_result  = 1;

    if (defined $options{stop_result}) {
        $stop_result = $options{stop_result};
    }

    return Nipe::Network::Install -> new();
}

subtest 'installs the dependencies with the distribution package manager' => sub {
    plan tests => 6;

    my %expected = (
        debian   => 'apt-get install -y tor iptables',
        fedora   => 'dnf install -y tor iptables',
        centos   => 'yum -y install epel-release tor iptables',
        void     => 'xbps-install -y tor iptables',
        arch     => 'pacman -S --noconfirm tor iptables',
        opensuse => 'zypper install -y tor iptables',
    );

    foreach my $distribution (sort keys %expected) {
        run_install($distribution);

        is($system_calls[0], $expected{$distribution}, "installs on $distribution");
    }
};

subtest 'stops the routing once the packages are installed' => sub {
    plan tests => 2;

    my $result = run_install('debian');

    is($stop_calls, 1, 'stops the routing exactly once');
    is($result, 1, 'reports success');
};

subtest 'reports a failure when the routing cannot be stopped' => sub {
    plan tests => 1;

    my $result = run_install('debian', stop_result => 0);

    is($result, 0, 'returns a falsy result');
};

done_testing();

1;
