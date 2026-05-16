package main;

our $VERSION = '0.001';

use strict;
use warnings;

use Test::More;

use lib 'lib';
use Nipe::Component::Utils::Helper;

my $help_text = Nipe::Component::Utils::Helper->new();

ok(defined $help_text, 'helper output is defined');
ok(!ref $help_text, 'helper output is plain text');
ok(length $help_text > 0, 'helper output is not empty');

like($help_text, qr{ ^ \s* Core \h+ Commands \s* $ }msx, 'contains section title');
like($help_text, qr{ ^ \s* install \s+ Install \h+ dependencies \s* $ }msx, 'documents install command');
like($help_text, qr{ ^ \s* start \s+ Start \h+ routing \s* $ }msx, 'documents start command');
like($help_text, qr{ ^ \s* stop \s+ Stop \h+ routing \s* $ }msx, 'documents stop command');
like($help_text, qr{ ^ \s* restart \s+ Restart \h+ the \h+ Nipe \h+ circuit \s* $ }msx, 'documents restart command');
like($help_text, qr{ ^ \s* status \s+ See \h+ status \s* $ }msx, 'documents status command');

done_testing();

1;
