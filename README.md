<p align="center">
  <img src="https://heitorgouvea.me/images/projects/nipe/logo.png">
  <p align="center">A engine to make Tor Network your default gateway.</p>

  <p align="center">
    <a href="/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/nipe/releases">
      <img src="https://img.shields.io/badge/version-0.9.1-blue.svg">
    </a>
  </p>
</p>

---


### How it works
```
  The Tor project allows users to surf the Internet, chat and send instant messages anonymously 
  through its own mechanism. It is used by a wide variety of people, companies and organizations, 
  both for lawful activities and for other illicit purposes. Tor is already gone and is used for 
  example by criminal companies, hacking groups, intelligence agencies and even ordinary users who care
  about privacy in the digital world. 
  
  Nipe is a engine, developed in Perl, that aims to make the Tor network your default network gateway. 
  Through Nipe, we can directly route traffic from our computer to the Tor network through which you can 
  surf the Internet having a more formidable stance on privacy and anonymity in cyberspace.
  
  Currently, only IPv4 is supported by Nipe, but we are working on a solution to add IPv6 support. 
  Also, only traffic other than DNS requests destined for local and/or loopback addresses is not 
  trafficked through the Tor. All non-local UDP/ICMP traffic is also blocked by the Tor project.
```


### Download and install:
```bash
  # Download
  $ git clone https://github.com/GouveaHeitor/nipe
  $ cd nipe
    
  # Install libs and dependencies
  $ sudo cpan install Switch JSON Config::Simple
  $ perl nipe.pl install
```

### Commands:
```bash
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

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page.](https://github.com/GouveaHeitor/nipe/issues) See here the [security policy.](/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).


### License

- This work is licensed under [MIT License.](/LICENSE.md)
