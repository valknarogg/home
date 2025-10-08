<template>
  <div class="flex flex-col min-h-screen">
    <!-- Header -->
    <header class="sticky top-0 z-50 w-full border-b border-dark-800 glass-dark">
      <div class="container mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex h-16 items-center justify-between">
          <!-- Logo -->
          <NuxtLink to="/" class="flex items-center space-x-3 group">
            <div class="text-3xl font-bold gradient-text group-hover:scale-110 transition-transform">
              KOMPOSE
            </div>
          </NuxtLink>

          <!-- Navigation -->
          <nav class="hidden md:flex items-center space-x-6">
            <NuxtLink to="/docs" class="link-fancy text-sm font-medium">
              Documentation
            </NuxtLink>
            <NuxtLink to="/api" class="link-fancy text-sm font-medium">
              API Reference
            </NuxtLink>
            <NuxtLink to="/examples" class="link-fancy text-sm font-medium">
              Examples
            </NuxtLink>
            <a href="https://github.com/yourusername/kompose" target="_blank" 
               class="text-gray-400 hover:text-white transition-colors">
              <Icon name="lucide:github" class="w-5 h-5" />
            </a>
          </nav>

          <!-- Mobile menu button -->
          <button @click="mobileMenuOpen = !mobileMenuOpen" class="md:hidden text-gray-400 hover:text-white">
            <Icon :name="mobileMenuOpen ? 'lucide:x' : 'lucide:menu'" class="w-6 h-6" />
          </button>
        </div>
      </div>

      <!-- Mobile menu -->
      <Transition
        enter-active-class="transition duration-200 ease-out"
        enter-from-class="opacity-0 scale-95"
        enter-to-class="opacity-100 scale-100"
        leave-active-class="transition duration-100 ease-in"
        leave-from-class="opacity-100 scale-100"
        leave-to-class="opacity-0 scale-95"
      >
        <div v-show="mobileMenuOpen" class="md:hidden border-t border-dark-800 bg-dark-900 p-4">
          <nav class="flex flex-col space-y-3">
            <NuxtLink @click="mobileMenuOpen = false" to="/docs" class="text-gray-300 hover:text-white">
              Documentation
            </NuxtLink>
            <NuxtLink @click="mobileMenuOpen = false" to="/api" class="text-gray-300 hover:text-white">
              API Reference
            </NuxtLink>
            <NuxtLink @click="mobileMenuOpen = false" to="/examples" class="text-gray-300 hover:text-white">
              Examples
            </NuxtLink>
          </nav>
        </div>
      </Transition>
    </header>

    <div class="flex-1 flex">
      <!-- Sidebar -->
      <aside class="hidden lg:block w-64 border-r border-dark-800 overflow-y-auto sticky top-16 h-[calc(100vh-4rem)]">
        <div class="p-6 space-y-6">
          <!-- Search -->
          <div class="relative">
            <Icon name="lucide:search" class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500" />
            <input
              type="search"
              placeholder="Search docs..."
              class="w-full pl-10 pr-4 py-2 bg-dark-900 border border-dark-700 rounded-lg text-sm focus:outline-none focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
            />
          </div>

          <!-- Navigation sections -->
          <nav class="space-y-6">
            <div v-for="section in navigation" :key="section.title">
              <h3 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">
                {{ section.title }}
              </h3>
              <ul class="space-y-1">
                <li v-for="item in section.items" :key="item.to">
                  <NuxtLink :to="item.to" class="sidebar-link">
                    {{ item.label }}
                  </NuxtLink>
                </li>
              </ul>
            </div>
          </nav>
        </div>
      </aside>

      <!-- Main content -->
      <main class="flex-1 overflow-x-hidden">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 py-8 max-w-5xl">
          <slot />
        </div>
      </main>

      <!-- Table of contents -->
      <aside class="hidden xl:block w-64 border-l border-dark-800 overflow-y-auto sticky top-16 h-[calc(100vh-4rem)]">
        <div class="p-6">
          <h3 class="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-4">
            On This Page
          </h3>
          <nav class="space-y-2">
            <a
              v-for="link in toc"
              :key="link.id"
              :href="`#${link.id}`"
              class="toc-link"
              :class="{ active: activeId === link.id }"
              :style="{ paddingLeft: `${(link.depth - 2) * 12 + 16}px` }"
            >
              {{ link.text }}
            </a>
          </nav>
        </div>
      </aside>
    </div>

    <!-- Footer -->
    <footer class="border-t border-dark-800 bg-dark-950">
      <div class="container mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div class="col-span-1 md:col-span-2">
            <div class="text-2xl font-bold gradient-text mb-4">KOMPOSE</div>
            <p class="text-gray-400 text-sm mb-4">
              Your Docker Compose Symphony Conductor
            </p>
            <div class="flex space-x-4">
              <a href="#" class="text-gray-400 hover:text-primary-400 transition-colors">
                <Icon name="lucide:github" class="w-5 h-5" />
              </a>
              <a href="#" class="text-gray-400 hover:text-primary-400 transition-colors">
                <Icon name="lucide:twitter" class="w-5 h-5" />
              </a>
            </div>
          </div>

          <div>
            <h4 class="text-sm font-semibold text-white mb-4">Documentation</h4>
            <ul class="space-y-2 text-sm">
              <li><NuxtLink to="/docs" class="text-gray-400 hover:text-white">Getting Started</NuxtLink></li>
              <li><NuxtLink to="/docs/guide" class="text-gray-400 hover:text-white">Guide</NuxtLink></li>
              <li><NuxtLink to="/api" class="text-gray-400 hover:text-white">API Reference</NuxtLink></li>
            </ul>
          </div>

          <div>
            <h4 class="text-sm font-semibold text-white mb-4">Community</h4>
            <ul class="space-y-2 text-sm">
              <li><a href="#" class="text-gray-400 hover:text-white">GitHub</a></li>
              <li><a href="#" class="text-gray-400 hover:text-white">Discord</a></li>
              <li><a href="#" class="text-gray-400 hover:text-white">Twitter</a></li>
            </ul>
          </div>
        </div>

        <div class="border-t border-dark-800 mt-8 pt-8 text-center text-sm text-gray-400">
          <p>&copy; 2025 Kompose. Made with ❤️ and ☕</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const mobileMenuOpen = ref(false)
const activeId = ref('')
const toc = ref([])

const navigation = [
  {
    title: 'Getting Started',
    items: [
      { label: 'Introduction', to: '/docs' },
      { label: 'Installation', to: '/docs/installation' },
      { label: 'Quick Start', to: '/docs/quick-start' },
    ]
  },
  {
    title: 'Guide',
    items: [
      { label: 'Stack Management', to: '/docs/guide/stack-management' },
      { label: 'Database Operations', to: '/docs/guide/database' },
      { label: 'Hooks System', to: '/docs/guide/hooks' },
      { label: 'Network Architecture', to: '/docs/guide/network' },
    ]
  },
  {
    title: 'Reference',
    items: [
      { label: 'Configuration', to: '/docs/reference/configuration' },
      { label: 'CLI Commands', to: '/docs/reference/cli' },
      { label: 'Environment Variables', to: '/docs/reference/env' },
    ]
  }
]

// Table of contents intersection observer
onMounted(() => {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          activeId.value = entry.target.id
        }
      })
    },
    { rootMargin: '-80px 0px -80% 0px' }
  )

  document.querySelectorAll('h2, h3').forEach((heading) => {
    observer.observe(heading)
  })
})
</script>
