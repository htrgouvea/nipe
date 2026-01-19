# Developer Guide: Getting Started

## Development Environment Setup

### Prerequisites

- **Perl**: Version 5.30 or higher
- **CPAN/cpanm**: For managing Perl dependencies
- **Git**: For version control
- **Linux**: Debian, Ubuntu, Fedora, Arch, Void, or OpenSUSE
- **Root Access**: Required for testing iptables and Tor

### Clone and Setup

```bash
# Clone the repository
git clone https://github.com/htrgouvea/nipe
cd nipe

# Install Perl dependencies
cpanm --installdeps .

# Install system dependencies (Tor, iptables)
sudo perl nipe.pl install
```

### Dependencies Overview

#### Perl Modules (cpanfile)

```perl
requires "Net::SSL", "2.86";
requires "IO::Socket::SSL", "2.095";
requires "JSON", "4.10";
requires "Try::Tiny", "0.32";
requires "Config::Simple", "4.58";
requires "Readonly", "2.02";
requires "Test::MockModule", "0.180.0";
requires "Test::MockObject", "1.20200122";
```

#### System Packages

- **tor**: The Tor anonymity network daemon
- **iptables**: Linux firewall and routing tool

## Project Structure

```
nipe/
├── nipe.pl                          # Main entry point
├── lib/                             # Perl modules
│   └── Nipe/
│       ├── Component/               # Core components
│       │   ├── Engine/             # Routing engine
│       │   │   ├── Start.pm       # Start Tor routing
│       │   │   └── Stop.pm        # Stop Tor routing
│       │   └── Utils/             # Utility modules
│       │       ├── Device.pm      # Distribution detection
│       │       ├── Status.pm      # Status checking
│       │       └── Helper.pm      # Help text
│       └── Network/               # Network operations
│           ├── Install.pm         # Install dependencies
│           └── Restart.pm         # Restart circuit
├── .configs/                       # Tor configuration files
│   ├── debian-torrc
│   ├── fedora-torrc
│   ├── arch-torrc
│   └── [distribution]-torrc
├── docs/                          # Documentation
│   ├── overview.md
│   ├── architecture.md
│   └── developer-guide/
│       ├── getting-started.md
│       └── module-api.md
├── cpanfile                       # Perl dependencies
├── Dockerfile                     # Docker configuration
├── .perlcriticrc                 # Perl::Critic configuration
└── README.md                     # Project README
```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Changes

Edit code following the existing style in the codebase.

### 3. Test Your Changes

```bash
# Check syntax
perl -c nipe.pl
perl -c lib/Nipe/Component/Engine/Start.pm

# Run Perl::Critic (code quality)
perlcritic nipe.pl lib/

# Test functionality (requires root)
sudo perl nipe.pl start
sudo perl nipe.pl status
sudo perl nipe.pl stop
```

### 4. Commit Changes

```bash
git add .
git commit -m "feat: add new feature"
```

