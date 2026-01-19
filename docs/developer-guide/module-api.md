# Module API Reference

This document provides detailed API documentation for all Nipe modules.

## Table of Contents

- [Core Engine Modules](#core-engine-modules)
  - [Nipe::Component::Engine::Start](#nipecomponentenginestart)
  - [Nipe::Component::Engine::Stop](#nipecomponentenginestop)
- [Utility Modules](#utility-modules)
  - [Nipe::Component::Utils::Device](#nipecomponentutilsdevice)
  - [Nipe::Component::Utils::Status](#nipecomponentutilsstatus)
  - [Nipe::Component::Utils::Helper](#nipecomponentutilshelper)
- [Network Modules](#network-modules)
  - [Nipe::Network::Install](#nipenetworkinstall)
  - [Nipe::Network::Restart](#nipenetworkrestart)

---

## Core Engine Modules

### Nipe::Component::Engine::Start

Routes all system traffic through the Tor network by configuring iptables rules and starting the Tor daemon.

#### Synopsis

```perl
use Nipe::Component::Engine::Start;

my $result = Nipe::Component::Engine::Start->new();
if ($result == 1) {
    print "Tor routing started successfully\n";
}
else {
    print "Failed to start: $result\n";
}
```

#### Methods

##### new()

Starts Tor routing.

**Parameters:** None

**Returns:**
- `1` - Success, Tor routing is active
- `0` - Failed to start Tor routing
- String - Error or status message from Status module

**Process:**
1. Stops any existing Tor routing
2. Detects system distribution
3. Configures Tor daemon with distribution-specific settings
4. Starts Tor service
5. Applies iptables NAT rules for DNS and TCP redirection
6. Applies iptables filter rules for traffic control
7. Blocks non-DNS UDP and ICMP traffic
8. Applies IPv6 rules when available
9. Verifies connectivity through Tor

**Dependencies:**
- `Nipe::Component::Engine::Stop`
- `Nipe::Component::Utils::Device`
- `Nipe::Component::Utils::Status`

**System Requirements:**
- Root privileges
- iptables installed
- Tor installed
- Tor configuration file in `.configs/[distribution]-torrc`

#### Configuration

**Ports Used:**
```perl
$dns_port      = '9061';  # Tor DNS resolver
$transfer_port = '9051';  # Tor TransPort (transparent proxy)
```

**IPTables Rules Applied:**

**NAT Table:**
- Accepts established connections
- Accepts traffic from Tor user
- Redirects DNS (port 53) to Tor DNS port (9061)
- Returns traffic to local networks (127.0.0.1/8, 192.168.0.0/16, 172.16.0.0/12, 10.0.0.0/8)
- Redirects all other TCP to Tor TransPort (9051)

**Filter Table:**
- Same as NAT but with ACCEPT/REJECT instead of REDIRECT/RETURN
- Rejects non-DNS UDP traffic
- Rejects all ICMP traffic

**IPv6 Handling:**
`ip6tables` rules mirror the IPv4 routing rules when IPv6 is available.

#### Example Usage

```perl
use Nipe::Component::Engine::Start;
use Try::Tiny;

try {
    my $result = Nipe::Component::Engine::Start->new();

    if ($result == 1) {
        print "Successfully started Tor routing\n";
    }
    elsif ($result =~ /true/) {
        print "Tor is active:\n$result";
    }
    else {
        warn "Failed to verify Tor connectivity: $result";
    }
}
catch {
    die "Error starting Tor: $_\n";
};
```

#### Version

- **Current:** 0.0.5
- **Location:** `lib/Nipe/Component/Engine/Start.pm`

---

### Nipe::Component::Engine::Stop

Stops Tor routing and removes all iptables rules, restoring normal network connectivity.

#### Synopsis

```perl
use Nipe::Component::Engine::Stop;

my $result = Nipe::Component::Engine::Stop->new();
```

#### Methods

##### new()

Stops Tor routing and cleans up iptables rules.

**Parameters:** None

**Returns:**
- `1` - Success

**Process:**
1. Detects system distribution
2. Flushes iptables OUTPUT chain for NAT table
3. Flushes iptables OUTPUT chain for Filter table
4. Stops Tor daemon using distribution-appropriate command

**Dependencies:**
- `Nipe::Component::Utils::Device`

**System Requirements:**
- Root privileges
- iptables installed

#### Distribution-Specific Behavior

**Void Linux:**
```bash
sv stop tor > /dev/null
```

**Systems with /etc/init.d/tor:**
```bash
/etc/init.d/tor stop > /dev/null
```

**Default (systemd):**
```bash
systemctl stop tor
```

#### Important Notes

⚠️ **Warning:** Stopping Nipe flushes **all** OUTPUT rules in both NAT and Filter tables, not just Nipe-specific rules. If you have existing iptables rules, they will be removed.

#### Example Usage

```perl
use Nipe::Component::Engine::Stop;

my $result = Nipe::Component::Engine::Stop->new();
if ($result) {
    print "Tor routing stopped successfully\n";
}
```

#### Version

- **Current:** 0.0.2
- **Location:** `lib/Nipe/Component/Engine/Stop.pm`

---

## Utility Modules

### Nipe::Component::Utils::Device

Detects the Linux distribution and returns appropriate configuration for Tor username and package management.

#### Synopsis

```perl
use Nipe::Component::Utils::Device;

my %device = Nipe::Component::Utils::Device->new();
print "Distribution: $device{distribution}\n";
print "Tor User: $device{username}\n";
```

#### Methods

##### new()

Detects Linux distribution and returns configuration.

**Parameters:** None

**Returns:** Hash with keys:
```perl
{
    username     => 'debian-tor',  # Tor service user
    distribution => 'debian',      # Distribution identifier
}
```

**Detection Method:**
- Parses `/etc/os-release` file
- Checks `ID_LIKE` and `ID` fields
- Matches against known patterns

#### Supported Distributions

| Pattern Match | Tor Username | Distribution ID | Package Manager |
|--------------|--------------|-----------------|-----------------|
| Fedora | toranon | fedora | dnf |
| Arch | tor | arch | pacman |
| Void | tor | void | xbps-install |
| Suse, OpenSuse | tor | opensuse | zypper |
| Default | debian-tor | debian | apt-get |

#### Detection Algorithm

```perl
my @distributions = (
    {
        pattern      => qr/[F,f]edora/xsm,
        username     => 'toranon',
        distribution => 'fedora',
    },
    # ... more patterns ...
);

for my $distro (@distributions) {
    if (($id_like =~ $distro->{pattern}) || ($id_distro =~ $distro->{pattern})) {
        return %device;
    }
}

# Default if no match
return (
    username     => 'debian-tor',
    distribution => 'debian'
);
```

#### Example Usage

```perl
use Nipe::Component::Utils::Device;

my %device = Nipe::Component::Utils::Device->new();

if ($device{distribution} eq 'fedora') {
    print "Running on Fedora with user: $device{username}\n";
}

# Use in system commands
system "iptables -m owner --uid $device{username} -j ACCEPT";
```

#### Version

- **Current:** 0.0.4
- **Location:** `lib/Nipe/Component/Utils/Device.pm`

---

### Nipe::Component::Utils::Status

Checks if traffic is successfully routed through the Tor network.

#### Synopsis

```perl
use Nipe::Component::Utils::Status;

my $status = Nipe::Component::Utils::Status->new();
print $status;
```

#### Methods

##### new()

Queries Tor Project API to verify Tor connectivity.

**Parameters:** None

**Returns:** String message:

**Success:**
```
[+] Status: true
[+] Ip: xxx.xxx.xxx.xxx
```

**Failure:**
```
[!] ERROR: sorry, it was not possible to establish a connection to the server.
```

**Implementation:**
1. Makes HTTP GET request to `https://check.torproject.org/api/ip`
2. Parses JSON response
3. Extracts `IsTor` and `IP` fields
4. Formats output string

#### API Response Format

```json
{
    "IsTor": true,
    "IP": "xxx.xxx.xxx.xxx"
}
```

#### Dependencies

**Perl Modules:**
- `JSON` - Parse API response
- `HTTP::Tiny` - HTTP client
- `Readonly` - Define constants

#### Constants

```perl
Readonly my $SUCCESS_CODE => 200;
```

#### Example Usage

```perl
use Nipe::Component::Utils::Status;

my $status = Nipe::Component::Utils::Status->new();

if ($status =~ /true/) {
    print "Tor is active!\n";
    print $status;
}
else {
    warn "Tor is not active or connection failed\n";
}
```

#### Error Handling

Returns error message if:
- Network connectivity issues
- Tor Project API is unreachable
- HTTP status code is not 200
- Invalid JSON response

#### Version

- **Current:** 0.0.4
- **Location:** `lib/Nipe/Component/Utils/Status.pm`

---

### Nipe::Component::Utils::Helper

Displays command-line help information.

#### Synopsis

```perl
use Nipe::Component::Utils::Helper;

print Nipe::Component::Utils::Helper->new();
```

#### Methods

##### new()

Returns formatted help text.

**Parameters:** None

**Returns:** String containing help text

**Output Format:**
```
Core Commands
==============
    Command       Description
    -------       -----------
    install       Install dependencies
    start         Start routing
    stop          Stop routing
    restart       Restart the Nipe circuit
    status        See status
```

#### Implementation

Uses indented here-doc for clean output:

```perl
return <<~'END_HELP';
    Core Commands
    ==============
        Command       Description
        -------       -----------
        install       Install dependencies
        start         Start routing
        stop          Stop routing
        restart       Restart the Nipe circuit
        status        See status
    END_HELP
```

#### Example Usage

```perl
use Nipe::Component::Utils::Helper;

# Display help
my $help = Nipe::Component::Utils::Helper->new();
print $help;

# Or directly
print Nipe::Component::Utils::Helper->new();
```

#### Version

- **Current:** 0.0.3
- **Location:** `lib/Nipe/Component/Utils/Helper.pm`

---

## Network Modules

### Nipe::Network::Install

Installs required system packages (Tor and iptables) based on detected distribution.

#### Synopsis

```perl
use Nipe::Network::Install;

my $result = Nipe::Network::Install->new();
```

#### Methods

##### new()

Installs Tor and iptables packages.

**Parameters:** None

**Returns:**
- `1` - Success
- `0` - Failure

**Process:**
1. Detects distribution using Device module
2. Executes appropriate package manager command
3. Stops any existing Tor routing
4. Returns status

**Dependencies:**
- `Nipe::Component::Utils::Device`
- `Nipe::Component::Engine::Stop`

**System Requirements:**
- Root privileges
- Internet connectivity
- Working package manager

#### Installation Commands

```perl
my %install = (
    debian   => 'apt-get install -y tor iptables',
    fedora   => 'dnf install -y tor iptables',
    void     => 'xbps-install -y tor iptables',
    arch     => 'pacman -S --noconfirm tor iptables',
    opensuse => 'zypper install -y tor iptables',
);
```

#### Example Usage

```perl
use Nipe::Network::Install;
use Try::Tiny;

try {
    my $result = Nipe::Network::Install->new();

    if ($result) {
        print "Dependencies installed successfully\n";
    }
    else {
        die "Installation failed\n";
    }
}
catch {
    die "Error during installation: $_\n";
};
```

#### Notes

- Uses non-interactive flags for all package managers
- Stops any running Tor routing after installation

#### Version

- **Current:** 0.0.3
- **Location:** `lib/Nipe/Network/Install.pm`

---

### Nipe::Network::Restart

Restarts the Tor circuit by stopping and starting routing, providing a new Tor identity.

#### Synopsis

```perl
use Nipe::Network::Restart;

my $result = Nipe::Network::Restart->new();
```

#### Methods

##### new()

Restarts Tor routing to get a new circuit/identity.

**Parameters:** None

**Returns:**
- `1` - Success (both stop and start succeeded)
- `0` - Failure (stop or start failed)

**Process:**
1. Calls `Nipe::Component::Engine::Stop->new()`
2. If successful, calls `Nipe::Component::Engine::Start->new()`
3. Returns combined status

**Dependencies:**
- `Nipe::Component::Engine::Stop`
- `Nipe::Component::Engine::Start`

#### Use Cases

- Get a new Tor exit node/IP address
- Refresh Tor circuit
- Recover from Tor connectivity issues
- Change identity during session

#### Example Usage

```perl
use Nipe::Network::Restart;

my $result = Nipe::Network::Restart->new();

if ($result) {
    print "Tor circuit restarted successfully\n";
    print "You now have a new Tor identity\n";
}
else {
    warn "Failed to restart Tor circuit\n";
}
```

#### Implementation

```perl
sub new {
    my $stop = Nipe::Component::Engine::Stop->new();

    if ($stop) {
        my $start = Nipe::Component::Engine::Start->new();

        if ($start) {
            return 1;
        }
    }

    return 0;
}
```

#### Version

- **Current:** 0.0.1
- **Location:** `lib/Nipe/Network/Restart.pm`

---

## Common Patterns

### Error Handling Pattern

All modules should follow this pattern:

```perl
use Try::Tiny;

try {
    my $result = Module->new();
    handle_success($result);
}
catch {
    handle_error($_);
};
```

### Root Privilege Check

Required for system operations:

```perl
use English '-no_match_vars';

if ($REAL_USER_ID != 0) {
    die "Must be run as root\n";
}
```

### Module Return Values

Standard return conventions:
- `1` = Success
- `0` = Failure
- String = Status message or error
- Hash = Configuration data

### Object Construction

All modules use class method `new()`:

```perl
my $result = Module->new();
```

Not instance-based - modules are stateless utilities.

## Testing Modules

### Unit Testing Example

```perl
use Test::More;
use Nipe::Component::Utils::Device;

# Test device detection
my %device = Nipe::Component::Utils::Device->new();
ok(exists $device{username}, 'Username defined');
ok(exists $device{distribution}, 'Distribution defined');
ok($device{username} =~ /^[a-z-]+$/, 'Valid username format');

done_testing();
```

### Integration Testing

```bash
# Test start/stop cycle
sudo perl -e 'use lib "./lib"; use Nipe::Component::Engine::Start; Nipe::Component::Engine::Start->new()'
sudo perl -e 'use lib "./lib"; use Nipe::Component::Utils::Status; print Nipe::Component::Utils::Status->new()'
sudo perl -e 'use lib "./lib"; use Nipe::Component::Engine::Stop; Nipe::Component::Engine::Stop->new()'
```

## Module Dependencies Graph

```
nipe.pl
├─→ Nipe::Component::Engine::Start
│   ├─→ Nipe::Component::Engine::Stop
│   ├─→ Nipe::Component::Utils::Device
│   └─→ Nipe::Component::Utils::Status
│       └─→ (HTTP::Tiny, JSON, Readonly)
├─→ Nipe::Component::Engine::Stop
│   └─→ Nipe::Component::Utils::Device
├─→ Nipe::Component::Utils::Status
├─→ Nipe::Component::Utils::Helper
├─→ Nipe::Network::Install
│   ├─→ Nipe::Component::Utils::Device
│   └─→ Nipe::Component::Engine::Stop
└─→ Nipe::Network::Restart
    ├─→ Nipe::Component::Engine::Stop
    └─→ Nipe::Component::Engine::Start
```

## Future API Considerations

### Planned Enhancements

- Configurable Tor ports
- Custom exit node selection
- Bridge support
- Status check customization

### Backward Compatibility

- All modules maintain semantic versioning
- Breaking changes will increment major version
- Deprecated features will be marked clearly

## Contributing

When adding or modifying modules:
1. Follow existing code style and patterns in the codebase
2. Update this API documentation
3. Add usage examples
4. Test on multiple distributions
5. Update version numbers
