<script lang="ts">
import { _ } from "svelte-i18n";
import { browser } from "$app/environment";
import { onMount, onDestroy } from "svelte";
import Button from "../ui/button/button.svelte";

const { images = [] } = $props();

let isViewerOpen = $state(false);
let currentImageIndex = $state(0);
let imageLoading = $state(false);

let currentImage = $derived(images[currentImageIndex]);
let canGoPrev = $derived(currentImageIndex > 0);
let canGoNext = $derived(currentImageIndex < images.length - 1);

function openViewer(index) {
	currentImageIndex = index;
	isViewerOpen = true;
	imageLoading = true;
	document.body.style.overflow = "hidden";
}

function closeViewer() {
	isViewerOpen = false;
	document.body.style.overflow = "";
}

function navigatePrev() {
	if (canGoPrev) {
		currentImageIndex--;
		imageLoading = true;
	}
}

function navigateNext() {
	if (canGoNext) {
		currentImageIndex++;
		imageLoading = true;
	}
}

function downloadImage() {
	const link = document.createElement("a");
	link.href = currentImage.url;
	link.download = currentImage.title.replace(/\\s+/g, "_") + ".jpg";
	link.target = "_blank";
	document.body.appendChild(link);
	link.click();
	document.body.removeChild(link);
}

function handleKeydown(event) {
	if (!isViewerOpen) return;

	switch (event.key) {
		case "ArrowLeft":
			event.preventDefault();
			navigatePrev();
			break;
		case "ArrowRight":
			event.preventDefault();
			navigateNext();
			break;
		case "Escape":
			event.preventDefault();
			closeViewer();
			break;
		case "d":
		case "D":
			event.preventDefault();
			downloadImage();
			break;
	}
}

function handleImageLoad() {
	imageLoading = false;
}

onMount(() => {
	if (!browser) {
		return;
	}
	window.addEventListener("keydown", handleKeydown);
	// Preload images
	images.forEach((img) => {
		const preload = new Image();
		preload.src = img.url;
	});
});

onDestroy(() => {
	if (!browser) {
		return;
	}
	window.removeEventListener("keydown", handleKeydown);
	document.body.style.overflow = "";
});
</script>

