
# Get debezium container id
container_id=$(docker ps | grep kafka | grep 9092 | grep confluent | awk '{print $1}')

# Enter inside of container
docker exec -it $container_id /bin/bash

# List topics
kafka-topics --bootstrap-server localhost:9092 --list

# Listen messages
kafka-console-consumer --bootstrap-server localhost:9092 --topic postgres.public.shipments
