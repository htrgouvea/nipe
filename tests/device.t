#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockModule;

use lib './lib';

BEGIN {
    use_ok('Nipe::Component::Utils::Device');
}

my %osrelease;

my $config_mock = Test::MockModule -> new('Config::Simple');
$config_mock -> mock('new', sub { return bless {}, 'Config::Simple'; });
$config_mock -> mock('param', sub {
    my ($self, $key) = @_;
    return $osrelease{$key};
});

my @cases = (
    [ 'arch',          q{},             'tor',        'arch'     ],
    [ 'manjaro',       'arch',          'tor',        'arch'     ],
    [ 'debian',        q{},             'debian-tor', 'debian'   ],
    [ 'ubuntu',        'debian',        'debian-tor', 'debian'   ],
    [ 'fedora',        q{},             'toranon',    'fedora'   ],
    [ 'centos',        'rhel fedora',   'tor',        'centos'   ],
    [ 'rhel',          'fedora',        'tor',        'centos'   ],
    [ 'void',          q{},             'tor',        'void'     ],
    [ 'opensuse-leap', 'suse opensuse', 'tor',        'opensuse' ],
);

foreach my $case (@cases) {
    my ($id, $like, $user, $distro) = @{$case};

    subtest "$id resolves to $distro" => sub {
        plan tests => 2;

        %osrelease = (ID => $id, ID_LIKE => $like);
        my %device = Nipe::Component::Utils::Device -> new();

        is($device{username},     $user,   "user is $user");
        is($device{distribution}, $distro, "distribution is $distro");
    };
}

subtest 'centos is not misdetected as fedora through ID_LIKE' => sub {
    plan tests => 1;

    %osrelease = (ID => 'centos', ID_LIKE => 'rhel fedora');
    my %device = Nipe::Component::Utils::Device -> new();

    is($device{distribution}, 'centos', 'centos wins over fedora');
};

done_testing();
