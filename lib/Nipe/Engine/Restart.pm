package Nipe::Engine::Restart;

use strict;
use warnings;
use Nipe::Engine::Stop;
use Nipe::Engine::Start;

sub new {
    Nipe::Engine::Stop -> new();
    Nipe::Engine::Start -> new();

    return 1;
}

1;