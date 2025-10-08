<script lang="ts" setup>
import { ref } from 'vue'

const isHovered = ref(false)
const glowIntensity = ref(0)

const handleMouseMove = (e: MouseEvent) => {
  const rect = (e.target as HTMLElement).getBoundingClientRect()
  const x = ((e.clientX - rect.left) / rect.width) * 100
  const y = ((e.clientY - rect.top) / rect.height) * 100
  glowIntensity.value = Math.max(0, 1 - Math.sqrt(Math.pow(x - 50, 2) + Math.pow(y - 50, 2)) / 70)
}
</script>

<template>
  <div 
    class="w-full h-full flex items-center justify-center bg-[#0a0e27] relative overflow-hidden"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false; glowIntensity = 0"
    @mousemove="handleMouseMove"
  >
    <!-- Animated background grid -->
    <svg class="absolute inset-0 w-full h-full opacity-20" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
          <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#00d4ff" stroke-width="0.5" opacity="0.3"/>
        </pattern>
        <pattern id="hexGrid" width="60" height="52" patternUnits="userSpaceOnUse">
          <path d="M30 0 L45 13 L45 39 L30 52 L15 39 L15 13 Z" fill="none" stroke="#00d4ff" stroke-width="0.5" opacity="0.2"/>
        </pattern>
      </defs>
      <rect width="100%" height="100%" fill="url(#grid)" />
      <rect width="100%" height="100%" fill="url(#hexGrid)" />
    </svg>

    <!-- Glowing orb effect -->
    <svg class="absolute inset-0 w-full h-full pointer-events-none">
      <defs>
        <radialGradient id="glow" cx="50%" cy="50%">
          <stop offset="0%" :stop-color="`rgba(0, 212, 255, ${glowIntensity * 0.4})`" />
          <stop offset="50%" :stop-color="`rgba(0, 100, 255, ${glowIntensity * 0.2})`" />
          <stop offset="100%" stop-color="rgba(0, 0, 0, 0)" />
        </radialGradient>
      </defs>
      <circle cx="50%" cy="50%" r="300" fill="url(#glow)" />
    </svg>

    <!-- Main logo tag container -->
    <div 
      class="relative z-10 transition-all duration-500 ease-out"
      :class="{ 'scale-105': isHovered }"
    >
      <!-- Tag shape with carbon fiber background -->
      <svg 
        width="500" 
        height="200" 
        viewBox="0 0 500 200" 
        class="drop-shadow-2xl"
        xmlns="http://www.w3.org/2000/svg"
      >
        <defs>
          <!-- Carbon fiber pattern -->
          <pattern id="carbon" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse">
            <rect width="20" height="20" fill="#1a1d2e"/>
            <path d="M0,0 L10,10 M10,0 L20,10 M0,10 L10,20" stroke="#0f1119" stroke-width="1" opacity="0.5"/>
            <path d="M10,0 L0,10 M20,0 L10,10 M10,10 L0,20" stroke="#252939" stroke-width="1" opacity="0.3"/>
          </pattern>
          
          <!-- Mesh overlay pattern -->
          <pattern id="mesh" x="0" y="0" width="30" height="30" patternUnits="userSpaceOnUse">
            <circle cx="15" cy="15" r="1" fill="#00d4ff" opacity="0.3"/>
            <line x1="15" y1="0" x2="15" y2="30" stroke="#00d4ff" stroke-width="0.3" opacity="0.2"/>
            <line x1="0" y1="15" x2="30" y2="15" stroke="#00d4ff" stroke-width="0.3" opacity="0.2"/>
          </pattern>

          <!-- Metallic gradient -->
          <linearGradient id="metalGrad" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#2d3548;stop-opacity:1" />
            <stop offset="50%" style="stop-color:#1a1d2e;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#0f1421;stop-opacity:1" />
          </linearGradient>

          <!-- Glow filter -->
          <filter id="glow-filter">
            <feGaussianBlur stdDeviation="3" result="coloredBlur"/>
            <feMerge>
              <feMergeNode in="coloredBlur"/>
              <feMergeNode in="SourceGraphic"/>
            </feMerge>
          </filter>

          <!-- Inner shadow -->
          <filter id="innerShadow">
            <feGaussianBlur in="SourceAlpha" stdDeviation="3"/>
            <feOffset dx="0" dy="2" result="offsetblur"/>
            <feComponentTransfer>
              <feFuncA type="linear" slope="0.5"/>
            </feComponentTransfer>
            <feMerge>
              <feMergeNode/>
              <feMergeNode in="SourceGraphic"/>
            </feMerge>
          </filter>
        </defs>

        <!-- Tag base shape with angled cut -->
        <path 
          d="M 20,20 L 450,20 L 480,100 L 450,180 L 20,180 L 50,100 Z" 
          fill="url(#carbon)"
          stroke="url(#metalGrad)"
          stroke-width="2"
        />
        
        <!-- Mesh overlay -->
        <path 
          d="M 20,20 L 450,20 L 480,100 L 450,180 L 20,180 L 50,100 Z" 
          fill="url(#mesh)"
        />

        <!-- Inner border glow -->
        <path 
          d="M 25,25 L 448,25 L 476,100 L 448,175 L 25,175 L 52,100 Z" 
          fill="none"
          :stroke="isHovered ? '#00d4ff' : '#003d4f'"
          stroke-width="1.5"
          :opacity="isHovered ? 0.8 : 0.4"
          class="transition-all duration-300"
          filter="url(#glow-filter)"
        />

        <!-- Corner rivets -->
        <circle cx="35" cy="35" r="4" fill="#1a1d2e" stroke="#00d4ff" stroke-width="1" opacity="0.6"/>
        <circle cx="465" cy="35" r="4" fill="#1a1d2e" stroke="#00d4ff" stroke-width="1" opacity="0.6"/>
        <circle cx="35" cy="165" r="4" fill="#1a1d2e" stroke="#00d4ff" stroke-width="1" opacity="0.6"/>
        <circle cx="465" cy="165" r="4" fill="#1a1d2e" stroke="#00d4ff" stroke-width="1" opacity="0.6"/>

        <!-- Decorative tech lines -->
        <line x1="70" y1="50" x2="150" y2="50" stroke="#00d4ff" stroke-width="1" opacity="0.4"/>
        <line x1="70" y1="55" x2="140" y2="55" stroke="#00d4ff" stroke-width="0.5" opacity="0.3"/>
        <line x1="350" y1="50" x2="430" y2="50" stroke="#00d4ff" stroke-width="1" opacity="0.4"/>
        <line x1="360" y1="55" x2="430" y2="55" stroke="#00d4ff" stroke-width="0.5" opacity="0.3"/>

        <line x1="70" y1="150" x2="150" y2="150" stroke="#00d4ff" stroke-width="1" opacity="0.4"/>
        <line x1="70" y1="145" x2="140" y2="145" stroke="#00d4ff" stroke-width="0.5" opacity="0.3"/>
        <line x1="350" y1="150" x2="430" y2="150" stroke="#00d4ff" stroke-width="1" opacity="0.4"/>
        <line x1="360" y1="145" x2="430" y2="145" stroke="#00d4ff" stroke-width="0.5" opacity="0.3"/>

        <!-- Logo text "kmpse" -->
        <text 
          x="250" 
          y="115" 
          font-family="'Courier New', monospace" 
          font-size="72" 
          font-weight="bold"
          text-anchor="middle"
          fill="#00d4ff"
          filter="url(#glow-filter)"
          :opacity="isHovered ? 1 : 0.9"
          class="transition-opacity duration-300"
        >
          kmpse
        </text>

        <!-- Text shadow/depth -->
        <text 
          x="252" 
          y="117" 
          font-family="'Courier New', monospace" 
          font-size="72" 
          font-weight="bold"
          text-anchor="middle"
          fill="#001a1f"
          opacity="0.6"
        >
          kmpse
        </text>

        <!-- Scanline effect -->
        <rect 
          x="20" 
          y="20" 
          width="460" 
          height="160" 
          fill="none" 
          stroke="#00d4ff" 
          stroke-width="0.5" 
          opacity="0.1"
          clip-path="polygon(0 20%, 100% 20%, 100% 22%, 0 22%)"
        >
          <animateTransform
            attributeName="transform"
            type="translate"
            from="0 -180"
            to="0 180"
            dur="3s"
            repeatCount="indefinite"
          />
        </rect>

        <!-- Subtle version number -->
        <text 
          x="430" 
          y="170" 
          font-family="'Courier New', monospace" 
          font-size="10" 
          fill="#00d4ff"
          opacity="0.4"
        >
          v4.0
        </text>
      </svg>

      <!-- Additional floating particles -->
      <div class="absolute inset-0 pointer-events-none">
        <div 
          v-for="i in 5" 
          :key="i"
          class="absolute w-1 h-1 bg-cyan-400 rounded-full opacity-30"
          :style="{
            left: `${20 + i * 15}%`,
            top: `${30 + (i % 2) * 40}%`,
            animation: `float ${3 + i * 0.5}s ease-in-out infinite`,
            animationDelay: `${i * 0.2}s`
          }"
        />
      </div>
    </div>

    <!-- Status indicator -->
    <div class="absolute bottom-8 left-8 flex items-center gap-2 text-cyan-400 text-sm font-mono">
      <div 
        class="w-2 h-2 rounded-full bg-cyan-400"
        :class="{ 'animate-pulse': isHovered }"
      />
      <span :class="{ 'text-cyan-300': isHovered }">SYSTEM.ACTIVE</span>
    </div>
  </div>
</template>

<style scoped>
@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}
</style>
