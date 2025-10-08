---
title: Quick Start
description: Get started with Kompose in minutes
---

# Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/kompose.git
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

# That's it! <img src="https://game-icons.net/icons/000000/transparent/1x1/delapouite/firework-rocket.svg" alt="celebration" style="display:inline; width:1.2em; height:1.2em; vertical-align:-0.15em;">
```
