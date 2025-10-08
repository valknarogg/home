#!/bin/bash

# Script to add comprehensive READMEs to each new stack directory

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

BASE_DIR="/home/valknar/Projects/kompose"

echo -e "${BLUE}Adding READMEs to new stacks...${NC}"
echo ""

cd "$BASE_DIR"

# Check if stack directories exist
for stack in home chain git link; do
    if [ ! -d "$stack" ]; then
        echo "Error: Directory $stack does not exist!"
        echo "Please run ./setup-new-stacks.sh first"
        exit 1
    fi
done

# Note: The full READMEs are very long (300-400 lines each)
# They are available as artifacts and should be copied manually
# or you can download them from the conversation

echo -e "${GREEN}Creating README placeholders...${NC}"

# Home README placeholder
cat > home/README.md << 'EOF'
# 🏠 Home Stack - Smart Home Automation

Complete documentation for Home Assistant is available in the artifacts.

## Quick Start

```bash
docker compose up -d
```

Access: https://home.localhost

## Key Features
- 2000+ device integrations
- Powerful automations
- Voice control
- Mobile apps

For the complete 300+ line README with full documentation,
please refer to the artifacts from the conversation.

EOF

# Chain README placeholder
cat > chain/README.md << 'EOF'
# ⛓️ Chain Stack - Workflow Automation

Complete documentation for n8n is available in the artifacts.

## Quick Start

```bash
docker compose up -d
```

Access: https://chain.localhost
Default credentials: admin / changeme (change immediately!)

## Key Features
- Visual workflow builder
- 400+ integrations
- Code nodes for custom logic
- Webhook triggers

For the complete 350+ line README with full documentation,
please refer to the artifacts from the conversation.

EOF

# Git README placeholder
cat > git/README.md << 'EOF'
# 🦊 Git Stack - Self-Hosted Git Service

Complete documentation for Gitea is available in the artifacts.

## Quick Start

```bash
docker compose up -d
```

Access: https://git.localhost
SSH: ssh://git@git.localhost:2222

## Key Features
- Unlimited private repos
- Pull requests & code review
- Issue tracking
- Organizations & teams

For the complete 400+ line README with full documentation,
please refer to the artifacts from the conversation.

EOF

# Link README placeholder
cat > link/README.md << 'EOF'
# 🔗 Link Stack - Bookmark Manager

Complete documentation for Linkwarden is available in the artifacts.

## Quick Start

```bash
docker compose up -d
```

Access: https://link.localhost

## Key Features
- Bookmark with screenshots
- Full page archives
- Tags & collections
- Team collaboration

For the complete 350+ line README with full documentation,
please refer to the artifacts from the conversation.

EOF

echo -e "${GREEN}✓ README placeholders created${NC}"
echo ""
echo -e "${BLUE}Note:${NC} The complete, detailed READMEs (300-400 lines each) are available"
echo "as artifacts in the Claude conversation. You can:"
echo "1. Copy them manually from the artifacts"
echo "2. Or use the placeholder READMEs as a starting point"
echo ""
echo -e "${GREEN}Done!${NC}"
