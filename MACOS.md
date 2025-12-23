# Nipe for macOS

This document provides macOS-specific information for running Nipe on macOS systems.

## Requirements

- macOS 10.12 (Sierra) or later
- Homebrew package manager
- Perl 5.30 or later (included with macOS)
- Root/sudo access

## Installation

### 1. Install Homebrew (if not already installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Dependencies

```bash
# Install cpanminus
brew install cpanminus

# Clone the repository
git clone https://github.com/htrgouvea/nipe && cd nipe

# Install Perl dependencies
cpanm --installdeps .

# Install Nipe and Tor
sudo perl nipe.pl install
```

## How It Works on macOS

### Packet Filter (pfctl)

Unlike Linux which uses iptables, macOS uses pfctl (Packet Filter Control) for firewall and traffic routing:

- Nipe creates a temporary pf configuration file at `/tmp/nipe-pf.conf`
- The configuration routes all non-local traffic through Tor
- When you stop Nipe, pfctl is disabled and the configuration is removed

### Tor Service Management

Nipe can manage Tor using Homebrew services:

```bash
# Start Tor
brew services start tor

# Stop Tor
brew services stop tor

# Check status
brew services list | grep tor
```

### Network Interfaces

The default network interface is set to `en0`. If you're using a different interface (e.g., `en1` for Wi-Fi on some Macs), you may need to modify `.configs/darwin-torrc` or the pfctl rules in `lib/Nipe/Component/Engine/Start.pm`.

To check your active network interface:

```bash
ifconfig | grep -E "^(en|wl)"
```

## Usage

### Starting Nipe

```bash
sudo perl nipe.pl start
```

This will:
1. Start the Tor service
2. Configure pfctl to route traffic through Tor
3. Verify the connection

### Checking Status

```bash
sudo perl nipe.pl status
```

### Stopping Nipe

```bash
sudo perl nipe.pl stop
```

This will:
1. Disable pfctl
2. Remove the pf configuration
3. Stop the Tor service

### Restarting

```bash
sudo perl nipe.pl restart
```

## Troubleshooting

### Permission Denied Errors

Make sure you're running Nipe with sudo:

```bash
sudo perl nipe.pl start
```

### pfctl Errors

If pfctl fails to load rules, check if there are existing pf rules:

```bash
# Show current pf rules
sudo pfctl -s rules

# Disable pf
sudo pfctl -d

# Try starting Nipe again
sudo perl nipe.pl start
```

### Tor Not Starting

Check if Tor is already running:

```bash
ps aux | grep tor
```

If Tor is running but Nipe can't connect:

```bash
# Stop all Tor processes
sudo killall tor

# Restart Nipe
sudo perl nipe.pl restart
```

### Network Interface Issues

If traffic isn't being routed correctly, you may need to change the network interface in the pfctl rules.

Edit the pf configuration by modifying `lib/Nipe/Component/Engine/Start.pm` and change `ext_if = "en0"` to your active interface.

### IPv6 Issues

If IPv6 is causing problems, you can temporarily disable it:

```bash
networksetup -setv6off Wi-Fi
```

To re-enable:

```bash
networksetup -setv6automatic Wi-Fi
```

## Limitations

### Known Issues

1. **VPN Compatibility**: Nipe may conflict with VPN software. It's recommended to disconnect from VPNs before starting Nipe.

2. **System Integrity Protection (SIP)**: Some macOS security features may interfere with pfctl. In most cases, running with sudo is sufficient.

3. **Network Interface Detection**: Nipe assumes `en0` as the primary interface. If your Mac uses a different interface, you may need to manually configure it.

4. **DNS Leaks**: Always verify your connection using the status command or external services like https://check.torproject.org

## Files and Directories

- **Configuration**: `.configs/darwin-torrc` - Tor configuration for macOS
- **PF Rules**: `/tmp/nipe-pf.conf` - Temporary packet filter configuration
- **Tor Data**: `/usr/local/var/lib/tor` - Tor data directory
- **Tor Logs**: `/usr/local/var/log/tor/log` - Tor log file

## Security Considerations

1. **Root Access**: Nipe requires root access to modify system networking. Always review the code before running with sudo.

2. **Traffic Analysis**: While Tor provides anonymity, it's not foolproof. Be aware of traffic analysis attacks and correlation attacks.

3. **Local Traffic**: Traffic to local networks (127.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12, 10.0.0.0/8) is NOT routed through Tor.

4. **UDP/ICMP**: Non-Tor UDP and ICMP traffic is blocked as per Tor project requirements.

## Support

For issues specific to the macOS implementation, please open an issue on GitHub with:
- macOS version (`sw_vers`)
- Perl version (`perl -v`)
- Error messages
- Output of `sudo perl nipe.pl status`

## Contributing

Contributions to improve macOS support are welcome! Areas that could use improvement:
- Automatic network interface detection
- Better error handling for pfctl
- Integration with macOS Keychain for Tor authentication
- Support for Apple Silicon (M1/M2/M3) specific optimizations

## License

This work is licensed under MIT License.
