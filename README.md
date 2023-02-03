<p align="center">
  <img src="https://heitorgouvea.me/images/projects/nipe/logo.png">
  <p align="center">An engine to make Tor Network your default gateway.</p>
  <p align="center">
    <a href="/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/htrgouvea/nipe/releases">
      <img src="https://img.shields.io/badge/version-0.9.6-blue.svg">
    </a>
  </p>
</p>

---

### Summary

The Tor project allows users to surf the Internet, chat and send instant messages anonymously through its own mechanism. 
It is used by a wide variety of people, companies and organizations, both for lawful activities and for other illicit purposes. Tor has been largely used by intelligence agencies, hacking groups, criminal activities and even ordinary users who care about their privacy in the digital world.
  
Nipe is an engine, developed in Perl, that aims on making the Tor network your default network gateway. Nipe can route the traffic from your machine to the Internet through Tor network, so you can surf the Internet having a more formidable stance on privacy and anonymity in cyberspace.
  
Currently, only IPv4 is supported by Nipe, but we are working on a solution that adds IPv6 support. Also, 
only traffic other than DNS requests destined for local and/or loopback addresses is not trafficked through Tor. 
All non-local UDP/ICMP traffic is also blocked by the Tor project.

---

### Download and install

```bash
  # Download
  $ git clone https://github.com/htrgouvea/nipe && cd nipe
    
  # Install libs and dependencies
  $ cpanm --installdeps .

  # Nipe must be run as root
  $ perl nipe.pl install
```
---

### Commands:
```
  COMMAND          FUNCTION
  install          Install dependencies
  start            Start routing
  stop             Stop routing
  restart          Restart the Nipe circuit
  status           See status

  Examples:

  perl nipe.pl install
  perl nipe.pl start
  perl nipe.pl stop
  perl nipe.pl restart
  perl nipe.pl status
```

---

### Demo

![Image](https://heitorgouvea.me/images/projects/nipe/demo.gif)

---

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page](https://github.com/htrgouvea/nipe/issues) and for security issues, see here the [security policy.](/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).

- If you are interested in providing financial support to this project, please visit: [heitorgouvea.me/donate](https://heitorgouvea.me/donate)

---

### License

- This work is licensed under [MIT License.](/LICENSE.md)