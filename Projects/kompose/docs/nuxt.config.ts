// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-04-03',
  devtools: { enabled: true },

  modules: [
    '@nuxt/content',
    '@nuxtjs/tailwindcss',
    '@nuxtjs/color-mode',
    '@nuxt/icon',
    '@vueuse/nuxt'
  ],

  // Content module configuration
  content: {
    documentDriven: true,
    highlight: {
      theme: {
        default: 'github-dark',
        dark: 'github-dark'
      },
      preload: [
        'bash',
        'shell',
        'yaml',
        'json',
        'markdown',
        'javascript',
        'typescript',
        'vue',
        'docker',
        'sql'
      ]
    },
    markdown: {
      toc: {
        depth: 3,
        searchDepth: 3
      },
      anchorLinks: true
    },
    // Search configuration
    experimental: {
      search: {
        indexed: true
      }
    }
  },

  // Color mode configuration
  colorMode: {
    classSuffix: '',
    preference: 'dark',
    fallback: 'dark'
  },

  // Tailwind configuration
  tailwindcss: {
    exposeConfig: true,
    viewer: true,
    config: {
      darkMode: 'class',
      content: [
        './components/**/*.{js,vue,ts}',
        './layouts/**/*.vue',
        './pages/**/*.vue',
        './plugins/**/*.{js,ts}',
        './app.vue'
      ]
    }
  },

  // App configuration
  app: {
    head: {
      charset: 'utf-8',
      viewport: 'width=device-width, initial-scale=1',
      title: 'Kompose Documentation',
      meta: [
        { name: 'description', content: 'Complete documentation for Kompose - Your Docker Compose Symphony Conductor' },
        { name: 'og:title', content: 'Kompose Documentation' },
        { name: 'og:description', content: 'Complete documentation for Kompose - Your Docker Compose Symphony Conductor' },
        { name: 'og:type', content: 'website' },
        { name: 'twitter:card', content: 'summary_large_image' }
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      ]
    }
  },

  // Nitro configuration for static generation
  nitro: {
    prerender: {
      crawlLinks: true,
      routes: ['/']
    }
  },

  // Build configuration
  build: {
    transpile: []
  },

  // PWA configuration
  pwa: {
    manifest: {
      name: 'Kompose Docs',
      short_name: 'Kompose',
      description: 'Kompose Documentation',
      theme_color: '#f97316',
      background_color: '#0a0a0a'
    }
  }
})
