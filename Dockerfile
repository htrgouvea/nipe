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

RUN cpanm --installdeps .

RUN chmod +x nipe.pl

# docker run -d -it --privileged --cap-add=NET_ADMIN nipe
# OR
# docker run -d -it --name nipe-container --privileged --cap-add=NET_ADMIN nipe
# THEN
# docker exec -it <container_id> ./nipe.pl <command>

ENTRYPOINT ["/bin/bash"]
