---
title: Configuration
description: Configure Kompose and your stacks
---

# Configuration

### Root Configuration (`.env`)

Global settings shared across all stacks:

```bash
# Network Configuration
NETWORK_NAME=kompose

# Database Connection (default values)
DB_USER=dbuser
DB_PASSWORD=secretpassword
DB_PORT=5432
DB_HOST=postgres

# Admin Settings
ADMIN_EMAIL=admin@example.com

# Email/SMTP Settings
EMAIL_TRANSPORT=smtp
EMAIL_FROM=noreply@example.com
EMAIL_SMTP_HOST=smtp.example.com
EMAIL_SMTP_PORT=465
EMAIL_SMTP_USER=smtp@example.com
EMAIL_SMTP_PASSWORD=smtppassword
```

### Stack Configuration (`<stack>/.env`)

Stack-specific settings:

```bash
# Stack Identification
COMPOSE_PROJECT_NAME=blog

# Docker Image
DOCKER_IMAGE=joseluisq/static-web-server:latest

# Traefik Configuration
TRAEFIK_HOST=example.com

# Application Settings
APP_PORT=80
```

### Configuration Precedence

```
CLI Overrides (-e flag) 
    ↓
Stack .env
    ↓
Root .env
    ↓
Compose defaults
```
