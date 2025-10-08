#!/bin/bash

# Kompose New Stacks Setup Script
# This script creates all directories and files for the 4 new stacks

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BASE_DIR="/home/valknar/Projects/kompose"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Kompose New Stacks Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -d "$BASE_DIR" ]; then
    echo -e "${RED}Error: Kompose directory not found at $BASE_DIR${NC}"
    exit 1
fi

cd "$BASE_DIR"

# Generate secrets
echo -e "${BLUE}Generating secrets...${NC}"
N8N_KEY=$(openssl rand -hex 32)
NEXTAUTH_SECRET=$(openssl rand -base64 32)
echo -e "${GREEN}✓ Secrets generated${NC}"
echo ""

# ============================================================================
# HOME STACK
# ============================================================================

echo -e "${YELLOW}Creating home stack...${NC}"
mkdir -p home/config

# home/compose.yaml
cat > home/compose.yaml << 'EOF'
name: home

services:
  homeassistant:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_app
    restart: unless-stopped
    privileged: true
    environment:
      TZ: ${TZ}
    volumes:
      - ./config:/config
      - /etc/localtime:/etc/localtime:ro
    networks:
      - kompose_network
    ports:
      - "${APP_PORT}:8123"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8123/manifest.json"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect-web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-web-secure-compress.compress=true'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-web-secure-compress'
      - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=${APP_PORT}'
      - 'traefik.docker.network=${NETWORK_NAME}'

networks:
  kompose_network:
    name: ${NETWORK_NAME}
    external: true
EOF

# home/.env
cat > home/.env << 'EOF'
# Stack identification
COMPOSE_PROJECT_NAME=home

# Docker image
DOCKER_IMAGE=ghcr.io/home-assistant/home-assistant:stable

# Traefik hostname
TRAEFIK_HOST=home.localhost

# App port
APP_PORT=8123

# Network
NETWORK_NAME=kompose

# Timezone (important for automations!)
TZ=Europe/Paris
EOF

echo -e "${GREEN}✓ Home stack created${NC}"

# ============================================================================
# CHAIN STACK
# ============================================================================

echo -e "${YELLOW}Creating chain stack...${NC}"
mkdir -p chain

# chain/compose.yaml
cat > chain/compose.yaml << 'EOF'
name: chain

