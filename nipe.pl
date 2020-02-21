#!/usr/bin/env perl

use 5.018;
use strict;
use warnings;

use lib "./lib/";
use Nipe::Commands;

Nipe::Commands->run(\@ARGV);