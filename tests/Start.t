use strict;
use warnings;
use Test::More;
use Test::MockModule;
use lib '../lib/';
use Nipe::Engine::Start;

my $mock_device = Test::MockModule -> new('Nipe::Utils::Device');
$mock_device -> mock('new', sub {
    return (
        'distribution' => 'debian',
        'username' => 'debian-tor'
    );
});

my $mock_system = Test::MockModule -> new('Nipe::Engine::Start');
$mock_system -> mock('system', sub {
    my ($command) = @_;
    return 0;
});

my $start = Nipe::Engine::Start -> new();
ok(defined $start, 'Start module initialized');

$mock_device -> unmock_all();
$mock_system -> unmock_all();

done_testing();