Follow [Conventional Commits](https://www.conventionalcommits.org/) format:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style/formatting
- `refactor:` - Code refactoring
- `test:` - Adding/updating tests
- `chore:` - Maintenance tasks

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## Testing

### Manual Testing

Test all commands on your target distribution:

```bash
# Install (clean system)
sudo perl nipe.pl install

# Start routing
sudo perl nipe.pl start

# Verify status
sudo perl nipe.pl status
# Expected: Status: true, IP: [Tor exit node IP]

# Restart circuit
sudo perl nipe.pl restart

# Verify new IP
sudo perl nipe.pl status
# Expected: Different IP than before

# Stop routing
sudo perl nipe.pl stop

# Verify stopped
sudo perl nipe.pl status
# Expected: Status: false, IP: [Your real IP]
```

### Testing on Multiple Distributions

Use Docker to test on different distributions:

```bash
# Build container
docker build -t nipe .

# Run tests
docker run -it --privileged --cap-add=NET_ADMIN nipe bash
```

### Code Quality Checks

```bash
# Perl syntax check
find lib -name "*.pm" -exec perl -c {} \;

# Perl::Critic (static analysis)
perlcritic --severity 1 nipe.pl lib/

# Check specific file
perlcritic lib/Nipe/Component/Engine/Start.pm
```

## Debugging

### Enable Verbose Mode

Add debugging statements:

```perl
use Data::Dumper;
print Dumper($variable);
```

### Check IPTables Rules

```bash
# View current rules
sudo iptables -t nat -L OUTPUT -v -n
sudo iptables -t filter -L OUTPUT -v -n

# Monitor rule application
watch -n 1 'sudo iptables -t nat -L OUTPUT -v -n'
```

### Check Tor Service

```bash
# Service status
sudo systemctl status tor

# Tor logs
sudo journalctl -u tor -f

# Or for traditional systems
sudo tail -f /var/log/tor/log
```

### Network Debugging

```bash
# Check if traffic goes through Tor
curl https://check.torproject.org/api/ip

# DNS resolution test
nslookup example.com

# Check listening ports
sudo netstat -tlnp | grep tor
```

## Common Development Tasks

### Adding Support for New Distribution

1. **Update Device Detection** (`lib/Nipe/Component/Utils/Device.pm`):

```perl
my @distributions = (
    # ... existing entries ...
    {
        pattern      => qr/[Y,y]our[D,d]istro/xsm,
        username     => 'tor',
        distribution => 'yourdistro',
    },
);
```

2. **Add Package Manager** (`lib/Nipe/Network/Install.pm`):

```perl
my %install = (
    # ... existing entries ...
    yourdistro => 'your-pkg-manager install -y tor iptables',
);
```

3. **Create Tor Config** (`.configs/yourdistro-torrc`):

```
VirtualAddrNetwork 10.66.0.0/10
AutomapHostsOnResolve 1
TransPort 9051
DNSPort 9061
```

4. **Test Installation and Routing**:

```bash
sudo perl nipe.pl install
sudo perl nipe.pl start
sudo perl nipe.pl status
```

### Adding a New Command

1. **Create Module** (`lib/Nipe/Component/YourNamespace/YourCommand.pm`):

```perl
package Nipe::Component::YourNamespace::YourCommand {
    use strict;
    use warnings;

    our $VERSION = '0.0.1';

    sub new {
        # Your implementation
        return 1; # or status string
    }
}

1;
```

2. **Register Command** (`nipe.pl`):

```perl
my $commands = {
    # ... existing commands ...
    yourcommand => 'Nipe::Component::YourNamespace::YourCommand',
};
```

3. **Update Help** (`lib/Nipe/Component/Utils/Helper.pm`):

```perl
return <<~'END_HELP';
    Core Commands
    ==============
        yourcommand   Your command description
    END_HELP
```

### Modifying IPTables Rules

Edit `lib/Nipe/Component/Engine/Start.pm`:

```perl
# Example: Add new rule
system "iptables -t nat -A OUTPUT -p tcp --dport 8080 -j REDIRECT --to-ports $transfer_port";
```

Always test thoroughly:
- Apply rules: `sudo perl nipe.pl start`
- Verify rules: `sudo iptables -t nat -L OUTPUT -v -n`
- Test connectivity: `curl -v http://example.com:8080`
- Clean up: `sudo perl nipe.pl stop`

## Troubleshooting Development Issues

### Module Not Found

```bash
# Check @INC paths
perl -e 'print join("\n", @INC)'

# Verify lib/ directory structure
find lib -name "*.pm"

# Test module loading
perl -I./lib -MNipe::Component::Engine::Start -e 'print "OK\n"'
```

### IPTables Permission Denied

```bash
# Ensure running as root
sudo perl nipe.pl start

# Check capabilities (Docker)
docker run --cap-add=NET_ADMIN ...
```

### Tor Won't Start

```bash
# Check Tor configuration
tor -f .configs/debian-torrc --verify-config

# Check port conflicts
sudo netstat -tlnp | grep -E '(9050|9051|9061)'

# Reset Tor
sudo systemctl restart tor
```

## Resources

- **Perl Documentation**: https://perldoc.perl.org/
- **Tor Project**: https://www.torproject.org/
- **IPTables Guide**: https://www.netfilter.org/documentation/
- **Perl Best Practices**: Review `.perlcriticrc` for coding standards

## Getting Help

- **Issues**: https://github.com/htrgouvea/nipe/issues
- **Discussions**: GitHub Discussions
- **Contributing**: See [CONTRIBUTING.md](/.github/CONTRIBUTING.md)
- **Security**: See [SECURITY.md](/SECURITY.md)
