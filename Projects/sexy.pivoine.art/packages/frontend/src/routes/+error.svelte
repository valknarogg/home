<script lang="ts">
import { _ } from "svelte-i18n";
import { page } from "$app/state";
import { Button } from "$lib/components/ui/button";
import { Card, CardContent } from "$lib/components/ui/card";
import PeonyIcon from "$lib/components/icon/peony-icon.svelte";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import Meta from "$lib/components/meta/meta.svelte";
</script>

<Meta
    title={page.status === 404 ? $_("error.not_found") : $_("error.common")}
    description={$_("error.description")}
/>

<div
    class="relative min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
    <PeonyBackground />

    <!-- Content -->
    <div class="relative z-10 container mx-auto px-4 text-center">
        <div class="max-w-2xl mx-auto">
            <!-- Premium Glassmorphism Card -->
            <Card
                class="bg-gradient-to-br from-card/25 via-card/30 to-card/20 backdrop-blur-2xl shadow-2xl shadow-primary/20"
            >
                <CardContent class="p-12">
                    <!-- 404 Animation -->
                    <div class="mb-8">
                        <div
                            class="text-8xl md:text-9xl font-bold bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent animate-pulse"
                        >
                            {page.status}
                        </div>
                        <div class="flex justify-center mt-4">
                            <PeonyIcon class="w-16 h-16 text-primary/60 animate-bounce" />
                        </div>
                    </div>

                    <!-- Error Message -->
                    <div class="space-y-6 mb-10">
                        <h1 class="text-4xl md:text-5xl font-bold text-foreground">
                            {page.status === 404 ? $_("error.not_found") : $_("error.common")}
                        </h1>
                        <p class="text-xl text-muted-foreground leading-relaxed max-w-2xl mx-auto">
                            {$_("error.description")}
                        </p>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
                        <Button
                            size="lg"
                            class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90 text-lg px-8 py-6"
                            href="/"
                        >
                            <span class="icon-[ri--home-2-line]"></span>
                            {$_("error.go_home")}
                        </Button>

                        <Button
                            variant="outline"
                            size="lg"
                            class="text-lg px-8 py-6 border-primary/50 hover:bg-primary/10"
                            href="/videos"
                        >
                            <span class="icon-[ri--search-line]"></span>
                            {$_("error.explore_videos")}
                        </Button>
                    </div>

                    <!-- Quick Links -->
                    <div class="mt-8 pt-8 border-t border-border/50">
                        <p class="text-sm text-muted-foreground mb-4">
                            {$_("error.quick_links")}
                        </p>
                        <div class="flex flex-wrap justify-center gap-3">
                            <button
                                class="text-sm text-primary hover:text-accent transition-colors hover:underline"
                                ><a href="/models">{$_("error.featured_models")}</a></button
                            >
                            <span class="text-muted-foreground">•</span>
                            <button
                                class="text-sm text-primary hover:text-accent transition-colors hover:underline"
                                ><a href="/magazine">{$_("error.magazine")}</a></button
                            >
                            <span class="text-muted-foreground">•</span>
                            <button
                                class="text-sm text-primary hover:text-accent transition-colors hover:underline"
                                ><a href="/about">{$_("error.about_us")}</a></button
                            >
                        </div>
                    </div>
                </CardContent>
            </Card>
        </div>
    </div>

    <!-- Floating Hearts Animation -->
    <div class="absolute inset-0 pointer-events-none">
        <div class="absolute top-1/4 left-1/4 opacity-20">
            <span
                class="icon-[ri--heart-3-line] w-6 h-6 text-primary animate-float animation-delay-1000"
            ></span>
        </div>
        <div class="absolute top-1/3 right-1/3 opacity-15">
            <span
                class="icon-[ri--heart-3-line] w-4 h-4 text-accent animate-float animation-delay-3000"
            ></span>
        </div>
        <div class="absolute bottom-1/4 left-1/3 opacity-25">
            <span
                class="icon-[ri--heart-3-line] w-5 h-5 text-primary animate-float animation-delay-5000"
            ></span>
        </div>
        <div class="absolute bottom-1/3 right-1/4 opacity-20">
            <span
                class="icon-[ri--heart-3-line] w-3 h-3 text-accent animate-float animation-delay-7000"
            ></span>
        </div>
    </div>
</div>
