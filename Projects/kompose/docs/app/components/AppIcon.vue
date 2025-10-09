<template>
  <div
    class="kompose-icon-wrapper"
    :class="{ 'is-clicked': isClicked, 'is-interactive': interactive }"
    @click="handleClick"
    @mouseenter="handleHover"
    @mouseleave="handleLeave"
    @touchstart="handleTouch"
    :style="{ width: size, height: size }"
  >
    <svg
      class="kompose-icon"
      viewBox="0 0 192 192"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <defs>
        <pattern id="carbon192" x="0" y="0" width="7.68" height="7.68" patternUnits="userSpaceOnUse">
          <rect width="7.68" height="7.68" fill="#0a0e27"></rect>
          <path d="M0,0 L3.84,3.84 M3.84,0 L7.68,3.84 M0,3.84 L3.84,7.68" stroke="#060815" stroke-width="1.5" opacity="0.5"></path>
        </pattern>

        <linearGradient id="bgGrad192" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:#1a1d2e;stop-opacity:1"></stop>
          <stop offset="100%" style="stop-color:#0a0e27;stop-opacity:1"></stop>
        </linearGradient>

        <linearGradient id="primaryGrad192" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" class="gradient-start" style="stop-color:#00DC82;stop-opacity:1"></stop>
          <stop offset="100%" class="gradient-end" style="stop-color:#00a86b;stop-opacity:1"></stop>
        </linearGradient>

        <filter id="glow192">
          <feGaussianBlur stdDeviation="6" result="coloredBlur"></feGaussianBlur>
          <feMerge>
            <feMergeNode in="coloredBlur"></feMergeNode>
            <feMergeNode in="SourceGraphic"></feMergeNode>
          </feMerge>
        </filter>

        <filter id="intenseglow192">
          <feGaussianBlur stdDeviation="12" result="coloredBlur"></feGaussianBlur>
          <feMerge>
            <feMergeNode in="coloredBlur"></feMergeNode>
            <feMergeNode in="SourceGraphic"></feMergeNode>
          </feMerge>
        </filter>
      </defs>

      <!-- Background -->
      <rect class="bg-rect" width="192" height="192" rx="24" fill="url(#bgGrad192)"></rect>
      <rect class="carbon-pattern" width="192" height="192" rx="24" fill="url(#carbon192)" opacity="0.4"></rect>

      <!-- Stylized K -->
      <g class="k-letter" transform="translate(48, 48)">
        <line class="k-line k-vertical" x1="0" y1="0" x2="0" y2="96" stroke="url(#primaryGrad192)" stroke-width="15" stroke-linecap="round" filter="url(#glow192)"></line>
        <line class="k-line k-diagonal-top" x1="0" y1="48" x2="57.6" y2="0" stroke="url(#primaryGrad192)" stroke-width="15" stroke-linecap="round" filter="url(#glow192)"></line>
        <line class="k-line k-diagonal-bottom" x1="0" y1="48" x2="57.6" y2="96" stroke="url(#primaryGrad192)" stroke-width="15" stroke-linecap="round" filter="url(#glow192)"></line>
      </g>

      <!-- Animated status dot -->
      <circle class="status-dot" cx="163.2" cy="163.2" r="11.52" fill="#00DC82" opacity="0.9"></circle>
      <circle class="status-ring" cx="163.2" cy="163.2" r="17.28" fill="none" stroke="#00DC82" stroke-width="3" opacity="0.3"></circle>

      <!-- Tech corners -->
      <line class="corner corner-tl-h" x1="15.36" y1="15.36" x2="28.8" y2="15.36" stroke="#00DC82" stroke-width="3" opacity="0.4"></line>
      <line class="corner corner-tl-v" x1="15.36" y1="15.36" x2="15.36" y2="28.8" stroke="#00DC82" stroke-width="3" opacity="0.4"></line>
      <line class="corner corner-tr-h" x1="176.64" y1="15.36" x2="163.2" y2="15.36" stroke="#00DC82" stroke-width="3" opacity="0.4"></line>
      <line class="corner corner-tr-v" x1="176.64" y1="15.36" x2="176.64" y2="28.8" stroke="#00DC82" stroke-width="3" opacity="0.4"></line>
    </svg>

    <!-- Ripple effect container -->
    <div class="ripple" v-if="showRipple"></div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface Props {
  size?: string
  interactive?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  size: '192px',
  interactive: true
})

