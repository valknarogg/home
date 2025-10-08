---
title: Stack Management
description: Learn how to manage multiple Docker Compose stacks
---

# Stack Management

```bash
# Start stacks
./kompose.sh <pattern> up -d

# Stop stacks
./kompose.sh <pattern> down

# View logs
./kompose.sh <pattern> logs -f

# Restart stacks
./kompose.sh <pattern> restart

# Check status
./kompose.sh <pattern> ps

# Pull latest images
./kompose.sh <pattern> pull
```
