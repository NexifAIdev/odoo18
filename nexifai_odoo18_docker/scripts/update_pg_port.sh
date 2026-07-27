#!/bin/bash

# Bash script to update PostgreSQL port inside Docker container

# Set variables
container_name="odoo18-db"   # must match container_name in docker-compose.yaml
pg_config_file="/var/lib/postgresql/data/pgdata/postgresql.conf"
pg_data_dir="/var/lib/postgresql/data/pgdata"
new_port="5434"

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${container_name}$"; then
    echo "❌ ERROR: Container '${container_name}' is not running."
    exit 1
fi

echo ""
echo "📄 Updating PostgreSQL to use port ${new_port}..."

# Update port in postgresql.conf inside the container
docker exec "$container_name" sed -i "s/^#*port = .*/port = ${new_port}/" "$pg_config_file"

# Reload PostgreSQL configuration
echo "🔄 Reloading PostgreSQL configuration..."
docker exec -u postgres "$container_name" pg_ctl reload -D "$pg_data_dir"

echo ""
echo "✅ PostgreSQL port updated to ${new_port} and reloaded successfully."
