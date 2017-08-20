# Nipe

[![MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/GouveaHeitor/nipe/blob/master/LICENSE.md)
[![Version-Program](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/GouveaHeitor/nipe/releases)

![Imagem](http://i.imgur.com/1XjfHPb.png)

```
    [+] AUTOR:        Heitor Gouvêa
    [+] SITE:         http://heitorgouvea.me
    [+] EMAIL:        hi@heitorgouvea.me
    [+] GITHUB:       https://github.com/GouveaHeitor
    [+] TELEGRAM:     @GouveaHeitor
```

[**See the tutorial on how to use the Nipe**](https://medium.com/@gouveaheitor/nipe-script-to-redirect-all-traffic-from-the-machine-to-the-tor-network-5f01a083fc80)

#### How it works

    Tor enables users to surf the Internet, chat and send instant messages
    anonymously,  and is used by a wide variety of people for both Licit and
    Illicit purposes. Tor has, for example, been used by criminals enterprises,
    Hacktivism groups, and law enforcement  agencies at cross purposes, sometimes
    simultaneously.

    Nipe is a Script to make Tor Network your Default Gateway.

    This Perl Script enables you to directly route all your traffic from your
    computer to the Tor Network through which you can surf the Internet Anonymously
    without having to worry about being tracked or traced back.

#### Download and install:
```
    git clone https://github.com/GouveaHeitor/nipe
    cd nipe
    cpan install Switch JSON LWP::UserAgent
```

#### Commands:
```
    COMMAND          FUNCTION
    install          Install dependencies
    start            Start routing
    stop             Stop routing
    status           See status

    Examples:

    perl nipe.pl install
    perl nipe.pl start
    perl nipe.pl stop
    perl nipe.pl status
```

#### Bugs

- Report bugs in my email: **hi@heitorgouvea.me**

#### License

- This work is licensed under [**MIT License**](https://github.com/GouveaHeitor/nipe/blob/master/LICENSE.md)

#### Contribution

- Your contributions and suggestions are heartily♥ welcome. (✿◕‿◕)
