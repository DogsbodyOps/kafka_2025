docker rm kafka
host=$(hostname)
SUPER_USERS="User:CN=kafka-prod-app1.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=kafka-prod-app2.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=kafka-prod-app3.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK"
if [ $host = 'kafka-app1' ]
then
   docker run -d \
        --name=kafka   \
        --net=host \
        --restart always \
        -e KAFKA_BROKER_ID=1 \
        -e KAFKA_ZOOKEEPER_CONNECT="kafka-app1.cloud.local:2181,kafka-app2.cloud.local:2181,kafka-app3.cloud.local:2181" \
        -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=SSL:SSL,PLAINTEXT:PLAINTEXT,INTERNAL:SSL \
        -e KAFKA_LISTENERS=SSL://kafka-app1.cloud.local:9091,PLAINTEXT://kafka-app1.cloud.local:9191,INTERNAL://kafka-app1.cloud.local:9291 \
        -e KAFKA_ADVERTISED_LISTENERS=SSL://stream.causeway.com:9091,PLAINTEXT://kafka-app1.cloud.local:9191,INTERNAL://kafka-app1.cloud.local:9291 \
        -e KAFKA_INTER_BROKER_LISTENER_NAME=INTERNAL \
        -e KAFKA_SSL_KEYSTORE_FILENAME=kafka-prod-app1-keystore.jks \
        -e KAFKA_SSL_KEYSTORE_CREDENTIALS=kafka_app1_keystore_creds \
        -e KAFKA_SSL_KEY_CREDENTIALS=kafka_app1_sslkey_creds \
        -e KAFKA_SSL_TRUSTSTORE_FILENAME=kafka-prod-app1-truststore.jks \
        -e KAFKA_SSL_TRUSTSTORE_CREDENTIALS=kafka_app1_truststore_creds \
        -e KAFKA_SSL_CLIENT_AUTH=required \
        -e KAFKA_LOG4J_LOGGERS="kafka.authorizer.logger=INFO" \
        -e KAFKA_DELETE_TOPIC_ENABLE=true \
        -e KAFKA_DEFAULT_REPLICATION_FACTOR=3 \
        -e KAFKA_AUTHORIZER_CLASS=kafka.security.auth.SimpleAclAuthorizer \
        -e KAFKA_SUPER_USERS="User:CN=kafka-prod-app1.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=kafka-prod-app2.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=kafka-prod-app3.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK" \
        -v /data/kafka/vol3/kafka-data:/var/lib/kafka/data \
        -v /data/kafka/vol4/secrets:/etc/kafka/secrets \
        -v "/$(pwd)/log4j_1x_lib/log4j-api-2.17.0.jar:/usr/share/java/kafka/log4j-api-2.17.0.jar" \
        -v "/$(pwd)/log4j_1x_lib/log4j-core-2.17.0.jar:/usr/share/java/kafka/log4j-core-2.17.0.jar" \
        -v "$(pwd)/log4j_1x_lib/empty-jar.jar:/usr/share/java/kafka/log4j-1.2.17.jar" \
        -v "$(pwd)/log4j_1x_lib/log4j-1.2-api-2.17.0.jar:/usr/share/java/kafka/log4j-1.2-api-2.17.0.jar" \
    confluentinc/cp-kafka:3.3.0
