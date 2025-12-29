#!/bin/bash

host=$(hostname)

case "$host" in
  STG-KAF-APP01)
    broker_id=1
    host_prefix="STG-KAF-APP01"
    domain="stage.causeway.com"
    hostname="STG-KAF-APP01.stage.causeway.com"
    ;;
  STG-KAF-APP02)
    broker_id=2
    host_prefix="STG-KAF-APP02"
    domain="stage.causeway.com"
    hostname="STG-KAF-APP02.stage.causeway.com"
    ;;
  STG-KAF-APP03)
    broker_id=3
    host_prefix="STG-KAF-APP03"
    domain="stage.causeway.com"
    hostname="STG-KAF-APP03.stage.causeway.com"
    ;;
  PRD-KAF-APP01)
    broker_id=1
    host_prefix="PRD-KAF-APP01"
    domain="causeway.com"
    hostname="PRD-KAF-APP01.causeway.com"
    ;;
  PRD-KAF-APP02)
    broker_id=2
    host_prefix="PRD-KAF-APP02"
    domain="causeway.com"
    hostname="PRD-KAF-APP02.causeway.com"
    ;;
  PRD-KAF-APP03)
    broker_id=3
    host_prefix="PRD-KAF-APP03"
    domain="causeway.com"
    hostname="PRD-KAF-APP03.causeway.com"
    ;;
  QA-KAF-APP01)
    broker_id=1
    host_prefix="QA-KAF-APP01"
    domain="qa.causeway.com"
    hostname="QA-KAF-APP01.qa.causeway.com"
    ;;
  QA-KAF-APP02)
    broker_id=2
    host_prefix="QA-KAF-APP02"
    domain="qa.causeway.com"
    hostname="QA-KAF-APP02.qa.causeway.com"
    ;;
  QA-KAF-APP03)
    broker_id=3
    host_prefix="QA-KAF-APP03"
    domain="qa.causeway.com"
    hostname="QA-KAF-APP03.qa.causeway.com"
    ;;
  *)
    echo "Unknown host, exiting!"
    exit 1
    ;;
esac

# Standard Kafka SSL port
ssl_port=9093
# KRaft controller port (internal only, also SSL)
controller_port=9094

# Copy docker-compose.yml to /opt/kafka/docker-compose.yml
sudo cp docker-compose.yml /opt/kafka/docker-compose.yml

# Set KRaft controller quorum voters based on environment
if [[ "$domain" == "stage.causeway.com" ]]; then
  KAFKA_CONTROLLER_QUORUM_VOTERS="1@STG-KAF-APP01.stage.causeway.com:9094,2@STG-KAF-APP02.stage.causeway.com:9094,3@STG-KAF-APP03.stage.causeway.com:9094"
elif [[ "$domain" == "causeway.com" ]]; then
  KAFKA_CONTROLLER_QUORUM_VOTERS="1@PRD-KAF-APP01.causeway.com:9094,2@PRD-KAF-APP02.causeway.com:9094,3@PRD-KAF-APP03.causeway.com:9094"
elif [[ "$domain" == "qa.causeway.com" ]]; then
  KAFKA_CONTROLLER_QUORUM_VOTERS="1@QA-KAF-APP01.qa.causeway.com:9094,2@QA-KAF-APP02.qa.causeway.com:9094,3@QA-KAF-APP03.qa.causeway.com:9094"
fi

# Set kafka super users based on environment (CN-only for simplicity)
if [[ "$domain" == "stage.causeway.com" ]]; then
  KAFKA_SUPER_USERS="User:CN=STG-KAF-APP01.stage.causeway.com;User:CN=STG-KAF-APP02.stage.causeway.com;User:CN=STG-KAF-APP03.stage.causeway.com"
elif [[ "$domain" == "causeway.com" ]]; then
  KAFKA_SUPER_USERS="User:CN=PRD-KAF-APP01.causeway.com;User:CN=PRD-KAF-APP02.causeway.com;User:CN=PRD-KAF-APP03.causeway.com"
elif [[ "$domain" == "qa.causeway.com" ]]; then
  KAFKA_SUPER_USERS="User:CN=QA-KAF-APP01.qa.causeway.com;User:CN=QA-KAF-APP02.qa.causeway.com;User:CN=QA-KAF-APP03.qa.causeway.com"
fi

# Set Kafdrop broker connect list based on environment
if [[ "$domain" == "stage.causeway.com" ]]; then
  KAFKA_BROKERCONNECT="STG-KAF-APP01.stage.causeway.com:9093,STG-KAF-APP02.stage.causeway.com:9093,STG-KAF-APP03.stage.causeway.com:9093"
