FROM perl:5.34

COPY . /usr/src/nipe
WORKDIR /usr/src/nipe

RUN cpanm --installdeps .

ENTRYPOINT [ "perl", "./nipe.pl" ]