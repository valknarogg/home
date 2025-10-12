---
title: Building a Dashboard
description: Guide to creating a web dashboard for Kompose using the REST API
---

This guide walks you through building a modern web dashboard for Kompose that consumes the REST API.

## Prerequisites

Before you start, ensure:
- Kompose API server is running (see [API Server Guide](/guide/api-server))
- Node.js 18+ installed
- Basic knowledge of Vue/React/Svelte
- Understanding of REST APIs

## Quick Start

### 1. Start the API Server

```bash
# Install Python 3 for best performance
sudo apt-get install python3

# Start the API server
./kompose.sh api start

# Verify it's working
curl http://localhost:8080/api/health | jq .
```

### 2. Choose Your Frontend Stack

We recommend these modern stacks:

#### Option A: Vue 3 + Nuxt + Tailwind (Recommended)
```bash
npx nuxi@latest init kompose-dashboard
cd kompose-dashboard
npm install
npm install @nuxtjs/tailwindcss
npm install lucide-vue-next
```

#### Option B: React + Vite + shadcn/ui
```bash
npm create vite@latest kompose-dashboard -- --template react-ts
cd kompose-dashboard
npm install
npx shadcn-ui@latest init
```

#### Option C: Svelte + SvelteKit + Tailwind
```bash
npm create svelte@latest kompose-dashboard
cd kompose-dashboard
npm install
npx svelte-add@latest tailwindcss
```

### 3. Create API Client

Create a reusable API client to interact with Kompose:

::code-group

```typescript [api/kompose.ts]
// API client for Kompose REST API
export interface Stack {
  name: string;
  description: string;
  url: string;
}

export interface StackStatus {
  stack: string;
  output: string;
  timestamp: string;
}

export interface ApiResponse<T> {
  status: 'success' | 'error';
  message: string;
  data: T;
  timestamp: string;
}

export class KomposeAPI {
  private baseURL: string;

  constructor(baseURL = 'http://localhost:8080/api') {
    this.baseURL = baseURL;
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<ApiResponse<T>> {
    const response = await fetch(`${this.baseURL}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'API request failed');
    }

    return response.json();
  }

  // Health
  async health() {
    return this.request<{
      version: string;
      server: string;
      uptime_seconds: number;
    }>('/health');
  }

  // Stack Management
  async listStacks() {
    return this.request<Stack[]>('/stacks');
  }

  async getStackStatus(name: string) {
    return this.request<StackStatus>(`/stacks/${name}`);
  }

  async startStack(name: string) {
    return this.request<StackStatus>(`/stacks/${name}/start`, {
      method: 'POST',
    });
  }

  async stopStack(name: string) {
    return this.request<StackStatus>(`/stacks/${name}/stop`, {
      method: 'POST',
    });
  }

  async restartStack(name: string) {
    return this.request<StackStatus>(`/stacks/${name}/restart`, {
      method: 'POST',
    });
  }

  async getStackLogs(name: string) {
    return this.request<{ stack: string; logs: string }>(`/stacks/${name}/logs`);
  }

  // Database
  async getDatabaseStatus() {
    return this.request<{ output: string }>('/db/status');
  }

  async listBackups() {
    return this.request<{ backups: string }>('/db/list');
  }

  // Tags
  async listTags() {
    return this.request<{ tags: string }>('/tag/list');
  }
}

// Create singleton instance
export const api = new KomposeAPI();
```

```python [api/kompose.py]
# Python API client for Kompose
import requests
from typing import Dict, List, Optional
from dataclasses import dataclass

@dataclass
class Stack:
    name: str
    description: str
    url: str

