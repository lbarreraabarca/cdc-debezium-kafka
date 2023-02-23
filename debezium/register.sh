
# Get debezium container id
container_id=$(docker ps | grep 8083 | grep debezium | awk '{print $1}')

# Enter inside of container
docker exec -it $container_id /bin/bash

# This command allow register the postgres connector in debezium
curl -H 'Content-Type: application/json' debezium:8083/connectors --data '
{
  "name": "shipments-connector",  
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector", 
    "plugin.name": "pgoutput",
    "database.hostname": "postgres", 
    "database.port": "5432", 
    "database.user": "postgresuser", 
    "database.password": "postgrespw", 
    "database.dbname" : "shipment_db", 
    "database.server.name": "postgres", 
    "table.include.list": "public.shipments" 
  }
}'