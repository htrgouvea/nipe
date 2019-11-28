requires 'JSON',            '>= 4.02';
requires 'Switch',          '>= 2.17';
requires 'LWP::UserAgent',  '>= 6.43';
requires 'Config::Simple',  '>= 4.58';

on 'develop' => sub {
  requires 'Carton';
  requires 'Data::Dumper';
};

on 'build' => sub {
  requires 'Carton';
  requires 'App::FatPacker';
};
