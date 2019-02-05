<p align="center">
  <h3 align="center">Nipe</h3>
  <p align="center">A script to make Tor Network your default gateway.</p>

  <p align="center">
    <a href="https://github.com/GouveaHeitor/nipe/blob/master/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/nipe/releases">
      <img src="https://img.shields.io/badge/version-1.0-blue.svg">
    </a>
  </p>
</p>

---

```
    [+] AUTOR:        Heitor Gouvêa
    [+] SITE:         https://heitorgouvea.me
    [+] EMAIL:        hi@heitorgouvea.me
    [+] GITHUB:       https://github.com/GouveaHeitor
    [+] TWITTER:      @GouveaHeitor
```

[**See complete documentation here**](https://heitorgouvea.me/nipe/)

#### How it works

    Tor enables users to surf the internet, chat and send instant messages
    anonymously,  and is used by a wide variety of people for both licit and
    illicit purposes. Tor has, for example, been used by criminals enterprises,
    hacktivism groups, and law enforcement  agencies at cross purposes, sometimes
    simultaneously.

    Nipe is a script to make the Tor network your default gateway.

    This Perl script enables you to directly route all your traffic from your
    computer to the Tor network through which you can surf the internet anonymously
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
    restart          Restart the Nipe process
    status           See status

    Examples:

    perl nipe.pl install
    perl nipe.pl start
    perl nipe.pl stop
    perl nipe.pl restart
    perl nipe.pl status
```

#### Bugs

- Report bugs in my email: **hi@heitorgouvea.me**

#### License

- This work is licensed under [**MIT License**](https://github.com/GouveaHeitor/nipe/blob/master/LICENSE.md)

#### Contribution

- Your contributions and suggestions are heartily♥ welcome. (✿◕‿◕) [**See here the contribution guidelines**](/.github/CONTRIBUTING.md)

#### Disclaimer

I do private jobs, if you are interested send me an e-mail at: **hi@heitorgouvea.me**
