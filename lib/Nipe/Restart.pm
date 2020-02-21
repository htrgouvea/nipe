package Nipe::Restart;

use strict;
use warnings;
use Nipe::Stop;
use Nipe::Start;

sub new {
    Nipe::Stop -> new();
    Nipe::Start -> new();
}

1;
