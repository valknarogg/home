<!-- 
  Icon Usage Examples for Favicon & PWA
  
  This component shows how to generate different sizes of the kompose.sh icon
  for various use cases: favicon, apple-touch-icon, PWA icons, etc.
-->

<script setup>
import AppIcon from "./AppIcon.vue";
</script>

<template>
  <div class="icon-showcase">
    <h2>kompose.sh Icon Sizes</h2>
    
    <div class="icon-grid">
      <!-- Favicon sizes -->
      <div class="icon-item">
        <AppIcon :size="16" />
        <p>16x16 (favicon.ico)</p>
      </div>
      
      <div class="icon-item">
        <AppIcon :size="32" />
        <p>32x32 (favicon-32x32.png)</p>
      </div>
      
      <div class="icon-item">
        <AppIcon :size="48" />
        <p>48x48 (favicon-48x48.png)</p>
      </div>

      <!-- Apple Touch Icon -->
      <div class="icon-item">
        <AppIcon :size="180" />
        <p>180x180 (apple-touch-icon.png)</p>
      </div>

      <!-- PWA Icons -->
      <div class="icon-item">
        <AppIcon :size="192" />
        <p>192x192 (PWA icon)</p>
      </div>

      <div class="icon-item">
        <AppIcon :size="512" />
        <p>512x512 (PWA icon)</p>
      </div>
    </div>

    <!-- HTML Head Examples -->
    <div class="code-section">
      <h3>HTML Head Implementation</h3>
      <pre><code>&lt;!-- Favicon --&gt;
&lt;link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png"&gt;
&lt;link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png"&gt;

&lt;!-- Apple Touch Icon --&gt;
&lt;link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png"&gt;

&lt;!-- PWA Manifest --&gt;
&lt;link rel="manifest" href="/site.webmanifest"&gt;</code></pre>
    </div>

    <!-- Manifest.json Example -->
    <div class="code-section">
      <h3>site.webmanifest</h3>
      <pre><code>{
  "name": "kompose.sh",
  "short_name": "kompose",
  "description": "Component composition framework",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0a0e27",
  "theme_color": "#00DC82",
  "icons": [
    {
      "src": "/icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}</code></pre>
    </div>

    <!-- Export Instructions -->
    <div class="instructions">
      <h3>How to Export Icons</h3>
      <ol>
        <li>Open the AppIcon.vue component in your browser</li>
        <li>Right-click on each icon size and "Save image as..."</li>
        <li>Or use a screenshot tool to capture at exact dimensions</li>
        <li>Or render the SVG and convert to PNG using a tool like:
          <ul>
            <li>Inkscape (CLI: inkscape --export-png=output.png --export-width=512 input.svg)</li>
            <li>ImageMagick (convert -background none input.svg -resize 512x512 output.png)</li>
            <li>Online tools like CloudConvert</li>
          </ul>
        </li>
      </ol>
    </div>
  </div>
</template>

<style scoped>
.icon-showcase {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

h2 {
  margin-bottom: 2rem;
  color: var(--ui-primary, #00DC82);
}

h3 {
  margin-top: 2rem;
  margin-bottom: 1rem;
  color: #fff;
}

.icon-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 2rem;
  margin-bottom: 3rem;
}

.icon-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(0, 220, 130, 0.2);
}

.icon-item p {
  margin: 0;
  font-size: 0.875rem;
  color: #888;
  font-family: monospace;
}

.code-section {
  margin: 2rem 0;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  padding: 1rem;
  border: 1px solid rgba(0, 220, 130, 0.2);
}

pre {
  margin: 0;
  overflow-x: auto;
}

code {
  font-family: 'Courier New', monospace;
  font-size: 0.875rem;
  color: #00DC82;
  line-height: 1.6;
}

.instructions {
  background: rgba(0, 220, 130, 0.1);
  padding: 1.5rem;
  border-radius: 8px;
  border: 1px solid rgba(0, 220, 130, 0.3);
}

.instructions ol, .instructions ul {
  margin: 0.5rem 0;
  padding-left: 1.5rem;
}

.instructions li {
  margin: 0.5rem 0;
  color: #ccc;
}
</style>