const isClicked = ref(false)
const showRipple = ref(false)

const handleClick = () => {
  if (!props.interactive) return

  isClicked.value = true
  showRipple.value = true

  setTimeout(() => {
    isClicked.value = false
  }, 600)

  setTimeout(() => {
    showRipple.value = false
  }, 800)
}

const handleHover = () => {
  if (!props.interactive) return
  // Hover animations are handled by CSS
}

const handleLeave = () => {
  if (!props.interactive) return
  // Leave animations are handled by CSS
}

const handleTouch = (e: TouchEvent) => {
  if (!props.interactive) return
  handleClick()
}
</script>

<style scoped>
.kompose-icon-wrapper {
  position: relative;
  display: inline-block;
  cursor: pointer;
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  transform-style: preserve-3d;
}

.kompose-icon-wrapper:not(.is-interactive) {
  cursor: default;
}

.kompose-icon {
  width: 100%;
  height: 100%;
  display: block;
  filter: drop-shadow(0 4px 20px rgba(0, 220, 130, 0.2));
  transition: filter 0.4s ease;
}

/* Hover Effects */
.kompose-icon-wrapper.is-interactive:hover {
  transform: scale(1.05) translateY(-2px);
}

.kompose-icon-wrapper.is-interactive:hover .kompose-icon {
  filter: drop-shadow(0 8px 30px rgba(0, 220, 130, 0.4));
  animation: subtle-pulse 2s ease-in-out infinite;
}

