# Change data capture using Postgres, Debezium and Kafka

## How to use?
You need to create a kafka environment.
```bash
docker compose up
```
### Configure database
Enter into database and you must urn the following instructions.
```sql
CREATE TABLE IF NOT EXISTS shipments
(
    shipment_id bigint NOT NULL,
    order_id bigint NOT NULL,
    date_created character varying(255) COLLATE pg_catalog."default",
    status character varying(25) COLLATE pg_catalog."default",
    CONSTRAINT shipments_pkey PRIMARY KEY (shipment_id)
);

INSERT INTO shipments values (30500,10500,'2021-01-21','COMPLETED');
INSERT INTO shipments values (31500,11500,'2021-04-21','COMPLETED');
INSERT INTO shipments values (32500,12500,'2021-05-31','PROCESSING');
```

### Debezium
```bash
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
```

### Kafka consumer
```bash
kafka-console-consumer --bootstrap-server localhost:9092 --topic postgres.public.shipments
```

### Database
```sql
INSERT INTO shipments values (33500, 13500,'2021-06-01','PENDING');
UPDATE shipments set status = 'PROCESSING' where shipment_id = 33500;
```