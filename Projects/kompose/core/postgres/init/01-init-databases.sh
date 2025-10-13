#!/bin/bash
set -e

# PostgreSQL initialization script for kompose core stack
# This script runs on first database initialization
# Creates all databases required by kompose.sh stacks

echo "Starting kompose database initialization..."

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create databases for kompose services
    -- Main application database
    SELECT 'CREATE DATABASE kompose'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'kompose')\gexec
    
    -- n8n workflow database
    SELECT 'CREATE DATABASE n8n'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'n8n')\gexec
    
    -- Semaphore Ansible automation database
    SELECT 'CREATE DATABASE semaphore'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'semaphore')\gexec
    
    -- Gitea git repository database
    SELECT 'CREATE DATABASE gitea'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'gitea')\gexec
    
    -- Keycloak authentication database
    SELECT 'CREATE DATABASE keycloak'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'keycloak')\gexec
    
    -- Letterspace newsletter database
    SELECT 'CREATE DATABASE letterspace'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'letterspace')\gexec
    
    -- Grant privileges to all databases
    GRANT ALL PRIVILEGES ON DATABASE kompose TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE n8n TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE semaphore TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE gitea TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE keycloak TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE letterspace TO $POSTGRES_USER;
    
    -- Log success
    SELECT 'Kompose databases initialized:' AS status;
    SELECT datname FROM pg_database 
    WHERE datname IN ('kompose', 'n8n', 'semaphore', 'gitea', 'keycloak', 'letterspace')
    ORDER BY datname;
EOSQL

echo ""
echo "✓ PostgreSQL initialization completed"
echo "✓ All kompose databases created successfully"
echo ""
echo "Databases available:"
echo "  • kompose     - Main application database"
echo "  • n8n         - Workflow automation"
echo "  • semaphore   - Ansible task automation"
echo "  • gitea       - Git repository"
echo "  • keycloak    - Authentication & SSO"
echo "  • letterspace - Newsletter service"
echo ""
