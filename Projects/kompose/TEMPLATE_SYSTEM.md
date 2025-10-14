# Stack Template System - Implementation Summary

## ✅ What Was Implemented

The complete stack template generation system that allows generating stacks from templates in `_templates/` into `+stacks/`.

## 📁 Directory Structure

```
kompose/
├── _templates/              # ★ Stack templates (version controlled)
│   ├── README.md           # Template system documentation
│   └── auth/               # Example: Auth stack template
│       ├── kompose.yml     # ★ Complete configuration (env + secrets)
│       ├── compose.yaml    # Docker Compose file
│       ├── .env.example    # Example environment
│       ├── oauth2-proxy.yaml  # Additional config
│       └── README.md       # Complete stack documentation
│
├── +stacks/                # ★ Generated stacks (NOT version controlled)
│   └── README.md           # Generated stacks documentation
│
├── +custom/                # Custom stacks (user-created from scratch)
│   └── ...
│
└── kompose-generate.sh     # ★ Updated generator script
```

## 🎯 Key Components

### 1. Template Structure (_templates/)

Each template is a complete, self-contained stack recipe:

**kompose.yml** - The blueprint defining:
- Metadata (name, description, version)
- Environment variables with defaults
- Secrets with generation methods
- Dependencies (required/optional stacks)
- Ports, volumes, health checks
- Setup notes and documentation

**compose.yaml** - Docker Compose configuration using variables from kompose.yml

**README.md** - Comprehensive documentation with:
- Overview and features
- Configuration instructions
- Deployment steps
- Troubleshooting guide
- Integration examples

### 2. Generation Script (kompose-generate.sh)

Completely rewritten to support:

#### Template-Based Generation
```bash
./kompose.sh generate auth
```
- Reads _templates/auth/kompose.yml
- Generates +stacks/auth/ directory
- Creates .env from environment variables
- Copies all template files
- Lists required secrets
- Ready to deploy

#### Custom Stack Generation (Original)
```bash
./kompose.sh generate custom myapp
```
- Creates stack from scratch in +custom/
- Generates boilerplate compose.yaml
- Creates basic .env template
- Adds documentation

#### Commands Available
```bash
# Template-based
kompose generate <template-name>  # Generate from template
kompose generate templates        # List available templates
kompose generate show <template>  # Show template details
kompose generate list             # List generated stacks
kompose generate delete <stack>   # Delete generated stack

# Custom stacks
kompose generate custom <name>    # Create custom stack
kompose generate custom list      # List custom stacks
kompose generate custom delete <n> # Delete custom stack
```

### 3. Module Cleanup

**kompose-env.sh** - Removed auth stack variables:
- ✅ Removed ENV_VARS[auth] section
- ✅ Cleaned up 6 environment variable definitions

**secrets.env** - Removed auth stack secrets:
- ✅ Removed AUTH Stack Secrets section (3 secrets)
- ✅ Updated shared secrets comments
- ✅ Updated Stack-to-Secrets Mapping
- ✅ Removed auth references from DB_PASSWORD and REDIS_PASSWORD

**auth/ directory** - Moved to template:
- ✅ Entire auth stack moved to _templates/auth/
- ✅ Original auth/ directory now empty/removed

### 4. Version Control (.gitignore)

Updated to properly handle generated vs template files:

```gitignore
# Generated stacks (from templates) - DO NOT commit
+stacks/

# Custom stacks (user-created) - DO NOT commit
+custom/
_docs/content/5.stacks/+custom/

# Templates - KEEP IN VERSION CONTROL
!_templates/
```

## 🔄 Workflow

### Template Development (Developer)

```
1. Create template in _templates/
   ├── Write kompose.yml (define everything)
   ├── Create compose.yaml (use variables)
   └── Document in README.md

2. Commit to version control
   git add _templates/mystack/
   git commit -m "Add mystack template"

3. Template is now available to all users
```

### Stack Generation (User)

