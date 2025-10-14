# Stack Templates Directory

This directory contains templates for generating complete, production-ready stacks using `kompose-generate.sh`.

## What are Templates?

Templates are complete stack definitions that include:
- Docker Compose configuration
- Environment variable definitions
- Secret specifications
- Documentation
- Setup instructions
- Dependencies

## Structure

Each template directory contains:

```
_templates/
├── auth/                    # Example: Auth stack template
│   ├── kompose.yml          # ★ Main configuration (env vars + secrets)
│   ├── compose.yaml         # Docker Compose file
│   ├── .env.example         # Example environment (optional)
│   ├── README.md            # Complete documentation
│   └── ...other files       # Any additional files needed
└── ...other templates
```

## The kompose.yml File

This is the heart of each template. It defines:

### 1. Metadata
```yaml
name: auth
description: Authentication and SSO stack with Keycloak
version: 1.0.0
```

### 2. Environment Variables
```yaml
environment:
  - name: AUTH_COMPOSE_PROJECT_NAME
    default: auth
    description: Auth stack project name
    required: yes
  
  - name: AUTH_DOCKER_IMAGE
    default: quay.io/keycloak/keycloak:latest
    description: Keycloak Docker image
    required: no
```

### 3. Secrets
```yaml
secrets:
  - name: AUTH_KEYCLOAK_ADMIN_PASSWORD
    description: Keycloak admin password for web UI access
    required: yes
    type: password
    length: 24
    stacks:
      - auth
    command: openssl rand -base64 32
```

### 4. Dependencies
```yaml
dependencies:
  required:
    - core
    - proxy
  optional:
    - watch
```

### 5. Additional Metadata
- Port mappings
- Volume definitions
- Health checks
- Setup notes

## Creating a New Template

### 1. Create Directory Structure

```bash
mkdir -p _templates/mystack
cd _templates/mystack
```

### 2. Create kompose.yml

```yaml
name: mystack
description: My custom stack
version: 1.0.0

environment:
  - name: MYSTACK_COMPOSE_PROJECT_NAME
    default: mystack
    description: Stack project name
    required: yes

secrets:
  - name: MYSTACK_API_KEY
    description: API key for service
    required: yes
    type: password
    length: 32

dependencies:
  required: []
  optional: []
```

### 3. Create compose.yaml

Create your Docker Compose configuration using environment variables defined in kompose.yml.

### 4. Create README.md

Document:
- What the stack does
- How to configure it
- How to deploy it
- Troubleshooting tips
- Integration examples

### 5. Test Generation

```bash
./kompose.sh generate mystack
```

## Using Templates

### Generate Stack from Template

```bash
# Generate auth stack
./kompose.sh generate auth

# View what will be generated
./kompose.sh generate show auth

# List all templates
./kompose.sh generate templates
```

### What Happens During Generation

