FROM ubuntu:latest

COPY . /usr/src/nipe
WORKDIR /usr/src/nipe

EXPOSE 9050 9061

RUN apt-get update && \
    apt-get install -y cpanminus && \
    apt-get install -y libssl-dev && \
    apt-get install -y libnet-ssleay-perl && \
    apt-get install -y libcrypt-ssleay-perl && \
    apt-get install -y tor && \
    apt-get install -y iptables && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/tor/torrc.d && \
    printf "SocksPort 0.0.0.0:9050\nControlPort 0.0.0.0:9061\n" > /etc/tor/torrc.d/nipe.conf
    
RUN cpanm --installdeps .

RUN chmod +x nipe.pl

ENTRYPOINT ["/bin/bash"]