class KomposeAPI:
    def __init__(self, base_url: str = "http://localhost:8080/api"):
        self.base_url = base_url
        self.session = requests.Session()
    
    def _request(self, method: str, endpoint: str, **kwargs) -> Dict:
        url = f"{self.base_url}{endpoint}"
        response = self.session.request(method, url, **kwargs)
        response.raise_for_status()
        data = response.json()
        
        if data['status'] == 'error':
            raise Exception(data['message'])
        
        return data
    
    def health(self) -> Dict:
        return self._request("GET", "/health")
    
    def list_stacks(self) -> List[Stack]:
        result = self._request("GET", "/stacks")
        return [Stack(**s) for s in result['data']]
    
    def get_stack_status(self, name: str) -> Dict:
        return self._request("GET", f"/stacks/{name}")
    
    def start_stack(self, name: str) -> Dict:
        return self._request("POST", f"/stacks/{name}/start")
    
    def stop_stack(self, name: str) -> Dict:
        return self._request("POST", f"/stacks/{name}/stop")
    
    def restart_stack(self, name: str) -> Dict:
        return self._request("POST", f"/stacks/{name}/restart")
    
    def get_stack_logs(self, name: str) -> str:
        result = self._request("GET", f"/stacks/{name}/logs")
        return result['data']['logs']

# Usage
api = KomposeAPI()
```

::

### 4. Create Component Examples

Here are example components for common dashboard features:

::code-group

```vue [StackCard.vue]
<script setup lang="ts">
import { ref } from 'vue';
import { api } from '~/api/kompose';
import type { Stack } from '~/api/kompose';

const props = defineProps<{
  stack: Stack;
}>();

const loading = ref(false);
const status = ref<'running' | 'stopped' | 'unknown'>('unknown');

const startStack = async () => {
  loading.value = true;
  try {
    await api.startStack(props.stack.name);
    status.value = 'running';
  } catch (error) {
    console.error('Failed to start stack:', error);
  } finally {
    loading.value = false;
  }
};

const stopStack = async () => {
  loading.value = true;
  try {
    await api.stopStack(props.stack.name);
    status.value = 'stopped';
  } catch (error) {
    console.error('Failed to stop stack:', error);
  } finally {
    loading.value = false;
  }
};
</script>

<template>
  <div class="bg-white dark:bg-slate-800 rounded-lg shadow-lg p-6 border border-slate-200 dark:border-slate-700">
    <div class="flex items-start justify-between mb-4">
      <div>
        <h3 class="text-xl font-bold text-slate-900 dark:text-white">
          {{ stack.name }}
        </h3>
        <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
          {{ stack.description }}
        </p>
      </div>
      <span
        :class="{
          'bg-green-100 text-green-800': status === 'running',
          'bg-red-100 text-red-800': status === 'stopped',
          'bg-gray-100 text-gray-800': status === 'unknown',
        }"
        class="px-3 py-1 rounded-full text-xs font-medium"
      >
        {{ status }}
      </span>
    </div>

    <div class="flex gap-2">
      <button
        @click="startStack"
        :disabled="loading || status === 'running'"
        class="flex-1 bg-green-500 hover:bg-green-600 disabled:bg-gray-300 text-white px-4 py-2 rounded-lg font-medium transition-colors"
      >
        <span v-if="loading">Starting...</span>
        <span v-else>Start</span>
      </button>
      
      <button
        @click="stopStack"
        :disabled="loading || status === 'stopped'"
        class="flex-1 bg-red-500 hover:bg-red-600 disabled:bg-gray-300 text-white px-4 py-2 rounded-lg font-medium transition-colors"
      >
        <span v-if="loading">Stopping...</span>
        <span v-else>Stop</span>
      </button>
    </div>
  </div>
</template>
```

```typescript [useStacks.ts]
// Composable for stack management
import { ref, onMounted } from 'vue';
import { api } from '~/api/kompose';
import type { Stack } from '~/api/kompose';

export function useStacks() {
  const stacks = ref<Stack[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);

  const loadStacks = async () => {
    loading.value = true;
    error.value = null;
    
    try {
      const response = await api.listStacks();
      stacks.value = response.data;
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Failed to load stacks';
      console.error('Error loading stacks:', err);
    } finally {
      loading.value = false;
    }
  };

  const startStack = async (name: string) => {
    try {
      await api.startStack(name);
      await loadStacks(); // Refresh list
    } catch (err) {
      console.error(`Error starting stack ${name}:`, err);
      throw err;
    }
  };

  const stopStack = async (name: string) => {
    try {
      await api.stopStack(name);
      await loadStacks(); // Refresh list
    } catch (err) {
      console.error(`Error stopping stack ${name}:`, err);
      throw err;
    }
  };

  const restartStack = async (name: string) => {
    try {
      await api.restartStack(name);
      await loadStacks(); // Refresh list
    } catch (err) {
      console.error(`Error restarting stack ${name}:`, err);
      throw err;
    }
  };

  onMounted(() => {
    loadStacks();
  });

  return {
    stacks,
    loading,
    error,
    loadStacks,
    startStack,
    stopStack,
    restartStack,
  };
}
```

```vue [Dashboard.vue]
<script setup lang="ts">
import { useStacks } from '~/composables/useStacks';
import StackCard from '~/components/StackCard.vue';

