requires 'IO::Socket::SSL', '2.098';
requires 'JSON', '4.11';
requires 'Try::Tiny',           '0.32';
requires 'Config::Simple',      '4.58';
requires 'Test::MockModule', 'v0.183.0';
requires 'Test::MockObject',    '1.20200122';
requires 'Readonly', '2.05';

on 'test' => sub {
    requires 'Test::MockModule', 'v0.183.0';
    requires 'Test::MockObject',    '1.20200122';
};