use strict;
use warnings;
use Test::More;
use Nipe::Utils::Helper;

{
    my $helper = Nipe::Utils::Helper->new();
    like( $helper, qr/Core Commands/, "Output contains 'Core Commands'" );
    like( $helper, qr/install\s+Install dependencies/,
        "Output contains 'install' command description" );
    like( $helper, qr/start\s+Start routing/,
        "Output contains 'start' command description" );
    like( $helper, qr/stop\s+Stop routing/,
        "Output contains 'stop' command description" );
    like( $helper, qr/restart\s+Restart the Nipe circuit/,
        "Output contains 'restart' command description" );
    like( $helper, qr/status\s+See status/,
        "Output contains 'status' command description" );
}

done_testing();