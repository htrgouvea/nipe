<p align="center">
  <img src="https://heitorgouvea.me/images/projects/nipe/logo.png">
  <p align="center">An engine to make Tor Network your default gateway.</p>

  <p align="center">
    <a href="/LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/nipe/releases">
      <img src="https://img.shields.io/badge/version-0.9.4-blue.svg">
    </a>
    <a href="https://github.com/GouveaHeitor/nipe/graphs/contributors">
      <img src="https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square">
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
  $ git clone https://github.com/GouveaHeitor/nipe && cd nipe
    
  # Install libs and dependencies
  $ sudo cpan install Try::Tiny Config::Simple JSON

  # Nipe must be run as root
  $ perl nipe.pl install
```
---

### Commands:
```bash
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

### Contribution

- Your contributions and suggestions are heartily ♥ welcome. [See here the contribution guidelines.](/.github/CONTRIBUTING.md) Please, report bugs via [issues page](https://github.com/GouveaHeitor/nipe/issues) and for security issues see here the [security policy.](/SECURITY.md) (✿ ◕‿◕) This project follows the best practices defined by this [style guide](https://heitorgouvea.me/projects/perl-style-guide).

---

### License

- This work is licensed under [MIT License.](/LICENSE.md)

### Contributors

Thanks goes to these wonderful people:

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/omatron"><img src="https://avatars0.githubusercontent.com/u/24454511?v=4" width="100px;" alt=""/><br /><sub><b>omatron</b></sub></a><br /><a href="https://github.com/GouveaHeitor/nipe/commits?author=omatron" title="Documentation">📖</a></td>
    <td align="center"><a href="https://security.care/"><img src="https://avatars3.githubusercontent.com/u/233977?v=4" width="100px;" alt=""/><br /><sub><b>Slavik Svyrydiuk</b></sub></a><br /><a href="https://github.com/GouveaHeitor/nipe/commits?author=sv0" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
