<template>
  <div class="relative group">
    <slot />
    <button
      @click="copyCode"
      class="absolute top-2 right-2 p-2 rounded-md bg-dark-800 text-gray-400 hover:text-white hover:bg-dark-700 transition-all opacity-0 group-hover:opacity-100"
      :class="{ '!opacity-100': copied }"
    >
      <Icon v-if="!copied" name="lucide:copy" class="w-4 h-4" />
      <Icon v-else name="lucide:check" class="w-4 h-4 text-green-500" />
    </button>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  code: {
    type: String,
    required: true
  }
})

const copied = ref(false)

const copyCode = async () => {
  try {
    await navigator.clipboard.writeText(props.code)
    copied.value = true
    setTimeout(() => {
      copied.value = false
    }, 2000)
  } catch (err) {
    console.error('Failed to copy code:', err)
  }
}
</script>
