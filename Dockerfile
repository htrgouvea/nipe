FROM perl:5.20

COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

CMD [ "perl", "./your-daemon-or-script.pl" ]


RUN sudo curl -L https://cpanmin.us | perl - --sudo App::cpanminus
RUN cpanm Switch Switch IO::Socket::SSL LWP::UserAgent LWP::Protocol::https HTTP::Request LWP::Protocol::https JSON Config::Simple WWW::Mechanize Mojolicious::Lite re::engine::TRE