FROM perl:5.20
MAINTAINER  Heitor Gouvêa hi@heitorgouvea.me

COPY . /usr/src/nipe
WORKDIR /usr/src/nipe

EXPOSE 9051 9061

RUN cpan install Switch 

# IO::Socket::SSL HTTP::Request LWP::UserAgent LWP::Protocol::https 
# JSON
# Config::Simple

RUN perl nipe.pl install

# CMD [ "perl", "./perl nipe.pl start" ]
# CMD [ "perl", "./perl nipe.pl status" ]

# docker build --rm --squash -t nipe .
# docker run -p 9051:9051 -p 9061:9061 -ti nipe /bin/bash
# docker stop nipe
# docker rm nipe