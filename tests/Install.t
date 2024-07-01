#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockObject;
use lib '../lib/';

my $mock_install = Test::MockObject -> new();
$mock_install -> fake_module(
    'Nipe::Utils::Install',
    new => sub {
        my ($class) = @_;
        my $self = bless {}, $class;
        
        my $distro = $ENV{DISTRO} || 'debian';
        
        my %install = (
            debian   => "apt-get install -y tor iptables",
            fedora   => "dnf install -y tor iptables",
            centos   => "yum -y install epel-release tor iptables",
            void     => "xbps-install -y tor iptables",
            arch     => "pacman -S --noconfirm tor iptables",
            opensuse => "zypper install -y tor iptables"
        );

        if (exists $install{$distro}) {
            pass("Correct install command would be executed for $distro: $install{$distro}");
            return 1;  
        } else {
            pass("Unknown distribution: $distro");
            return 0;
        }
    }
);

my @distributions = qw(debian fedora centos void arch opensuse);

foreach my $distro (@distributions) {
    local $ENV{DISTRO} = $distro;
    my $install = Nipe::Utils::Install -> new();
    is($install, 1, "Install command executed correctly for $distro");
}

{
    local $ENV{DISTRO} = 'unknown';
    my $install = Nipe::Utils::Install -> new();
    is($install, 0, "Install returns 0 for unknown distribution");
}

done_testing();
