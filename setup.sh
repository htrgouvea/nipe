#!/usr/bin/env bash

curl -L https://cpanmin.us | perl - --sudo App::cpanminus
cpanm Switch JSON LWP::UserAgent Config::Simple
perl nipe.pl install