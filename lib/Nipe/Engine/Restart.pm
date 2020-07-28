package Nipe::Engine::Restart {
    use strict;
    use warnings;
    use Nipe::Engine::Stop;
    use Nipe::Engine::Start;

    sub new {
        my $stop = Nipe::Engine::Stop -> new();

        if ($stop) {
            my $start = Nipe::Engine::Start -> new();

            if ($start) {
                return 1;
            }
        }

        return 0;
    }
}

1;