1. **Reads kompose.yml** - Parses configuration
2. **Creates +stacks/stackname/** - Output directory
3. **Copies all template files** - Including compose.yaml
4. **Generates .env** - From environment section
5. **Lists required secrets** - Shows what needs to be added to secrets.env
6. **Ready to deploy** - Stack is configured and ready

## Template Best Practices

### 1. Complete Configuration

Define ALL environment variables in kompose.yml:
```yaml
environment:
  - name: EVERY_VARIABLE_USED
    default: sensible_default
    description: Clear description
    required: yes/no
```

### 2. Secret Management

Clearly document secrets:
```yaml
secrets:
  - name: SECRET_NAME
    description: What it's for
    required: yes
    type: password|base64|hex|uuid
    length: 32
    command: openssl rand -base64 32  # Generation command
```

### 3. Dependencies

List what must be running:
```yaml
dependencies:
  required:
    - core    # PostgreSQL, Redis
    - proxy   # Traefik
  optional:
    - watch   # Monitoring (nice to have)
```

### 4. Documentation

Include comprehensive README.md:
- Overview and features
- Configuration steps
- Deployment instructions
- Integration examples
- Troubleshooting guide
- Security considerations

### 5. Sensible Defaults

Provide working defaults for everything possible:
```yaml
- name: APP_PORT
  default: 8080              # ✓ Good
  description: App port
  required: no

- name: TRAEFIK_HOST        # ✗ Bad (no default)
  default: ""                # User must provide
  description: Hostname
  required: yes
```

### 6. Variable Naming Convention

Follow consistent naming:
```yaml
STACKNAME_COMPOSE_PROJECT_NAME  # Stack identifier
STACKNAME_DOCKER_IMAGE          # Image reference
STACKNAME_DB_NAME               # Database name
STACKNAME_SECRET_KEY            # Stack-specific secret
```

### 7. Compatibility

Ensure compose.yaml uses only defined variables:
```yaml
services:
  app:
    image: ${STACKNAME_DOCKER_IMAGE}  # ✓ Defined in kompose.yml
    environment:
      API_KEY: ${STACKNAME_API_KEY}   # ✓ Defined in kompose.yml
```

## Template Workflow

```
Developer creates template:
  _templates/mystack/
  ├── kompose.yml      (defines everything)
  ├── compose.yaml     (uses variables from kompose.yml)
  └── README.md        (documents everything)

↓ Commit to git

User generates stack:
  ./kompose.sh generate mystack

↓ Creates

  +stacks/mystack/
  ├── kompose.yml      (reference, copied from template)
  ├── compose.yaml     (copied from template)
  ├── .env             (generated from kompose.yml)
  └── README.md        (copied from template)

↓ User configures

  Edits .env
  Adds secrets to secrets.env
  Configures domain.env

↓ Deploy

  ./kompose.sh up mystack
```

## Benefits of Templates

1. **Consistency** - All stacks follow same structure
2. **Documentation** - Everything is documented in one place
3. **Reproducibility** - Anyone can generate identical stacks
4. **Version Control** - Templates are tracked, generated stacks are not
5. **Environment Independence** - Same template works in dev, staging, prod
6. **Easy Updates** - Update template, regenerate stack
7. **Self-Documenting** - kompose.yml describes entire stack

## Examples

### Simple Template (Single Service)

```yaml
name: simple
description: Simple web application
version: 1.0.0

environment:
  - name: SIMPLE_COMPOSE_PROJECT_NAME
    default: simple
    description: Stack name
    required: yes
  
  - name: SIMPLE_DOCKER_IMAGE
    default: nginx:alpine
    description: Container image
    required: yes

secrets: []

dependencies:
  required:
    - proxy
```

### Complex Template (Multiple Services)

```yaml
name: complex
description: Multi-service application with database
version: 1.0.0

environment:
  - name: COMPLEX_COMPOSE_PROJECT_NAME
    default: complex
    description: Stack name
    required: yes
  
  - name: COMPLEX_APP_IMAGE
    default: myapp:latest
    description: Application image
    required: yes
  
  - name: COMPLEX_DB_NAME
    default: complex_db
    description: Database name
    required: yes

secrets:
  - name: COMPLEX_APP_SECRET
    description: Application secret key
    required: yes
    type: password
    length: 32
  
  - name: DB_PASSWORD
    description: Database password (shared)
    required: yes
    type: password
    length: 32

dependencies:
  required:
    - core
    - proxy
  optional:
    - watch
```

## Troubleshooting

### Template not found
```bash
./kompose.sh generate templates  # List available
ls -la _templates/                # Check directory
```

### Generation fails
```bash
./kompose.sh generate show mystack  # Check template details
cat _templates/mystack/kompose.yml  # Validate YAML syntax
```

### Variables not substituted
- Ensure all variables are defined in kompose.yml
- Check spelling and case (variables are case-sensitive)
- Verify compose.yaml references match kompose.yml definitions

## See Also

- [Generated Stacks](../+stacks/README.md)
- [Custom Stacks](../+custom/README.md)
- [Stack Generation Guide](../_docs/content/guide/stack-generation.md)
- [kompose.yml Specification](../_docs/content/reference/kompose-yml.md)
