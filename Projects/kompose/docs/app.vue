<template>
  <div class="min-h-screen bg-dark-950 text-gray-100">
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>

<script setup>
useHead({
  htmlAttrs: {
    class: 'dark'
  }
})
</script>

<style>
@import '@/assets/css/main.css';

/* Custom scrollbar */
::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

::-webkit-scrollbar-track {
  @apply bg-dark-900;
}

::-webkit-scrollbar-thumb {
  @apply bg-gradient-to-b from-primary-500 to-accent-500 rounded-full;
}

::-webkit-scrollbar-thumb:hover {
  @apply from-primary-400 to-accent-400;
}

/* Selection */
::selection {
  @apply bg-primary-500/30 text-white;
}

::-moz-selection {
  @apply bg-primary-500/30 text-white;
}
</style>