```
1. List available templates
   ./kompose.sh generate templates

2. Show template details
   ./kompose.sh generate show auth

3. Generate stack
   ./kompose.sh generate auth
   
   Creates:
   +stacks/auth/
   ├── kompose.yml    (reference copy)
   ├── compose.yaml   (from template)
   ├── .env           (generated)
   └── README.md      (from template)

4. Configure
   - Edit +stacks/auth/.env
   - Add secrets to secrets.env
   - Configure domain.env

5. Deploy
   ./kompose.sh up auth
```

## 🎨 Example: Auth Stack Template

### kompose.yml Structure

```yaml
name: auth
description: Authentication and SSO stack with Keycloak and OAuth2 Proxy
version: 1.0.0

environment:
  - name: AUTH_COMPOSE_PROJECT_NAME
    default: auth
    description: Auth stack project name
    required: yes
  
  - name: AUTH_DOCKER_IMAGE
    default: quay.io/keycloak/keycloak:latest
    description: Keycloak Docker image
    required: no
  
  # ... 17 total variables

secrets:
  - name: DB_PASSWORD
    description: PostgreSQL password for database connections
    required: yes
    type: password
    length: 32
    stacks: [core, auth, chain, ...]
  
  - name: AUTH_KEYCLOAK_ADMIN_PASSWORD
    description: Keycloak admin password
    required: yes
    type: password
    length: 24
  
  # ... 4 total secrets

dependencies:
  required:
    - core   # PostgreSQL and Redis
    - proxy  # Traefik for routing
  optional: []
```

### Generation Output

```bash
$ ./kompose.sh generate auth

[INFO] Generating stack from template: auth

[INFO] Copying template files...
[INFO] Generating .env file from kompose.yml...
[INFO] Checking required secrets...

Required secrets for auth:

  DB_PASSWORD [REQUIRED]
    PostgreSQL password for database connections
    Generate: openssl rand -base64 48 | tr -d '=+/' | cut -c1-32

  AUTH_KEYCLOAK_ADMIN_PASSWORD [REQUIRED]
    Keycloak admin password for web UI access
    Generate: openssl rand -base64 48 | tr -d '=+/' | cut -c1-32

  AUTH_OAUTH2_CLIENT_SECRET [REQUIRED]
    OAuth2 Proxy client secret (generate in Keycloak UI)
    Generate: openssl rand -base64 48 | tr -d '=+/' | cut -c1-32

  AUTH_OAUTH2_COOKIE_SECRET [REQUIRED]
    OAuth2 Proxy cookie secret (32 bytes base64)
    Generate: openssl rand -base64 32

⚠ Add these secrets to secrets.env before starting the stack

[SUCCESS] Stack 'auth' generated successfully!

[INFO] Generated in: +stacks/auth

[INFO] Next steps:
  1. Review configuration: +stacks/auth/.env
  2. Add required secrets to: secrets.env
  3. Configure domain in: domain.env
  4. Start stack: ./kompose.sh up auth

[INFO] 📖 Documentation: +stacks/auth/README.md
```

## 📝 Benefits

### 1. Separation of Concerns
- **Templates** (_templates/) - Blueprint, version controlled
- **Instances** (+stacks/) - Working copies, environment-specific
- **Module Config** (kompose-env.sh, secrets.env) - Only for non-templated stacks

### 2. Reproducibility
- Same template generates identical stacks
- Works across dev, staging, production
- Easy onboarding for new team members

### 3. Documentation
- Everything documented in kompose.yml
- Self-documenting configuration
- Clear requirements and dependencies

### 4. Maintainability
- Update template once, regenerate everywhere
- Consistent structure across stacks
- Easy to see what changed (git diff templates)

### 5. Flexibility
- Template-based for standard stacks
- Custom generation for one-off needs
- Both approaches coexist peacefully

## 🔧 Technical Details

### kompose.yml Parsing

Simple shell-based parsing (no external dependencies):

