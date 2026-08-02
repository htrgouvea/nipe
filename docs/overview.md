# Nipe Project Overview

## What is Nipe?

Nipe is a Perl-based network gateway engine that routes all system traffic through the Tor network, providing enhanced privacy and anonymity for internet activities. It transforms your default network gateway to use Tor, effectively anonymizing all outbound connections from your machine.

## Key Features

- **Automatic Tor Routing**: Routes all IPv4 traffic through the Tor network
- **System-Wide Anonymity**: All applications benefit from Tor routing without individual configuration
- **Multi-Distribution Support**: Works across major Linux distributions
- **IPTables Integration**: Uses iptables for secure traffic redirection
- **Simple CLI Interface**: Easy-to-use command-line interface for control

## How It Works

Nipe operates by:

1. **Installing Dependencies**: Sets up Tor and iptables on your system
2. **Configuring IPTables**: Creates redirection rules to route traffic through Tor
3. **Managing Tor Service**: Controls the Tor daemon lifecycle
4. **Status Verification**: Checks if your traffic is successfully routed through Tor

### Traffic Flow

```
Application → IPTables Rules → Tor Network → Internet
```

## Supported Platforms

Nipe supports the following Linux distributions:

- Debian/Ubuntu (using `debian-tor` user)
- Fedora (using `toranon` user)
- Arch Linux (using `tor` user)
- Void Linux (using `tor` user)
- OpenSUSE (using `tor` user)

## Network Coverage

### What Gets Routed Through Tor

- All IPv4 TCP traffic
- All IPv4 UDP DNS queries (port 53)
- IPv6 TCP traffic (via `ip6tables`)
- IPv6 UDP DNS queries (port 53) when IPv6 is available

### What Doesn't Get Routed

- Local/loopback addresses (127.0.0.0/8)
- Private networks (192.168.0.0/16, 172.16.0.0/12, 10.0.0.0/8)
- Non-DNS UDP traffic (blocked by Tor)
- ICMP traffic (blocked by Tor)

## Security Considerations

### Important Notes

1. **Root Required**: Nipe requires root privileges to modify iptables and system networking
2. **IPTables Conflicts**: Existing iptables rules may conflict; stopping Nipe removes all OUTPUT rules
3. **IPv6 Handling**: IPv6 is routed via `ip6tables` rules when available
4. **UDP/ICMP Blocked**: Non-DNS UDP and all ICMP traffic is blocked
5. **Local Traffic Exempt**: Traffic to local/private networks bypasses Tor

### Use Cases

**Appropriate Uses:**
- Privacy-conscious browsing
- Research requiring anonymity
- Accessing geo-restricted content
- Security testing and penetration testing (with authorization)
- Protecting against network surveillance

**Not Recommended For:**
- High-bandwidth activities (streaming, large downloads)
- Applications requiring low latency (gaming, video calls)
- Illegal activities

## Performance Impact

Routing traffic through Tor introduces latency:
- **Increased Latency**: 3-7 hops through Tor network
- **Reduced Bandwidth**: Tor network limitations apply
- **Variable Performance**: Depends on Tor network load

## Privacy Guarantees

Nipe provides:
- ✅ IP address anonymization
- ✅ Protection from basic network surveillance
- ✅ Exit node rotation (via restart)

Nipe does NOT provide:
- ❌ Protection against malware
- ❌ End-to-end encryption (use HTTPS separately)
- ❌ Anonymity against sophisticated attackers with Tor network visibility
- ❌ Protection from application-level fingerprinting

## Quick Start

```bash
# Install dependencies (requires root)
sudo perl nipe.pl install

# Start Tor routing
sudo perl nipe.pl start

# Check status
sudo perl nipe.pl status

# Stop routing
sudo perl nipe.pl stop
```

## Version Information

- **Current Version**: 0.9.8
- **Perl Requirement**: 5.30 or higher
- **License**: MIT

## Getting Help

- View available commands: `perl nipe.pl help`
- Report bugs: [GitHub Issues](https://github.com/htrgouvea/nipe/issues)
- Security issues: See [SECURITY.md](/SECURITY.md)
- Contributions: See [CONTRIBUTING.md](/.github/CONTRIBUTING.md)
