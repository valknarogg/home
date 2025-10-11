---
title: Quick Start
description: Get started with Kompose in minutes
---

```bash
# Clone the repository
git clone https://code.pivoine.art/valknar/kompose.git
cd kompose

# Make kompose executable
chmod +x kompose.sh

# List all stacks
./kompose.sh --list

# Start everything
./kompose.sh "*" up -d

# View logs from specific stacks
./kompose.sh "blog,news" logs -f

# Export all databases
./kompose.sh "*" db:export

# That's it! :icon{name="lucide:party-popper"}
```
