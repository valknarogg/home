<script lang="ts">
import { Avatar, AvatarFallback, AvatarImage } from "$lib/components/ui/avatar";
import { getUserInitials } from "$lib/utils";

interface User {
	name: string;
	email: string;
	avatar: string;
}

interface Props {
	user: User;
	onLogout: () => void;
}

let { user, onLogout }: Props = $props();

let isDragging = $state(false);
let slidePosition = $state(0);
let startX = 0;
let currentX = 0;
let maxSlide = 117; // Maximum slide distance
let threshold = 0.75; // 70% threshold to trigger logout

// Calculate slide progress (0 to 1)
const slideProgress = $derived(Math.min(slidePosition / maxSlide, 1));
const isNearThreshold = $derived(slideProgress > threshold);

const handleStart = (clientX: number) => {
	isDragging = true;
	startX = clientX;
	currentX = clientX;
};

const handleMove = (clientX: number) => {
	if (!isDragging) return;

	currentX = clientX;
	const deltaX = currentX - startX;
	slidePosition = Math.max(0, Math.min(deltaX, maxSlide));
};

const handleEnd = () => {
	if (!isDragging) return;

	isDragging = false;

	if (slideProgress >= threshold) {
		// Trigger logout
		slidePosition = maxSlide;
		onLogout();
	} else {
		// Snap back
		slidePosition = 0;
	}
};

// Mouse events
const handleMouseDown = (e: MouseEvent) => {
	e.preventDefault();
	handleStart(e.clientX);
};

const handleMouseMove = (e: MouseEvent) => {
	handleMove(e.clientX);
};

const handleMouseUp = () => {
	handleEnd();
};

// Touch events
const handleTouchStart = (e: TouchEvent) => {
	handleStart(e.touches[0].clientX);
};

const handleTouchMove = (e: TouchEvent) => {
	e.preventDefault();
	handleMove(e.touches[0].clientX);
};

const handleTouchEnd = () => {
	handleEnd();
};

// Add global event listeners when dragging
$effect(() => {
	if (isDragging) {
		document.addEventListener("mousemove", handleMouseMove);
		document.addEventListener("mouseup", handleMouseUp);
		document.addEventListener("touchmove", handleTouchMove, { passive: false });
		document.addEventListener("touchend", handleTouchEnd);

		return () => {
			document.removeEventListener("mousemove", handleMouseMove);
			document.removeEventListener("mouseup", handleMouseUp);
			document.removeEventListener("touchmove", handleTouchMove);
			document.removeEventListener("touchend", handleTouchEnd);
		};
	}
});
</script>

<div
	class="relative h-10 w-40 rounded-full bg-muted/30 overflow-hidden select-none transition-all duration-300 bg-muted/40 shadow-lg shadow-accent/10 {isDragging ? 'cursor-grabbing' : ''}"
	style="background: linear-gradient(90deg, 
		oklch(var(--primary) / 0.3) 0%, 
		oklch(var(--primary) / 0.3) {(1 - slideProgress) * 100}%, 
		oklch(var(--accent) / {0.1 + slideProgress * 0.2}) {(1 - slideProgress) * 100}%, 
		oklch(var(--accent) / {0.2 + slideProgress * 0.3}) 100%
	)"
>
	<!-- Background slide indicator -->
	<div
		class="absolute inset-0 rounded-full transition-all duration-200"
		style="background: linear-gradient(90deg, 
			transparent 0%, 
			transparent {Math.max(0, slideProgress * 100 - 20)}%, 
			oklch(var(--accent) / {slideProgress * 0.1}) {slideProgress * 100}%, 
			oklch(var(--accent) / {slideProgress * 0.2}) 100%
		)"
	></div>

	<!-- Sliding user info -->
	<button class="cursor-grab absolute left-0 top-0 h-full flex items-center gap-3 px-2 transition-all duration-200 ease-out rounded-full bg-background/80 backdrop-blur-sm border border-border/50 bg-background/90 border-primary/20 {isDragging ? '' : 'transition-all duration-300 ease-out'}" style="transform: translateX({slidePosition}px); width: calc(100% - {slidePosition}px);" onmousedown={handleMouseDown} ontouchstart={handleTouchStart}>
        <Avatar class="h-7 w-7 ring-2 ring-accent/20 transition-all duration-200 {isNearThreshold ? 'ring-destructive/40' : ''}" style="opacity: {Math.max(0.1, 1 - slideProgress * 1.8)}">
			<AvatarImage src={user.avatar} alt={user.name} />
			<AvatarFallback class="bg-gradient-to-br from-primary to-accent text-primary-foreground text-xs font-semibold transition-all duration-200 {isNearThreshold ? 'from-destructive to-destructive/80' : ''}">
				{getUserInitials(user.name)}
			</AvatarFallback>
		</Avatar>
		<div class="text-left flex flex-col min-w-0 flex-1">
			<span class="text-sm font-medium text-foreground leading-none truncate transition-all duration-200 {isNearThreshold ? 'text-destructive' : ''}" style="opacity: {Math.max(0.15, 1 - slideProgress * 1.5)}">{user.name.split(" ")[0]}</span>
			<span class="text-xs text-muted-foreground leading-none transition-all duration-200 {isNearThreshold ? 'text-destructive/70' : ''}" style="opacity: {Math.max(0.1, 1 - slideProgress * 1.8)}">
				{slideProgress > 0.3 ? "Logout" : "Online"}
			</span>
		</div>
	</button>

    	<!-- Logout icon area -->
	<div class="absolute right-2 top-1/2 -translate-y-1/2 flex items-center justify-center w-8 h-8 rounded-full transition-all duration-200 {isNearThreshold ? 'bg-destructive text-destructive-foreground scale-110' : 'bg-transparent text-foreground'}">
        <span class="icon-[ri--logout-circle-r-line] h-4 w-4 transition-transform duration-200 {isNearThreshold ? 'scale-110' : ''}" ></span>
	</div>


	<!-- Progress indicator -->
	<!-- <div class="absolute bottom-0 left-0 h-0.5 bg-gradient-to-r from-primary to-accent transition-all duration-200 rounded-full" style="width: {slideProgress * 100}%"></div> -->
</div>
