<script setup lang="ts">
import type { ContentNavigationItem } from '@nuxt/content'
import OgImageDocs from '~/components/OgImage/OgImageDocs.vue';

const navigation = inject<Ref<ContentNavigationItem[]>>('navigation')
</script>

<template>
  <UContainer>
    <UPage>
      <template #left>
        <UPageAside>
          <UContentNavigation
            highlight
            :navigation="navigation"
          />
          <OgImageDocs />
        </UPageAside>
      </template>

      <slot />
    </UPage>
  </UContainer>
</template>
