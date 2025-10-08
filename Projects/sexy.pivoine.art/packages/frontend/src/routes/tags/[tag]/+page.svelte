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
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import Meta from "$lib/components/meta/meta.svelte";

let searchQuery = $state("");
let categoryFilter = $state("all");

const { data } = $props();

function getUrlForItem(item) {
	switch (item.category) {
		case "video":
			return `/videos/${item.slug}`;
		case "article":
			return `/magazine/${item.slug}`;
		case "model":
			return `/models/${item.slug}`;
	}
}

const filteredItems = $derived(() => {
	return data.items
		.filter((item: any) => {
			const matchesSearch =
				searchQuery === "" ||
				item.title.toLowerCase().includes(searchQuery.toLowerCase());
			const matchesCategory =
				categoryFilter === "all" || item.category === categoryFilter;
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
			return a.title.localeCompare(b.title);
		});
});
</script>

<Meta
  title={$_('tags.title', { values: { tag: data.tag } })}
  description={$_('tags.description', { values: { tag: data.tag } })}
/>

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
          {$_('tags.title', { values: { tag: data.tag } })}
        </h1>
        <p
          class="text-xl md:text-2xl text-muted-foreground mb-10 leading-relaxed max-w-4xl mx-auto"
        >
          {$_('tags.description', { values: { tag: data.tag } })}
        </p>
        <!-- Filters -->
        <div class="flex flex-col md:flex-row gap-4 max-w-4xl mx-auto">
          <!-- Search -->
          <div class="relative flex-1">
            <span
              class="icon-[ri--search-line] absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground"
            ></span>
            <Input
              placeholder={$_('tags.search_placeholder')}
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
              {categoryFilter === 'all'
                ? $_('tags.categories.all')
                : categoryFilter === 'video'
                  ? $_('tags.categories.video')
                  : categoryFilter === 'article'
                    ? $_('tags.categories.article')
                    : $_('tags.categories.model')}
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">{$_('tags.categories.all')}</SelectItem>
              <SelectItem value="video"
                >{$_('tags.categories.video')}</SelectItem
              >
              <SelectItem value="article"
                >{$_('tags.categories.article')}</SelectItem
              >
              <SelectItem value="model"
                >{$_('tags.categories.model')}</SelectItem
              >
            </SelectContent>
          </Select>
        </div>
      </div>
    </div>
  </section>
  <!-- Items Grid -->
  <div class="container mx-auto px-4 py-12">
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      {#each filteredItems() as item}
        <Card
          class="py-0 group hover:shadow-2xl hover:shadow-primary/25 transition-all duration-300 hover:-translate-y-3 bg-gradient-to-br from-card/90 via-card/95 to-card/85 backdrop-blur-xl shadow-lg shadow-primary/10 overflow-hidden"
        >
          <div class="relative">
            <img
              src={getAssetUrl(item['image'] || item['avatar'], 'preview')}
              alt={item.title}
              class="w-full h-64 object-cover group-hover:scale-105 transition-transform duration-300"
            />
            <div
              class="absolute group-hover:scale-105 transition-transform inset-0 bg-gradient-to-t from-black/40 to-transparent duration-300"
            ></div>

            <!-- Category Badge -->
            <div
              class="absolute top-3 left-3 bg-primary/90 text-white text-xs px-2 py-1 rounded-full capitalize"
            >
              {item.category}
            </div>
          </div>

          <CardContent class="p-6">
            <div class="flex items-start justify-between mb-3">
              <div>
                <h3
                  class="font-semibold text-lg mb-1 group-hover:text-primary transition-colors"
                >
                  {item.title}
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
              {#each item.tags as tag}
                <a
                  class="text-xs bg-primary/10 text-primary px-2 py-1 rounded-full"
                  href="/tags/{tag}"
                >
                  {tag}
                </a>
              {/each}
            </div>

            <!-- Action Buttons -->
            <div class="flex gap-2">
              <Button
                variant="outline"
                size="sm"
                class="flex-1 border-primary/20 hover:bg-primary/10"
                href={getUrlForItem(item)}
                >{$_('tags.view', {
                  values: { category: item.category }
                })}</Button
              >
              <!-- <Button
                size="sm"
                class="flex-1 bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                >{$_("tags.follow")}</Button
              > -->
            </div>
          </CardContent>
        </Card>
      {/each}
    </div>

    {#if filteredItems().length === 0}
      <div class="text-center py-12">
        <p class="text-muted-foreground text-lg">{$_('tags.no_results')}</p>
        <Button
          variant="outline"
          onclick={() => {
            searchQuery = '';
            categoryFilter = 'all';
          }}
          class="mt-4"
        >
          {$_('tags.clear_filters')}
        </Button>
      </div>
    {/if}
  </div>
</div>
