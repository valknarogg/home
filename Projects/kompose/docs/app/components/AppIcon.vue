<script setup>
import { computed } from 'vue'

const props = defineProps({
  size: {
    type: Number,
    default: 512 // Default for PWA, can be 16, 32, 192, 512, etc.
  }
})

const iconSize = computed(() => props.size)
const strokeWidth = computed(() => props.size / 32) // Scales with size
</script>

<template>
  <svg
    :width="iconSize"
    :height="iconSize"
    :viewBox="`0 0 ${iconSize} ${iconSize}`"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <defs>
      <!-- Carbon fiber pattern -->
      <pattern 
        id="carbon" 
        x="0" 
        y="0" 
        :width="iconSize / 25" 
        :height="iconSize / 25" 
        patternUnits="userSpaceOnUse"
      >
        <rect :width="iconSize / 25" :height="iconSize / 25" fill="#0a0e27"/>
        <path 
          :d="`M0,0 L${iconSize/50},${iconSize/50} M${iconSize/50},0 L${iconSize/25},${iconSize/50} M0,${iconSize/50} L${iconSize/50},${iconSize/25}`" 
          stroke="#060815" 
          :stroke-width="strokeWidth / 4" 
          opacity="0.5"
        />
      </pattern>

      <!-- Gradient for depth -->
      <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" style="stop-color:#1a1d2e;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#0a0e27;stop-opacity:1" />
      </linearGradient>

      <!-- Primary color gradient -->
      <linearGradient id="primaryGrad" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" style="stop-color:#00DC82;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#00a86b;stop-opacity:1" />
      </linearGradient>

      <!-- Glow effect -->
      <filter id="glow">
        <feGaussianBlur :stdDeviation="strokeWidth" result="coloredBlur"/>
        <feMerge>
          <feMergeNode in="coloredBlur"/>
          <feMergeNode in="SourceGraphic"/>
        </feMerge>
      </filter>
    </defs>

    <!-- Background with rounded corners -->
    <rect 
      :width="iconSize" 
      :height="iconSize" 
      :rx="iconSize / 8" 
      fill="url(#bgGrad)"
    />
    
    <!-- Carbon texture overlay -->
    <rect 
      :width="iconSize" 
      :height="iconSize" 
      :rx="iconSize / 8" 
      fill="url(#carbon)" 
      opacity="0.4"
    />

    <!-- Stylized "K" letter with geometric design -->
    <g :transform="`translate(${iconSize * 0.25}, ${iconSize * 0.25})`">
      <!-- Main vertical line of K -->
      <line 
        :x1="0" 
        :y1="0" 
        :x2="0" 
        :y2="iconSize * 0.5" 
        stroke="url(#primaryGrad)" 
        :stroke-width="strokeWidth * 2.5" 
        stroke-linecap="round"
        filter="url(#glow)"
      />
      
      <!-- Upper diagonal of K -->
      <line 
        :x1="0" 
        :y1="iconSize * 0.25" 
        :x2="iconSize * 0.3" 
        :y2="0" 
        stroke="url(#primaryGrad)" 
        :stroke-width="strokeWidth * 2.5" 
        stroke-linecap="round"
        filter="url(#glow)"
      />
      
      <!-- Lower diagonal of K -->
      <line 
        :x1="0" 
        :y1="iconSize * 0.25" 
        :x2="iconSize * 0.3" 
        :y2="iconSize * 0.5" 
        stroke="url(#primaryGrad)" 
        :stroke-width="strokeWidth * 2.5" 
        stroke-linecap="round"
        filter="url(#glow)"
      />
    </g>

    <!-- Animated status dot (bottom right) -->
    <circle 
      :cx="iconSize * 0.85" 
      :cy="iconSize * 0.85" 
      :r="iconSize * 0.06" 
      fill="#00DC82"
      opacity="0.9"
    >
      <animate
        attributeName="opacity"
        values="0.6;1;0.6"
        dur="2s"
        repeatCount="indefinite"
      />
      <animate
        attributeName="r"
        :values="`${iconSize * 0.06};${iconSize * 0.07};${iconSize * 0.06}`"
        dur="2s"
        repeatCount="indefinite"
      />
    </circle>

    <!-- Glow ring around dot -->
    <circle 
      :cx="iconSize * 0.85" 
      :cy="iconSize * 0.85" 
      :r="iconSize * 0.09" 
      fill="none"
      stroke="#00DC82" 
      :stroke-width="strokeWidth / 2"
      opacity="0.3"
    />

    <!-- Tech corner accents -->
    <line 
      :x1="iconSize * 0.08" 
      :y1="iconSize * 0.08" 
      :x2="iconSize * 0.15" 
      :y2="iconSize * 0.08" 
      stroke="#00DC82" 
      :stroke-width="strokeWidth / 2" 
      opacity="0.4"
    />
    <line 
      :x1="iconSize * 0.08" 
      :y1="iconSize * 0.08" 
      :x2="iconSize * 0.08" 
      :y2="iconSize * 0.15" 
      stroke="#00DC82" 
      :stroke-width="strokeWidth / 2" 
      opacity="0.4"
    />

    <line 
      :x1="iconSize * 0.92" 
      :y1="iconSize * 0.08" 
      :x2="iconSize * 0.85" 
      :y2="iconSize * 0.08" 
      stroke="#00DC82" 
      :stroke-width="strokeWidth / 2" 
      opacity="0.4"
    />
    <line 
      :x1="iconSize * 0.92" 
      :y1="iconSize * 0.08" 
      :x2="iconSize * 0.92" 
      :y2="iconSize * 0.15" 
      stroke="#00DC82" 
      :stroke-width="strokeWidth / 2" 
      opacity="0.4"
    />
  </svg>
</template>