.kompose-icon-wrapper.is-interactive:hover .bg-rect {
  fill: url(#bgGrad192);
  opacity: 1;
  animation: bg-glow 2s ease-in-out infinite;
}

.kompose-icon-wrapper.is-interactive:hover .k-letter {
  animation: letter-glow 1.5s ease-in-out infinite;
}

.kompose-icon-wrapper.is-interactive:hover .k-vertical {
  animation: line-slide-vertical 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.kompose-icon-wrapper.is-interactive:hover .k-diagonal-top {
  animation: line-slide-diagonal-top 0.8s cubic-bezier(0.34, 1.56, 0.64, 1) 0.1s;
}

.kompose-icon-wrapper.is-interactive:hover .k-diagonal-bottom {
  animation: line-slide-diagonal-bottom 0.8s cubic-bezier(0.34, 1.56, 0.64, 1) 0.2s;
}

.kompose-icon-wrapper.is-interactive:hover .status-dot {
  animation: pulse-expand 1s ease-in-out infinite;
}

.kompose-icon-wrapper.is-interactive:hover .status-ring {
  animation: ring-pulse 1.5s ease-in-out infinite;
}

.kompose-icon-wrapper.is-interactive:hover .corner {
  opacity: 1 !important;
  stroke: #00DC82;
  animation: corner-extend 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* Click/Active Effects */
.kompose-icon-wrapper.is-clicked {
  animation: click-bounce 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.kompose-icon-wrapper.is-clicked .kompose-icon {
  animation: rotate-3d 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
  filter: drop-shadow(0 12px 40px rgba(0, 220, 130, 0.6));
}

.kompose-icon-wrapper.is-clicked .k-letter {
  animation: letter-flash 0.6s ease-out;
  filter: url(#intenseglow192);
}

.kompose-icon-wrapper.is-clicked .status-dot {
  animation: dot-burst 0.6s ease-out;
}

/* Ripple Effect */
.ripple {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(0, 220, 130, 0.6) 0%, rgba(0, 220, 130, 0) 70%);
  transform: translate(-50%, -50%) scale(0);
  animation: ripple-expand 0.8s ease-out;
  pointer-events: none;
}

/* Default animations for status dot */
.status-dot {
  animation: default-pulse 2s ease-in-out infinite;
}

.status-ring {
  animation: default-ring-pulse 2s ease-in-out infinite;
}

/* Keyframe Animations */
@keyframes subtle-pulse {
  0%, 100% {
    filter: drop-shadow(0 8px 30px rgba(0, 220, 130, 0.4));
  }
  50% {
    filter: drop-shadow(0 8px 35px rgba(0, 220, 130, 0.6));
  }
}

@keyframes bg-glow {
  0%, 100% {
    filter: brightness(1);
  }
  50% {
    filter: brightness(1.1);
  }
}

@keyframes letter-glow {
  0%, 100% {
    filter: url(#glow192);
  }
  50% {
    filter: url(#intenseglow192);
  }
}

@keyframes line-slide-vertical {
  0% {
    stroke-dasharray: 96;
    stroke-dashoffset: 96;
  }
  100% {
    stroke-dasharray: 96;
    stroke-dashoffset: 0;
  }
}

@keyframes line-slide-diagonal-top {
  0% {
    stroke-dasharray: 68;
    stroke-dashoffset: 68;
  }
  100% {
    stroke-dasharray: 68;
    stroke-dashoffset: 0;
  }
}

@keyframes line-slide-diagonal-bottom {
  0% {
    stroke-dasharray: 68;
    stroke-dashoffset: 68;
  }
  100% {
    stroke-dasharray: 68;
    stroke-dashoffset: 0;
  }
}

@keyframes pulse-expand {
  0%, 100% {
    r: 11.52;
    opacity: 0.9;
  }
  50% {
    r: 14;
    opacity: 1;
  }
}

@keyframes ring-pulse {
  0%, 100% {
    r: 17.28;
    opacity: 0.3;
    stroke-width: 3;
  }
  50% {
    r: 20;
    opacity: 0.6;
    stroke-width: 2;
  }
}

@keyframes corner-extend {
  0% {
    stroke-dasharray: 13.44;
    stroke-dashoffset: 13.44;
  }
  100% {
    stroke-dasharray: 13.44;
    stroke-dashoffset: 0;
  }
}

@keyframes click-bounce {
  0% {
    transform: scale(1) translateY(0) rotateY(0deg);
  }
  30% {
    transform: scale(0.92) translateY(0) rotateY(0deg);
  }
  50% {
    transform: scale(1.08) translateY(-4px) rotateY(180deg);
  }
  70% {
    transform: scale(0.98) translateY(0) rotateY(360deg);
  }
  100% {
    transform: scale(1) translateY(0) rotateY(360deg);
  }
}

@keyframes rotate-3d {
  0% {
    transform: perspective(800px) rotateY(0deg);
  }
  50% {
    transform: perspective(800px) rotateY(180deg);
  }
  100% {
    transform: perspective(800px) rotateY(360deg);
  }
}

@keyframes letter-flash {
  0%, 100% {
    opacity: 1;
  }
  20%, 60% {
    opacity: 0.7;
  }
  40%, 80% {
    opacity: 1;
  }
}

@keyframes dot-burst {
  0% {
    r: 11.52;
    opacity: 0.9;
  }
  50% {
    r: 20;
    opacity: 1;
  }
  100% {
    r: 11.52;
    opacity: 0.9;
  }
}

@keyframes ripple-expand {
  0% {
    transform: translate(-50%, -50%) scale(0);
    opacity: 1;
  }
  100% {
    transform: translate(-50%, -50%) scale(2.5);
    opacity: 0;
  }
}

@keyframes default-pulse {
  0%, 100% {
    opacity: 0.6;
    r: 11.52;
  }
  50% {
    opacity: 1;
    r: 13.44;
  }
}

@keyframes default-ring-pulse {
  0%, 100% {
    opacity: 0.3;
  }
  50% {
    opacity: 0.5;
  }
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .kompose-icon-wrapper.is-interactive:hover {
    transform: scale(1.03) translateY(-1px);
  }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
  .kompose-icon-wrapper,
  .kompose-icon,
  .kompose-icon *,
  .ripple {
    animation: none !important;
    transition: none !important;
  }

  .kompose-icon-wrapper.is-interactive:hover {
    transform: scale(1.02);
  }
}

/* Touch device optimizations */
@media (hover: none) and (pointer: coarse) {
  .kompose-icon-wrapper.is-interactive:active {
    transform: scale(0.95);
  }
}
</style>
