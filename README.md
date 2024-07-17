# 🐘 PostgreSQL Replication Project 🚀

This project sets up a PostgreSQL replication environment using Docker, with one master node and two slave nodes. It also includes a sample database schema for a store management system.

## 🌟 Features

- PostgreSQL 14.5 containers
- Master-Slave replication with two slaves
- Sample store database schema
- Easy setup with Docker Compose
- Automated backup and initialization scripts

## 🚀 Project Structure
``` 
📁 postgresql-replication/
│
├── 📄 docker-compose.yml
├── 📄 docker-init.sh
├── 📄 createdb.sql
├── 📄 backup-master.sh
├── 📄 create-replica-user.sh
├── 📄 init-slave.sh
├── 📄 init.sh
│
├── 📁 init-script/
│   ├── 📁 csv/
│   │   └── (various CSV files)
│   ├── 📁 config/
│   │   ├── 📄 pg_hba.conf
│   │   └── 📄 postgres.conf
│   ├── 📁 slave-config/
│   ├── 📁 slave2-config/
│   └── 📄 init.sh
│
├── 📁 data/
├── 📁 data-slave/
└── 📁 data-slave2/
```
## 🛠 Setup

1. Clone this repository:
git clone https://github.com/yourusername/postgresql-replication.git
cd postgresql-replication

2. Run the initialization script:
./docker-init.sh

This script will:
- Clear any existing data
- Start the master PostgreSQL node
- Prepare replica configuration
- Start the slave nodes

## 🐳 Docker Containers

- `postgres_master`: Master node (Port 5432)
- `postgres_slave`: First slave node (Port 5433)
- `postgres_slave2`: Second slave node (Port 5434)

## 📊 Database Schema

The `createdb.sql` file sets up a `store` schema with various tables including manufacturers, categories, products, stores, customers, price changes, deliveries, purchases, and purchase items. It also creates a `store_sales_summary` view.

## 🔄 Replication

The master-slave replication is set up automatically using the provided configuration files and initialization scripts:

- `create-replica-user.sh`: Creates replication users and replication slots
- `backup-master.sh`: Performs base backups for both slave nodes
- `init-slave.sh`: Initializes slave configurations
- `init.sh`: Orchestrates the entire initialization process

## 🔒 Security

Replication users are created with encrypted passwords. Ensure to change the default passwords in a production environment.

## 🚧 Note

This setup is intended for development and testing purposes. For production environments, please ensure proper security measures are in place and customize the configuration as needed.
