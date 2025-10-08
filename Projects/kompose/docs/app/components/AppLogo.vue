<template>
  <svg
    width="280"
    height="80"
    viewBox="0 0 280 80"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <defs>
      <!-- Soft shadow filter -->
      <filter id="softShadow" x="-50%" y="-50%" width="200%" height="200%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="3"/>
        <feOffset dx="0" dy="3" result="offsetblur"/>
        <feComponentTransfer>
          <feFuncA type="linear" slope="0.3"/>
        </feComponentTransfer>
        <feMerge>
          <feMergeNode/>
          <feMergeNode in="SourceGraphic"/>
        </feMerge>
      </filter>
      
      <!-- Subtle glow for extra depth -->
      <filter id="glow">
        <feGaussianBlur stdDeviation="2" result="coloredBlur"/>
        <feMerge>
          <feMergeNode in="coloredBlur"/>
          <feMergeNode in="SourceGraphic"/>
        </feMerge>
      </filter>
    </defs>

    <g filter="url(#softShadow)">
      <!-- K -->
      <path 
        d="M 20,20 L 20,60 M 20,40 L 48,20 M 20,40 L 48,60" 
        stroke="currentColor" 
        stroke-width="12" 
        stroke-linecap="round" 
        stroke-linejoin="round"
        filter="url(#glow)"
      />
      
      <!-- M -->
      <path 
        d="M 68,60 L 68,20 L 86,42 L 104,20 L 104,60" 
        stroke="currentColor" 
        stroke-width="12" 
        stroke-linecap="round" 
        stroke-linejoin="round"
        filter="url(#glow)"
      />
      
      <!-- P -->
      <path 
        d="M 124,60 L 124,20 L 148,20 C 156,20 162,26 162,34 C 162,42 156,48 148,48 L 124,48" 
        stroke="currentColor" 
        stroke-width="12" 
        stroke-linecap="round" 
        stroke-linejoin="round"
        filter="url(#glow)"
      />
      
      <!-- S -->
      <path 
        d="M 196,24 C 192,20 186,20 182,24 C 178,28 178,32 182,36 C 186,39 190,39 194,42 C 198,45 202,45 206,49 C 210,53 210,57 206,61 C 202,65 196,65 192,61" 
        stroke="currentColor" 
        stroke-width="12" 
        stroke-linecap="round" 
        stroke-linejoin="round"
        fill="none"
        filter="url(#glow)"
      />
      
      <!-- E -->
      <path 
        d="M 260,20 L 226,20 L 226,60 L 260,60 M 226,40 L 254,40" 
        stroke="currentColor" 
        stroke-width="12" 
        stroke-linecap="round" 
        stroke-linejoin="round"
        filter="url(#glow)"
      />
    </g>
  </svg>
</template>
