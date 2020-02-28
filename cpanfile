requires 'JSON';
requires 'File::Which';
requires 'Config::Simple';
requires 'HTTP::Tiny';

on 'test' => sub {
  requires 'Test::More';
};

on 'develop' => sub {
  requires 'DDP';
  recommends 'Carton';
};
