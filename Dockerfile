FROM ubuntu:latest

COPY . /usr/src/nipe
WORKDIR /usr/src/nipe

EXPOSE 9050

RUN apt-get update && \
    apt-get install -y cpanminus && \
    rm -rf /var/lib/apt/lists/*

RUN cpanm --installdeps .
RUN perl nipe.pl install