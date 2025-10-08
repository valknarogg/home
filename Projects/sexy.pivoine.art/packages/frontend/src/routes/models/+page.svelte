<script lang="ts">
import { _ } from "svelte-i18n";
import { Button } from "$lib/components/ui/button";
import { Card, CardContent } from "$lib/components/ui/card";
import { Input } from "$lib/components/ui/input";
import {
	Select,
	SelectContent,
	SelectItem,
	SelectTrigger,
} from "$lib/components/ui/select";
import { getAssetUrl } from "$lib/directus";
import Meta from "$lib/components/meta/meta.svelte";

let searchQuery = $state("");
let sortBy = $state("popular");
let categoryFilter = $state("all");

const { data } = $props();

const filteredModels = $derived(() => {
	return data.models
		.filter((model) => {
			const matchesSearch =
				searchQuery === "" ||
				model.artist_name.toLowerCase().includes(searchQuery.toLowerCase()) ||
				model.tags.some((tag) =>
					tag.toLowerCase().includes(searchQuery.toLowerCase()),
				);
			const matchesCategory =
				categoryFilter === "all" || model.category === categoryFilter;
			return matchesSearch && matchesCategory;
		})
		.sort((a, b) => {
			// if (sortBy === "popular") {
			//   const aNum = parseInt(a.subscribers.replace(/[^\d]/g, ""));
			//   const bNum = parseInt(b.subscribers.replace(/[^\d]/g, ""));
			//   return bNum - aNum;
			// }
			// if (sortBy === "rating") return b.rating - a.rating;
			// if (sortBy === "videos") return b.videos - a.videos;
			return a.artist_name.localeCompare(b.artist_name);
		});
});
</script>

<Meta title={$_("models.title")} description={$_("models.description")} />