```bash
# Extract environment variables
extract_env_vars() {
    awk '
        /^environment:/ { in_env=1; next }
        in_env && /^[a-z]/ { in_env=0 }
        in_env && /^  - name:/ { 
            name=$3
            getline; default=$2
            getline; desc=$2
            getline; req=$2
            printf "%s|%s|%s|%s\n", name, default, desc, req
        }
    ' kompose.yml
}
```

For production use, consider:
- `yq` for robust YAML parsing
- Python with PyYAML
- Validation schemas

### .env Generation

Reads kompose.yml and creates:

```bash
# Generated .env structure
# ============================================================================
# stack Stack Configuration
# ============================================================================
# Generated from template by kompose-generate.sh
# Template version: 1.0.0
# Description text here
# ============================================================================

# Description of variable
# [REQUIRED] or [OPTIONAL]
VARIABLE_NAME=default_value

...
```

### Secret Handling

Lists required secrets with generation commands:

```bash
AUTH_OAUTH2_COOKIE_SECRET [REQUIRED]
  OAuth2 Proxy cookie secret
  Generate: openssl rand -base64 32
```

User adds to `secrets.env`:
```bash
AUTH_OAUTH2_COOKIE_SECRET=$(openssl rand -base64 32)
```

## 🚀 Future Enhancements

1. **Secret Auto-Generation**
   - Option to auto-generate secrets during stack generation
   - Interactive prompt for secret values

2. **Validation**
   - Validate kompose.yml schema
   - Check for required fields
   - Verify variable references in compose.yaml

3. **Updates**
   - Detect when template has updates
   - Smart merge of user changes with template updates
   - Version tracking

4. **Testing**
   - Template validation tests
   - Generation tests
   - Integration tests

5. **Advanced Features**
   - Conditional generation based on environment
   - Stack variants (dev/prod configurations)
   - Template inheritance

## 📚 Documentation Files Created

1. **_templates/README.md** - Complete template system guide
2. **_templates/auth/README.md** - Auth stack documentation
3. **_templates/auth/kompose.yml** - Auth stack configuration
4. **+stacks/README.md** - Generated stacks documentation

## ✨ Usage Examples

### Generate Auth Stack
```bash
# Show what's available
./kompose.sh generate templates

# See details
./kompose.sh generate show auth

# Generate it
./kompose.sh generate auth

# Configure
vim +stacks/auth/.env
vim secrets.env  # Add required secrets

# Deploy
./kompose.sh up auth
```

### Create Custom Stack
```bash
# Generate custom stack from scratch
./kompose.sh generate custom myapp

# Edit configuration
vim +custom/myapp/.env
vim +custom/myapp/compose.yaml

# Deploy
./kompose.sh up myapp
```

### List Everything
```bash
# List templates
./kompose.sh generate templates

# List generated stacks
./kompose.sh generate list

# List custom stacks
./kompose.sh generate custom list
```

## 🎓 Key Concepts

### Template
- Blueprint for a stack
- Lives in `_templates/`
- Version controlled
- Used to generate instances

### Generated Stack
- Instance of a template
- Lives in `+stacks/`
- NOT version controlled
- Environment-specific configuration

### Custom Stack
- Created from scratch
- Lives in `+custom/`
- NOT version controlled
- For unique, one-off stacks

### kompose.yml
- Central configuration file
- Defines everything about a stack
- Environment variables
- Secrets
- Dependencies
- Documentation

## 🎉 Summary

The complete stack template system is now ready! You can:

✅ Create templates in `_templates/` with full configuration  
✅ Generate stacks with `./kompose.sh generate <template-name>`  
✅ Stacks are created in `+stacks/` ready to deploy  
✅ All auth references removed from modules  
✅ Clean separation between templates and instances  
✅ Comprehensive documentation at every level  
✅ Works alongside existing custom stack generation  

The auth stack serves as the reference implementation showing how powerful and complete the template system is!
