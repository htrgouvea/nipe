package main;

our $VERSION = '0.001';

use strict;
use warnings;

use Test::More;
use English '-no_match_vars';
use IPC::Open3;
use Symbol qw(gensym);

my $script = 'nipe.pl';

sub run_perl {
    my (@arguments) = @_;

    my $error_handle = gensym;
    my $pid = open3(my $input, my $output, $error_handle, $EXECUTABLE_NAME, @arguments);

    close $input or die "cannot close the input handle: $OS_ERROR\n";

    my $stdout = do { local $INPUT_RECORD_SEPARATOR = undef; <$output> };
    my $stderr = do { local $INPUT_RECORD_SEPARATOR = undef; <$error_handle> };

    my $reaped = waitpid $pid, 0;

    if ($reaped != $pid) {
        die "cannot reap the nipe process: $OS_ERROR\n";
    }

    return ($stdout, $stderr);
}

subtest 'the entry point compiles cleanly' => sub {
    plan tests => 1;

    my (undef, $stderr) = run_perl('-c', $script);

    like($stderr, qr{syntax[ ]OK}smx, 'passes a syntax check');
};

subtest 'prints the help screen when no command is given' => sub {
    plan tests => 3;

    my ($stdout, $stderr) = run_perl($script);

    like($stdout, qr{Core[ ]Commands}smx, 'prints the help screen');
    like($stdout, qr{^ \s* status \s+ See \h+ status \s* $}msx, 'lists the status command');
    is($stderr, q{}, 'writes nothing to standard error');
};

SKIP: {
    if ($REAL_USER_ID == 0) {
        skip 'the privilege check only rejects unprivileged users', 1;
    }

    subtest 'refuses to run a command without root privileges' => sub {
        plan tests => 2;

        my ($stdout, $stderr) = run_perl($script, 'status');

        is($stdout, q{}, 'prints nothing on standard output');
        like($stderr, qr{Nipe[ ]must[ ]be[ ]run[ ]as[ ]root}smx, 'explains that root is required');
    };
}

done_testing();

1;
