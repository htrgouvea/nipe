# Nipe Architecture Diagrams

This document contains visual diagrams to help understand Nipe's architecture, data flow, and component interactions.

## Table of Contents

1. [Module Architecture](#module-architecture)
2. [Command Flow Diagrams](#command-flow-diagrams)
3. [Component Interaction](#component-interaction)
4. [Network Traffic Flow](#network-traffic-flow)
5. [IPTables Rules Structure](#iptables-rules-structure)

---

## Module Architecture

### Overall Module Structure

```mermaid
graph TB
    subgraph "Entry Point"
        A[nipe.pl<br/>Main CLI Entry]
    end

    subgraph "Component::Engine"
        B[Start<br/>v0.0.5]
        C[Stop<br/>v0.0.2]
    end

    subgraph "Component::Utils"
        D[Device<br/>v0.0.4]
        E[Status<br/>v0.0.4]
        F[Helper<br/>v0.0.3]
    end

    subgraph "Network"
        G[Install<br/>v0.0.3]
        H[Restart<br/>v0.0.1]
    end

    subgraph "External Services"
        I[Tor Daemon]
        J[IPTables]
        K[Tor Project API]
    end

    A -->|start| B
    A -->|stop| C
    A -->|status| E
    A -->|install| G
    A -->|restart| H
    A -->|help| F

    B --> C
    B --> D
    B --> E
    B --> I
    B --> J

    C --> D
    C --> I
    C --> J

    E --> K

    G --> D
    G --> C

    H --> C
    H --> B

    style A fill:#e1f5ff
    style B fill:#ffe1e1
    style C fill:#ffe1e1
    style H fill:#e1ffe1
    style G fill:#e1ffe1
```

### Module Dependencies

```mermaid
graph LR
    subgraph "Dependency Layers"
        direction TB
        L1[Layer 1: Core Utils]
        L2[Layer 2: Engine]
        L3[Layer 3: Network Ops]
        L4[Layer 4: CLI]
    end

    subgraph "Layer 1"
        D[Device]
        S[Status]
        H[Helper]
    end

    subgraph "Layer 2"
        ST[Stop]
        SR[Start]
    end

    subgraph "Layer 3"
        I[Install]
        R[Restart]
    end

    subgraph "Layer 4"
        CLI[nipe.pl]
    end

    ST --> D
    SR --> D
    SR --> S
    SR --> ST

    I --> D
    I --> ST

    R --> ST
    R --> SR

    CLI --> ST
    CLI --> SR
    CLI --> S
    CLI --> H
    CLI --> I
    CLI --> R

    style D fill:#ffd700
    style S fill:#ffd700
    style H fill:#ffd700
    style ST fill:#ff9999
    style SR fill:#ff9999
    style I fill:#99ff99
    style R fill:#99ff99
```

---

## Command Flow Diagrams

### Start Command Flow

```mermaid
sequenceDiagram
    actor User
    participant CLI as nipe.pl
    participant Start as Engine::Start
    participant Stop as Engine::Stop
    participant Device as Utils::Device
    participant Status as Utils::Status
    participant Tor as Tor Daemon
    participant IPT as IPTables

    User->>CLI: perl nipe.pl start
    CLI->>CLI: Check root privileges

    CLI->>Start: new()
    Start->>Stop: Stop existing routing
    Stop->>Device: Detect distribution
    Device-->>Stop: {username, distribution}
    Stop->>IPT: Flush OUTPUT chains
    Stop->>Tor: Stop daemon
    Stop-->>Start: Success (1)

    Start->>Device: Detect distribution
    Device-->>Start: {username, distribution}

    Start->>Tor: Start with config
    Note over Tor: Ports 9051, 9061

    Start->>IPT: Apply NAT rules
    Note over IPT: DNS redirect<br/>TCP redirect

    Start->>IPT: Apply Filter rules
    Note over IPT: Accept established<br/>Reject UDP/ICMP

    Start->>IPT: Apply IPv6 rules

    Start->>Status: Verify connectivity
    Status->>Status: Query check.torproject.org
    Status-->>Start: Status string

    Start-->>CLI: Result (1 or status)
    CLI-->>User: Display result
```

### Stop Command Flow

```mermaid
sequenceDiagram
    actor User
    participant CLI as nipe.pl
    participant Stop as Engine::Stop
    participant Device as Utils::Device
    participant IPT as IPTables
    participant Tor as Tor Daemon

    User->>CLI: perl nipe.pl stop
    CLI->>CLI: Check root privileges

    CLI->>Stop: new()
    Stop->>Device: Detect distribution
    Device-->>Stop: {username, distribution}

    Stop->>IPT: Flush NAT OUTPUT
    Stop->>IPT: Flush Filter OUTPUT
    Note over IPT: All rules removed

    Stop->>Tor: Stop daemon
    Note over Tor: systemctl stop tor<br/>or distribution-specific

    Stop-->>CLI: Success (1)
    CLI-->>User: Routing stopped
```

### Status Command Flow

```mermaid
sequenceDiagram
    actor User
    participant CLI as nipe.pl
    participant Status as Utils::Status
    participant API as check.torproject.org

    User->>CLI: perl nipe.pl status
    CLI->>CLI: Check root privileges

    CLI->>Status: new()
    Status->>API: GET /api/ip

    alt Success (200)
        API-->>Status: {"IsTor": true, "IP": "x.x.x.x"}
        Status->>Status: Parse JSON
        Status-->>CLI: "[+] Status: true\n[+] Ip: x.x.x.x"
    else Error
        API-->>Status: Connection failed
        Status-->>CLI: "[!] ERROR: connection failed"
    end

    CLI-->>User: Display status
```

### Restart Command Flow

```mermaid
sequenceDiagram
    actor User
    participant CLI as nipe.pl
    participant Restart as Network::Restart
    participant Stop as Engine::Stop
    participant Start as Engine::Start

    User->>CLI: perl nipe.pl restart
    CLI->>CLI: Check root privileges

    CLI->>Restart: new()

    Restart->>Stop: new()
    Note over Stop: Cleanup iptables<br/>Stop Tor
    Stop-->>Restart: Success (1)

    Restart->>Start: new()
    Note over Start: Configure iptables<br/>Start Tor<br/>Verify connectivity
    Start-->>Restart: Success (1)

    Restart-->>CLI: Success (1)
    CLI-->>User: Circuit restarted
```

---

## Component Interaction

### System Component Diagram

```mermaid
graph TB
    subgraph "User Space"
        U[User/Application]
    end

    subgraph "Nipe Components"
        N[nipe.pl]
        E[Engine Modules]
        UT[Utils Modules]
        NW[Network Modules]
    end

    subgraph "System Layer"
        IPT[IPTables]
        TOR[Tor Daemon]
        NET[Network Stack]
    end

    subgraph "External"
        TN[Tor Network]
        INT[Internet]
    end

    U -->|Commands| N
    N --> E
    N --> UT
    N --> NW

    E -->|Configure| IPT
    E -->|Control| TOR
    UT -->|Query| INT

    IPT -->|Redirect| NET
    NET -->|Traffic| TOR
    TOR <-->|Encrypted| TN
    TN <-->|Exit| INT

    style N fill:#e1f5ff
    style E fill:#ffe1e1
    style IPT fill:#fff0e1
    style TOR fill:#fff0e1
    style TN fill:#e1ffe1
```

### Distribution Detection Flow

```mermaid
flowchart TD
    A[Start: Device->new] --> B[Read /etc/os-release]
    B --> C{Parse ID_LIKE<br/>and ID}

    C -->|Match Fedora| D[Return:<br/>toranon, fedora]
    C -->|Match Arch| E[Return:<br/>tor, arch]
    C -->|Match Void| F[Return:<br/>tor, void]
    C -->|Match Suse| G[Return:<br/>tor, opensuse]
    C -->|No match| H[Return:<br/>debian-tor, debian]

    D --> I[Used in iptables<br/>and package install]
    E --> I
    F --> I
    G --> I
    H --> I

    style A fill:#e1f5ff
    style I fill:#e1ffe1
```

---

## Network Traffic Flow

### Normal Traffic vs Tor Traffic

```mermaid
graph LR
    subgraph "Without Nipe"
        A1[Application] --> N1[Network]
        N1 --> I1[ISP]
        I1 --> W1[Internet]
        W1 --> D1[Destination]
    end

    subgraph "With Nipe Active"
        A2[Application] --> IPT2[IPTables]
        IPT2 -->|Redirect| T2[Tor TransPort<br/>9051]
        T2 --> TN2[Tor Network<br/>3-7 hops]
        TN2 --> TE2[Tor Exit Node]
        TE2 --> D2[Destination]
    end

    style A1 fill:#ffcccc
    style D1 fill:#ffcccc
    style A2 fill:#ccffcc
    style D2 fill:#ccffcc
    style TN2 fill:#cce5ff
```

### Traffic Classification

```mermaid
flowchart TD
    START[Outbound Traffic] --> CHECK{Check Traffic Type}

    CHECK -->|Local/Loopback<br/>127.0.0.0/8| ALLOW1[RETURN/ACCEPT<br/>Direct routing]
    CHECK -->|Private Networks<br/>192.168.x.x, 10.x.x.x| ALLOW2[RETURN/ACCEPT<br/>Direct routing]
    CHECK -->|DNS Port 53| DNS[REDIRECT to<br/>Tor DNS: 9061]
    CHECK -->|TCP Traffic| TCP[REDIRECT to<br/>Tor TransPort: 9051]
    CHECK -->|Non-DNS UDP| BLOCK1[REJECT<br/>Blocked by Tor]
    CHECK -->|ICMP| BLOCK2[REJECT<br/>Blocked by Tor]
    CHECK -->|From Tor User| ALLOW3[ACCEPT<br/>Tor traffic]

    DNS --> TOR[Tor Network]
    TCP --> TOR
    TOR --> INTERNET[Internet]

    style ALLOW1 fill:#90EE90
    style ALLOW2 fill:#90EE90
    style ALLOW3 fill:#90EE90
    style BLOCK1 fill:#FFB6C1
    style BLOCK2 fill:#FFB6C1
    style TOR fill:#87CEEB
```

---

## IPTables Rules Structure

### NAT Table Rules

```mermaid
flowchart TB
    START[Packet in OUTPUT Chain] --> R1{Established?}
    R1 -->|Yes| RETURN1[RETURN<br/>Allow through]
    R1 -->|No| R2{From Tor user?}

    R2 -->|Yes| RETURN2[RETURN<br/>Allow Tor traffic]
    R2 -->|No| R3{DNS Port 53?}

    R3 -->|Yes UDP| REDIR1[REDIRECT<br/>to port 9061]
    R3 -->|Yes TCP| REDIR1
    R3 -->|No| R4{Local network?}

    R4 -->|127.0.0.0/8| RETURN3[RETURN]
    R4 -->|192.168.0.0/16| RETURN3
    R4 -->|172.16.0.0/12| RETURN3
    R4 -->|10.0.0.0/8| RETURN3
    R4 -->|No| R5{TCP?}

    R5 -->|Yes| REDIR2[REDIRECT<br/>to port 9051]
    R5 -->|No| END[End of NAT rules]

    style RETURN1 fill:#90EE90
    style RETURN2 fill:#90EE90
    style RETURN3 fill:#90EE90
    style REDIR1 fill:#87CEEB
    style REDIR2 fill:#87CEEB
```

### Filter Table Rules

```mermaid
flowchart TB
    START[Packet in OUTPUT Chain] --> F1{Established?}
    F1 -->|Yes| ACCEPT1[ACCEPT<br/>Allow through]
    F1 -->|No| F2{From Tor user?}

    F2 -->|Yes| ACCEPT2[ACCEPT<br/>Allow Tor traffic]
    F2 -->|No| F3{DNS Port 9061?}

    F3 -->|Yes UDP| ACCEPT3[ACCEPT]
    F3 -->|Yes TCP| ACCEPT3
    F3 -->|No| F4{Local network?}

    F4 -->|127.0.0.0/8| ACCEPT4[ACCEPT]
    F4 -->|192.168.0.0/16| ACCEPT4
    F4 -->|172.16.0.0/12| ACCEPT4
    F4 -->|10.0.0.0/8| ACCEPT4
    F4 -->|No| F5{Protocol?}

    F5 -->|TCP| ACCEPT5[ACCEPT]
    F5 -->|UDP| REJECT1[REJECT<br/>No non-DNS UDP]
    F5 -->|ICMP| REJECT2[REJECT<br/>No ICMP]

    style ACCEPT1 fill:#90EE90
    style ACCEPT2 fill:#90EE90
    style ACCEPT3 fill:#90EE90
    style ACCEPT4 fill:#90EE90
    style ACCEPT5 fill:#90EE90
    style REJECT1 fill:#FFB6C1
    style REJECT2 fill:#FFB6C1
```

### Complete Rules Flow

```mermaid
graph TB
    subgraph "NAT Table"
        direction TB
        N1[Check Established] --> N2[Check Tor User]
        N2 --> N3[DNS Redirect 53→9061]
        N3 --> N4[Local Network Return]
        N4 --> N5[TCP Redirect →9051]
    end

    subgraph "Filter Table"
        direction TB
        F1[Check Established] --> F2[Check Tor User]
        F2 --> F3[DNS Accept 9061]
        F3 --> F4[Local Network Accept]
        F4 --> F5[TCP Accept]
        F5 --> F6[Reject UDP]
        F6 --> F7[Reject ICMP]
    end

    START[Outbound Packet] --> NAT
    NAT --> FILTER
    FILTER --> ROUTE[Routing Decision]

    style NAT fill:#FFE4B5
    style FILTER fill:#E0BBE4
    style ROUTE fill:#90EE90
```

---

## Module Call Stack

### Start Command Call Stack

```mermaid
graph TD
    A[nipe.pl::main] -->|1| B[Engine::Start::new]
    B -->|2| C[Engine::Stop::new]
    C -->|3| D[Utils::Device::new]
    D -->|4| C
    C -->|5| B
    B -->|6| D2[Utils::Device::new]
    D2 -->|7| B
    B -->|8| E[system: tor]
    B -->|9| F[system: iptables NAT]
    B -->|10| G[system: iptables Filter]
    B -->|11| H[system: ip6tables rules]
    B -->|12| I[Utils::Status::new]
    I -->|13| J[HTTP::Tiny::get]
    J -->|14| K[JSON::decode_json]
    K -->|15| I
    I -->|16| B
    B -->|17| A
    A -->|18| L[print result]

    style A fill:#e1f5ff
    style B fill:#ffe1e1
    style I fill:#ffd700
    style L fill:#90EE90
```

### Class Hierarchy

```mermaid
classDiagram
    class NipeCLI {
        +main()
        -check_root()
        -dispatch_command()
    }

    class EngineStart {
        +new()
        -configure_tor()
        -apply_nat_rules()
        -apply_filter_rules()
        -apply_ipv6_rules()
    }

    class EngineStop {
        +new()
        -flush_iptables()
        -stop_tor()
    }

    class UtilsDevice {
        +new()
        -parse_os_release()
        -match_distribution()
    }

    class UtilsStatus {
        +new()
        -query_api()
        -format_output()
    }

    class UtilsHelper {
        +new()
        -format_help()
    }

    class NetworkInstall {
        +new()
        -install_packages()
    }

    class NetworkRestart {
        +new()
    }

    NipeCLI --> EngineStart
    NipeCLI --> EngineStop
    NipeCLI --> UtilsStatus
    NipeCLI --> UtilsHelper
    NipeCLI --> NetworkInstall
    NipeCLI --> NetworkRestart

    EngineStart --> EngineStop
    EngineStart --> UtilsDevice
    EngineStart --> UtilsStatus

    EngineStop --> UtilsDevice

    NetworkInstall --> UtilsDevice
    NetworkInstall --> EngineStop

    NetworkRestart --> EngineStop
    NetworkRestart --> EngineStart
```

---

## Legend

### Diagram Colors

- 🔵 **Light Blue** - Entry points / CLI
- 🔴 **Light Red** - Engine modules (Start/Stop)
- 🟢 **Light Green** - Network modules (Install/Restart)
- 🟡 **Yellow** - Utility modules
- 🟠 **Orange** - External services (Tor, IPTables)

### Flow Direction

- ➡️ **Solid arrows** - Direct function calls
- ⤴️ **Dashed arrows** - Return values
- 🔄 **Bidirectional** - Interactive communication

---

## Using These Diagrams

These diagrams are rendered using Mermaid, which is natively supported by GitHub. To view them:

1. **On GitHub**: Diagrams render automatically in markdown preview
2. **Locally**: Use a Mermaid-compatible markdown viewer
3. **In IDE**: VS Code, IntelliJ with Mermaid plugins
4. **Export**: Use [Mermaid Live Editor](https://mermaid.live/) to export as PNG/SVG

## Updating Diagrams

When modifying the code:

1. Update relevant diagrams to reflect changes
2. Keep module versions in sync
3. Update flow diagrams if command logic changes
4. Add new components to architecture diagram
5. Test diagram rendering on GitHub

---

**Last Updated**: 2025-12-05
