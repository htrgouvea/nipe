FROM debian:bookworm-slim

WORKDIR /usr/src/nipe
COPY . .

EXPOSE 9050 9061

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    cpanminus \
    tor \
    iptables \
    libssl-dev \
    libnet-ssleay-perl \
    libcrypt-ssleay-perl \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/tor/torrc.d \
 && printf "SocksPort 0.0.0.0:9050\nControlPort 0.0.0.0:9061\n" > /etc/tor/torrc.d/nipe.conf

RUN cpanm --notest --installdeps .

RUN chmod +x nipe.pl

ENTRYPOINT ["/bin/bash"]
