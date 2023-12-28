echo "Clearing data"
rm -rf data*
rm -rf ../postgresql-rp/data/*
rm -rf ../postgresql-rp/data-slave/*
docker-compose down
docker-compose up -d  postgres_master

echo "Starting postgres_master node..."
sleep 12  # Waits for master note start complete

echo "Prepare replica config..."
docker exec -it postgres_master sh /etc/postgresql/init-script/init.sh
echo "Restart master node"
docker-compose restart postgres_master
sleep 10

echo "Starting slave node..."
docker-compose up -d  postgres_slave
sleep 10  # Waits for note start complete
echo "Starting slave2 node..."
docker-compose up -d  postgres_slave2
sleep 10
echo "Done"
