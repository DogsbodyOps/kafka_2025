docker rm rest
host=$(hostname)
if [ $host = 'kafka-web1' ]
then
   kafka_rest_host_name=kafka-web1.cloud.local
   schema_registry_host_name=kafka-web1.cloud.local
elif [ $host = 'kafka-web2' ]
then
   kafka_rest_host_name=kafka-web2.cloud.local
   schema_registry_host_name=kafka-web2.cloud.local
fi

docker run -d \
        --name=rest \
        --net=host \
        --restart always \
        -e KAFKA_REST_HOST_NAME=$kafka_rest_host_name \
        -e KAFKA_REST_BOOTSTRAP_SERVERS=stream.staging.causeway.com:9091,stream.staging.causeway.com:9092,stream.staging.causeway.com:9093 \
        -e KAFKA_REST_ZOOKEEPER_CONNECT="kafka-app1.cloud.local:2181,kafka-app2.cloud.local:2181,kafka-app3.cloud.local:2181" \
        -e KAFKA_REST_LISTENERS="http://$kafka_rest_host_name:8082" \
        -e KAFKA_REST_SCHEMA_REGISTRY_URL="http://$schema_registry_host_name:8081" \
        -e KAFKA_HEAP_OPTS="-Xms1G -Xmx1G" \
        -e KAFKA_REST_SECURITY_PROTOCOL=SSL \
        -e KAFKA_REST_SSL_PROTOCOL=SSL \
        -e KAFKA_REST_CLIENT_SSL_KEYSTORE_PASSWORD="" \
        -e KAFKA_REST_CLIENT_SSL_TRUSTSTORE_PASSWORD="" \
        -e KAFKA_REST_CLIENT_SSL_KEYSTORE_LOCATION=/etc/kafka/secrets/kafka-rest-staging-keystore.jks \
        -e KAFKA_REST_CLIENT_SSL_TRUSTSTORE_LOCATION=/etc/kafka/secrets/kafka-rest-staging-truststore.jks \
        -v `pwd`/secrets:/etc/kafka/secrets \
        -v "/$(pwd)/log4j_1x_lib/empty-jar.jar:/usr/share/java/confluent-common/log4j-1.2.17.jar" \
        -v "/$(pwd)/log4j_1x_lib/log4j-1.2-api-2.17.0.jar:/usr/share/java/confluent-common/log4j-1.2-api-2.17.0.jar" \
        -v "/$(pwd)/log4j_1x_lib/log4j-api-2.17.0.jar:/usr/share/java/confluent-common/log4j-api-2.17.0.jar" \
        -v "/$(pwd)/log4j_1x_lib/log4j-core-2.17.0.jar:/usr/share/java/confluent-common/log4j-core-2.17.0.jar" \
        -v "/$(pwd)/log4j_1x_lib/empty-jar.jar:/usr/share/java/kafka-rest/log4j-1.2.17.jar" \
        -v "/$(pwd)/log4j_1x_lib/log4j-1.2-api-2.17.0.jar:/usr/share/java/kafka-rest/log4j-1.2-api-2.17.0.jar" \
        -v "/$(pwd)/log4j_1x_lib/log4j-api-2.17.0.jar:/usr/share/java/kafka-rest/log4j-api-2.17.0.jar" \
        -v "/$(pwd)/log4j_1x_lib/log4j-core-2.17.0.jar:/usr/share/java/kafka-rest/log4j-core-2.17.0.jar" \
        docker.causeway.com/kafka/kafka-rest:3.3.0