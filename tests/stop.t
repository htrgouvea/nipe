package main;

our $VERSION = '0.001';

use strict;
use warnings;

use Test::More;
use Test::MockModule;
use File::Temp qw(tempdir tempfile);

my @system_calls;

BEGIN {
    *CORE::GLOBAL::system = sub {
        push @system_calls, join q{ }, @_;

        return 0;
    };
}

use lib 'lib';
use_ok('Nipe::Component::Engine::Stop');

my $missing_path = '/nipe/path/that/does/not/exist';
my $present_dir  = tempdir(CLEANUP => 1);
my (undef, $present_file) = tempfile(UNLINK => 1);

my %device = (
    username     => 'debian-tor',
    distribution => 'debian',
);

my $device_mock = Test::MockModule -> new('Nipe::Component::Utils::Device');
$device_mock -> mock('new', sub { return %device; });

sub run_stop {
    my (%options) = @_;

    local $Nipe::Component::Engine::Stop::TOR_INIT_SCRIPT = $options{init_script};
    local $Nipe::Component::Engine::Stop::IPV6_PROC_PATH  = $options{ipv6_path};

    @system_calls = ();

    return Nipe::Component::Engine::Stop -> new();
}

subtest 'exposes the production paths as overridable defaults' => sub {
    plan tests => 2;

    is(
        $Nipe::Component::Engine::Stop::TOR_INIT_SCRIPT,
        '/etc/init.d/tor',
        'defaults to the system init script'
    );
    is(
        $Nipe::Component::Engine::Stop::IPV6_PROC_PATH,
        '/proc/sys/net/ipv6',
        'defaults to the kernel IPv6 directory'
    );
};

subtest 'flushes both iptables chains and stops tor via systemd' => sub {
    plan tests => 4;

    %device = (username => 'debian-tor', distribution => 'debian');

    my $result = run_stop(init_script => $missing_path, ipv6_path => $missing_path);

    is($result, 1, 'reports success');
    ok((grep { $_ eq 'iptables -t nat -F OUTPUT' } @system_calls), 'flushes the nat table');
    ok((grep { $_ eq 'iptables -t filter -F OUTPUT' } @system_calls), 'flushes the filter table');
    is($system_calls[-1], 'systemctl stop tor', 'stops tor through systemctl');
};

subtest 'stops tor through runit on Void Linux' => sub {
    plan tests => 1;

    %device = (username => 'tor', distribution => 'void');

    run_stop(init_script => $missing_path, ipv6_path => $missing_path);

    is($system_calls[-1], 'sv stop tor > /dev/null', 'uses the runit service command');
};

subtest 'prefers the init script when it is available' => sub {
    plan tests => 1;

    %device = (username => 'debian-tor', distribution => 'debian');

    run_stop(init_script => $present_file, ipv6_path => $missing_path);

    is($system_calls[-1], '/etc/init.d/tor stop > /dev/null', 'uses the init script');
};

subtest 'the init script takes precedence over the Void service command' => sub {
    plan tests => 1;

    %device = (username => 'tor', distribution => 'void');

    run_stop(init_script => $present_file, ipv6_path => $missing_path);

    is(
        $system_calls[-1],
        '/etc/init.d/tor stop > /dev/null',
        'overrides the runit command when an init script exists'
    );
};

subtest 'skips ip6tables when the kernel has no IPv6 support' => sub {
    plan tests => 1;

    %device = (username => 'debian-tor', distribution => 'debian');

    run_stop(init_script => $missing_path, ipv6_path => $missing_path);

    is(scalar(grep { m/ip6tables/sm } @system_calls), 0, 'runs no ip6tables commands');
};

subtest 'flushes the IPv6 chains when the kernel supports IPv6' => sub {
    plan tests => 3;

    %device = (username => 'debian-tor', distribution => 'debian');

    run_stop(init_script => $missing_path, ipv6_path => $present_dir);

    my @ipv6_calls = grep { m/ip6tables/sm } @system_calls;

    is(scalar @ipv6_calls, 2, 'flushes one chain per table');
    ok((grep { $_ eq 'ip6tables -t nat -F OUTPUT' } @ipv6_calls), 'flushes the IPv6 nat table');
    ok((grep { $_ eq 'ip6tables -t filter -F OUTPUT' } @ipv6_calls), 'flushes the IPv6 filter table');
};

done_testing();

1;
