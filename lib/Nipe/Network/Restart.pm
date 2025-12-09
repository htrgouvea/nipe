package Nipe::Network::Restart {
    use strict;
    use warnings;
    use Nipe::Component::Engine::Stop;
    use Nipe::Component::Engine::Start;

    our $VERSION = '0.0.1';

    sub new {
        my $stop = Nipe::Component::Engine::Stop -> new();

        if ($stop) {
            my $start = Nipe::Component::Engine::Start -> new();

            if ($start) {
                return 1;
            }
        }

        return 0;
    }
}

1;