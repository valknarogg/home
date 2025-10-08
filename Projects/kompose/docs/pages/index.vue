<template>
  <div class="relative overflow-hidden">
    <!-- Hero section -->
    <section class="relative py-20 lg:py-32">
      <!-- Background decorations -->
      <div class="absolute top-0 left-1/4 hero-blob bg-primary-500/20 animate-float" style="animation-delay: 0s"></div>
      <div class="absolute bottom-0 right-1/4 hero-blob bg-accent-500/20 animate-float" style="animation-delay: 2s"></div>
      
      <div class="container mx-auto px-4 relative z-10">
        <div class="max-w-4xl mx-auto text-center">
          <!-- Main heading with gradient -->
          <h1 class="text-6xl md:text-8xl font-black mb-6 gradient-text-hero">
            KOMPOSE
          </h1>
          
          <p class="text-2xl md:text-3xl text-gray-300 mb-8 font-light">
            Your Docker Compose Symphony Conductor
          </p>
          
          <p class="text-lg text-gray-400 mb-12 max-w-2xl mx-auto">
            Manage multiple Docker Compose stacks with style and grace. 
            One command to rule them all, with beautiful output and powerful features.
          </p>

          <!-- CTA Buttons -->
          <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <NuxtLink to="/docs" class="btn-primary text-lg px-8 py-4">
              <span class="flex items-center gap-2">
                <Icon name="lucide:book-open" class="w-5 h-5" />
                Get Started
              </span>
            </NuxtLink>
            
            <NuxtLink to="/docs/quick-start" class="btn-ghost text-lg px-8 py-4">
              <span class="flex items-center gap-2">
                <Icon name="lucide:zap" class="w-5 h-5" />
                Quick Start
              </span>
            </NuxtLink>
          </div>

          <!-- Installation command -->
          <div class="mt-12 glass-dark rounded-xl p-6 inline-block">
            <div class="flex items-center justify-between gap-4">
              <code class="text-primary-400 text-sm font-mono">
                git clone https://github.com/yourusername/kompose.git
              </code>
              <button @click="copyCommand" class="text-gray-400 hover:text-white transition-colors">
                <Icon :name="copied ? 'lucide:check' : 'lucide:copy'" class="w-5 h-5" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features section -->
    <section class="py-20 relative">
      <div class="container mx-auto px-4">
        <div class="text-center mb-16">
          <h2 class="text-4xl md:text-5xl font-bold mb-4 gradient-text">
            Powerful Features
          </h2>
          <p class="text-xl text-gray-400">
            Everything you need to manage your Docker infrastructure
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div v-for="feature in features" :key="feature.title" 
               class="card-glow group hover:-translate-y-2">
            <div class="mb-4">
              <div class="w-12 h-12 rounded-lg bg-gradient-primary flex items-center justify-center">
                <Icon :name="feature.icon" class="w-6 h-6 text-white" />
              </div>
            </div>
            <h3 class="text-xl font-semibold text-white mb-3">
              {{ feature.title }}
            </h3>
            <p class="text-gray-400">
              {{ feature.description }}
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Code example section -->
    <section class="py-20 bg-dark-900/50">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
          <div class="text-center mb-12">
            <h2 class="text-4xl md:text-5xl font-bold mb-4 gradient-text">
              Simple Yet Powerful
            </h2>
            <p class="text-xl text-gray-400">
              Manage all your stacks with intuitive commands
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div v-for="example in examples" :key="example.title" class="card-glass">
              <h3 class="text-lg font-semibold text-white mb-4 flex items-center gap-2">
                <Icon name="lucide:terminal" class="w-5 h-5 text-primary-400" />
                {{ example.title }}
              </h3>
              <pre class="bg-dark-950 p-4 rounded-lg overflow-x-auto">
<code class="text-sm text-gray-300">{{ example.code }}</code></pre>
            </div>
          </div>

          <div class="text-center mt-12">
            <NuxtLink to="/docs" class="btn-accent px-8 py-4">
              <span class="flex items-center gap-2">
                Explore Full Documentation
                <Icon name="lucide:arrow-right" class="w-5 h-5" />
              </span>
            </NuxtLink>
          </div>
        </div>
      </div>
    </section>

    <!-- Stats section -->
    <section class="py-20">
      <div class="container mx-auto px-4">
        <div class="max-w-5xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-8">
          <div v-for="stat in stats" :key="stat.label" 
               class="text-center card-glass">
            <div class="text-5xl font-bold gradient-text mb-2">
              {{ stat.value }}
            </div>
            <div class="text-gray-400">
              {{ stat.label }}
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA section -->
    <section class="py-20 relative">
      <div class="absolute inset-0 bg-gradient-hero opacity-10"></div>
      <div class="container mx-auto px-4 relative z-10">
        <div class="max-w-3xl mx-auto text-center">
          <h2 class="text-4xl md:text-5xl font-bold mb-6 text-white">
            Ready to Conduct Your Docker Symphony?
          </h2>
          <p class="text-xl text-gray-300 mb-8">
            Get started with Kompose today and simplify your Docker workflow
          </p>
          <NuxtLink to="/docs/installation" class="btn-primary text-lg px-8 py-4">
            <span class="flex items-center gap-2">
              <Icon name="lucide:download" class="w-5 h-5" />
              Install Now
            </span>
          </NuxtLink>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const copied = ref(false)

const features = [
  {
    title: 'Stack Management',
    icon: 'lucide:layers',
    description: 'Manage multiple Docker Compose stacks with pattern-based selection and bulk operations.'
  },
  {
    title: 'Database Operations',
    icon: 'lucide:database',
    description: 'Automated backups, smart imports, and database cleanup with PostgreSQL support.'
  },
  {
    title: 'Hooks System',
    icon: 'lucide:git-branch',
    description: 'Extend functionality with custom pre/post operation hooks for each stack.'
  },
  {
    title: 'Network Maestro',
    icon: 'lucide:network',
    description: 'Smart network management with CLI overrides and seamless Traefik integration.'
  },
  {
    title: 'Environment Control',
    icon: 'lucide:settings',
    description: 'Override environment variables on-the-fly without editing configuration files.'
  },
  {
    title: 'Beautiful Output',
    icon: 'lucide:sparkles',
    description: 'Color-coded logs, status indicators, and intuitive command-line interface.'
  }
]

const examples = [
  {
    title: 'Start Everything',
    code: './kompose.sh "*" up -d'
  },
  {
    title: 'Export Databases',
    code: './kompose.sh "*" db:export'
  },
  {
    title: 'View Logs',
    code: './kompose.sh "blog,news" logs -f'
  },
  {
    title: 'Override Network',
    code: './kompose.sh --network staging "*" up'
  }
]

const stats = [
  { value: '10+', label: 'Production Stacks' },
  { value: '100%', label: 'Bash Powered' },
  { value: '1', label: 'Command to Rule Them All' }
]

const copyCommand = () => {
  navigator.clipboard.writeText('git clone https://github.com/yourusername/kompose.git')
  copied.value = true
  setTimeout(() => {
    copied.value = false
  }, 2000)
}
</script>