const { stacks, loading, error, loadStacks } = useStacks();
</script>

<template>
  <div class="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 dark:from-slate-900 dark:to-slate-800">
    <div class="container mx-auto px-4 py-8">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-4xl font-bold text-slate-900 dark:text-white mb-2">
          Kompose Dashboard
        </h1>
        <p class="text-slate-600 dark:text-slate-400">
          Manage your Docker Compose stacks
        </p>
      </div>

      <!-- Error State -->
      <div
        v-if="error"
        class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4 mb-6"
      >
        <p class="text-red-800 dark:text-red-200">{{ error }}</p>
        <button
          @click="loadStacks"
          class="mt-2 text-red-600 dark:text-red-400 hover:underline"
        >
          Retry
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
        <p class="mt-4 text-slate-600 dark:text-slate-400">Loading stacks...</p>
      </div>

      <!-- Stacks Grid -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <StackCard
          v-for="stack in stacks"
          :key="stack.name"
          :stack="stack"
        />
      </div>

      <!-- Empty State -->
      <div
        v-if="!loading && stacks.length === 0"
        class="text-center py-12"
      >
        <p class="text-slate-600 dark:text-slate-400 text-lg">
          No stacks found
        </p>
      </div>
    </div>
  </div>
</template>
```

::

## Advanced Features

### Real-time Log Viewer

```vue
<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { api } from '~/api/kompose';

const props = defineProps<{
  stackName: string;
}>();

const logs = ref('');
const autoScroll = ref(true);
let intervalId: number;

const fetchLogs = async () => {
  try {
    const response = await api.getStackLogs(props.stackName);
    logs.value = response.data.logs;
    
    if (autoScroll.value) {
      scrollToBottom();
    }
  } catch (error) {
    console.error('Failed to fetch logs:', error);
  }
};

const scrollToBottom = () => {
  const logContainer = document.getElementById('log-container');
  if (logContainer) {
    logContainer.scrollTop = logContainer.scrollHeight;
  }
};

onMounted(() => {
  fetchLogs();
  // Refresh logs every 5 seconds
  intervalId = setInterval(fetchLogs, 5000);
});

onUnmounted(() => {
  if (intervalId) {
    clearInterval(intervalId);
  }
});
</script>

<template>
  <div class="bg-slate-900 rounded-lg overflow-hidden">
    <div class="bg-slate-800 px-4 py-2 flex items-center justify-between">
      <h3 class="text-white font-medium">Logs: {{ stackName }}</h3>
      <label class="flex items-center gap-2 text-sm text-slate-300">
        <input v-model="autoScroll" type="checkbox" class="rounded" />
        Auto-scroll
      </label>
    </div>
    
    <pre
      id="log-container"
      class="p-4 h-96 overflow-auto text-xs text-green-400 font-mono"
    >{{ logs }}</pre>
  </div>
</template>
```

### Status Polling

```typescript
// composables/useStackStatus.ts
import { ref, onMounted, onUnmounted } from 'vue';
import { api } from '~/api/kompose';

