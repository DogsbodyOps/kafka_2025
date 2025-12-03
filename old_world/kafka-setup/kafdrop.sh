docker rm kafdrop
#docker run -d \
#        --name=kafdrop \
#        --restart always \
#        --net=host \
#        -e ZOOKEEPER_CONNECT="kafka-app1.cloud.local:2181,kafka-app2.cloud.local:2181,kafka-app3.cloud.local:2181" \
#        docker.causeway.com/kafka/kafdrop:2.0.0

docker run -d -p 9000:9000 --name=kafdrop \
    --restart always \
    -e ZOOKEEPER_CONNECT=kafka-app1.cloud.local:2181,kafka-app2.cloud.local:2181,kafka-app3.cloud.local:2181 \
    -e KAFKA_BROKERCONNECT=kafka-app1.cloud.local:9191,kafka-app2.cloud.local:9192,kafka-app3.cloud.local:9193 \
    -e JVM_OPTS="-Xms32M -Xmx64M" \
    -e SERVER_SERVLET_CONTEXTPATH="/" \
    docker.causeway.com/kafka/kafdrop:3.8.0
    #obsidiandynamics/kafdrop