# Kafka Standard Port Numbers

## Default Kafka Ports

| Port | Protocol | Purpose | Default Listener |
|------|----------|---------|------------------|
| **9092** | PLAINTEXT | Standard client connections (unencrypted) | PLAINTEXT://localhost:9092 |
| **9093** | SSL | SSL/TLS encrypted client connections | SSL://localhost:9093 |
| **9094** | SASL_PLAINTEXT | SASL authentication (unencrypted) | SASL_PLAINTEXT://localhost:9094 |
| **9095** | SASL_SSL | SASL authentication with SSL encryption | SASL_SSL://localhost:9095 |

## KRaft Mode Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| **9093** | PLAINTEXT | Controller quorum communication (internal) |
| **19092** | PLAINTEXT | Alternative controller port |

## Additional Kafka Ecosystem Ports

| Port | Service | Purpose |
|------|---------|---------|
| **2181** | ZooKeeper | Client connections (legacy, not needed in KRaft) |
| **2888** | ZooKeeper | Follower connections (legacy) |
| **3888** | ZooKeeper | Leader election (legacy) |
| **8081** | Schema Registry | REST API for schema management |
| **8082** | REST Proxy | REST API for Kafka operations |
| **8083** | Kafka Connect | REST API for connector management |
| **9000** | Kafdrop | Web UI for Kafka monitoring |
| **9021** | Confluent Control Center | Web UI for cluster management |

## Current Configuration (Your Setup)

### SSL Listener (External via stream.causeway.com)
- Broker 1: **9091**
- Broker 2: **9092**
- Broker 3: **9093**

### PLAINTEXT Listener (Direct broker access)
- Broker 1: **9191**
- Broker 2: **9192**
- Broker 3: **9193**

### INTERNAL Listener (Inter-broker communication)
- Broker 1: **9291**
- Broker 2: **9292**
- Broker 3: **9293**

### CONTROLLER Listener (KRaft mode)
- All Brokers: **9093** (same port, different hosts)

## Recommendations

### Option 1: Standard Ports with Direct Access
Remove HAProxy and use standard ports with direct broker hostnames:
```
SSL://stg-kaf-app01.stage.cloud.local:9093
SSL://stg-kaf-app02.stage.cloud.local:9093
SSL://stg-kaf-app03.stage.cloud.local:9093
```
**Benefits:**
- Industry standard configuration
- No HAProxy overhead
- Simpler architecture
- Better performance

### Option 2: Keep HAProxy with Standard Ports
Use HAProxy but with standard port (9093) for all brokers:
```
SSL://stream.causeway.com:9093
```
**Benefits:**
- Single hostname for clients
- Requires HAProxy to handle broker-specific routing (more complex)

### Option 3: Current Setup (Different Ports)
Keep current setup with different ports through HAProxy:
```
SSL://stream.causeway.com:9091 → broker 1
SSL://stream.causeway.com:9092 → broker 2
SSL://stream.causeway.com:9093 → broker 3
```
**Drawbacks:**
- Non-standard port usage
- HAProxy provides no real load balancing
- Extra hop adds latency

## Typical Production Setup (Recommended)

```yaml
Kafka Brokers (3 nodes):
  - External SSL: Port 9093 on each broker's hostname
  - Inter-broker: Port 9091 (PLAINTEXT or SSL)
  - Controller: Port 9092 (KRaft quorum)

Clients connect to:
  - broker1.domain.com:9093
  - broker2.domain.com:9093
  - broker3.domain.com:9093
```

This uses standard ports, no HAProxy, and lets Kafka clients handle broker discovery and direct connections.