export function useStackStatus(stackName: string, pollInterval = 5000) {
  const status = ref<any>(null);
  const loading = ref(true);
  const error = ref<string | null>(null);
  let intervalId: number;

  const fetchStatus = async () => {
    try {
      const response = await api.getStackStatus(stackName);
      status.value = response.data;
      error.value = null;
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Failed to fetch status';
    } finally {
      loading.value = false;
    }
  };

  onMounted(() => {
    fetchStatus();
    intervalId = setInterval(fetchStatus, pollInterval);
  });

  onUnmounted(() => {
    if (intervalId) {
      clearInterval(intervalId);
    }
  });

  return { status, loading, error, refresh: fetchStatus };
}
```

## Security Setup

### 1. Environment Variables

Create a `.env` file:

```bash
# .env
VITE_API_URL=http://localhost:8080/api
VITE_API_KEY=your-api-key-here  # If you add auth later
```

Use in your code:

```typescript
const apiURL = import.meta.env.VITE_API_URL || 'http://localhost:8080/api';
export const api = new KomposeAPI(apiURL);
```

### 2. Add Authentication (Future)

When you add authentication to the API:

```typescript
export class KomposeAPI {
  private apiKey: string | null;

  constructor(baseURL: string, apiKey?: string) {
    this.baseURL = baseURL;
    this.apiKey = apiKey || null;
  }

  private async request<T>(endpoint: string, options: RequestInit = {}) {
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
      ...options.headers,
    };

    if (this.apiKey) {
      headers['Authorization'] = `Bearer ${this.apiKey}`;
    }

    const response = await fetch(`${this.baseURL}${endpoint}`, {
      ...options,
      headers,
    });

    // ... rest of implementation
  }
}
```

## Deployment

### Build for Production

```bash
# Build the dashboard
npm run build

# Preview production build
npm run preview
```

### Deploy with Docker

Create a `Dockerfile`:

```dockerfile
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Add to docker-compose:

```yaml
services:
  dashboard:
    build: ./kompose-dashboard
    ports:
      - "3000:80"
    environment:
      - VITE_API_URL=http://localhost:8080/api
    depends_on:
      - kompose-api
```

## Best Practices

### 1. Error Handling

Always handle API errors gracefully:

```typescript
try {
  await api.startStack(name);
} catch (error) {
  // Show user-friendly error message
  toast.error('Failed to start stack');
  console.error(error);
}
```

### 2. Loading States

Show loading indicators for all API calls:

```vue
<button :disabled="loading">
  <Spinner v-if="loading" />
  <span v-else>Start Stack</span>
</button>
```

### 3. Caching

Implement caching to reduce API calls:

```typescript
const cache = new Map();

async function getStackStatus(name: string) {
  const cacheKey = `stack-${name}`;
  const cached = cache.get(cacheKey);
  
  if (cached && Date.now() - cached.timestamp < 5000) {
    return cached.data;
  }
  
  const data = await api.getStackStatus(name);
  cache.set(cacheKey, { data, timestamp: Date.now() });
  
  return data;
}
```

### 4. Optimistic Updates

Update UI immediately, then sync with server:

```typescript
async function startStack(name: string) {
  // Update UI immediately
  updateStackStatus(name, 'starting');
  
  try {
    // Call API
    await api.startStack(name);
    // Update with real status
    await refreshStackStatus(name);
  } catch (error) {
    // Revert on error
    updateStackStatus(name, 'stopped');
    throw error;
  }
}
```

## Testing

### Unit Tests

```typescript
// api.test.ts
import { describe, it, expect, vi } from 'vitest';
import { KomposeAPI } from './kompose';

describe('KomposeAPI', () => {
  it('should fetch stacks', async () => {
    global.fetch = vi.fn(() =>
      Promise.resolve({
        ok: true,
        json: () => Promise.resolve({
          status: 'success',
          data: [{ name: 'core', description: 'Core services' }]
        }),
      })
    );

    const api = new KomposeAPI();
    const result = await api.listStacks();
    
    expect(result.data).toHaveLength(1);
    expect(result.data[0].name).toBe('core');
  });
});
```

## Next Steps

1. **Add Real-time Updates**: Use WebSockets or Server-Sent Events
2. **Implement Authentication**: Add login/logout functionality
3. **Add Monitoring**: Integrate metrics and alerts
4. **Mobile App**: Build React Native or Flutter app
5. **Advanced Features**: Add stack creation, editing, etc.

## See Also

- [API Server Guide](/guide/api-server) - API documentation
- [Stack Management](/guide/stack-management) - Managing stacks
- [Security](/guide/security) - Security best practices
- [Traefik](/guide/traefik) - Reverse proxy setup
