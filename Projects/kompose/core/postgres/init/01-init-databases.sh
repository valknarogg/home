#!/bin/bash
set -e

# PostgreSQL initialization script for kompose core stack
# This script runs on first database initialization

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create databases for kompose services
    SELECT 'CREATE DATABASE n8n'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'n8n')\gexec
    
    SELECT 'CREATE DATABASE semaphore'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'semaphore')\gexec
    
    SELECT 'CREATE DATABASE gitea'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'gitea')\gexec
    
    -- Grant privileges
    GRANT ALL PRIVILEGES ON DATABASE n8n TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE semaphore TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE gitea TO $POSTGRES_USER;
    
    -- Log success
    SELECT 'Kompose databases created successfully' AS status;
EOSQL

echo "PostgreSQL initialization completed"