services:
  n8n:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_app
    restart: unless-stopped
    environment:
      DB_TYPE: postgresdb
      DB_POSTGRESDB_HOST: ${DB_HOST}
      DB_POSTGRESDB_PORT: 5432
      DB_POSTGRESDB_DATABASE: ${DB_NAME}
      DB_POSTGRESDB_USER: ${DB_USER}
      DB_POSTGRESDB_PASSWORD: ${DB_PASSWORD}
      N8N_ENCRYPTION_KEY: ${N8N_ENCRYPTION_KEY}
      WEBHOOK_URL: https://${TRAEFIK_HOST}/
      GENERIC_TIMEZONE: ${TZ}
      N8N_BASIC_AUTH_ACTIVE: ${N8N_BASIC_AUTH_ACTIVE}
      N8N_BASIC_AUTH_USER: ${N8N_BASIC_AUTH_USER}
      N8N_BASIC_AUTH_PASSWORD: ${N8N_BASIC_AUTH_PASSWORD}
      EXECUTIONS_DATA_SAVE_ON_ERROR: all
      EXECUTIONS_DATA_SAVE_ON_SUCCESS: all
      EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS: true
      N8N_EMAIL_MODE: ${EMAIL_TRANSPORT}
      N8N_SMTP_HOST: ${EMAIL_SMTP_HOST}
      N8N_SMTP_PORT: ${EMAIL_SMTP_PORT}
      N8N_SMTP_USER: ${EMAIL_SMTP_USER}
      N8N_SMTP_PASS: ${EMAIL_SMTP_PASSWORD}
      N8N_SMTP_SENDER: ${EMAIL_FROM}
    volumes:
      - n8n_data:/home/node/.n8n
    healthcheck:
      test: ["CMD-SHELL", "wget --spider -q http://localhost:${APP_PORT}/healthz || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 45s
    networks:
      - kompose_network
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect-web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-web-secure-compress.compress=true'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-web-secure-compress'
      - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=${APP_PORT}'
      - 'traefik.docker.network=${NETWORK_NAME}'

volumes:
  n8n_data:

networks:
  kompose_network:
    name: ${NETWORK_NAME}
    external: true
EOF

# chain/.env with generated secret
cat > chain/.env << EOF
# Stack identification
COMPOSE_PROJECT_NAME=chain

# Docker image
DOCKER_IMAGE=n8nio/n8n:latest

# Database name
DB_NAME=n8n

# Traefik hostname
TRAEFIK_HOST=chain.localhost

# App port
APP_PORT=5678

# Network
NETWORK_NAME=kompose

# Timezone
TZ=Europe/Paris

# Encryption key for credentials (GENERATED!)
N8N_ENCRYPTION_KEY=$N8N_KEY

# Basic Auth (optional, recommended for initial setup)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=changeme
EOF

echo -e "${GREEN}✓ Chain stack created${NC}"

# ============================================================================
# GIT STACK
# ============================================================================

echo -e "${YELLOW}Creating git stack...${NC}"
mkdir -p git

# git/compose.yaml
cat > git/compose.yaml << 'EOF'
name: git

services:
  gitea:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_app
    restart: unless-stopped
    environment:
      USER_UID: 1000
      USER_GID: 1000
      GITEA__database__DB_TYPE: postgres
      GITEA__database__HOST: ${DB_HOST}:5432
      GITEA__database__NAME: ${DB_NAME}
      GITEA__database__USER: ${DB_USER}
      GITEA__database__PASSWD: ${DB_PASSWORD}
      GITEA__server__DOMAIN: ${TRAEFIK_HOST}
      GITEA__server__SSH_DOMAIN: ${TRAEFIK_HOST}
      GITEA__server__ROOT_URL: https://${TRAEFIK_HOST}/
      GITEA__server__HTTP_PORT: ${APP_PORT}
      GITEA__server__DISABLE_SSH: ${DISABLE_SSH}
      GITEA__server__SSH_PORT: ${SSH_PORT}
      GITEA__security__INSTALL_LOCK: true
      GITEA__mailer__ENABLED: ${EMAIL_ENABLED}
      GITEA__mailer__SMTP_ADDR: ${EMAIL_SMTP_HOST}
      GITEA__mailer__SMTP_PORT: ${EMAIL_SMTP_PORT}
      GITEA__mailer__FROM: ${EMAIL_FROM}
      GITEA__mailer__USER: ${EMAIL_SMTP_USER}
      GITEA__mailer__PASSWD: ${EMAIL_SMTP_PASSWORD}
    volumes:
      - gitea_data:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "${SSH_PORT}:22"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:${APP_PORT}/api/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    networks:
      - kompose_network
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect-web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-web-secure-compress.compress=true'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-web-secure-compress'
      - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=${APP_PORT}'
      - 'traefik.docker.network=${NETWORK_NAME}'

volumes:
  gitea_data:

networks:
  kompose_network:
    name: ${NETWORK_NAME}
    external: true
EOF

# git/.env
cat > git/.env << 'EOF'
# Stack identification
COMPOSE_PROJECT_NAME=git

# Docker image
DOCKER_IMAGE=gitea/gitea:latest

# Database name
DB_NAME=gitea

# Traefik hostname
TRAEFIK_HOST=git.localhost

# App port (internal HTTP)
APP_PORT=3000

# SSH port (for git operations)
SSH_PORT=2222

# Network
NETWORK_NAME=kompose

# SSH settings
DISABLE_SSH=false

# Email settings (optional)
EMAIL_ENABLED=true
EOF

echo -e "${GREEN}✓ Git stack created${NC}"

# ============================================================================
# LINK STACK
# ============================================================================

echo -e "${YELLOW}Creating link stack...${NC}"
mkdir -p link

# link/compose.yaml
cat > link/compose.yaml << 'EOF'
name: link

services:
  linkwarden:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_app
    restart: unless-stopped
    environment:
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:5432/${DB_NAME}
      NEXTAUTH_SECRET: ${NEXTAUTH_SECRET}
      NEXTAUTH_URL: https://${TRAEFIK_HOST}
      NEXT_PUBLIC_PAGINATION_TAKE_COUNT: 20
      STORAGE_FOLDER: /data/archives
      NEXT_PUBLIC_DISABLE_SCREENSHOT: ${DISABLE_SCREENSHOT}
      NEXT_PUBLIC_DISABLE_ARCHIVE: ${DISABLE_ARCHIVE}
      NEXT_PUBLIC_DISABLE_REGISTRATION: ${DISABLE_REGISTRATION}
      EMAIL_FROM: ${EMAIL_FROM}
      EMAIL_SERVER: smtp://${EMAIL_SMTP_USER}:${EMAIL_SMTP_PASSWORD}@${EMAIL_SMTP_HOST}:${EMAIL_SMTP_PORT}
    volumes:
      - linkwarden_data:/data/archives
    healthcheck:
      test: ["CMD-SHELL", "wget --spider -q http://localhost:${APP_PORT}/api/healthcheck || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    networks:
      - kompose_network
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-redirect-web-secure.redirectscheme.scheme=https'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.middlewares=${COMPOSE_PROJECT_NAME}-redirect-web-secure'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web.entrypoints=web'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.rule=Host(`${TRAEFIK_HOST}`)'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.tls.certresolver=resolver'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.entrypoints=web-secure'
      - 'traefik.http.middlewares.${COMPOSE_PROJECT_NAME}-web-secure-compress.compress=true'
      - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=${COMPOSE_PROJECT_NAME}-web-secure-compress'
      - 'traefik.http.services.${COMPOSE_PROJECT_NAME}-web-secure.loadbalancer.server.port=${APP_PORT}'
      - 'traefik.docker.network=${NETWORK_NAME}'

volumes:
  linkwarden_data:

networks:
  kompose_network:
    name: ${NETWORK_NAME}
    external: true
EOF

# link/.env with generated secret
cat > link/.env << EOF
# Stack identification
COMPOSE_PROJECT_NAME=link

# Docker image
DOCKER_IMAGE=ghcr.io/linkwarden/linkwarden:latest

# Database name
DB_NAME=linkwarden

# Traefik hostname
TRAEFIK_HOST=link.localhost

# App port
APP_PORT=3000

# Network
NETWORK_NAME=kompose

# NextAuth Secret (GENERATED!)
NEXTAUTH_SECRET=$NEXTAUTH_SECRET

# Features
DISABLE_SCREENSHOT=false
DISABLE_ARCHIVE=false
DISABLE_REGISTRATION=true
EOF

echo -e "${GREEN}✓ Link stack created${NC}"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Creating databases...${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Source root .env for DB credentials
source .env

# Check if data stack is running
if ! docker ps | grep -q "data_postgres"; then
    echo -e "${RED}Warning: PostgreSQL container not running!${NC}"
    echo -e "${YELLOW}Please start the data stack first: cd data && docker compose up -d${NC}"
    echo -e "${YELLOW}Then run: docker exec data_postgres createdb -U $DB_USER n8n${NC}"
    echo -e "${YELLOW}          docker exec data_postgres createdb -U $DB_USER gitea${NC}"
    echo -e "${YELLOW}          docker exec data_postgres createdb -U $DB_USER linkwarden${NC}"
else
    # Create databases
    echo -e "${YELLOW}Creating n8n database...${NC}"
    if docker exec data_postgres psql -U "$DB_USER" -lqt | cut -d \| -f 1 | grep -qw "n8n"; then
        echo -e "${YELLOW}Database n8n already exists${NC}"
    else
        docker exec data_postgres createdb -U "$DB_USER" n8n
        echo -e "${GREEN}✓ Created database: n8n${NC}"
    fi

    echo -e "${YELLOW}Creating gitea database...${NC}"
    if docker exec data_postgres psql -U "$DB_USER" -lqt | cut -d \| -f 1 | grep -qw "gitea"; then
        echo -e "${YELLOW}Database gitea already exists${NC}"
    else
        docker exec data_postgres createdb -U "$DB_USER" gitea
        echo -e "${GREEN}✓ Created database: gitea${NC}"
    fi

    echo -e "${YELLOW}Creating linkwarden database...${NC}"
    if docker exec data_postgres psql -U "$DB_USER" -lqt | cut -d \| -f 1 | grep -qw "linkwarden"; then
        echo -e "${YELLOW}Database linkwarden already exists${NC}"
    else
        docker exec data_postgres createdb -U "$DB_USER" linkwarden
        echo -e "${GREEN}✓ Created database: linkwarden${NC}"
    fi
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Generated Secrets:${NC}"
echo -e "${YELLOW}N8N_ENCRYPTION_KEY:${NC} $N8N_KEY"
echo -e "${YELLOW}NEXTAUTH_SECRET:${NC} $NEXTAUTH_SECRET"
echo ""
echo -e "${BLUE}These secrets have been saved to the .env files!${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Review the .env files in each directory"
echo "2. Update TRAEFIK_HOST if needed (currently set to *.localhost)"
echo "3. Start the stacks:"
echo ""
echo "   cd home && docker compose up -d"
echo "   cd ../chain && docker compose up -d"
echo "   cd ../git && docker compose up -d"
echo "   cd ../link && docker compose up -d"
echo ""
echo -e "${BLUE}Access URLs:${NC}"
echo "  Home Assistant: https://home.localhost"
echo "  n8n:           https://chain.localhost"
echo "  Gitea:         https://git.localhost"
echo "  Linkwarden:    https://link.localhost"
echo ""
echo -e "${GREEN}Happy hacking! 🚀${NC}"