elif [[ "$domain" == "causeway.com" ]]; then
  KAFKA_BROKERCONNECT="PRD-KAF-APP01.causeway.com:9093,PRD-KAF-APP02.causeway.com:9093,PRD-KAF-APP03.causeway.com:9093"
elif [[ "$domain" == "qa.causeway.com" ]]; then
  KAFKA_BROKERCONNECT="QA-KAF-APP01.qa.causeway.com:9093,QA-KAF-APP02.qa.causeway.com:9093,QA-KAF-APP03.qa.causeway.com:9093"
fi

KAFKA_REST_SSL_KEYSTORE_PASSWORD=$KAFKA_REST_CLIENT_SSL_KEYSTORE_PASSWORD
KAFKA_REST_SSL_TRUSTSTORE_PASSWORD=$KAFKA_REST_CLIENT_SSL_TRUSTSTORE_PASSWORD

# Generate a stable cluster ID based on the domain
if [[ "$domain" == "stage.causeway.com" ]]; then
  KAFKA_CLUSTER_ID="STG_KRAFT_CLUSTER_ID"
elif [[ "$domain" == "causeway.com" ]]; then
  KAFKA_CLUSTER_ID="PRD_KRAFT_CLUSTER_ID"
elif [[ "$domain" == "qa.causeway.com" ]]; then
  KAFKA_CLUSTER_ID="QA_KRAFT_CLUSTER_ID"
fi

# Write the .env file
cat > .env <<EOF
# =====================
# Kafka Broker Settings (KRaft Mode)
# =====================
KAFKA_BROKER_ID=$broker_id
KAFKA_LISTENER_SECURITY_PROTOCOL_MAP="SSL:SSL,CONTROLLER:SSL"
KAFKA_LISTENERS="SSL://${hostname}:${ssl_port},CONTROLLER://${hostname}:${controller_port}"
KAFKA_ADVERTISED_LISTENERS="SSL://${hostname}:${ssl_port}"
KAFKA_INTER_BROKER_LISTENER_NAME=SSL
KAFKA_SSL_KEYSTORE_FILENAME=kafka-prod-app${broker_id}-keystore.jks
KAFKA_SSL_KEYSTORE_CREDENTIALS=kafka_app${broker_id}_keystore_creds
KAFKA_SSL_KEY_CREDENTIALS=kafka_app${broker_id}_sslkey_creds
KAFKA_SSL_TRUSTSTORE_FILENAME=kafka-prod-app${broker_id}-truststore.jks
KAFKA_SSL_TRUSTSTORE_CREDENTIALS=kafka_app${broker_id}_truststore_creds
KAFKA_SSL_CLIENT_AUTH=required
KAFKA_LOG4J_LOGGERS="kafka.authorizer.logger=INFO"
KAFKA_DELETE_TOPIC_ENABLE=true
KAFKA_DEFAULT_REPLICATION_FACTOR=3
KAFKA_AUTHORIZER_CLASS=kafka.security.auth.SimpleAclAuthorizer
KAFKA_SUPER_USERS="$KAFKA_SUPER_USERS"

# =====================
# KRaft Controller Settings
# =====================
KAFKA_CONTROLLER_QUORUM_VOTERS="$KAFKA_CONTROLLER_QUORUM_VOTERS"
KAFKA_CLUSTER_ID="$KAFKA_CLUSTER_ID"

# =====================
# Kafdrop Settings
# =====================
KAFKA_BROKERCONNECT="$KAFKA_BROKERCONNECT"
JVM_OPTS="-Xms32M -Xmx64M"
SERVER_SERVLET_CONTEXTPATH="/"

# =====================
# REST Proxy Settings
# =====================
KAFKA_REST_HOST_NAME="${hostname}"
KAFKA_REST_BOOTSTRAP_SERVERS="$KAFKA_BROKERCONNECT"
KAFKA_REST_LISTENERS="http://${hostname}:8082"
KAFKA_REST_SCHEMA_REGISTRY_URL="http://${hostname}:8081"
KAFKA_HEAP_OPTS="-Xms1G -Xmx1G"
KAFKA_REST_SECURITY_PROTOCOL=SSL
KAFKA_REST_SSL_PROTOCOL=SSL
KAFKA_REST_CLIENT_SSL_KEYSTORE_PASSWORD=$KAFKA_REST_SSL_KEYSTORE_PASSWORD
KAFKA_REST_CLIENT_SSL_TRUSTSTORE_PASSWORD=$KAFKA_REST_SSL_TRUSTSTORE_PASSWORD
KAFKA_REST_CLIENT_SSL_KEYSTORE_LOCATION="/etc/kafka/secrets/kafka-rest-staging-keystore.jks"
KAFKA_REST_CLIENT_SSL_TRUSTSTORE_LOCATION="/etc/kafka/secrets/kafka-rest-staging-truststore.jks"
EOF

docker compose up -d
