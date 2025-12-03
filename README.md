# Kafka Cluster Deployment (Docker Compose)

This repository provides a high-availability Kafka cluster deployment using Docker Compose, including Zookeeper, Kafka brokers, REST Proxy, and Kafdrop UI. All configuration is managed via a generated `.env` file for each node.

## Services

### Kafka Broker
- Image: `confluentinc/cp-kafka:latest`
- Configured for SSL and PLAINTEXT listeners
- Uses Zookeeper for cluster coordination
- Supports ACLs and super users

### Zookeeper
- Image: `confluentinc/cp-zookeeper:latest`
- Manages Kafka cluster state
- Configured for multi-node ensemble

### REST Proxy
- Image: `confluentinc/cp-kafka-rest:latest`
- Provides HTTP API for Kafka
- Configured for SSL and Schema Registry integration

### Kafdrop
- Image: `obsidiandynamics/kafdrop:latest` (or legacy `docker.causeway.com/kafka/kafdrop:<version>`)
- Web UI for Kafka cluster management
- Connects to all brokers for full cluster visibility
- Example legacy usage:
  ```bash
  docker run -d -p 9000:9000 --name=kafdrop \
    --restart always \
    -e ZOOKEEPER_CONNECT=kafka-app1.cloud.local:2181,kafka-app2.cloud.local:2181,kafka-app3.cloud.local:2181 \
    -e KAFKA_BROKERCONNECT=kafka-app1.cloud.local:9191,kafka-app2.cloud.local:9192,kafka-app3.cloud.local:9193 \
    -e JVM_OPTS="-Xms32M -Xmx64M" \
    -e SERVER_SERVLET_CONTEXTPATH="/" \
    obsidiandynamics/kafdrop:latest
  ```
  - You can load balance the web interface with HAProxy; session stickiness is not required.

## Deployment Script

The `deployment_script.sh` script:
- Detects the host and environment (staging/production)
- Generates a `.env` file with all required variables, organized by service
- Runs `docker compose up -d` to start all services

## Usage

1. **Edit and review `deployment_script.sh` as needed for your environment.**
2. **Run the script on each node:**
   ```bash
   ./deployment_script.sh
   ```
3. **Access Kafdrop UI:**
   - Open `http://<host>:9000` in your browser
   - Use HAProxy or similar for load balancing if desired

## Configuration

- All environment variables are set in `.env` and loaded by Docker Compose.
- Variables are grouped by service for clarity.
- Update SSL credentials, hostnames, and ports as needed for your environment.

## High Availability

- Deploy on three nodes for HA.
- Each node runs all services; Kafdrop connects to all brokers for cluster-wide management.

## Troubleshooting

- Ensure all required ports are open and not conflicting.
- Monitor resource usage on each node.
- For Kafdrop, session stickiness is not required; each instance shows the full cluster state.

## File Structure

- `deployment_script.sh` — Generates `.env` and starts services
- `docker-compose.yml` — Service definitions
- `old_world/kafka-setup/` — Legacy scripts for reference

## Azure Pipelines

- The repository includes an `azure-pipelines.yml` for CI/CD.
- Pipeline steps:
  - Check validity of deployment and compose files
  - Inject secrets as environment variables
  - Run the deployment script to generate `.env` and start services
- Sensitive values (e.g., SSL passwords) should be stored as pipeline secrets and not committed to git.

## Security

- Do **not** commit `.env` files or secrets to version control.
- Use Azure Pipeline secrets or Key Vault for sensitive values.
- Review and secure any credentials, keystore/truststore files, and passwords.

## License

MIT
