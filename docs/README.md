# Nipe Documentation

Welcome to the Nipe documentation! This directory contains comprehensive documentation for both users and developers.

## Documentation Structure

### For Users

- **[Overview](overview.md)** - Project overview, features, and quick start guide
  - What is Nipe?
  - How it works
  - Supported platforms
  - Security considerations
  - Quick start guide

- **[Architecture](architecture.md)** - System architecture and technical details
  - Module organization
  - Component details
  - Data flow diagrams
  - Configuration files
  - Security architecture

- **[Diagrams](diagrams.md)** - Visual architecture diagrams
  - Module architecture graphs
  - Command flow diagrams
  - Component interactions
  - Network traffic flow
  - IPTables rules visualization

### For Developers

The `developer-guide/` directory contains documentation for contributors and developers:

- **[Getting Started](developer-guide/getting-started.md)** - Development environment setup
  - Prerequisites and setup
  - Project structure
  - Development workflow
  - Testing procedures
  - Common development tasks
  - Troubleshooting

- **[Module API](developer-guide/module-api.md)** - Complete API reference
  - Core engine modules
  - Utility modules
  - Network modules
  - Usage examples
  - Testing patterns

## Quick Links

### Getting Started with Nipe

```bash
# Clone and install
git clone https://github.com/htrgouvea/nipe
cd nipe
cpanm --installdeps .
perl nipe.pl install

# Start using Tor
perl nipe.pl start
perl nipe.pl status
```

### Contributing

Want to contribute? Start here:

1. Read [Getting Started](developer-guide/getting-started.md) for development setup
2. Check [Module API](developer-guide/module-api.md) for implementation details
3. See [CONTRIBUTING.md](../.github/CONTRIBUTING.md) for the contribution process

## Documentation by Topic

### Understanding Nipe

| Topic | Document | Section |
|-------|----------|---------|
| What does Nipe do? | [Overview](overview.md) | What is Nipe? |
| How does it work? | [Overview](overview.md) | How It Works |
| System architecture | [Architecture](architecture.md) | System Architecture |
| Module organization | [Architecture](architecture.md) | Module Organization |

### Using Nipe

| Topic | Document | Section |
|-------|----------|---------|
| Installation | [Overview](overview.md) | Quick Start |
| Commands | [Overview](overview.md) | Quick Start |
| Supported platforms | [Overview](overview.md) | Supported Platforms |
| Security considerations | [Overview](overview.md) | Security Considerations |
| Performance impact | [Overview](overview.md) | Performance Impact |

### Developing Nipe

| Topic | Document | Section |
|-------|----------|---------|
| Setup dev environment | [Getting Started](developer-guide/getting-started.md) | Development Environment Setup |
| Project structure | [Getting Started](developer-guide/getting-started.md) | Project Structure |
| Testing | [Getting Started](developer-guide/getting-started.md) | Testing |

### Module Reference

| Module | Document | Purpose |
|--------|----------|---------|
| Engine::Start | [Module API](developer-guide/module-api.md#nipecomponentenginestart) | Start Tor routing |
| Engine::Stop | [Module API](developer-guide/module-api.md#nipecomponentenginestop) | Stop Tor routing |
| Utils::Device | [Module API](developer-guide/module-api.md#nipecomponentutilsdevice) | Detect distribution |
| Utils::Status | [Module API](developer-guide/module-api.md#nipecomponentutilsstatus) | Check Tor status |
| Utils::Helper | [Module API](developer-guide/module-api.md#nipecomponentutilshelper) | Display help |
| Network::Install | [Module API](developer-guide/module-api.md#nipenetworkinstall) | Install dependencies |
| Network::Restart | [Module API](developer-guide/module-api.md#nipenetworkrestart) | Restart circuit |

## Common Tasks

### I want to...

**Use Nipe:**
- Install and use Nipe → [Overview - Quick Start](overview.md#quick-start)
- Understand privacy implications → [Overview - Security Considerations](overview.md#security-considerations)
- Troubleshoot issues → [Getting Started - Troubleshooting](developer-guide/getting-started.md#troubleshooting-development-issues)

**Contribute to Nipe:**
- Set up development environment → [Getting Started](developer-guide/getting-started.md)
- Add support for new distribution → [Getting Started - Adding New Distribution](developer-guide/getting-started.md#adding-support-for-new-distribution)
- Add a new command → [Getting Started - Adding New Command](developer-guide/getting-started.md#adding-a-new-command)

**Understand Nipe:**
- How traffic is routed → [Architecture - Data Flow](architecture.md#data-flow)
- How distribution detection works → [Module API - Utils::Device](developer-guide/module-api.md#nipecomponentutilsdevice)
- How iptables rules are applied → [Module API - Engine::Start](developer-guide/module-api.md#nipecomponentenginestart)
- Module dependencies → [Module API - Dependencies Graph](developer-guide/module-api.md#module-dependencies-graph)

## Additional Resources

- **Main README**: [../README.md](../README.md) - Project overview and badges
- **Contributing Guide**: [../.github/CONTRIBUTING.md](../.github/CONTRIBUTING.md) - How to contribute
- **Security Policy**: [../SECURITY.md](../SECURITY.md) - Security reporting
- **License**: [../LICENSE.md](../LICENSE.md) - MIT License
- **Issue Tracker**: [GitHub Issues](https://github.com/htrgouvea/nipe/issues)

## Documentation Maintenance

### For Contributors

When making changes to the codebase:

1. **Update relevant documentation** if you:
   - Add/remove/modify modules
   - Change module APIs or behavior
   - Add new commands
   - Change configuration format
   - Add support for new platforms

2. **Keep documentation in sync** with code:
   - Version numbers
   - Command syntax
   - Configuration examples
   - API signatures

3. **Test documentation examples**:
   - Verify code examples work
   - Check command outputs are accurate
   - Ensure links are not broken

### Documentation Standards

- Use clear, concise language
- Include code examples
- Provide usage context
- Keep formatting consistent
- Link to related sections
- Update modification dates

## Getting Help

If you can't find what you're looking for:

1. **Search documentation** - Use your editor's search or GitHub search
2. **Check existing issues** - Someone may have asked already
3. **Ask in Discussions** - GitHub Discussions for Q&A
4. **Open an issue** - For bugs or unclear documentation

---

**Last Updated**: 2025-12-05
**Nipe Version**: 0.9.8
**Documentation Version**: 1.0.0
