#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockModule;
use JSON;
use lib '../lib/';
use Nipe::Utils::Status;

sub normalize_whitespace {
    my ($str) = @_;
    $str =~ s/^\s+|\s+$//g; 
    $str =~ s/\s+/ /g;       
    return $str;
}

my $mock_http = Test::MockModule -> new('HTTP::Tiny');

subtest 'Successful connection' => sub {
    $mock_http -> mock('get', sub {
        return {
            status => 200,
            content => encode_json({
                IP => '1.2.3.4',
                IsTor => JSON::true
            })
        };
    });

    my $status = Nipe::Utils::Status -> new();
    my $expected = "[+] Status: true [+] Ip: 1.2.3.4";
    is(normalize_whitespace($status), $expected, 'Status output is correct for successful Tor connection');
};

subtest 'Unsuccessful connection' => sub {
    $mock_http -> mock('get', sub {
        return { status => 500 };
    });

    my $status = Nipe::Utils::Status -> new();
    my $expected = "[!] ERROR: sorry, it was not possible to establish a connection to the server.";
    is(normalize_whitespace($status), $expected, 'Error message is correct for unsuccessful connection');
};

subtest 'Non-Tor connection' => sub {
    $mock_http -> mock('get', sub {
        return {
            status => 200,
            content => encode_json({
                IP => '5.6.7.8',
                IsTor => JSON::false
            })
        };
    });

    my $status = Nipe::Utils::Status -> new();
    my $expected = "[+] Status: false [+] Ip: 5.6.7.8";
    is(normalize_whitespace($status), $expected, 'Status output is correct for non-Tor connection');
};

done_testing();
