use strict;
use warnings;
use Test::More;
use Test::MockModule;
use Config::Simple;
use lib '../lib/';
use Nipe::Utils::Device;

my $mock = Test::MockModule -> new('Config::Simple');

my %distributions = (
    'debian' => {
        'ID'          => 'debian',
        'ID_LIKE'     => '',
        'username'    => 'debian-tor',
        'distribution'=> 'debian'
    },
    'fedora' => {
        'ID'          => 'fedora',
        'ID_LIKE'     => 'fedora',
        'username'    => 'toranon',
        'distribution'=> 'fedora'
    },
    'arch' => {
        'ID'          => 'arch',
        'ID_LIKE'     => 'arch',
        'username'    => 'tor',
        'distribution'=> 'arch'
    },
    'centos' => {
        'ID'          => 'centos',
        'ID_LIKE'     => 'centos',
        'username'    => 'tor',
        'distribution'=> 'arch'
    },
    'void' => {
        'ID'          => 'void',
        'ID_LIKE'     => '',
        'username'    => 'tor',
        'distribution'=> 'void'
    },
    'opensuse' => {
        'ID'          => 'opensuse',
        'ID_LIKE'     => 'suse',
        'username'    => 'tor',
        'distribution'=> 'opensuse'
    }
);

foreach my $distro (keys %distributions) {
    $mock -> mock('new', sub { 
        my $class = shift;
        return bless { 
            'ID' => $distributions{$distro}{'ID'},
            'ID_LIKE' => $distributions{$distro}{'ID_LIKE'}
        }, $class;
    });

    $mock -> mock('param', sub {
        my ($self, $param) = @_;
        return $self -> {$param};
    });

    my %device = Nipe::Utils::Device -> new();
    
    is($device{username}, $distributions{$distro}{'username'}, "Username is correct for $distro");
    is($device{distribution}, $distributions{$distro}{'distribution'}, "Distribution is correct for $distro");
}

done_testing();
