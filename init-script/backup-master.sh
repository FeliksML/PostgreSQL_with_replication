#Backup master
pg_basebackup -D /var/lib/postgresql/data-slave -S replication_slot_slave1 -X stream -P -U replicator -Fp -R
pg_basebackup -D /var/lib/postgresql/data-slave2 -S replication_slot_slave2 -X stream -P -U replicator2 -Fp -R