elif [ $host = 'kafka-app2' ]
then
  docker run -d \
        --name=kafka   \
        --net=host \
        --restart always \
        -e KAFKA_BROKER_ID=2 \
        -e KAFKA_ZOOKEEPER_CONNECT="kafka-app1.cloud.local:2181,kafka-app2.cloud.local:2181,kafka-app3.cloud.local:2181" \
        -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=SSL:SSL,PLAINTEXT:PLAINTEXT,INTERNAL:SSL \
        -e KAFKA_LISTENERS=SSL://kafka-app2.cloud.local:9092,PLAINTEXT://kafka-app2.cloud.local:9192,INTERNAL://kafka-app2.cloud.local:9292 \
        -e KAFKA_ADVERTISED_LISTENERS=SSL://stream.causeway.com:9092,PLAINTEXT://kafka-app2.cloud.local:9192,INTERNAL://kafka-app2.cloud.local:9292 \
        -e KAFKA_INTER_BROKER_LISTENER_NAME=INTERNAL \
        -e KAFKA_SSL_KEYSTORE_FILENAME=kafka-prod-app2-keystore.jks \
        -e KAFKA_SSL_KEYSTORE_CREDENTIALS=kafka_app2_keystore_creds \
        -e KAFKA_SSL_KEY_CREDENTIALS=kafka_app2_sslkey_creds \
        -e KAFKA_SSL_TRUSTSTORE_FILENAME=kafka-prod-app2-truststore.jks \
        -e KAFKA_SSL_TRUSTSTORE_CREDENTIALS=kafka_app2_truststore_creds \
        -e KAFKA_SSL_CLIENT_AUTH=required \
        -e KAFKA_LOG4J_LOGGERS="kafka.authorizer.logger=INFO" \
        -e KAFKA_DELETE_TOPIC_ENABLE=true \
        -e KAFKA_DEFAULT_REPLICATION_FACTOR=3 \
        -e KAFKA_AUTHORIZER_CLASS=kafka.security.auth.SimpleAclAuthorizer \
        -e KAFKA_SUPER_USERS="User:CN=kafka-prod-app1.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=kafka-prod-app2.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=kafka-prod-app3.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK" \
        -v /data/kafka/vol3/kafka-data:/var/lib/kafka/data \
        -v /data/kafka/vol4/secrets:/etc/kafka/secrets \
        -v "/$(pwd)/log4j_1x_lib/log4j-api-2.17.0.jar:/usr/share/java/kafka/log4j-api-2.17.0.jar" \
        -v "/$(pwd)/log4j_1x_lib/log4j-core-2.17.0.jar:/usr/share/java/kafka/log4j-core-2.17.0.jar" \
        -v "$(pwd)/log4j_1x_lib/empty-jar.jar:/usr/share/java/kafka/log4j-1.2.17.jar" \
        -v "$(pwd)/log4j_1x_lib/log4j-1.2-api-2.17.0.jar:/usr/share/java/kafka/log4j-1.2-api-2.17.0.jar" \
    confluentinc/cp-kafka:3.3.0
elif [ $host = 'kafka-app3' ]
then
   docker run -d \
        --name=kafka   \
        --net=host \
        --restart always \
        -e KAFKA_BROKER_ID=3 \
        -e KAFKA_ZOOKEEPER_CONNECT="kafka-app1.cloud.local:2181,kafka-app2.cloud.local:2181,kafka-app3.cloud.local:2181" \
        -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=SSL:SSL,PLAINTEXT:PLAINTEXT,INTERNAL:SSL \
        -e KAFKA_LISTENERS=SSL://kafka-app3.cloud.local:9093,PLAINTEXT://kafka-app3.cloud.local:9193,INTERNAL://kafka-app3.cloud.local:9293 \
        -e KAFKA_ADVERTISED_LISTENERS=SSL://stream.causeway.com:9093,PLAINTEXT://kafka-app3.cloud.local:9193,INTERNAL://kafka-app3.cloud.local:9293 \
        -e KAFKA_INTER_BROKER_LISTENER_NAME=INTERNAL \
        -e KAFKA_SSL_KEYSTORE_FILENAME=kafka-prod-app3-keystore.jks \
        -e KAFKA_SSL_KEYSTORE_CREDENTIALS=kafka_app3_keystore_creds \
        -e KAFKA_SSL_KEY_CREDENTIALS=kafka_app3_sslkey_creds \
        -e KAFKA_SSL_TRUSTSTORE_FILENAME=kafka-prod-app3-truststore.jks \
        -e KAFKA_SSL_TRUSTSTORE_CREDENTIALS=kafka_app3_truststore_creds \
        -e KAFKA_SSL_CLIENT_AUTH=required \
        -e KAFKA_LOG4J_LOGGERS="kafka.authorizer.logger=INFO" \
        -e KAFKA_DELETE_TOPIC_ENABLE=true \
        -e KAFKA_DEFAULT_REPLICATION_FACTOR=3 \
        -e KAFKA_AUTHORIZER_CLASS=kafka.security.auth.SimpleAclAuthorizer \
        -e KAFKA_SUPER_USERS="User:CN=kafka-prod-app1.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=kafka-prod-app2.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK;User:CN=kafka-prod-app3.cloud.local,OU=STREAM,O=CAUSEWAY,L=FARNHAM,ST=SURREY,C=UK" \
        -v /data/kafka/vol3/kafka-data:/var/lib/kafka/data \
        -v /data/kafka/vol4/secrets:/etc/kafka/secrets \
        -v "/$(pwd)/log4j_1x_lib/log4j-api-2.17.0.jar:/usr/share/java/kafka/log4j-api-2.17.0.jar" \
        -v "/$(pwd)/log4j_1x_lib/log4j-core-2.17.0.jar:/usr/share/java/kafka/log4j-core-2.17.0.jar" \
        -v "$(pwd)/log4j_1x_lib/empty-jar.jar:/usr/share/java/kafka/log4j-1.2.17.jar" \
        -v "$(pwd)/log4j_1x_lib/log4j-1.2-api-2.17.0.jar:/usr/share/java/kafka/log4j-1.2-api-2.17.0.jar" \
    confluentinc/cp-kafka:3.3.0
fi