<!-- Gallery Grid -->
<div class="w-full mx-auto">
  <div
    class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 animate-fade-in"
  >
    {#each images as image, index}
      <button
        onclick={() => openViewer(index)}
        class="group relative aspect-square overflow-hidden rounded-xl bg-zinc-900 border border-zinc-800 transition-all duration-300 hover:scale-[1.03] hover:border-primary/50 hover:shadow-2xl hover:shadow-primary/20 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 focus:ring-offset-zinc-950"
      >
        <!-- Thumbnail Image -->
        <img
          src={image.thumbnail}
          alt={image.title}
          class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
          loading="lazy"
        />

        <!-- Gradient Overlay -->
        <div
          class="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
        ></div>

        <!-- Hover Glow Effect -->
        <div
          class="absolute inset-0 bg-gradient-to-br from-primary/20 to-accent/20 opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none"
        ></div>

        <!-- Image Info Overlay -->
        <div
          class="absolute bottom-0 left-0 right-0 p-4 transform translate-y-full group-hover:translate-y-0 transition-transform duration-300"
        >
          <h3 class="text-foreground font-semibold text-sm mb-1">
            {image.title}
          </h3>
          <p class="text-zinc-400 text-xs">
            {index + 1} / {images.length}
          </p>
        </div>
      </button>
    {/each}
  </div>
</div>

<!-- Image Viewer Modal -->
{#if isViewerOpen}
  <div
    class="fixed inset-0 z-50 flex items-center justify-center animate-fade-in"
  >
    <!-- Backdrop -->
    <div
      class="absolute inset-0 bg-black/95 backdrop-blur-xl"
      onclick={closeViewer}
    ></div>

    <!-- Viewer Content -->
    <div class="relative w-[90vw] h-[90vh] flex flex-col animate-slide-up">
      <!-- Header -->
      <div class="absolute top-0 left-0 right-0 z-20 p-6 rounded-2xl">
        <div class="flex items-start justify-between">
          <div class="flex-1">
            <h2 class="text-3xl font-bold text-foreground mb-2 drop-shadow-lg">
              {currentImage.title}
            </h2>
            <div class="text-primary font-medium mb-3">
              {$_("image_viewer.index", {
                values: {
                    index: currentImageIndex + 1,
                    size: images.length
                }
              })}
            </div>
            <p class="text-zinc-400 max-w-2xl">
              {currentImage.description}
            </p>
          </div>

          <!-- Control Buttons -->
          <div class="flex gap-3 ml-8">
            <Button
              onclick={downloadImage}
              variant="outline"
              size="icon"
              class="w-11 h-11 rounded-lg bg-foreground/10 backdrop-blur border border-foreground/10 text-foreground flex items-center justify-center transition-all hover:bg-primary hover:border-primary hover:scale-105 hover:shadow-lg active:scale-95"
            >
              <span class="icon-[ri--download-fill] w-4 h-4"></span>
            </Button>
            <Button
              onclick={closeViewer}
              variant="outline"
              size="icon"
              class="w-11 h-11 rounded-lg bg-foreground/10 backdrop-blur border border-foreground/10 text-foreground flex items-center justify-center transition-all hover:bg-destructive hover:border-destructive hover:scale-105 hover:shadow-lg active:scale-95"
            >
              <span class="icon-[ri--close-fill] w-4 h-4"></span>
            </Button>
          </div>
        </div>
      </div>

      <!-- Image Container -->
      <div class="flex-1 flex items-center justify-center relative px-20">
        <!-- Previous Button -->
        <Button
          onclick={navigatePrev}
          disabled={!canGoPrev}
          variant="outline"
          size="icon"
          class="absolute left-8 top-1/2 -translate-y-1/2 w-14 h-14 rounded-full bg-foreground/10 backdrop-blur border border-foreground/10 text-foreground flex items-center justify-center transition-all hover:bg-accent hover:border-accent hover:scale-110 hover:shadow-xl active:scale-95 disabled:opacity-30 disabled:cursor-not-allowed disabled:hover:bg-foreground/10 disabled:hover:border-foreground/10 disabled:hover:scale-100 disabled:hover:shadow-none z-10"
        >
          <span class="icon-[ri--arrow-left-s-line] w-5 h-5"></span>
        </Button>

        <!-- Main Image -->
        <div class="relative max-w-full max-h-full">
          {#if imageLoading}
            <div class="absolute inset-0 flex items-center justify-center">
              <div
                class="w-12 h-12 border-4 border-primary/30 border-t-primary rounded-full animate-spin"
              ></div>
            </div>
          {/if}
          <img
            src={currentImage.url}
            alt={currentImage.title}
            onload={handleImageLoad}
            class="max-w-full max-h-[calc(90vh-8rem)] object-contain rounded-lg shadow-2xl {imageLoading
              ? 'opacity-0'
              : 'opacity-100 animate-zoom-in'} transition-opacity duration-300"
          />
        </div>

        <!-- Next Button -->
        <Button
          onclick={navigateNext}
          disabled={!canGoNext}
          variant="outline"
          size="icon"
          class="absolute right-8 top-1/2 -translate-y-1/2 w-14 h-14 rounded-full bg-foreground/10 backdrop-blur border border-foreground/10 text-foreground flex items-center justify-center transition-all hover:bg-accent hover:border-accent hover:scale-110 hover:shadow-xl active:scale-95 disabled:opacity-30 disabled:cursor-not-allowed disabled:hover:bg-foreground/10 disabled:hover:border-foreground/10 disabled:hover:scale-100 disabled:hover:shadow-none z-10"
        >
          <span class="icon-[ri--arrow-right-s-line] w-5 h-5"></span>
        </Button>
      </div>

      <!-- Keyboard Hints -->
      <div
        class="hidden md:flex absolute bottom-6 left-1/2 -translate-x-1/2 gap-4 px-6 py-3 bg-zinc-900/95 backdrop-blur-sm rounded-lg border border-zinc-800 text-zinc-400 text-sm"
      >
        <span class="flex items-center gap-2">
          <kbd
            class="px-2 py-1 bg-zinc-800 border border-zinc-700 rounded text-foreground font-mono text-xs"
            >←</kbd
          >
          {$_("image_viewer.previous")}
        </span>
        <span class="flex items-center gap-2">
          <kbd
            class="px-2 py-1 bg-zinc-800 border border-zinc-700 rounded text-foreground font-mono text-xs"
            >→</kbd
          >
          {$_("image_viewer.next")}
        </span>
        <span class="flex items-center gap-2">
          <kbd
            class="px-2 py-1 bg-zinc-800 border border-zinc-700 rounded text-foreground font-mono text-xs"
            >Esc</kbd
          >
          {$_("image_viewer.close")}
        </span>
        <span class="flex items-center gap-2">
          <kbd
            class="px-2 py-1 bg-zinc-800 border border-zinc-700 rounded text-foreground font-mono text-xs"
            >D</kbd
          >
          {$_("image_viewer.download")}
        </span>
      </div>
    </div>
  </div>
{/if}
