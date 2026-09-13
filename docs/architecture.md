# Nipe Architecture

## System Architecture

Nipe follows a modular architecture with clear separation of concerns between components, network operations, and utilities.

```
nipe.pl (Entry Point)
    │
    ├── Nipe::Component::Engine::*    (Core Routing Logic)
    │   ├── Start                      (Configure & start Tor routing)
    │   └── Stop                       (Remove routing & stop Tor)
    │
    ├── Nipe::Component::Utils::*      (Utilities)
    │   ├── Device                     (Detect Linux distribution)
    │   ├── Status                     (Check Tor connectivity)
    │   └── Helper                     (Display help information)
    │
    └── Nipe::Network::*               (Network Operations)
        ├── Install                    (Install Tor & iptables)
        └── Restart                    (Restart Tor circuit)
```

## Module Organization

### Core Namespaces

#### `Nipe::Component::Engine::*`
Contains the core routing engine that manages iptables rules and Tor service.

- **Start**: Configures iptables and starts Tor routing
- **Stop**: Cleans up iptables rules and stops Tor service

#### `Nipe::Component::Utils::*`
Utility modules for system detection, status checking, and user interface.

- **Device**: Detects the Linux distribution and returns appropriate configuration
- **Status**: Checks if traffic is successfully routed through Tor
- **Helper**: Provides command-line help text

#### `Nipe::Network::*`
High-level network operations that combine multiple components.

- **Install**: Installs required packages (Tor, iptables)
- **Restart**: Restarts the Tor circuit (stop + start)

## Component Details

### Entry Point: nipe.pl

The main script handles:
- Command-line argument parsing
- Root privilege verification
- Command dispatch to appropriate modules
- Error handling with Try::Tiny

```perl
Commands Mapping:
    start   => Nipe::Component::Engine::Start
    stop    => Nipe::Component::Engine::Stop
    status  => Nipe::Component::Utils::Status
    restart => Nipe::Network::Restart
    install => Nipe::Network::Install
    help    => Nipe::Component::Utils::Helper
```

### Nipe::Component::Engine::Start

**Purpose**: Configure the system to route all traffic through Tor.

**Operations**:
1. Stops any existing Tor routing (calls Stop)
2. Detects Linux distribution
3. Configures Tor with distribution-specific settings
4. Starts Tor daemon
5. Applies iptables rules for traffic redirection
6. Applies IPv6 rules when available
7. Verifies Tor connectivity

**IPTables Rules Applied**:
- NAT table rules for DNS and TCP redirection
- Filter table rules for established connections
- Blocks non-DNS UDP and ICMP traffic
- Exempts local/private network ranges

**Port Configuration**:
- DNS Port: 9061 (Tor DNS resolver)
- Transfer Port: 9051 (Tor TransPort)
- DNS Redirect: Port 53 → 9061

### Nipe::Component::Engine::Stop

**Purpose**: Remove Tor routing and restore normal networking.

**Operations**:
1. Detects Linux distribution
2. Flushes iptables OUTPUT chain (nat & filter tables)
3. Stops Tor daemon using appropriate init system

**Distribution-Specific Stop Commands**:
- Void Linux: `sv stop tor`
- Systems with /etc/init.d: `/etc/init.d/tor stop`
- Others: `systemctl stop tor`

### Nipe::Component::Utils::Device

**Purpose**: Detect the Linux distribution and return appropriate configuration.

**Detection Method**:
Parses `/etc/os-release` for distribution identification using:
- `ID_LIKE` field (e.g., "debian", "fedora")
- `ID` field (e.g., "ubuntu", "arch")

**Returns**:
```perl
{
    username     => 'debian-tor',  # Tor service user
    distribution => 'debian'       # Package manager type
}
```

**Supported Distributions**:
| Distribution | Tor User    | Package Manager |
|-------------|-------------|-----------------|
| Debian/Ubuntu | debian-tor | apt-get |
| Fedora | toranon | dnf |
| Arch | tor | pacman |
| Void | tor | xbps-install |
| OpenSUSE | tor | zypper |

### Nipe::Component::Utils::Status

**Purpose**: Verify if traffic is routed through Tor network.

**Implementation**:
1. Queries Tor Project's API: `https://check.torproject.org/api/ip`
2. Parses JSON response
3. Checks `IsTor` field
4. Displays current IP address and Tor status

**Success Response**:
```
[+] Status: true
[+] Ip: xxx.xxx.xxx.xxx
```

**Error Response**:
```
[!] ERROR: sorry, it was not possible to establish a connection to the server.
```

