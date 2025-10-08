<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  size: {
    type: String,
    default: '42px' // Can be: '24px', '32px', '42px', '56px', etc.
  }
})

const isHovered = ref(false)

// Load Google Font
if (typeof document !== 'undefined') {
  const link = document.createElement('link')
  link.href = 'https://fonts.googleapis.com/css2?family=Inter:wght@800;900&display=swap'
  link.rel = 'stylesheet'
  document.head.appendChild(link)
}
</script>

<template>
  <div 
    class="logo-wrapper"
    :style="{ fontSize: size }"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <div class="logo-container">
      <!-- Main brand text -->
      <span class="brand-text">kompose</span>
      
      <!-- Tech domain extension with animated dot -->
      <span class="domain-wrapper">
        <span class="animated-dot-wrapper">
          <span class="animated-dot" :class="{ active: isHovered }"></span>
        </span>
        <span class="domain-text-wrapper">
          <span class="domain-text">sh</span>
          <span class="underline" :class="{ active: isHovered }"></span>
        </span>
      </span>
    </div>
    
    <!-- Floating particles on hover -->
    <transition name="fade">
      <div v-if="isHovered" class="particles">
        <span v-for="i in 3" :key="i" class="particle" :style="{ animationDelay: `${i * 0.15}s` }"></span>
      </div>
    </transition>
  </div>
</template>

<style scoped>
.logo-wrapper {
  position: relative;
  display: inline-block;
  cursor: pointer;
  font-size: 42px; /* Default size, can be overridden */
}

.logo-container {
  position: relative;
  display: inline-flex;
  align-items: center;
  gap: 0;
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  font-weight: 900;
  font-size: 1em; /* Relative to wrapper */
  letter-spacing: -0.05em;
  color: currentColor;
  text-shadow: 0 0.07em 0.19em rgba(0, 0, 0, 0.25);
  line-height: 1;
  user-select: none;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  transition: transform 0.3s ease;
}

.logo-wrapper:hover .logo-container {
  transform: translateY(-0.05em);
}

.brand-text {
  position: relative;
  z-index: 2;
}

.domain-wrapper {
  display: inline-flex;
  align-items: center;
  margin-left: -0.02em;
  gap: 0;
}

/* Animated pulsing dot (replacing the regular dot) */
.animated-dot-wrapper {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 0.3em;
  height: 1em;
  position: relative;
}

.animated-dot {
  width: 0.15em;
  height: 0.15em;
  border-radius: 50%;
  background: var(--ui-primary, #00DC82);
  opacity: 0.7;
  transition: all 0.3s ease;
  animation: pulse 2s ease-in-out infinite;
  position: relative;
  top: 0.15em; /* Align as a period baseline */
}

.animated-dot.active {
  opacity: 1;
  box-shadow: 0 0 0.3em var(--ui-primary, #00DC82);
  animation: pulse-fast 1s ease-in-out infinite;
}

.domain-text-wrapper {
  position: relative;
  display: inline-block;
}

.domain-text {
  position: relative;
  z-index: 2;
  color: var(--ui-primary, #00DC82);
  opacity: 0.8;
  font-weight: 800;
  transition: opacity 0.3s ease;
}

.logo-wrapper:hover .domain-text {
  opacity: 1;
}

/* Animated underline - only under "sh" */
.underline {
  position: absolute;
  bottom: -0.1em;
  left: 0;
  width: 0%;
  height: 0.07em;
  background: var(--ui-primary, #00DC82);
  opacity: 0.8;
  border-radius: 0.05em;
  transition: width 0.4s ease;
}

.underline.active {
  width: 100%;
}

/* Floating particles */
.particles {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.particle {
  position: absolute;
  width: 0.1em;
  height: 0.1em;
  background: var(--ui-primary, #00DC82);
  border-radius: 50%;
  opacity: 0.5;
  animation: float-particle 1.5s ease-out forwards;
  box-shadow: 0 0 0.2em var(--ui-primary, #00DC82);
}

.particle:nth-child(1) {
  left: 20%;
  top: 30%;
}

.particle:nth-child(2) {
  left: 50%;
  top: 20%;
}

.particle:nth-child(3) {
  left: 80%;
  top: 40%;
}

/* Animations */
@keyframes pulse {
  0%, 100% {
    transform: scale(1);
    opacity: 0.7;
  }
  50% {
    transform: scale(1.3);
    opacity: 1;
  }
}

@keyframes pulse-fast {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.5);
    opacity: 0.8;
  }
}

@keyframes float-particle {
  0% {
    transform: translateY(0) scale(1);
    opacity: 0.5;
  }
  100% {
    transform: translateY(-0.7em) scale(0);
    opacity: 0;
  }
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
