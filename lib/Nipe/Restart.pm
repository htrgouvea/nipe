#!/usr/bin/env perl

package Nipe::Restart;

use Nipe::Stop;
use Nipe::Start;

sub new {
    Nipe::Stop -> new();
    Nipe::Start -> new();

    return true;
}

1;