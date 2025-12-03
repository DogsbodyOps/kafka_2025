docker rm zk
host=$(hostname)
if [ $host = 'kafka-app1' ]
then
   zookeeper_servers="0.0.0.0:2888:3888;kafka-app2.cloud.local:2888:3888;kafka-app3.cloud.local:2888:3888"
   zookeeper_id=1
elif [ $host = 'kafka-app2' ]
then
   zookeeper_servers="kafka-app1.cloud.local:2888:3888;0.0.0.0:2888:3888;kafka-app3.cloud.local:2888:3888"
   zookeeper_id=2
elif [ $host = 'kafka-app3' ]
then
   zookeeper_servers="kafka-app1.cloud.local:2888:3888;kafka-app2.cloud.local:2888:3888;0.0.0.0:2888:3888"
   zookeeper_id=3
fi

docker run -d \
        --name=zk \
        --net=host \
        --restart always \
        -e ZOOKEEPER_SERVER_ID=$zookeeper_id \
        -e ZOOKEEPER_CLIENT_PORT=2181 \
        -e ZOOKEEPER_TICK_LIMIT=2000 \
        -e ZOOKEEPER_INIT_LIMIT=5 \
        -e ZOOKEEPER_SYNC_LIMIT=2 \
        -e ZOOKEEPER_SET_ACL=true \
        -e ZOOKEEPER_SERVERS=$zookeeper_servers \
        -v /data/kafka/vol1/zk-data:/var/lib/zookeeper/data \
        -v /data/kafka/vol2/zk-txn-logs:/var/lib/zookeeper/log \
        confluentinc/cp-zookeeper:3.3.0