### Nipe::Component::Utils::Helper

**Purpose**: Display available commands and usage information.

**Output Format**:
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

### Nipe::Network::Install

**Purpose**: Install Tor and iptables packages.

**Process**:
1. Detects distribution
2. Runs appropriate package manager command
3. Stops any existing Tor routing
4. Returns installation status

**Package Manager Commands**:
```perl
debian    => 'apt-get install -y tor iptables'
fedora    => 'dnf install -y tor iptables'
void      => 'xbps-install -y tor iptables'
arch      => 'pacman -S --noconfirm tor iptables'
opensuse  => 'zypper install -y tor iptables'
```

### Nipe::Network::Restart

**Purpose**: Restart the Tor circuit to get a new identity.

**Process**:
1. Calls `Nipe::Component::Engine::Stop->new()`
2. If successful, calls `Nipe::Component::Engine::Start->new()`
3. Returns success/failure status

## Data Flow

### Start Command Flow

```
User: perl nipe.pl start
    ↓
nipe.pl: Verify root privileges
    ↓
Start->new(): Stop existing routing
    ↓
Device->new(): Detect distribution
    ↓
Start->new(): Configure & start Tor
    ↓
Start->new(): Apply iptables rules
    ↓
Start->new(): Disable IPv6
    ↓
Status->new(): Verify connectivity
    ↓
User: Display status
```

### Stop Command Flow

```
User: perl nipe.pl stop
    ↓
nipe.pl: Verify root privileges
    ↓
Stop->new(): Detect distribution
    ↓
Stop->new(): Flush iptables OUTPUT chains
    ↓
Stop->new(): Stop Tor daemon
    ↓
User: Return success
```

## Configuration Files

### Tor Configuration
Located in `.configs/[distribution]-torrc`

Key settings:
- DNS port configuration
- Transparent proxy configuration
- Exit node policies
- Control port settings

### IPTables Rules

**NAT Table**:
- REDIRECT rules for DNS (53 → 9061)
- REDIRECT rules for TCP (→ 9051)
- RETURN rules for local/private networks

**Filter Table**:
- ACCEPT rules for established connections
- ACCEPT rules for Tor user traffic
- REJECT rules for non-DNS UDP
- REJECT rules for ICMP

## Dependencies

### Perl Modules
- `JSON` - Parse Tor API responses
- `HTTP::Tiny` - HTTP client for status checks
- `Config::Simple` - Parse `/etc/os-release`
- `Try::Tiny` - Error handling
- `Readonly` - Define constants
- `English` - Readable variable names

### System Packages
- `tor` - The Tor daemon
- `iptables` - Firewall/routing tool

### System Requirements
- Perl 5.30 or higher
- Root/sudo privileges
- Linux kernel with iptables support
- Network connectivity

## Security Architecture

### Privilege Requirements
- **Root Access**: Required for iptables and system service management
- **Verification**: Checks `$REAL_USER_ID != 0` before operations

### Traffic Isolation
- Local networks exempt from routing
- Private IP ranges bypass Tor
- DNS-only UDP allowed through Tor
- All other UDP/ICMP blocked

### IPv6 Handling
IPv6 routing rules are applied when `/proc/sys/net/ipv6` is present:
```bash
ip6tables -t nat -A OUTPUT ...
ip6tables -t filter -A OUTPUT ...
```

This mirrors the IPv4 ruleset to route TCP and DNS traffic through Tor.

## Error Handling

All module calls are wrapped in Try::Tiny blocks:
```perl
try {
    my $exec = $commands->{$argument}->new();
    # Handle result
}
catch {
    print "\n[!] ERROR: this command could not be run.\n\n";
};
```

Module methods return:
- `1` for success (Start, Stop, Restart)
- `0` for failure
- Status string for Status and Helper modules

## Extension Points

### Adding New Distributions

1. Update `Nipe::Component::Utils::Device`:
   - Add pattern to `@distributions` array
   - Define Tor username and distribution identifier

2. Update `Nipe::Network::Install`:
   - Add package manager command to `%install` hash

3. Add Tor configuration:
   - Create `.configs/[distribution]-torrc`

### Adding New Commands

1. Create new module in appropriate namespace
2. Implement `new()` method
3. Add command mapping in `nipe.pl`
4. Update help text in `Nipe::Component::Utils::Helper`

## Testing Considerations

Key areas for testing:
- Distribution detection across platforms
- IPTables rule application and cleanup
- Tor service lifecycle management
- Network connectivity verification
- Error handling for missing dependencies
- Root privilege verification