<div
    class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
    <!-- Global Plasma Background -->
    <div class="absolute inset-0 pointer-events-none">
        <div
            class="absolute top-40 left-1/4 w-80 h-80 bg-gradient-to-r from-primary/16 via-accent/20 to-primary/12 rounded-full blur-3xl animate-blob-slow"
        ></div>
        <div
            class="absolute bottom-40 right-1/4 w-96 h-96 bg-gradient-to-r from-accent/16 via-primary/20 to-accent/12 rounded-full blur-3xl animate-blob-slow animation-delay-5000"
        ></div>
        <div
            class="absolute top-1/3 right-1/3 w-64 h-64 bg-gradient-to-r from-primary/14 via-accent/18 to-primary/10 rounded-full blur-2xl animate-blob-reverse animation-delay-2500"
        ></div>
    </div>

    <section class="relative py-20 overflow-hidden">
        <div class="relative container mx-auto px-4 text-center">
            <div class="max-w-5xl mx-auto">
                <h1
                    class="text-5xl md:text-7xl font-bold mb-8 bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent"
                >
                    {$_("models.title")}
                </h1>
                <p
                    class="text-xl md:text-2xl text-muted-foreground mb-10 leading-relaxed max-w-4xl mx-auto"
                >
                    {$_("models.description")}
                </p>
                <!-- Filters -->
                <div class="flex flex-col md:flex-row gap-4 max-w-4xl mx-auto">
                    <!-- Search -->
                    <div class="relative flex-1">
                        <span
                            class="icon-[ri--search-line] absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground"
                        ></span>
                        <Input
                            placeholder={$_("models.search_placeholder")}
                            bind:value={searchQuery}
                            class="pl-10 bg-background/50 border-primary/20 focus:border-primary"
                        />
                    </div>

                    <!-- Category Filter -->
                    <Select type="single" bind:value={categoryFilter}>
                        <SelectTrigger
                            class="w-full md:w-48 bg-background/50 border-primary/20 focus:border-primary"
                        >
                            <span class="icon-[ri--filter-line] w-4 h-4 mr-2"></span>
                            {categoryFilter === "all"
                                ? $_("models.categories.all")
                                : categoryFilter === "romantic"
                                  ? $_("models.categories.romantic")
                                  : categoryFilter === "artistic"
                                    ? $_("models.categories.artistic")
                                    : $_("models.categories.intimate")}
                        </SelectTrigger>
                        <SelectContent>
                            <SelectItem value="all">{$_("models.categories.all")}</SelectItem>
                            <SelectItem value="romantic"
                                >{$_("models.categories.romantic")}</SelectItem
                            >
                            <SelectItem value="artistic"
                                >{$_("models.categories.artistic")}</SelectItem
                            >
                            <SelectItem value="intimate"
                                >{$_("models.categories.intimate")}</SelectItem
                            >
                        </SelectContent>
                    </Select>

                    <!-- Sort -->
                    <Select type="single" bind:value={sortBy}>
                        <SelectTrigger
                            class="w-full md:w-48 bg-background/50 border-primary/20 focus:border-primary"
                        >
                            {sortBy === "popular"
                                ? $_("models.sort.popular")
                                : sortBy === "rating"
                                  ? $_("models.sort.rating")
                                  : sortBy === "videos"
                                    ? $_("models.sort.videos")
                                    : $_("models.sort.name")}
                        </SelectTrigger>
                        <SelectContent>
                            <SelectItem value="popular">{$_("models.sort.popular")}</SelectItem>
                            <SelectItem value="rating">{$_("models.sort.rating")}</SelectItem>
                            <SelectItem value="videos">{$_("models.sort.videos")}</SelectItem>
                            <SelectItem value="name">{$_("models.sort.name")}</SelectItem>
                        </SelectContent>
                    </Select>
                </div>
            </div>
        </div>
    </section>
    <!-- Models Grid -->
    <div class="container mx-auto px-4 py-12">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {#each filteredModels() as model}
                <Card
                    class="py-0 group hover:shadow-2xl hover:shadow-primary/25 transition-all duration-500 hover:-translate-y-3 bg-gradient-to-br from-card/90 via-card/95 to-card/85 backdrop-blur-xl shadow-lg shadow-primary/10 overflow-hidden"
                >
                    <div class="relative">
                        <img
                            src={getAssetUrl(model.avatar, "preview")}
                            alt={model.artist_name}
                            class="w-full aspect-square object-cover group-hover:scale-105 transition-transform duration-300"
                        />

                        <!-- Online Status -->
                        <!-- {#if model.isOnline}
              <div
                class="absolute top-3 left-3 bg-green-500 text-white text-xs px-2 py-1 rounded-full flex items-center gap-1"
              >
                <div class="w-2 h-2 bg-white rounded-full animate-pulse"></div>
                {$_("models.online")}
              </div>
            {/if} -->

                        <!-- Heart Button -->
                        <!-- <button
              class="absolute top-3 right-3 w-10 h-10 bg-black/50 hover:bg-primary/80 rounded-full flex items-center justify-center transition-colors group/heart"
            >
              <HeartIcon
                class="w-5 h-5 text-white group-hover/heart:fill-current"
              />
            </button> -->

                        <!-- Play Overlay -->
                        <a
                            href="/models/{model.slug}"
                            aria-label={model.artist_name}
                            class="absolute inset-0 group-hover:scale-105 transition bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 flex items-center justify-center"
                        >
                            <div
                                class="w-16 h-16 bg-primary/90 rounded-full flex items-center justify-center"
                            >
                                <span class="icon-[ri--play-large-fill] w-8 h-8 text-white ml-1"
                                ></span>
                            </div>
                        </a>
                    </div>

                    <CardContent class="p-6">
                        <div class="flex items-start justify-between mb-3">
                            <div>
                                <h3
                                    class="font-semibold text-lg mb-1 group-hover:text-primary transition-colors"
                                >
                                    {model.artist_name}
                                </h3>
                                <!-- <div
                  class="flex items-center gap-4 text-sm text-muted-foreground"
                >
                  <div class="flex items-center gap-1">
                    <StarIcon class="w-4 h-4 text-yellow-500 fill-current" />
                    {model.rating}
                  </div>
                  <div>{model.subscribers} followers</div>
                </div> -->
                            </div>
                        </div>

                        <!-- Tags -->
                        <div class="flex flex-wrap gap-2 mb-4">
                            {#each model.tags as tag}
                                <a
                                    class="text-xs bg-primary/10 text-primary px-2 py-1 rounded-full"
                                    href="/tags/{tag}"
                                >
                                    {tag}
                        </a>
                            {/each}
                        </div>

                        <!-- Stats -->
                        <div
                            class="flex items-center justify-between text-sm text-muted-foreground mb-4"
                        >
                            <!-- <span>{model.videos} videos</span> -->
                            <span class="capitalize">{model.category}</span>
                        </div>

                        <!-- Action Buttons -->
                        <div class="flex gap-2">
                            <Button
                                variant="outline"
                                size="sm"
                                class="flex-1 border-primary/20 hover:bg-primary/10"
                                href="/models/{model.slug}">{$_("models.view_profile")}</Button
                            >
                            <!-- <Button
                size="sm"
                class="flex-1 bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                >{$_("models.follow")}</Button
              > -->
                        </div>
                    </CardContent>
                </Card>
            {/each}
        </div>

        {#if filteredModels().length === 0}
            <div class="text-center py-12">
                <p class="text-muted-foreground text-lg">{$_("models.no_results")}</p>
                <Button
                    variant="outline"
                    onclick={() => {
                        searchQuery = "";
                        categoryFilter = "all";
                    }}
                    class="mt-4"
                >
                    {$_("models.clear_filters")}
                </Button>
            </div>
        {/if}
    </div>
</div>
