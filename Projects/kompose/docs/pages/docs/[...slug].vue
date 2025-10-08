<template>
  <div class="docs-page">
    <article class="prose prose-lg max-w-none">
      <ContentDoc v-slot="{ doc }">
        <div>
          <!-- Page header -->
          <div class="mb-8 pb-8 border-b border-dark-800">
            <h1 class="text-5xl font-bold gradient-text mb-4">
              {{ doc.title }}
            </h1>
            <p v-if="doc.description" class="text-xl text-gray-400">
              {{ doc.description }}
            </p>
          </div>

          <!-- Content -->
          <ContentRenderer :value="doc" class="markdown-content" />

          <!-- Navigation -->
          <div class="mt-16 pt-8 border-t border-dark-800 flex justify-between items-center">
            <NuxtLink
              v-if="doc.prev"
              :to="doc.prev.path"
              class="flex items-center gap-2 text-primary-400 hover:text-primary-300 transition-colors"
            >
              <Icon name="lucide:arrow-left" class="w-5 h-5" />
              <span>{{ doc.prev.title }}</span>
            </NuxtLink>
            <div v-else></div>

            <NuxtLink
              v-if="doc.next"
              :to="doc.next.path"
              class="flex items-center gap-2 text-primary-400 hover:text-primary-300 transition-colors"
            >
              <span>{{ doc.next.title }}</span>
              <Icon name="lucide:arrow-right" class="w-5 h-5" />
            </NuxtLink>
            <div v-else></div>
          </div>
        </div>
      </ContentDoc>
    </article>
  </div>
</template>

<script setup>
definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.markdown-content :deep(h2) {
  @apply text-3xl font-bold text-white mt-12 mb-6 flex items-center gap-3;
}

.markdown-content :deep(h2::before) {
  content: '';
  @apply w-1 h-8 bg-gradient-primary rounded;
}

.markdown-content :deep(h3) {
  @apply text-2xl font-semibold text-white mt-8 mb-4;
}

.markdown-content :deep(p) {
  @apply text-gray-300 leading-relaxed mb-6;
}

.markdown-content :deep(ul),
.markdown-content :deep(ol) {
  @apply space-y-2 mb-6;
}

.markdown-content :deep(li) {
  @apply text-gray-300;
}

.markdown-content :deep(code) {
  @apply bg-dark-800 text-primary-300 px-2 py-1 rounded text-sm font-mono;
}

.markdown-content :deep(pre) {
  @apply bg-dark-900 border border-dark-700 rounded-lg p-6 overflow-x-auto mb-6 relative group;
}

.markdown-content :deep(pre code) {
  @apply bg-transparent text-gray-300 p-0;
}

.markdown-content :deep(blockquote) {
  @apply border-l-4 border-primary-500 pl-6 py-2 my-6 bg-dark-900/50 rounded-r-lg;
}

.markdown-content :deep(blockquote p) {
  @apply text-gray-400 italic;
}

.markdown-content :deep(a) {
  @apply text-primary-400 hover:text-primary-300 underline decoration-primary-500/30 hover:decoration-primary-400 transition-colors;
}

.markdown-content :deep(table) {
  @apply w-full border-collapse mb-6;
}

.markdown-content :deep(th) {
  @apply bg-dark-800 text-primary-400 font-semibold py-3 px-4 text-left border-b-2 border-primary-500/30;
}

.markdown-content :deep(td) {
  @apply py-3 px-4 border-b border-dark-700;
}

.markdown-content :deep(tr:hover) {
  @apply bg-white/5;
}

.markdown-content :deep(img) {
  @apply rounded-lg shadow-glow-cyber my-6;
}

.markdown-content :deep(.alert) {
  @apply p-4 rounded-lg mb-6 border-l-4;
}

.markdown-content :deep(.alert-info) {
  @apply bg-blue-500/10 border-blue-500;
}

.markdown-content :deep(.alert-warning) {
  @apply bg-yellow-500/10 border-yellow-500;
}

.markdown-content :deep(.alert-danger) {
  @apply bg-red-500/10 border-red-500;
}

.markdown-content :deep(.alert-success) {
  @apply bg-green-500/10 border-green-500;
}
</style>
