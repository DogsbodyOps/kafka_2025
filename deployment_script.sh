#!/bin/bash

host=$(hostname)

case "$host" in
  stg-kaf-app01)
    broker_id=1
    host_prefix="stg-kaf-app01"
    domain="stage.cloud.local"
    ssl_port=9091
    ;;
  stg-kaf-app02)
    broker_id=2
    host_prefix="stg-kaf-app02"
    domain="stage.cloud.local"
    ssl_port=9092
    ;;
  stg-kaf-app03)
    broker_id=3
    host_prefix="stg-kaf-app03"
    domain="stage.cloud.local"
    ssl_port=9093
    ;;
  prd-kaf-app1)
    broker_id=1
    host_prefix="prd-kaf-app1"
    domain="prod.cloud.local"
    ssl_port=9091
    ;;
  prd-kaf-app2)
    broker_id=2
    host_prefix="prd-kaf-app2"
    domain="prod.cloud.local"
    ssl_port=9092
    ;;
  prd-kaf-app3)
    broker_id=3
    host_prefix="prd-kaf-app3"
    domain="prod.cloud.local"
    ssl_port=9093
    ;;
  *)
    echo "Unknown host, exiting!"
    exit 1
    ;;
esac

# Set Zookeeper servers based on environment
if [[ "$domain" == "stage.cloud.local" ]]; then
  ZOOKEEPER_SERVERS="stg-kaf-app01.stage.cloud.local:2888:3888;stg-kaf-app02.stage.cloud.local:2888:3888;stg-kaf-app03.stage.cloud.local:2888:3888"
elif [[ "$domain" == "prod.cloud.local" ]]; then
  ZOOKEEPER_SERVERS="prd-kaf-app1.prod.cloud.local:2888:3888;prd-kaf-app2.prod.cloud.local:2888:3888;prd-kaf-app3.prod.cloud.local:2888:3888"
fi

# Set Zookeeper connection string based on environment
if [[ "$domain" == "stage.cloud.local" ]]; then
  KAFKA_ZOOKEEPER_CONNECT="stg-kaf-app01.stage.cloud.local:2181,stg-kaf-app02.stage.cloud.local:2181,stg-kaf-app03.stage.cloud.local:2181"
elif [[ "$domain" == "prod.cloud.local" ]]; then
  KAFKA_ZOOKEEPER_CONNECT="prd-kaf-app1.prod.cloud.local:2181,prd-kaf-app2.prod.cloud.local:2181,prd-kaf-app3.prod.cloud.local:2181"
fi

# Set kafka super users based on environment
if [[ "$domain" == "stage.cloud.local" ]]; ]; then
  KAFKA_SUPER_USERS="User:CN=stg-kaf-app01.stage.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=stg-kaf-app02.stage.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=stg-kaf-app03.stage.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK"
elif [[ "$domain" == "prod.cloud.local" ]]; then
  KAFKA_SUPER_USERS="User:CN=prd-kaf-app1.prod.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=prd-kaf-app2.prod.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=prd-kaf-app3.prod.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK"
fi

# Set Kafdrop broker connect list based on environment
if [[ "$domain" == "stage.cloud.local" ]]; then
  KAFKA_BROKERCONNECT="stg-kaf-app01.stage.cloud.local:9191,stg-kaf-app02.stage.cloud.local:9192,stg-kaf-app03.stage.cloud.local:9193"
else
  KAFKA_BROKERCONNECT="prd-kaf-app1.prod.cloud.local:9191,prd-kaf-app2.prod.cloud.local:9192,prd-kaf-app3.prod.cloud.local:9193"
fi

KAFKA_REST_SSL_KEYSTORE_PASSWORD=$KAFKA_REST_CLIENT_SSL_KEYSTORE_PASSWORD
KAFKA_REST_SSL_TRUSTSTORE_PASSWORD=$KAFKA_REST_CLIENT_SSL_TRUSTSTORE_PASSWORD

# Write the .env file
cat > .env <<EOF
# =====================
# Kafka Broker Settings
# =====================
KAFKA_BROKER_ID=$broker_id
KAFKA_LISTENER_HOST=${host_prefix}.${domain}
KAFKA_SSL_PORT=$ssl_port
KAFKA_ZOOKEEPER_CONNECT="$KAFKA_ZOOKEEPER_CONNECT"
KAFKA_LISTENER_SECURITY_PROTOCOL_MAP="SSL:SSL,PLAINTEXT:PLAINTEXT,INTERNAL:SSL"
KAFKA_LISTENERS="SSL://${host_prefix}.${domain}:${ssl_port},PLAINTEXT://${host_prefix}.${domain}:919${broker_id},INTERNAL://${host_prefix}.${domain}:929${broker_id}"
KAFKA_ADVERTISED_LISTENERS="SSL://stream.causeway.com:${ssl_port},PLAINTEXT://${host_prefix}.${domain}:919${broker_id},INTERNAL://${host_prefix}.${domain}:929${broker_id}"
KAFKA_INTER_BROKER_LISTENER_NAME=INTERNAL
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
# Zookeeper Settings
# =====================
ZOOKEEPER_SERVERS="$ZOOKEEPER_SERVERS"
ZOOKEEPER_SERVER_ID=$broker_id
ZOOKEEPER_CLIENT_PORT=2181
ZOOKEEPER_TICK_LIMIT=2000
ZOOKEEPER_INIT_LIMIT=5
ZOOKEEPER_SYNC_LIMIT=2
ZOOKEEPER_SET_ACL=true

# =====================
# Kafdrop Settings
# =====================
KAFKA_BROKERCONNECT="$KAFKA_BROKERCONNECT"
JVM_OPTS="-Xms32M -Xmx64M"
SERVER_SERVLET_CONTEXTPATH="/"
ZOOKEEPER_CONNECT="$KAFKA_ZOOKEEPER_CONNECT"

# =====================
# REST Proxy Settings
# =====================
KAFKA_REST_HOST_NAME="${host_prefix}.${domain}"
KAFKA_REST_BOOTSTRAP_SERVERS="$KAFKA_BROKERCONNECT"
KAFKA_REST_ZOOKEEPER_CONNECT="$KAFKA_ZOOKEEPER_CONNECT"
KAFKA_REST_LISTENERS="http://${host_prefix}.${domain}:8082"
KAFKA_REST_SCHEMA_REGISTRY_URL="http://${host_prefix}.${domain}:8081"
KAFKA_HEAP_OPTS="-Xms1G -Xmx1G"
KAFKA_REST_SECURITY_PROTOCOL=SSL
KAFKA_REST_SSL_PROTOCOL=SSL
KAFKA_REST_CLIENT_SSL_KEYSTORE_PASSWORD=$KAFKA_REST_SSL_KEYSTORE_PASSWORD
KAFKA_REST_CLIENT_SSL_TRUSTSTORE_PASSWORD=$KAFKA_REST_SSL_TRUSTSTORE_PASSWORD
KAFKA_REST_CLIENT_SSL_KEYSTORE_LOCATION="/etc/kafka/secrets/kafka-rest-staging-keystore.jks"
KAFKA_REST_CLIENT_SSL_TRUSTSTORE_LOCATION="/etc/kafka/secrets/kafka-rest-staging-truststore.jks"
EOF

docker compose up -d