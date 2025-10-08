<script lang="ts">
import "../app.css";
import { onMount } from "svelte";
import { waitLocale } from "svelte-i18n";
import "$lib/i18n";
import Footer from "$lib/components/footer/footer.svelte";
import { Toaster } from "$lib/components/ui/sonner";
import Header from "$lib/components/header/header.svelte";
import AgeVerificationDialog from "$lib/components/age-verification-dialog/age-verification-dialog.svelte";
import { PUBLIC_UMAMI_ID } from "$env/static/public";

onMount(async () => {
	await waitLocale();
});

let { children, data } = $props();
</script>

<svelte:head>
    {#if import.meta.env.PROD}
        <script
            defer
            src="https://umami.pivoine.art/script.js"
            data-website-id={PUBLIC_UMAMI_ID}
        ></script>
    {/if}
</svelte:head>

<AgeVerificationDialog />

<Toaster />

<div class="bg-background text-foreground min-h-screen">
    <!-- Advanced Global Plasma Background -->
    <div class="fixed inset-0 pointer-events-none overflow-hidden">
        <!-- Large primary blobs -->
        <div
            class="absolute -top-40 -left-40 w-80 h-80 bg-gradient-to-r from-primary/12 via-accent/18 to-primary/8 rounded-full blur-3xl animate-blob-ultra-slow"
        ></div>
        <div
            class="absolute -bottom-40 -right-40 w-96 h-96 bg-gradient-to-r from-accent/12 via-primary/18 to-accent/8 rounded-full blur-3xl animate-blob-ultra-slow animation-delay-5000"
        ></div>

        <!-- Medium floating elements -->
        <div
            class="absolute top-1/2 -left-20 w-64 h-64 bg-gradient-to-r from-primary/10 via-accent/15 to-primary/6 rounded-full blur-2xl animate-blob-ultra-slow animation-delay-8000"
        ></div>
        <div
            class="absolute top-1/4 -right-20 w-72 h-72 bg-gradient-to-r from-accent/10 via-primary/15 to-accent/6 rounded-full blur-2xl animate-blob-ultra-slow animation-delay-10000"
        ></div>

        <!-- Small particle-like elements -->
        <div
            class="absolute top-1/3 left-1/4 w-32 h-32 bg-gradient-to-r from-primary/15 to-accent/12 rounded-full blur-xl animate-float animation-delay-2000"
        ></div>
        <div
            class="absolute bottom-1/3 right-1/3 w-40 h-40 bg-gradient-to-r from-accent/15 to-primary/12 rounded-full blur-xl animate-float animation-delay-6000"
        ></div>
        <div
            class="absolute top-2/3 left-1/2 w-24 h-24 bg-gradient-to-r from-primary/20 to-accent/15 rounded-full blur-lg animate-pulse-slow animation-delay-4000"
        ></div>

        <!-- Glassmorphism overlay -->
        <div
            class="absolute inset-0 bg-gradient-to-br from-primary/2 via-transparent to-accent/2 backdrop-blur-[0.5px]"
        ></div>
    </div>
    <!-- Header -->
    <Header authStatus={data.authStatus} />

    <!-- Main Content -->
    <main class="min-h-screen">
        {@render children()}
    </main>

    <!-- Footer -->
    <Footer />
</div>
